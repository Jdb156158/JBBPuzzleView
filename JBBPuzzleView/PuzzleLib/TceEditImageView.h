//
//  TceEditImageView.h
//  JBBPuzzleView
//
//  Created by 9haomi on 2021/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TceEditImageView;
@protocol TceEditImageViewDelegate <NSObject>
- (void)TcePuzzleTapWithEditView:(TceEditImageView *)editView;
@end

@interface TceEditImageView : UIView
@property (nonatomic, assign) bool isSelect;//是否选中状态
@property (nonatomic, assign) id<TceEditImageViewDelegate> editDelegate;
@end

NS_ASSUME_NONNULL_END
