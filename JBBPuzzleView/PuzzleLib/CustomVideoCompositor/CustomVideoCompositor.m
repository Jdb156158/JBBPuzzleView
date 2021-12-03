//
//  CustomVideoCompositor
//  VideoMoments
//
//  Created by Johnny Xu(徐景周) on 5/30/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//

@import  UIKit;
#import "CustomVideoCompositor.h"
#import "PuzzleData.h"
#import "ColorData.h"
#import "CustomFilter.h"

@interface CustomVideoCompositor()

@property (nonatomic, strong) CIContext *context;
@property (nonatomic, strong) CIImage *currentImage;
@property (nonatomic, assign) CGFloat currentTime;


@end

@implementation CustomVideoCompositor

- (instancetype)init
{
    return self;
}

#pragma mark - startVideoCompositionRequest  获取每一帧的原始图像
- (void)startVideoCompositionRequest:(AVAsynchronousVideoCompositionRequest *)request
{
    NSMutableArray *videoArray = [[NSMutableArray alloc] init];
    CVPixelBufferRef destination = [request.renderContext newPixelBuffer];
    self.currentTime = [NSNumber numberWithInteger:request.compositionTime.value].floatValue / [NSNumber numberWithInteger:request.compositionTime.timescale].floatValue;
//    self.currentTime = request.compositionTime.value;

//    NSLog(@"compositionTime------%f",self.currentTime);
    if (request.sourceTrackIDs.count > 0)// 已添加的资源数量
    {
        for (NSUInteger i = 0; i < [request.sourceTrackIDs count]; ++i)
        {
            CVPixelBufferRef videoBufferRef = [request sourceFrameByTrackID:[[request.sourceTrackIDs objectAtIndex:i] intValue]];
            if (videoBufferRef)
            {
                [videoArray addObject:(__bridge id)(videoBufferRef)];
            }
        }
        
        for (NSUInteger i = 0; i < [videoArray count]; ++i)
        {
            CVPixelBufferRef video = (__bridge CVPixelBufferRef)([videoArray objectAtIndex:i]);
            CVPixelBufferLockBaseAddress(video, kCVPixelBufferLock_ReadOnly);
        }
        CVPixelBufferLockBaseAddress(destination, 0);
        
        [self renderBuffer:videoArray toBuffer:destination];

        CVPixelBufferUnlockBaseAddress(destination, 0);
        for (NSUInteger i = 0; i < [videoArray count]; ++i)
        {
            CVPixelBufferRef video = (__bridge CVPixelBufferRef)([videoArray objectAtIndex:i]);
            CVPixelBufferUnlockBaseAddress(video, kCVPixelBufferLock_ReadOnly);
        }
    }
    
    [request finishWithComposedVideoFrame:destination];
    CVBufferRelease(destination);
}

- (CIContext *)context {
    if (!_context) {
        _context = [[CIContext alloc] init];
    }
    return _context;
}

- (void)renderContextChanged:(AVVideoCompositionRenderContext *)newRenderContext
{
}

- (NSDictionary *)requiredPixelBufferAttributesForRenderContext
{
    return @{ (__bridge NSString *)kCVPixelBufferPixelFormatTypeKey : @[ @(kCVPixelFormatType_32BGRA) ] };
}

- (NSDictionary *)sourcePixelBufferAttributes
{
    return @{ (__bridge NSString *)kCVPixelBufferPixelFormatTypeKey : @[ @(kCVPixelFormatType_32BGRA) ] };
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

#pragma mark - renderBuffer
- (void)renderBuffer:(NSMutableArray *)videoBufferRefArray toBuffer:(CVPixelBufferRef)destination
{
    size_t width = CVPixelBufferGetWidth(destination);
    size_t height = CVPixelBufferGetHeight(destination);
    NSMutableArray *imageRefArray = [[NSMutableArray alloc] init];
//    NSMutableArray *filterNameArray = [[PuzzleData sharedInstance] filterNameArray];
//    NSMutableArray *videoDurationArray = [[PuzzleData sharedInstance] videoDurationArray];

    for (NSUInteger i = 0; i < [videoBufferRefArray count]; ++i)
    {
        CVPixelBufferRef videoFrame = (__bridge CVPixelBufferRef)([videoBufferRefArray objectAtIndex:i]);

        // 在每一帧的buffer上渲染滤镜
//        NSString *filterName = [filterNameArray objectAtIndex:i];
//        NSInteger currentVideoTime = [[videoDurationArray objectAtIndex:i] integerValue];
//
//        if (![filterName isEqualToString:@""] && self.currentTime < currentVideoTime) {// 不超过当前视频时长不渲染且需要添加滤镜
//            @autoreleasepool {
//                CIImage *image = [CIImage imageWithCVPixelBuffer:videoFrame];
//                CIFilter *ciFilter = [CIFilter filterWithName:filterName withInputParameters:@{kCIInputImageKey: image}];
//                image = [ciFilter valueForKey:kCIOutputImageKey];
//                [self.context render:image toCVPixelBuffer:videoFrame];
//            }
//        }
        
//        CGFloat currentVideoTime = [[videoDurationArray objectAtIndex:i] floatValue];
//        if (self.currentTime < currentVideoTime) {// 超过当前视频时长不渲染
//            @autoreleasepool {
//                NSString *filterName = [filterNameArray objectAtIndex:i];
//                CIImage *image = [CIImage imageWithCVPixelBuffer:videoFrame];
//                if (![filterName isEqualToString:@""]) {
//                    CIFilter *ciFilter = [CIFilter filterWithName:filterName withInputParameters:@{kCIInputImageKey: image}];
//                    image = [ciFilter valueForKey:kCIOutputImageKey];
//                } else {
//                    // 加一层淡黄色滤镜
//                    CIImage *filterImage = [CIImage imageWithColor:[CIColor clearColor]];
//                    image = [filterImage imageByCompositingOverImage:image];
//                }
//                [self.context render:image toCVPixelBuffer:videoFrame];
//            }
//        }

        
        CGImageRef imageRef = [self createSourceImageFromBuffer:videoFrame];
        if (imageRef)
        {
            if ([self shouldRightRotate90ByTrackID:i+1])
            {
                // Right rotation 90
                imageRef = CGImageRotated(imageRef, M_PI_2);
            }
            

//            CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage,CGRectMake(0,0,width,height));

            CIImage *newimage = [CIImage imageWithCGImage:imageRef];
            
            [imageRefArray addObject:(__bridge id)(imageRef)];
        }
        CGImageRelease(imageRef);
//        CVBufferRelease(sourseVideoFrame);
    }
    
    CGRect rectVideo = CGRectZero;
    rectVideo.size = CGSizeMake(width, height);

    // Fill whole background--- 视频加背景
    if ([PuzzleData sharedInstance].bgColor != nil) {
        CGContextRef bgGc = CGBitmapContextCreate(CVPixelBufferGetBaseAddress(destination), width, height, CGImageGetBitsPerComponent((CGImageRef)imageRefArray[0]), CVPixelBufferGetBytesPerRow(destination), CGImageGetColorSpace((CGImageRef)imageRefArray[0]), 8194);
        CGContextSetFillColorWithColor(bgGc, [PuzzleData sharedInstance].bgColor.CGColor);
        CGContextFillRect(bgGc, rectVideo);
        CGContextRelease(bgGc);
    } else {
        
        UIImage *backgroundImage = [PuzzleData sharedInstance].bgImage;
        
        CGImageRef imageRef = backgroundImage.CGImage;
        int bgImageRefInfo = CGImageGetBitmapInfo(imageRef);
        CGContextRef bgGc = CGBitmapContextCreate(CVPixelBufferGetBaseAddress(destination), width, height, CGImageGetBitsPerComponent((CGImageRef)imageRefArray[0]), CVPixelBufferGetBytesPerRow(destination), CGImageGetColorSpace((CGImageRef)imageRefArray[0]), bgImageRefInfo);
        CGContextClipToRect(bgGc, rectVideo);
        
        CGImageRef bgImageRef = backgroundImage.CGImage;
        CGContextDrawTiledImage(bgGc, CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height), bgImageRef);
        CGContextRelease(bgGc);
    }
    

    int bgImageRefInfo = CGImageGetBitmapInfo((CGImageRef)imageRefArray[0]);
//    int bgImageRefInfo = 8194;

    CGContextRef gc = CGBitmapContextCreate(CVPixelBufferGetBaseAddress(destination), width, height, CGImageGetBitsPerComponent((CGImageRef)imageRefArray[0]), CVPixelBufferGetBytesPerRow(destination), CGImageGetColorSpace((CGImageRef)imageRefArray[0]), bgImageRefInfo);
        
   // 加上子视频
    NSMutableArray *frames = [[PuzzleData sharedInstance] frames];
    NSMutableArray *cropFrames = [[PuzzleData sharedInstance] cropFramesArray];

    for (int i = 0; i < [imageRefArray count]; ++i)
    {
        CGRect frame = [frames[i] CGRectValue];
        CGRect cropFrame = [cropFrames[i] CGRectValue];

        CGContextSetFillColorWithColor(gc, [UIColor blackColor].CGColor);
        CGContextFillRect(gc, frame);

        float imageWidth = CGImageGetWidth((CGImageRef)imageRefArray[i]);
        float imageHeight = CGImageGetHeight((CGImageRef)imageRefArray[i]);
        float width = 0.0, height = 0.0;
        if (imageWidth < CGRectGetWidth(frame))
        {
            width = imageWidth;
        }
        else
        {
            width = CGRectGetWidth(frame);
        }

        if (imageHeight < CGRectGetHeight(frame))
        {
            height = imageHeight;
        }
        else
        {
            height = CGRectGetHeight(frame);
        }


//        CGRect cropRect = CGRectMake(fabs((imageWidth - width)/2), fabs((imageHeight - height)/2), width, height);
        CGRect cropRect = CGRectMake(cropFrame.origin.x, cropFrame.origin.y, cropFrame.size.width, cropFrame.size.height);

        CGImageRef imageRef = CGImageCreateWithImageInRect((CGImageRef)imageRefArray[i], cropRect);
        
        CIImage *newimage = [CIImage imageWithCGImage:imageRef];
        
        CGRect resultRect = CGRectMake(CGRectGetMinX(frame) + fabs((CGRectGetWidth(frame) - width)/2), CGRectGetMinY(frame) + fabs((CGRectGetHeight(frame) - height)/2), width, height);
        CGContextDrawImage(gc, resultRect, imageRef);
        CGImageRelease(imageRef);
        
    }

    CGContextRelease(gc);
}

- (NSData *)getBGRWithImage:(UIImage *)image
{
    int RGBA = 4;
    int RGB  = 3;
    
    CGImageRef imageRef = [image CGImage];
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char *) malloc(width * height * sizeof(unsigned char) * RGBA);
    NSUInteger bytesPerPixel = RGBA;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    unsigned char * tempRawData = (unsigned char *)malloc(width * height * 3 * sizeof(unsigned char));
    
    for (int i = 0; i < width * height; i ++) {
        
        NSUInteger byteIndex = i * RGBA;
        NSUInteger newByteIndex = i * RGB;
        
        // Get RGB
        CGFloat red    = rawData[byteIndex + 0];
        CGFloat green  = rawData[byteIndex + 1];
        CGFloat blue   = rawData[byteIndex + 2];
        //CGFloat alpha  = rawData[byteIndex + 3];// 这里Alpha值是没有用的
        
        // Set RGB To New RawData
        tempRawData[newByteIndex + 0] = blue;   // B
        tempRawData[newByteIndex + 1] = green;  // G
        tempRawData[newByteIndex + 2] = red;    // R
    }
    
    NSData *data = [NSData dataWithBytes:tempRawData length:(width * height * 3 * sizeof(unsigned char))];
    return data;
}

#pragma mark - createSourceImageFromBuffer
- (CGImageRef)createSourceImageFromBuffer:(CVPixelBufferRef)buffer
{
    size_t width = CVPixelBufferGetWidth(buffer);
    size_t height = CVPixelBufferGetHeight(buffer);
    size_t stride = CVPixelBufferGetBytesPerRow(buffer);
    void *data = CVPixelBufferGetBaseAddress(buffer);
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, data, height * stride, NULL);
    CGImageRef image = CGImageCreate(width, height, 8, 32, stride, rgb, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast, provider, NULL, NO, kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(rgb);
    
    return image;
}

#pragma mark - CGImageRotated
CGImageRef CGImageRotated(CGImageRef originalCGImage, double radians)
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

void drawImage(CGContextRef context, CGImageRef image , CGRect rect)
{
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    CGContextDrawImage(context, rect, image);
    
    CGContextRestoreGState(context);
}

#pragma mark - addPath
- (void)addPath:(CGContextRef)gc withPath:(UIBezierPath *)path
{
    // Path points
    CGContextBeginPath(gc);
    CGContextSetRGBStrokeColor(gc, 1, 1, 1, 1);
    CGContextSetLineWidth(gc, 3);
    CGContextSetShouldAntialias(gc, YES);
    CGContextAddPath(gc, path.CGPath);
}

#pragma mark - drawBorderInFrame
- (void)drawBorderInFrames:(NSArray *)frames withContextRef:(CGContextRef)contextRef
{
    if (!frames || [frames count] < 1)
    {
        NSLog(@"drawBorderInFrames is empty.");
        return;
    }
    
    if ([self shouldDisplayInnerBorder])
    {
        // Fill background
        CGContextSetFillColorWithColor(contextRef, [UIColor whiteColor].CGColor);
        CGContextFillRect(contextRef, [frames[0] CGRectValue]);
        
        // Draw
        CGContextBeginPath(contextRef);
        CGFloat lineWidth = 5;
        for (int i = 1; i < [frames count]; ++i)
        {
            CGRect innerVideoRect = [frames[i] CGRectValue];
            if (!CGRectIsEmpty(innerVideoRect))
            {
                CGContextAddRect(contextRef, CGRectInset(innerVideoRect, lineWidth, lineWidth));
            }
        }
        CGContextClip(contextRef);
    }
}

#pragma mark - getCroppedRect
- (CGRect)getCroppedRect
{
    NSArray *pointsPath = [self getPathPoints];
    return getCroppedBounds(pointsPath);
}

#pragma mark - NSUserDefaults
#pragma mark - PathPoints
- (NSArray *)getPathPoints
{
    NSArray *arrayResult = nil;
    NSString *flag = @"ArrayPathPoints";
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSData *dataPathPoints = [userDefaultes objectForKey:flag];
    if (dataPathPoints)
    {
        arrayResult = [NSKeyedUnarchiver unarchiveObjectWithData:dataPathPoints];
//        if (arrayResult && [arrayResult count] > 0)
//        {
//             NSLog(@"points has content.");
//        }
    }
    else
    {
//        NSLog(@"getPathPoints is empty.");
    }
    
    return arrayResult;
}

#pragma mark - OutputBGColor
- (UIColor *)getOutputBGColor
{
    NSString *flag = @"OutputBGColor";
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSData *objColor = [userDefaultes objectForKey:flag];
    UIColor *bgColor = nil;
    if (objColor)
    {
        bgColor = [NSKeyedUnarchiver unarchiveObjectWithData:objColor];
    }
    return bgColor;
}

#pragma mark - shouldDisplayInnerBorder
- (BOOL)shouldDisplayInnerBorder
{
    NSString *shouldDisplayInnerBorder = @"ShouldDisplayInnerBorder";
//    NSLog(@"shouldDisplayInnerBorder: %@", [[[NSUserDefaults standardUserDefaults] objectForKey:shouldDisplayInnerBorder] boolValue]?@"Yes":@"No");
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:shouldDisplayInnerBorder] boolValue])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - shouldRightRotate90ByTrackID
- (BOOL)shouldRightRotate90ByTrackID:(NSInteger)trackID
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *identifier = [NSString stringWithFormat:@"TrackID_%ld", (long)trackID];
    BOOL result = [[userDefaultes objectForKey:identifier] boolValue];
//    NSLog(@"shouldRightRotate90ByTrackID %@ : %@", identifier, result?@"Yes":@"No");
    
    if (result)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
