//
//  UIView+GifMakingUtils.h
//  GIFMakingMastery
//
//  Created by db J on 2021/3/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (GifMakingUtils)

/**
 Create a snapshot image of the complete view hierarchy.
 */
- (nullable UIImage *)snapshotImage;

/**
 Create a snapshot image of the complete view hierarchy.
 @discussion It's faster than "snapshotImage", but may cause screen updates.
 See -[UIView drawViewHierarchyInRect:afterScreenUpdates:] for more information.
 */
- (nullable UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;

/**
 Create a snapshot PDF of the complete view hierarchy.
 */
- (nullable NSData *)snapshotPDF;

/**
 Shortcut to set the view.layer's shadow
 
 @param color  Shadow Color
 @param offset Shadow offset
 @param radius Shadow radius
 */
- (void)setLayerShadow:(nullable UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;

/**
 Remove all subviews.
 
 @warning Never call this method inside your view's drawRect: method.
 */
- (void)removeAllSubviews;

/**
 Returns the view's view controller (may be nil).
 */
@property (nullable, nonatomic, readonly) UIViewController *viewController;

/**
 Returns the visible alpha on screen, taking into account superview and window.
 */
@property (nonatomic, readonly) CGFloat visibleAlpha;

/**
 Converts a point from the receiver's coordinate system to that of the specified view or window.
 
 @param point A point specified in the local coordinate system (bounds) of the receiver.
 @param view  The view or window into whose coordinate system point is to be converted.
 If view is nil, this method instead converts to window base coordinates.
 @return The point converted to the coordinate system of view.
 */
- (CGPoint)convertPoint:(CGPoint)point toViewOrWindow:(nullable UIView *)view;

/**
 Converts a point from the coordinate system of a given view or window to that of the receiver.
 
 @param point A point specified in the local coordinate system (bounds) of view.
 @param view  The view or window with point in its coordinate system.
 If view is nil, this method instead converts from window base coordinates.
 @return The point converted to the local coordinate system (bounds) of the receiver.
 */
- (CGPoint)convertPoint:(CGPoint)point fromViewOrWindow:(nullable UIView *)view;

/**
 Converts a rectangle from the receiver's coordinate system to that of another view or window.
 
 @param rect A rectangle specified in the local coordinate system (bounds) of the receiver.
 @param view The view or window that is the target of the conversion operation. If view is nil, this method instead converts to window base coordinates.
 @return The converted rectangle.
 */
- (CGRect)convertRect:(CGRect)rect toViewOrWindow:(nullable UIView *)view;

/**
 Converts a rectangle from the coordinate system of another view or window to that of the receiver.
 
 @param rect A rectangle specified in the local coordinate system (bounds) of view.
 @param view The view or window with rect in its coordinate system.
 If view is nil, this method instead converts from window base coordinates.
 @return The converted rectangle.
 */
- (CGRect)convertRect:(CGRect)rect fromViewOrWindow:(nullable UIView *)view;


@property (nonatomic) CGFloat nov_left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat nov_top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat nov_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat nov_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat nov_width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat nov_height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat nov_centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat nov_centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint nov_origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  nov_size;        ///< Shortcut for frame.size.


@property(nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property(nonatomic, assign) IBInspectable CGFloat circleWidth;
@property(nonatomic, assign) IBInspectable BOOL masksToBounds;
@property(nonatomic, strong) IBInspectable UIColor * borderColor;
@property(nonatomic, assign) IBInspectable CGFloat  borderWidth;


- (void)setRounded:(CGFloat)radius masksToBounds:(BOOL)masks;
- (UIStackView *)wrappInStackViewWithPadding:(UIEdgeInsets)padding;

- (void)setRoundedByCorners:(UIRectCorner)corners withRadius:(CGSize)radius;
@end

NS_ASSUME_NONNULL_END
