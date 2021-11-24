//
//  NSData+GifMaking.m
//  GIFMakingMastery
//
//  Created by 9haomi on 2021/7/26.
//

#import "NSData+GifMaking.h"
#import <MobileCoreServices/MobileCoreServices.h>
@implementation NSData (GifMaking)
+ (NSData *)rawDataImage:(UIImage *)image{
    NSDictionary *options = @{(__bridge NSString *)kCGImageSourceShouldCache : @NO,
                              (__bridge NSString *)kCGImageSourceShouldCacheImmediately : @NO
                              };
    NSMutableData *data = [NSMutableData data];
    CGImageDestinationRef destRef = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)data, kUTTypePNG, 1, (__bridge CFDictionaryRef)options);
    CGImageDestinationAddImage(destRef, image.CGImage, (__bridge CFDictionaryRef)options);
    CGImageDestinationFinalize(destRef);
    CFRelease(destRef);
    return data;
}
@end
