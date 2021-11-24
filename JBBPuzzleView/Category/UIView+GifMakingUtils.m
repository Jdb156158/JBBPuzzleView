//
//  UIView+GifMakingUtils.m
//  GIFMakingMastery
//
//  Created by db J on 2021/3/30.
//

#import "UIView+GifMakingUtils.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (GifMakingUtils)


- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates {
    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        return [self snapshotImage];
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (NSData *)snapshotPDF {
    CGRect bounds = self.bounds;
    NSMutableData *data = [NSMutableData data];
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef) data);
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
    CGDataConsumerRelease(consumer);
    if (!context) return nil;
    CGPDFContextBeginPage(context, NULL);
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [self.layer renderInContext:context];
    CGPDFContextEndPage(context);
    CGPDFContextClose(context);
    CGContextRelease(context);
    return data;
}

- (void)setLayerShadow:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 1;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)removeAllSubviews {
    //[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}


- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *) nextResponder;
        }
    }
    return nil;
}

- (CGFloat)visibleAlpha {
    if ([self isKindOfClass:[UIWindow class]]) {
        if (self.hidden) return 0;
        return self.alpha;
    }
    if (!self.window) return 0;
    CGFloat alpha = 1;
    UIView *v = self;
    while (v) {
        if (v.hidden) {
            alpha = 0;
            break;
        }
        alpha *= v.alpha;
        v = v.superview;
    }
    return alpha;
}

- (CGPoint)convertPoint:(CGPoint)point toViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *) self) convertPoint:point toWindow:nil];
        } else {
            return [self convertPoint:point toView:nil];
        }
    }

    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id) self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id) view : view.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point toView:view];
    point = [self convertPoint:point toView:from];
    point = [to convertPoint:point fromWindow:from];
    point = [view convertPoint:point fromView:to];
    return point;
}

- (CGPoint)convertPoint:(CGPoint)point fromViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *) self) convertPoint:point fromWindow:nil];
        } else {
            return [self convertPoint:point fromView:nil];
        }
    }

    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id) view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id) self : self.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point fromView:view];
    point = [from convertPoint:point fromView:view];
    point = [to convertPoint:point fromWindow:from];
    point = [self convertPoint:point fromView:to];
    return point;
}

- (CGRect)convertRect:(CGRect)rect toViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *) self) convertRect:rect toWindow:nil];
        } else {
            return [self convertRect:rect toView:nil];
        }
    }

    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id) self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id) view : view.window;
    if (!from || !to) return [self convertRect:rect toView:view];
    if (from == to) return [self convertRect:rect toView:view];
    rect = [self convertRect:rect toView:from];
    rect = [to convertRect:rect fromWindow:from];
    rect = [view convertRect:rect fromView:to];
    return rect;
}

- (CGRect)convertRect:(CGRect)rect fromViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *) self) convertRect:rect fromWindow:nil];
        } else {
            return [self convertRect:rect fromView:nil];
        }
    }

    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id) view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id) self : self.window;
    if ((!from || !to) || (from == to)) return [self convertRect:rect fromView:view];
    rect = [from convertRect:rect fromView:view];
    rect = [to convertRect:rect fromWindow:from];
    rect = [self convertRect:rect fromView:to];
    return rect;
}

- (CGFloat)nov_left {
    return self.frame.origin.x;
}

- (void)setNov_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)nov_top {
    return self.frame.origin.y;
}

- (void)setNov_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)nov_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setNov_right:(CGFloat)nov_right {
    CGRect frame = self.frame;
    frame.origin.x = nov_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)nov_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setNov_bottom:(CGFloat)nov_bottom {
    CGRect frame = self.frame;
    frame.origin.y = nov_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)nov_width {
    return self.frame.size.width;
}

- (void)setNov_width:(CGFloat)nov_width {
    CGRect frame = self.frame;
    frame.size.width = nov_width;
    self.frame = frame;
}

- (CGFloat)nov_height {
    return self.frame.size.height;
}

- (void)setNov_height:(CGFloat)nov_height {
    CGRect frame = self.frame;
    frame.size.height = nov_height;
    self.frame = frame;
}

- (CGFloat)nov_centerX {
    return self.center.x;
}

- (void)setNov_centerX:(CGFloat)nov_centerX {
    self.center = CGPointMake(nov_centerX, self.center.y);
}

- (CGFloat)nov_centerY {
    return self.center.y;
}

- (void)setNov_centerY:(CGFloat)nov_centerY {
    self.center = CGPointMake(self.center.x, nov_centerY);
}

- (CGPoint)nov_origin {
    return self.frame.origin;
}

- (void)setNov_origin:(CGPoint)nov_origin {
    CGRect frame = self.frame;
    frame.origin = nov_origin;
    self.frame = frame;
}

- (CGSize)nov_size {
    return self.frame.size;
}

- (void)setNov_size:(CGSize)nov_size {
    CGRect frame = self.frame;
    frame.size = nov_size;
    self.frame = frame;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)circleWidth {
    return self.cornerRadius*2;
}

- (void)setCircleWidth:(CGFloat)circleWidth {
    self.cornerRadius = circleWidth/2;
}

- (BOOL)masksToBounds {
    return self.layer.masksToBounds;
}

- (void)setMasksToBounds:(BOOL)masksToBounds {
    self.layer.masksToBounds = masksToBounds;
}

- (UIColor *)borderColor {
    return [[UIColor alloc] initWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = [borderColor CGColor];
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)setRounded:(CGFloat)radius masksToBounds:(BOOL)masks {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = masks;
}

- (UIStackView *)wrappInStackViewWithPadding:(UIEdgeInsets)padding {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFill;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.layoutMargins = padding;
    stackView.layoutMarginsRelativeArrangement = true;
    [stackView addArrangedSubview:self];

    CGSize newSize = [stackView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    stackView.frame = CGRectMake(0, 0, newSize.width, newSize.height);

    return stackView;
}

- (void)setRoundedByCorners:(UIRectCorner)corners withRadius:(CGSize)radius {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radius];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.path = [path CGPath];
    self.layer.mask = shapeLayer;
}
@end
