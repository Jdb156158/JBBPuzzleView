//
//  TcePuzzlePuzzleView.h
//  ConstellationCamera
//
//  Created by zzb on 2019/1/9.
//  Copyright © 2019年 ConstellationCamera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXLINVView.h"
#import "DXLINVManage.h"

@protocol TcePuzzlePuzzleViewDelegate<NSObject>

- (void)TcePuzzleMoveEditView;

@end

@interface TcePuzzlePuzzleView : UIView

@property (nonatomic,   weak) id<TcePuzzlePuzzleViewDelegate> puzzleDelegate;

//10个拼图（TceEditImageView）view视图数组对象
@property (nonatomic, strong) NSMutableArray *TcePuzzleContentViewArray;

//几宫格
@property (nonatomic, assign) NSInteger TcePuzzleStyleIndex;
//几宫格不规则风格
@property (nonatomic, assign) NSInteger TcePuzzleStyleRow;
//边距
@property (nonatomic, assign) NSInteger grpValue;

//视图管理
@property(nonatomic, strong) DXLINVManage * manage;

@end
