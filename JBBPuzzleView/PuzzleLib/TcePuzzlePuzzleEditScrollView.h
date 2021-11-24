//
//  TcePuzzlePuzzleEditScrollView.h
//  ConstellationCamera
//
//  Created by zzb on 2019/1/9.
//  Copyright © 2019年 ConstellationCamera. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TcePuzzlePuzzleEditScrollView;
@protocol TcePuzzlePuzzleEditScrollViewDelegate <NSObject>
- (void)TcePuzzleTapWithEditView:(TcePuzzlePuzzleEditScrollView *)editView;
@end


@interface TcePuzzlePuzzleEditScrollView : UIScrollView
@property (nonatomic, assign) id<TcePuzzlePuzzleEditScrollViewDelegate> editDelegate;
@property (nonatomic, retain) UIBezierPath  *TcePuzzleRealCellPath;
@property (nonatomic, retain) UIImageView   *TcePuzzleImageView;//普通图片
@property (nonatomic, retain) YYAnimatedImageView *TcePuzzleAnimatedImageView;//动态图片
@property (nonatomic, assign) CGRect        TcePuzzleOldRect;
//@property (nonatomic, copy) void(^ClickChooseView)(NSInteger chooseTag);

- (void)setNotReloadFrame:(CGRect)frame;
- (void)setImageViewData:(UIImage *)image;
- (void)setImageViewData:(UIImage *)image rect:(CGRect)rect;

@end
