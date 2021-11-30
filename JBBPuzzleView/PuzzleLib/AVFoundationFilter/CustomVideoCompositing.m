//
//  CustomVideoCompositing.m
//  testVideoFilter
//
//  Created by Lyman Li on 2020/3/8.
//  Copyright © 2020 Lyman Li. All rights reserved.
//

#import <CoreImage/CoreImage.h>

#import "CustomVideoCompositionInstruction.h"

#import "CustomVideoCompositing.h"

@interface CustomVideoCompositing ()

@property (nonatomic, strong) dispatch_queue_t renderContextQueue;
@property (nonatomic, strong) dispatch_queue_t renderingQueue;
@property (nonatomic, assign) BOOL shouldCancelAllRequests;

@property (nonatomic, strong) AVVideoCompositionRenderContext *renderContext;
@property (nonatomic, strong) CIContext *ciContext;

@end

@implementation CustomVideoCompositing

- (instancetype)init {
    self = [super init];
    if (self) {
        _sourcePixelBufferAttributes = @{(id)kCVPixelBufferOpenGLCompatibilityKey: @YES,
                                         (id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)};
        _requiredPixelBufferAttributesForRenderContext = @{(id)kCVPixelBufferOpenGLCompatibilityKey: @YES,
                                                           (id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)};

        _renderContextQueue = dispatch_queue_create("com.lymamli.videofilter.rendercontextqueue", 0);
        _renderingQueue = dispatch_queue_create("com.lymamli.videofilter.renderingqueue", 0);
    }
    return self;
}

- (void)renderContextChanged:(AVVideoCompositionRenderContext *)newRenderContext {
    dispatch_sync(self.renderContextQueue, ^{
        self.renderContext = newRenderContext;
    });
}

- (void)startVideoCompositionRequest:(AVAsynchronousVideoCompositionRequest *)asyncVideoCompositionRequest {
    dispatch_async(self.renderingQueue, ^{
        @autoreleasepool {
            if (self.shouldCancelAllRequests) {
                [asyncVideoCompositionRequest finishCancelledRequest];
            } else {
                CVPixelBufferRef resultPixels = [self newRenderdPixelBufferForRequest:asyncVideoCompositionRequest];
                if (resultPixels) {
                    [asyncVideoCompositionRequest finishWithComposedVideoFrame:resultPixels];
                    CVPixelBufferRelease(resultPixels);
                } else {
                    NSError *error = [NSError errorWithDomain:@"com.lymamli.panorama.videocompositor" code:0 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Composition request new pixel buffer failed.", nil)}];
                    [asyncVideoCompositionRequest finishWithError:error];
                    NSLog(@"%@", error);
                }
            }
        }
    });
}

- (void)cancelAllPendingVideoCompositionRequests {
    self.shouldCancelAllRequests = YES;
    dispatch_barrier_async(self.renderingQueue, ^{
        self.shouldCancelAllRequests = NO;
    });
}

#pragma mark - Private

- (CVPixelBufferRef)newRenderdPixelBufferForRequest:(AVAsynchronousVideoCompositionRequest *)request {
    CustomVideoCompositionInstruction *videoCompositionInstruction = (CustomVideoCompositionInstruction *)request.videoCompositionInstruction;
    NSArray<AVVideoCompositionLayerInstruction *> *layerInstructions = videoCompositionInstruction.layerInstructions;
    CMPersistentTrackID trackID = layerInstructions.firstObject.trackID;
    
    CVPixelBufferRef sourcePixelBuffer = [request sourceFrameByTrackID:trackID];
    // Right rotation 90
    if ([self shouldRightRotate90ByTrackID:videoCompositionInstruction.rotateId]) {
        CGImageRef imageRef = [[self convert:sourcePixelBuffer] CGImage];
        if (imageRef != nil) {
            imageRef = CGImageRotated1(imageRef, M_PI_2);
            sourcePixelBuffer = [self pixelBufferFromCGImage:imageRef];
        }
    }
    
    CVPixelBufferRef resultPixelBuffer = [videoCompositionInstruction applyPixelBuffer:sourcePixelBuffer];
    if (!resultPixelBuffer) {
        CVPixelBufferRef emptyPixelBuffer = [self createEmptyPixelBuffer];
        return emptyPixelBuffer;
    } else {
        return resultPixelBuffer;
    }
}

CGImageRef CGImageRotated1(CGImageRef originalCGImage, double radians)
{
    CGSize imageSize = CGSizeMake(CGImageGetWidth(originalCGImage), CGImageGetHeight(originalCGImage));
    CGSize rotatedSize;
    if (radians == M_PI_2 || radians == -M_PI_2)
    {
        rotatedSize = CGSizeMake(imageSize.height, imageSize.width);
    }
    else
    {
        rotatedSize = imageSize;
    }
    
    double rotatedCenterX = rotatedSize.width / 2.f;
    double rotatedCenterY = rotatedSize.height / 2.f;
    CGContextRef rotatedContext = CGBitmapContextCreate(NULL, rotatedSize.width, rotatedSize.height,
                                             CGImageGetBitsPerComponent(originalCGImage), 0,
                                             CGImageGetColorSpace(originalCGImage),
                                             CGImageGetBitmapInfo(originalCGImage));
    if (radians == 0.f || radians == M_PI)
    {
        // 0 or 180 degrees
        CGContextTranslateCTM(rotatedContext, rotatedCenterX, rotatedCenterY);
        if (radians == 0.0f)
        {
            CGContextScaleCTM(rotatedContext, 1.f, -1.f);
        }
        else
        {
            CGContextScaleCTM(rotatedContext, -1.f, 1.f);
        }
        CGContextTranslateCTM(rotatedContext, -rotatedCenterX, -rotatedCenterY);
    }
    else if (radians == M_PI_2 || radians == -M_PI_2)
    {
        // +/- 90 degrees
//        CGContextTranslateCTM(rotatedContext, rotatedCenterX, rotatedCenterY);
//        CGContextRotateCTM(rotatedContext, radians);
//        CGContextScaleCTM(rotatedContext, 1.f, -1.f);
//        CGContextTranslateCTM(rotatedContext, -rotatedCenterY, -rotatedCenterX);
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformTranslate(transform, 0, rotatedSize.height);
        transform = CGAffineTransformRotate(transform, -M_PI_2);
        CGContextConcatCTM(rotatedContext, transform);
    }
    
    CGRect drawingRect = CGRectMake(0.f, 0.f, imageSize.width, imageSize.height);
    CGContextDrawImage(rotatedContext, drawingRect, originalCGImage);
    CGImageRef rotatedCGImage = CGBitmapContextCreateImage(rotatedContext);
    CGContextRelease(rotatedContext);
    
    return rotatedCGImage;
}

- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image {
    CVPixelBufferRef pxbuffer = NULL;
    NSCParameterAssert(NULL != image);
    size_t originalWidth = CGImageGetWidth(image);
    size_t originalHeight = CGImageGetHeight(image);
    
    NSMutableData *imageData = [NSMutableData dataWithLength:originalWidth*originalHeight*4];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef cgContext = CGBitmapContextCreate([imageData mutableBytes], originalWidth, originalHeight, 8, 4*originalWidth, colorSpace, 8194);//bitmapInfo真是个迷，有时间要好好看看
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(cgContext, CGRectMake(0, 0, originalWidth, originalHeight), image);
    CGContextRelease(cgContext);
    CGImageRelease(image);
    unsigned char *pImageData = (unsigned char *)[imageData bytes];
    
    
    CFDictionaryRef empty;
    empty = CFDictionaryCreate(kCFAllocatorDefault, NULL, NULL,
                               0,
                               &kCFTypeDictionaryKeyCallBacks,
                               &kCFTypeDictionaryValueCallBacks);
    
    CFMutableDictionaryRef m_pPixelBufferAttribs = CFDictionaryCreateMutable(kCFAllocatorDefault,
                                                      3,
                                                      &kCFTypeDictionaryKeyCallBacks,
                                                      &kCFTypeDictionaryValueCallBacks);
    
    CFDictionarySetValue(m_pPixelBufferAttribs, kCVPixelBufferIOSurfacePropertiesKey, empty);
    CFDictionarySetValue(m_pPixelBufferAttribs, kCVPixelBufferOpenGLCompatibilityKey, empty);
    CFDictionarySetValue(m_pPixelBufferAttribs, kCVPixelBufferCGBitmapContextCompatibilityKey, empty);
    
    CVPixelBufferCreateWithBytes(kCFAllocatorDefault, originalWidth, originalHeight, kCVPixelFormatType_32BGRA, pImageData, originalWidth * 4, NULL, NULL, m_pPixelBufferAttribs, &pxbuffer);
    CFRelease(empty);
    CFRelease(m_pPixelBufferAttribs);
    
    
    return pxbuffer;
}

- (UIImage *)convert:(CVPixelBufferRef)pixelBuffer {
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];

    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
        createCGImage:ciImage
             fromRect:CGRectMake(0, 0, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer))];
    UIImage *image = [UIImage imageWithCGImage:videoImage];//还是要用UIImage，CGImageRef不受ACR控制需要手动释放
    CGImageRelease(videoImage);

    return image;
}

- (BOOL)shouldRightRotate90ByTrackID:(NSInteger)trackID
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *identifier = [NSString stringWithFormat:@"TrackID_%ld", (long)trackID];
    BOOL result = [[userDefaultes objectForKey:identifier] boolValue];
    NSLog(@"shouldRightRotate90ByTrackID %@ : %@", identifier, result?@"Yes":@"No");
    
    if (result)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/// 创建一个空白的视频帧
- (CVPixelBufferRef)createEmptyPixelBuffer {
    CVPixelBufferRef pixelBuffer = [self.renderContext newPixelBuffer];
    CIImage *image = [CIImage imageWithColor:[CIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [self.ciContext render:image toCVPixelBuffer:pixelBuffer];
    return pixelBuffer;
}

#pragma mark - Accessors

- (CIContext *)ciContext {
    if (!_ciContext) {
        _ciContext = [[CIContext alloc] init];
    }
    return _ciContext;
}

@end
