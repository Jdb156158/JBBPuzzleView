//
//  PXKConstMarcro.h
//  huashiStudents
//
//  Created by 彭新凯 on 2019/4/12.
//  Copyright © 2019 pxk. All rights reserved.
//

#ifndef PXKConstMarcro_h
#define PXKConstMarcro_h

#import <AVFoundation/AVFoundation.h>

/*常量相关宏*/
typedef NS_ENUM(NSInteger,ImageType){   //cell图片选中状态
    ImageType_normal = 0,// 默认
    ImageType_rightAndSelected,// 选中或者选对
    ImageType_fail, // 选错
};

static CGFloat const IMGHEIGHT = 150.0; //图片高度

static NSString * const SDYOUKE = @"SDYOUKE";


#define kBrightBlue [UIColor colorWithRed:100/255.0f green:100/255.0f blue:230/255.0f alpha:1]


// Callback
typedef void(^GenericCallback)(BOOL success, id result);

static inline float randomFloat()
{
    return (float)rand()/(float)RAND_MAX;
}

#pragma mark - dispatch_async_main_after
static inline void dispatch_async_main_after(NSTimeInterval after, dispatch_block_t block)
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

#pragma mark - String
static inline BOOL isStringEmpty(NSString *value)
{
    BOOL result = FALSE;
    if (!value || [value isKindOfClass:[NSNull class]])
    {
        // null object
        result = TRUE;
    }
    else
    {
        NSString *trimedString = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([value isKindOfClass:[NSString class]] && [trimedString length] == 0)
        {
            // empty string
            result = TRUE;
        }
    }
    
    return result;
}

#pragma mark - App Info
static inline NSString* getAppVersion()
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    NSLog(@"App version: %@", versionNum);
    return versionNum;
}

static inline NSString* getAppName()
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDict objectForKey:@"CFBundleDisplayName"];
    NSLog(@"App name: %@", appName);
    return appName;
}

static inline NSString* getAppNameByInfoPlist()
{
    NSString *appName = NSLocalizedStringFromTable(@"CFBundleDisplayName", @"InfoPlist", nil);
    NSLog(@"App name: %@", appName);
    return appName;
}

/* 获取本机正在使用的语言  * en:英文  zh-Hans:简体中文   zh-Hant:繁体中文    ja:日本 ...... */
static inline NSString* getPreferredLanguage()
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    
    NSLog(@"Preferred Language: %@", preferredLang);
    return preferredLang;
}

static inline NSString* getCurrentlyLanguage()
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    NSLog(@"currentLanguage: %@", currentLanguage);
    return currentLanguage;
}

static inline BOOL isZHHansFromCurrentlyLanguage()
{
    BOOL bResult = FALSE;
    NSString *curLauguage = getCurrentlyLanguage();
    NSString *cnLauguage = @"zh-Hans";
    if ([curLauguage compare:cnLauguage options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame)
    {
        bResult = TRUE;
    }
    
    return bResult;
}

#define CURR_LANG ([[NSLocale preferredLanguages] objectAtIndex: 0])
static inline NSString* GBLocalizedString(NSString *translation_key)
{
    NSString * string = NSLocalizedString(translation_key, nil);
    if (![CURR_LANG isEqual:@"en"] && ![CURR_LANG hasPrefix:@"zh-Hans"])
    {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        string = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }
    
    return string;
}

#pragma mark - Show Alert
static inline void showAlertMessage(NSString *text, NSString *title)
{
    NSString *ok = GBLocalizedString(@"OK");
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:nil
                      cancelButtonTitle:ok
                      otherButtonTitles:nil] show];
}

#pragma mark - FindRightNavBarItemView
static inline UIView* findRightNavBarItemView(UINavigationBar *navbar)
{
    UIView* rightView = nil;
    for (UIView* view in navbar.subviews)
    {
        if (!rightView)
        {
            rightView = view;
        }
        else if (view.frame.origin.x > rightView.frame.origin.x)
        {
            rightView = view;
        }
    }
    
    return rightView;
}

#pragma mark - Find ViewController
static inline UIViewController* findViewController(UIView *currentView)
{
    for (UIView* next = [currentView superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark - File Helper
static inline NSArray* getFilelistBySymbol(NSString *symbol, NSString *dirPath, NSString *type)
{
    NSMutableArray *filelist = [NSMutableArray arrayWithCapacity:1];
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    NSString *symbolResult = [symbol lowercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *typeResult = [type lowercaseStringWithLocale:[NSLocale currentLocale]];
    for (NSString *filename in tmplist)
    {
        NSString *fullpath = [dirPath stringByAppendingPathComponent:filename];
        BOOL fileExisted = [[NSFileManager defaultManager] fileExistsAtPath:fullpath];
        if (fileExisted)
        {
            NSString *filenameResult = [filename lowercaseStringWithLocale:[NSLocale currentLocale]];
            if ([[filenameResult lastPathComponent] hasPrefix:symbolResult] && [filenameResult hasSuffix:typeResult])
            {
                [filelist  addObject:filename];
            }
        }
    }
    
    return filelist;
}

static inline BOOL isFileExistAtPath(NSString *fileFullPath)
{
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
}

#pragma mark - Delete Files/Directory
static inline void deleteFilesAt(NSString *directory, NSString *suffixName)
{
    NSError *err = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:directory];
    NSString *toDelFile;
    while (toDelFile = [dirEnum nextObject])
    {
        NSComparisonResult result = [[toDelFile pathExtension] compare:suffixName options:NSCaseInsensitiveSearch|NSNumericSearch];
        if (result == NSOrderedSame)
        {
            NSLog(@"removing file：%@", toDelFile);
            
            if(![fileManager removeItemAtPath:[directory stringByAppendingPathComponent:toDelFile] error:&err])
            {
                NSLog(@"Error: %@", [err localizedDescription]);
            }
        }
    }
}

static inline NSString* getFilePath(NSString *name)
{
    NSString *fileName = [name stringByDeletingPathExtension];
    NSLog(@"%@",fileName);
    NSString *fileExt = [name pathExtension];
    NSLog(@"%@",fileExt);
    NSString *inputVideoPath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExt];
    
    return inputVideoPath;
}

static inline NSURL* getFileURLFromAbsolutePath(NSString *filePath)
{
    if (!filePath || [filePath length] == 0)
        return nil;
    
    NSURL *fileURL = [NSURL URLWithString:filePath];
    if (!fileURL || ![fileURL scheme])
    {
        fileURL = [NSURL fileURLWithPath:filePath];
    }
    
    return fileURL;
}

static inline NSURL* getFileURLFromFilename(NSString *filePath)
{
    if (!filePath || [filePath length] == 0)
        return nil;
    
    NSString *fileName = [filePath stringByDeletingPathExtension];
    NSLog(@"%@",fileName);
    NSString *fileExt = [filePath pathExtension];
    NSLog(@"%@",fileExt);
    
    NSURL *inputVideoURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:fileExt];
    return inputVideoURL;
}

// File Size(M)
static inline long long fileSizeAtPath(NSString *filePath)
{
    long long result = 0;
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath])
    {
        result = [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    
    NSLog(@"fileSizeAtPath: %lld (M)", result/(1024*1024));
    
    return result;
}

// Folder Size(M)
static inline float folderSizeAtPath(NSString *folderPath)
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
        return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil)
    {
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += fileSizeAtPath(fileAbsolutePath);
    }
    
    return folderSize/(1024.0*1024.0);
}

#pragma mark - Screen Bounds

// iOS 8 way of returning bounds for all SDK's and OS-versions
#ifndef NSFoundationVersionNumber_iOS_7_1
# define NSFoundationVersionNumber_iOS_7_1 1047.25
#endif
static inline CGRect screenBounds()
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    
    static BOOL isNotRotatedBySystem;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BOOL OSIsBelowIOS8 = [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0;
        BOOL SDKIsBelowIOS8 = floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1;
        isNotRotatedBySystem = OSIsBelowIOS8 || SDKIsBelowIOS8;
    });
    
    BOOL needsToRotate = isNotRotatedBySystem && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
    if(needsToRotate)
    {
        CGRect bounds = screenBounds;
        bounds.size.width = screenBounds.size.height;
        bounds.size.height = screenBounds.size.width;
        return bounds;
    }
    else
    {
        return screenBounds;
    }
}

#pragma mark - getCroppedBounds
static inline CGRect getCroppedBounds(NSArray *points)
{
    CGRect croppedRect = CGRectZero;
    if (points && [points count] > 0)
    {
        CGPoint pointBegin = CGPointZero;
        NSUInteger i = 0;
        do
        {
            pointBegin = [[points objectAtIndex:i] CGPointValue];
            ++i;
        }
        while (CGPointEqualToPoint(pointBegin, CGPointZero));
        
        CGFloat x = pointBegin.x, y = pointBegin.y, width = pointBegin.x, height = pointBegin.y;
        for (; i < [points count]; ++i)
        {
            CGPoint point = [[points objectAtIndex:i] CGPointValue];
            if (CGPointEqualToPoint(CGPointZero, point))
            {
                continue;
            }
            
            x = MIN(x, point.x);
            y = MAX(y, point.y);
            width = MAX(width, point.x);
            height = MIN(height, point.y);
        }
        
        width = fabs(width - x);
        height = fabs(y - height);
        croppedRect = CGRectMake(x, y, width, height);
    }
    
    return croppedRect;
}

#pragma mark - Save Image
static inline NSString* getTempImageOutputFile()
{
    NSString *path = NSTemporaryDirectory();
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmssSSS";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSString *imageOutputFile = [[path stringByAppendingPathComponent:nowTimeStr] stringByAppendingString:@"image.jpg"];
    return imageOutputFile;
}

static inline BOOL saveImage(UIImage *image)
{
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    NSString *imageOutputFile = getTempImageOutputFile();
    unlink([imageOutputFile UTF8String]);
    NSLog(@"Save Image: %@", imageOutputFile);
    return [data writeToFile:imageOutputFile atomically:YES];
}

static inline NSString* saveImageData(NSData *imageData)
{
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    NSString *imageOutputFile = getTempImageOutputFile();
    unlink([imageOutputFile UTF8String]);
    if (![data writeToFile:imageOutputFile atomically:YES])
    {
        imageOutputFile = nil;
    }
    
    NSLog(@"saveImageData: %@", imageOutputFile);
    return imageOutputFile;
}

#pragma mark - Image Border Splice
static inline UIImage* imageBorderSplice(UIImage *image, UIImage *imageBorder)
{
    int widthBorder = 3;
    CGSize size = CGSizeMake(image.size.width + 2*widthBorder, image.size.height + 2*widthBorder);
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(widthBorder, widthBorder, image.size.width, image.size.height)];
    [imageBorder drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

#pragma mark - Image Scale
static inline UIImage* scaleImage(UIImage *image, CGSize size)
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Square Image
static inline UIImage* squareImageFromImage(UIImage *image)
{
    UIImage *squareImage = nil;
    CGSize imageSize = [image size];
    
    if (imageSize.width == imageSize.height)
    {
        squareImage = image;
    }
    else
    {
        // Compute square crop rect
        CGFloat smallerDimension = MIN(imageSize.width, imageSize.height);
        CGRect cropRect = CGRectMake(0, 0, smallerDimension, smallerDimension);
        
        // Center the crop rect either vertically or horizontally, depending on which dimension is smaller
        if (imageSize.width <= imageSize.height)
        {
            cropRect.origin = CGPointMake(0, rintf((imageSize.height - smallerDimension) / 2.0));
        }
        else
        {
            cropRect.origin = CGPointMake(rintf((imageSize.width - smallerDimension) / 2.0), 0);
        }
        
        CGImageRef croppedImageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
        squareImage = [UIImage imageWithCGImage:croppedImageRef];
        CGImageRelease(croppedImageRef);
    }
    
    return squareImage;
}

#pragma mark - Thumbnail
static inline UIImage* generateThumbnail(UIImage *image, CGFloat width, CGFloat height)
{
    // Create a thumbnail image
    CGSize size = image.size;
    CGSize croppedSize;
    CGFloat ratioX = 75.0;
    CGFloat ratioY = 75.0;
    CGFloat offsetX = 0.0;
    CGFloat offsetY = 0.0;
    
    if (width > 0)
    {
        ratioX = width;
    }
    
    if (height > 0)
    {
        ratioY = height;
    }
    
    // Check the size of the image, we want to make it a square with sides the size of the smallest dimension
    if (size.width > size.height)
    {
        offsetX = (size.height - size.width) / 2;
        croppedSize = CGSizeMake(size.height, size.height);
    }
    else
    {
        offsetY = (size.width - size.height) / 2;
        croppedSize = CGSizeMake(size.width, size.width);
    }
    
    
    // Crop the image before resize
    CGRect clippedRect = CGRectMake(offsetX * -1, offsetY * -1, croppedSize.width, croppedSize.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
    // Done cropping
    
    // Resize the image
    CGRect rect = CGRectMake(0.0, 0.0, ratioX, ratioY);
    UIGraphicsBeginImageContext(rect.size);
    [[UIImage imageWithCGImage:imageRef] drawInRect:rect];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Done Resizing
    
    CGImageRelease(imageRef);
    
    return thumbnail;
}

static inline UIImage* generateThumbnailPhoto(UIImage *image)
{
    CGFloat width = 150, height = 150;
    UIImage *thumbnail = nil;
    if (image)
    {
        thumbnail = generateThumbnail(image, width, height);
    }
    else
    {
        NSLog(@"Image is empty!");
    }
    
    return thumbnail;
}

// Create a UIImage from sample buffer data
static inline UIImage* imageFromSampleBuffer(CMSampleBufferRef sampleBuffer)
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return image;
}

static inline UIImage* imageFixOrientation(UIImage* image)
{
    UIImageOrientation imageOrientation = [image imageOrientation];
    if (imageOrientation == UIImageOrientationUp)
        return image;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    UIImageOrientation io = imageOrientation;
    if (io == UIImageOrientationDown || io == UIImageOrientationDownMirrored)
    {
        transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
        transform = CGAffineTransformRotate(transform, M_PI);
    }
    else if (io == UIImageOrientationLeft || io == UIImageOrientationLeftMirrored)
    {
        transform = CGAffineTransformTranslate(transform, image.size.width, 0);
        transform = CGAffineTransformRotate(transform, M_PI_2);
    }
    else if (io == UIImageOrientationRight || io == UIImageOrientationRightMirrored)
    {
        transform = CGAffineTransformTranslate(transform, 0, image.size.height);
        transform = CGAffineTransformRotate(transform, -M_PI_2);
    }
    
    if (io == UIImageOrientationUpMirrored || io == UIImageOrientationDownMirrored)
    {
        transform = CGAffineTransformTranslate(transform, image.size.width, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
    }
    else if (io == UIImageOrientationLeftMirrored || io == UIImageOrientationRightMirrored)
    {
        transform = CGAffineTransformTranslate(transform, image.size.height, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    
    if (io == UIImageOrientationLeft || io == UIImageOrientationLeftMirrored || io == UIImageOrientationRight || io == UIImageOrientationRightMirrored)
    {
        CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
    }
    else
    {
        CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

#pragma mark - ImageFromCIImage
static inline UIImage* makeUIImageFromCIImage(CIImage *ciImage)
{
    UIImage * returnImage = nil;
    CGImageRef processedCGImage = [[CIContext contextWithOptions:nil] createCGImage:ciImage
                                                                           fromRect:[ciImage extent]];
    returnImage = [UIImage imageWithCGImage:processedCGImage];
    CGImageRelease(processedCGImage);
    
    return returnImage;
}

static inline BOOL imageHasAlpha(CGImageRef imageRef)
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(imageRef);
    BOOL hasAlpha = (alpha == kCGImageAlphaFirst || alpha == kCGImageAlphaLast || alpha == kCGImageAlphaPremultipliedFirst || alpha == kCGImageAlphaPremultipliedLast);
    
    return hasAlpha;
}

#pragma mark - Video Helper
static inline CGFloat getVideoDuration(NSURL *URL)
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    
    return second;
}

static inline UIImage* getImageFromVideoFrame(NSURL *videoFileURL, CMTime atTime)
{
    NSURL *inputUrl = videoFileURL;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:inputUrl options:nil];
    
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:atTime actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
    {
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    }
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    if (thumbnailImageRef)
    {
        CGImageRelease(thumbnailImageRef);
    }
    
    return thumbnailImage;
}

static inline UIInterfaceOrientation orientationForTrack(AVAsset *asset)
{
    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGSize size = [videoTrack naturalSize];
    CGAffineTransform txf = [videoTrack preferredTransform];
    
    if (size.width == txf.tx && size.height == txf.ty)
        return UIInterfaceOrientationLandscapeRight;
    else if (txf.tx == 0 && txf.ty == 0)
        return UIInterfaceOrientationLandscapeLeft;
    else if (txf.tx == 0 && txf.ty == size.width)
        return UIInterfaceOrientationPortraitUpsideDown;
    else
        return UIInterfaceOrientationPortrait;
}


#endif /* PXKConstMarcro_h */
