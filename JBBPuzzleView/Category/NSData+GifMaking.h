//
//  NSData+GifMaking.h
//  GIFMakingMastery
//
//  Created by 9haomi on 2021/7/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (GifMaking)

+ (NSData *)rawDataImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
