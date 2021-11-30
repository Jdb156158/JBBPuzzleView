//
//  PostersCollageSingeToolView.h
//  babyPhoto
//
//  Created by 彭新凯 on 2021/8/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostersCollageSingeToolView : UIView
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titlesLabelArray;
@property (nonatomic, copy) void (^postersCollageSingeToolBlock)(NSInteger type);

@end

NS_ASSUME_NONNULL_END
