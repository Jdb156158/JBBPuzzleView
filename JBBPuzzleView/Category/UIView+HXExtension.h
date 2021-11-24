//
//  UIView+HXExtension.h
//  HXPhotoPickerExample
//
//  Created by 洪欣 on 17/2/16.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXPhotoManager;
@interface UIView (HXExtension)

@property (assign, nonatomic) CGFloat hx_x;
@property (assign, nonatomic) CGFloat hx_y;
@property (assign, nonatomic) CGFloat hx_w;
@property (assign, nonatomic) CGFloat hx_h;
@property (assign, nonatomic) CGFloat hx_centerX;
@property (assign, nonatomic) CGFloat hx_centerY;
@property (assign, nonatomic) CGSize hx_size;
@property (assign, nonatomic) CGPoint hx_origin;

/// 设置圆角。使用自动布局，需要在layoutsubviews 中使用
/// @param radius 圆角尺寸
/// @param corner 圆角位置
- (void)hx_radiusWithRadius:(CGFloat)radius corner:(UIRectCorner)corner;
@end
