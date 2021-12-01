//
//  TcePuzzlePuzzleView.m
//  ConstellationCamera
//
//  Created by zzb on 2019/1/9.
//  Copyright © 2019年 ConstellationCamera. All rights reserved.
//

#import "TcePuzzlePuzzleView.h"
//#import "TcePuzzlePuzzleEditScrollView.h"
#import "TcePuzzleViewFrameAndPoint.h"
//#import <AssetsLibrary/AssetsLibrary.h>
#import "TCESingle.h"
#import "TceEditImageView.h"

#import "CustomAlbumController.h"



@interface TcePuzzlePuzzleView()<TceEditImageViewDelegate,DXLINVManageDelegate>
{
    BOOL contain;
    CGPoint startPoint;
    CGPoint originPoint;
}

//所有的视图
@property (nonatomic, strong) DXLINVView *TcePuzzleFirstView;
@property (nonatomic, strong) DXLINVView *TcePuzzleSecondView;
@property (nonatomic, strong) DXLINVView *TcePuzzleThirdView;
@property (nonatomic, strong) DXLINVView *TcePuzzleFourthView;
@property (nonatomic, strong) DXLINVView *TcePuzzleFiveView;
@property (nonatomic, strong) DXLINVView *TcePuzzleSixView;
@property (nonatomic, strong) DXLINVView *TcePuzzleSevenView;
@property (nonatomic, strong) DXLINVView *TcePuzzleEightView;
@property (nonatomic, strong) DXLINVView *TcePuzzleNineView;
@property (nonatomic, strong) DXLINVView *TcePuzzleTempView;

//当前选中的DXLINVManage的tag
@property(nonatomic, assign) NSInteger cutterDxlinviewTag;

@property (nonatomic, strong) NSArray *points;

@end

@implementation TcePuzzlePuzzleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.cutterDxlinviewTag = -1;
        _grpValue = 5;
        [self TcePuzzleInitPuzzleView];
    }
    return self;
}

- (void)TcePuzzleInitPuzzleView
{
    
    _TcePuzzleFirstView  = [[DXLINVView alloc] initWithFrame:CGRectZero];
    _TcePuzzleSecondView = [[DXLINVView alloc] initWithFrame:CGRectZero];
    _TcePuzzleThirdView  = [[DXLINVView alloc] initWithFrame:CGRectZero];
    _TcePuzzleFourthView = [[DXLINVView alloc] initWithFrame:CGRectZero];
    _TcePuzzleFiveView   = [[DXLINVView alloc] initWithFrame:CGRectZero];
    _TcePuzzleSixView    = [[DXLINVView alloc] initWithFrame:CGRectZero];
    _TcePuzzleSevenView  = [[DXLINVView alloc] initWithFrame:CGRectZero];
    _TcePuzzleEightView  = [[DXLINVView alloc] initWithFrame:CGRectZero];
    _TcePuzzleNineView   = [[DXLINVView alloc] initWithFrame:CGRectZero];
    
    [self TcePuzzleResetAllView];
    
    _TcePuzzleFirstView.tag  = 1;
    _TcePuzzleSecondView.tag = 2;
    _TcePuzzleThirdView.tag  = 3;
    _TcePuzzleFourthView.tag = 4;
    _TcePuzzleFiveView.tag   = 5;
    _TcePuzzleSixView.tag = 6;
    _TcePuzzleSevenView.tag  = 7;
    _TcePuzzleEightView.tag = 8;
    _TcePuzzleNineView.tag   = 9;
    
    
    [self addSubview:_TcePuzzleFirstView];
    [self addSubview:_TcePuzzleSecondView];
    [self addSubview:_TcePuzzleThirdView];
    [self addSubview:_TcePuzzleFourthView];
    [self addSubview:_TcePuzzleFiveView];
    [self addSubview:_TcePuzzleSixView];
    [self addSubview:_TcePuzzleSevenView];
    [self addSubview:_TcePuzzleEightView];
    [self addSubview:_TcePuzzleNineView];
    
    self.manage = [[DXLINVManage alloc]init];
    self.manage.backgroundColor = [UIColor clearColor];
    [self addSubview:self.manage];
    self.manage.delegate = self;
}

- (void)TcePuzzleResetAllView
{
    [self TcePuzzleStyleSettingWithView:_TcePuzzleFirstView];
    [self TcePuzzleStyleSettingWithView:_TcePuzzleSecondView];
    [self TcePuzzleStyleSettingWithView:_TcePuzzleThirdView];
    [self TcePuzzleStyleSettingWithView:_TcePuzzleFourthView];
    [self TcePuzzleStyleSettingWithView:_TcePuzzleFiveView];
    [self TcePuzzleStyleSettingWithView:_TcePuzzleSixView];
    [self TcePuzzleStyleSettingWithView:_TcePuzzleSevenView];
    [self TcePuzzleStyleSettingWithView:_TcePuzzleEightView];
    [self TcePuzzleStyleSettingWithView:_TcePuzzleNineView];
}

- (void)TcePuzzleStyleSettingWithView:(DXLINVView *)view
{
    view.frame = CGRectZero;
    [view setClipsToBounds:YES];
    [view setUserInteractionEnabled:YES];
    [view setBackgroundColor:[UIColor colorWithHexString:@"#181A1E"]];
}


- (void)setTcePuzzleStyleIndex:(NSInteger)TcePuzzleStyleIndex
{
    _TcePuzzleStyleIndex = TcePuzzleStyleIndex;
    
    _TcePuzzleContentViewArray = [NSMutableArray array];
    
    if (TcePuzzleStyleIndex == 2) {
        [_TcePuzzleContentViewArray addObject:_TcePuzzleFirstView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleSecondView];
    }else if (TcePuzzleStyleIndex == 3){
        [_TcePuzzleContentViewArray addObject:_TcePuzzleFirstView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleSecondView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleThirdView];
    }else if (TcePuzzleStyleIndex == 4){
        [_TcePuzzleContentViewArray addObject:_TcePuzzleFirstView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleSecondView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleThirdView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleFourthView];
    }else if (TcePuzzleStyleIndex == 5){
        [_TcePuzzleContentViewArray addObject:_TcePuzzleFirstView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleSecondView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleThirdView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleFourthView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleFiveView];
    }else if (TcePuzzleStyleIndex == 6){
        [_TcePuzzleContentViewArray addObject:_TcePuzzleFirstView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleSecondView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleThirdView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleFourthView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleFiveView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleSixView];
    }else if (TcePuzzleStyleIndex == 7){
        [_TcePuzzleContentViewArray addObject:_TcePuzzleFirstView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleSecondView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleThirdView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleFourthView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleFiveView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleSixView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleSevenView];
    }else if (TcePuzzleStyleIndex == 8){
        [_TcePuzzleContentViewArray addObject:_TcePuzzleFirstView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleSecondView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleThirdView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleFourthView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleFiveView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleSixView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleSevenView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleEightView];
    }else if (TcePuzzleStyleIndex == 9){
        [_TcePuzzleContentViewArray addObject:_TcePuzzleFirstView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleSecondView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleThirdView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleFourthView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleFiveView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleSixView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleSevenView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleEightView];
        [_TcePuzzleContentViewArray addObject:_TcePuzzleNineView];
    }
    
    [self.manage.invViews removeAllObjects];
    [self.manage setInvViews:_TcePuzzleContentViewArray];
    
    
    _points = [TcePuzzleViewFrameAndPoint tceGetArrayWithQuantity:TcePuzzleStyleIndex];
//    self.TcePuzzleStyleRow = [TCESingle tceSingle].tceStyleRow;
//    self.grpValue = [TCESingle tceSingle].tceGra;
//    if (_points)
//    {
//        [self TcePuzzleResetAllView];
//        [self TcePuzzleResetStyle];
//    }
}

- (void)TcePuzzleResetStyle
{
    if (_points)
    {
        if (_TcePuzzleStyleRow >= _points.count) {
            _TcePuzzleStyleRow = _points.count - 1;
        }
        CGSize superSize = CGSizeMake(720, 960);
        superSize = [TcePuzzlePuzzleView TcePuzzleGetNewSizeScaleWithSize:superSize scale:2.0f];
        NSArray *subPoints = self.points[_TcePuzzleStyleRow];
        
        for (int j = 0; j<subPoints.count; j++)
        {

            NSDictionary *subDict = [subPoints objectAtIndex:j];
            
            //当前格子位置和大小
            CGRect rect = [self TcePuzzleRectWithArray:subDict[@"pointArray"] andSuperSize:superSize];
 
            if (j < self.TcePuzzleContentViewArray.count) {
                DXLINVView *imageView = (DXLINVView *)self.TcePuzzleContentViewArray[j];
                NSLog(@"=====%f",rect.size.width);
                
                //根据风格来绘制位置
                imageView.frame = [self cutterDXLINVViewRect:j  oldRect:rect];
                
                
                if (imageView.originalImage == nil) {
                    imageView.isVideo = NO;
                    UIImage *defaultImage = [UIImage imageNamed:@"clearMark"];
                    [imageView setImage:defaultImage];
                    imageView.originalImage = defaultImage;
                }else if(imageView.isVideo){
                    if (imageView.videoAsset) {
                        [imageView updateVideoContentViewConstraint];
                    }
                }else if(imageView.originalImage && !imageView.isVideo){
                    imageView.isVideo = NO;
                    [imageView updateImageViewConstraint];
                }
                imageView.filterName = @"";
                
                //imageView.editDelegate = self;
                //NSLog(@"======imageView.frame:[x:%f,y:%f,width:%f,hieght:%f]",imageView.frame.origin.x,imageView.frame.origin.y,imageView.frame.size.width,imageView.frame.size.height);

            }
        }
    }
}

- (CGRect)cutterDXLINVViewRect:(NSInteger)tagIdext oldRect:(CGRect)rect{
    if (self.TcePuzzleStyleIndex == 2 && self.TcePuzzleStyleRow == 3) {
        if (tagIdext == 0) {
            return CGRectMake(rect.origin.x+self.grpValue, rect.origin.y+self.grpValue, rect.size.width-self.grpValue*2, rect.size.height-self.grpValue-self.grpValue/2);
        }else{
            return CGRectMake(rect.origin.x+self.grpValue, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue*2, rect.size.height-self.grpValue-self.grpValue/2);
        }
        
    }else if(self.TcePuzzleStyleIndex == 3 && self.TcePuzzleStyleRow == 4){
        if (tagIdext == 0) {
            return CGRectMake(rect.origin.x+self.grpValue, rect.origin.y+self.grpValue, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue*2);
        }else if(tagIdext == 1){
            return CGRectMake(rect.origin.x+self.grpValue/2, rect.origin.y+self.grpValue, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue-self.grpValue/2);
        }else{
            return CGRectMake(rect.origin.x+self.grpValue/2, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue-self.grpValue/2);
        }
    }else if(self.TcePuzzleStyleIndex == 4 && self.TcePuzzleStyleRow == 6){
        if (tagIdext == 0) {
            return CGRectMake(rect.origin.x+self.grpValue, rect.origin.y+self.grpValue, rect.size.width-self.grpValue*2, rect.size.height-self.grpValue-self.grpValue/2);
        }else if(tagIdext == 1){
            return CGRectMake(rect.origin.x+self.grpValue, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue, rect.size.height-self.grpValue-self.grpValue/2);
        }else if(tagIdext == 2){
            return CGRectMake(rect.origin.x+self.grpValue, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue, rect.size.height-self.grpValue-self.grpValue/2);
        }else{
            return CGRectMake(rect.origin.x+self.grpValue, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue*2, rect.size.height-self.grpValue-self.grpValue/2);
        }
    }else if(self.TcePuzzleStyleIndex == 5 && self.TcePuzzleStyleRow == 0){
        if (tagIdext == 0) {
            return CGRectMake(rect.origin.x+self.grpValue, rect.origin.y+self.grpValue, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue-self.grpValue/2);
        }else if(tagIdext == 1){
            return CGRectMake(rect.origin.x+self.grpValue/2, rect.origin.y+self.grpValue, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue-self.grpValue/2);
        }else if(tagIdext == 2){
            return CGRectMake(rect.origin.x+self.grpValue/2, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue);
        }else if(tagIdext == 3){
            return CGRectMake(rect.origin.x+self.grpValue/2, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue-self.grpValue/2);
        }else{
            return CGRectMake(rect.origin.x+self.grpValue, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue-self.grpValue/2);
        }
    }else if(self.TcePuzzleStyleIndex == 6 && self.TcePuzzleStyleRow == 1){
        if (tagIdext == 0) {
            return CGRectMake(rect.origin.x+self.grpValue, rect.origin.y+self.grpValue, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue-self.grpValue/2);
        }else if(tagIdext == 1){
            return CGRectMake(rect.origin.x+self.grpValue/2, rect.origin.y+self.grpValue, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue-self.grpValue/2);
        }else if(tagIdext == 2){
            return CGRectMake(rect.origin.x+self.grpValue, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue);
        }else if(tagIdext == 3){
            return CGRectMake(rect.origin.x+self.grpValue/2, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue);
        }else if(tagIdext == 4){
            return CGRectMake(rect.origin.x+self.grpValue, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue-self.grpValue/2);
        }else{
            return CGRectMake(rect.origin.x+self.grpValue/2, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue-self.grpValue/2);
        }
    }else if(self.TcePuzzleStyleIndex == 7 && self.TcePuzzleStyleRow == 0){
        if (tagIdext == 0) {
            return CGRectMake(rect.origin.x+self.grpValue, rect.origin.y+self.grpValue, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue-self.grpValue/2);
        }else if(tagIdext == 1){
            return CGRectMake(rect.origin.x+self.grpValue/2, rect.origin.y+self.grpValue, rect.size.width-self.grpValue, rect.size.height-self.grpValue-self.grpValue/2);
        }else if(tagIdext == 2){
            return CGRectMake(rect.origin.x+self.grpValue/2, rect.origin.y+self.grpValue, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue-self.grpValue/2);
        }else if(tagIdext == 3){
            return CGRectMake(rect.origin.x+self.grpValue, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue*2, rect.size.height-self.grpValue);
        }else if(tagIdext == 4){
            return CGRectMake(rect.origin.x+self.grpValue, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue-self.grpValue/2);
        }else if(tagIdext == 5){
            return CGRectMake(rect.origin.x+self.grpValue/2, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue, rect.size.height-self.grpValue-self.grpValue/2);
        }else{
            return CGRectMake(rect.origin.x+self.grpValue/2, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue-self.grpValue/2);
        }
    }else if(self.TcePuzzleStyleIndex == 8 && self.TcePuzzleStyleRow == 0){
        if (tagIdext == 0) {
            return CGRectMake(rect.origin.x+self.grpValue, rect.origin.y+self.grpValue, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue-self.grpValue/2);
        }else if(tagIdext == 1){
            return CGRectMake(rect.origin.x+self.grpValue/2, rect.origin.y+self.grpValue, rect.size.width-self.grpValue, rect.size.height-self.grpValue-self.grpValue/2);
        }else if(tagIdext == 2){
            return CGRectMake(rect.origin.x+self.grpValue/2, rect.origin.y+self.grpValue, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue-self.grpValue/2);
        }else if(tagIdext == 3){
            return CGRectMake(rect.origin.x+self.grpValue, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue);
        }else if(tagIdext == 4){
            return CGRectMake(rect.origin.x+self.grpValue/2, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue);
        }else if(tagIdext == 5){
            return CGRectMake(rect.origin.x+self.grpValue, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue-self.grpValue/2);
        }else if(tagIdext == 6){
            return CGRectMake(rect.origin.x+self.grpValue/2, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue, rect.size.height-self.grpValue-self.grpValue/2);
        }else{
            return CGRectMake(rect.origin.x+self.grpValue/2, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue-self.grpValue/2);
        }
    }else if(self.TcePuzzleStyleIndex == 9 && self.TcePuzzleStyleRow == 0){
        if (tagIdext == 0) {
            return CGRectMake(rect.origin.x+self.grpValue, rect.origin.y+self.grpValue, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue-self.grpValue/2);
        }else if(tagIdext == 1){
            return CGRectMake(rect.origin.x+self.grpValue/2, rect.origin.y+self.grpValue, rect.size.width-self.grpValue, rect.size.height-self.grpValue-self.grpValue/2);
        }else if(tagIdext == 2){
            return CGRectMake(rect.origin.x+self.grpValue/2, rect.origin.y+self.grpValue, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue-self.grpValue/2);
        }else if(tagIdext == 3){
            return CGRectMake(rect.origin.x+self.grpValue, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue);
        }else if(tagIdext == 4){
            return CGRectMake(rect.origin.x+self.grpValue/2, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue, rect.size.height-self.grpValue);
        }else if(tagIdext == 5){
            return CGRectMake(rect.origin.x+self.grpValue/2, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue);
        }else if(tagIdext == 6){
            return CGRectMake(rect.origin.x+self.grpValue, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue-self.grpValue/2);
        }else if(tagIdext == 7){
            return CGRectMake(rect.origin.x+self.grpValue/2, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue, rect.size.height-self.grpValue-self.grpValue/2);
        }else{
            return CGRectMake(rect.origin.x+self.grpValue/2, rect.origin.y+self.grpValue/2, rect.size.width-self.grpValue-self.grpValue/2, rect.size.height-self.grpValue-self.grpValue/2);
        }
    }else{
        return CGRectMake(rect.origin.x+self.grpValue, rect.origin.y+self.grpValue, rect.size.width-self.grpValue*2, rect.size.height-self.grpValue*2);
    }
}


- (CGRect)TcePuzzleRectWithArray:(NSArray *)array andSuperSize:(CGSize)superSize
{
    CGRect rect = CGRectZero;
    CGFloat minX = INT_MAX;
    CGFloat maxX = 0;
    CGFloat minY = INT_MAX;
    CGFloat maxY = 0;
    for (int i = 0; i < [array count]; i++) {
        NSString *pointString = [array objectAtIndex:i];
        CGPoint point = CGPointFromString(pointString);
        if (point.x <= minX) {
            minX = point.x;
        }
        if (point.x >= maxX) {
            maxX = point.x;
        }
        if (point.y <= minY) {
            minY = point.y;
        }
        if (point.y >= maxY) {
            maxY = point.y;
        }
        rect = CGRectMake(minX, minY, maxX - minX, maxY - minY);
    }
    rect = [TcePuzzlePuzzleView TcePuzzleGetRectScaleWithRect:rect scale:2.0f];
    rect.origin.x = rect.origin.x * self.frame.size.width/superSize.width;
    rect.origin.y = rect.origin.y * self.frame.size.height/superSize.height;
    rect.size.width = rect.size.width * self.frame.size.width/superSize.width;
    rect.size.height = rect.size.height * self.frame.size.height/superSize.height;
    return rect;
}

+ (CGRect)TcePuzzleGetRectScaleWithRect:(CGRect)rect scale:(CGFloat)scale
{
    if (scale<=0) {
        scale = 1.0f;
    }
    CGRect retRect = CGRectZero;
    retRect.origin.x = rect.origin.x/scale;
    retRect.origin.y = rect.origin.y/scale;
    retRect.size.width = rect.size.width/scale;
    retRect.size.height = rect.size.height/scale;
    return  retRect;
}


+ (CGSize)TcePuzzleGetNewSizeScaleWithSize:(CGSize)size scale:(CGFloat)scale
{
    if (scale <= 0) {
        scale = 1.0f;
    }
    CGSize retSize = CGSizeZero;
    retSize.width = size.width/scale;
    retSize.height = size.height/scale;
    return  retSize;
}


+ (CGPoint)TcePuzzlePointScaleWithPoint:(CGPoint)point scale:(CGFloat)scale
{
    if (scale<=0) {
        scale = 1.0f;
    }
    CGPoint retPointt = CGPointZero;
    retPointt.x = point.x/scale;
    retPointt.y = point.y/scale;
    return  retPointt;
}


#pragma mark - seter

- (void)setGrpValue:(NSInteger)grpValue
{
    _grpValue = grpValue;
    [TCESingle tceSingle].tceGra = grpValue;
    if (_points)
    {
        [self TcePuzzleResetAllView];
        [self TcePuzzleResetStyle];
    }
}

- (void)setTcePuzzleStyleRow:(NSInteger)TcePuzzleStyleRow
{
    _TcePuzzleStyleRow = TcePuzzleStyleRow;
    [TCESingle tceSingle].tceStyleRow = TcePuzzleStyleRow;
    if (_points)
    {
        [self TcePuzzleResetAllView];
        [self TcePuzzleResetStyle];
    }
}

#pragma mark - TceEditImageViewDelegate

- (void)TcePuzzleTapWithEditView:(nonnull TceEditImageView *)editView {
    NSLog(@"当前view的tag:%ld",(long)editView.tag);
    CustomAlbumController *nextview = [[CustomAlbumController alloc] init];
    [[UIViewController currentViewController].navigationController pushViewController:nextview animated:YES];
}

- (void)changeImageClick:(DXLINVView *)invView {
    if (self.cutterDxlinviewTag == invView.tag) {
        //去相册替换资源
        [self toAlbumChangeInvView:invView];
    }else{
        //标记当前选中状态的invView
        self.cutterDxlinviewTag = invView.tag;
    }
    
    NSLog(@"当前view的tag:%ld DXLINVViewh状态：%d",(long)invView.tag,invView.invViewtatus);
}

-(void)updatePlayVideoDXLINVManageView{
    for(DXLINVView *view in self.manage.invViews){
        if (view.isVideo) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [view.videoPlayerController playFromCurrentTime];
            });
        }
    }
}

- (void)toAlbumChangeInvView:(DXLINVView *)invView {
    
    CustomAlbumController *nextview = [[CustomAlbumController alloc] init];
    nextview.didSelextAssetfinsh = ^(PHAsset * _Nonnull asset) {
        //如果是GIF
        if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"] ||
                  [[asset valueForKey:@"filename"] hasSuffix:@"gif"]){
            NSLog(@"====选的是GIF资源====");
            [self gifToNsdata:asset invView:invView];
        }else if (asset.mediaType == PHAssetMediaTypeImage) {
            NSLog(@"====选的是图片资源====");
            PHImageRequestOptions *requestOptions = [PHImageRequestOptions new];
            requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
            requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            requestOptions.networkAccessAllowed = YES;
            requestOptions.synchronous = YES;
            CGSize targetSize = CGSizeMake(5000, 5000);
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeDefault options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                dispatch_async(dispatch_get_main_queue(), ^{

                    invView.isVideo = NO;
                    [invView setImage:result];
                    invView.originalImage = result;

                });
                
            }];
            
        } else if(asset.mediaType == PHAssetMediaTypeVideo){
            NSLog(@"====选的是视频资源====");
            invView.isVideo = YES;
            [invView setVideoResources:asset];
        }
        
        //播放
        //[self updatePlayVideoDXLINVManageView];
    };
    [[UIViewController currentViewController].navigationController pushViewController:nextview animated:YES];
}


#pragma mark - 跳转到编辑gif详情页面
- (void)gifToNsdata:(PHAsset *)asset invView:(DXLINVView *)invView{
    
    NSString *MYGIF_New_PATH =  [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"MyNEWGIF"];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:MYGIF_New_PATH withIntermediateDirectories:YES attributes:nil error:nil];
    __weak typeof(self) weakself = self;
    
    //首先将GIF 图片的 PHAsset 转 NSData
    [SVProgressHUD showWithStatus:@"正在读取..."];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *resourceList = [PHAssetResource assetResourcesForAsset:asset];
        [resourceList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAssetResource *resource = obj;
            PHAssetResourceRequestOptions *option = [[PHAssetResourceRequestOptions alloc]init];
            option.networkAccessAllowed = YES;
            if ([resource.uniformTypeIdentifier isEqualToString:@"com.compuserve.gif"]) {
                NSLog(@"是gif图片格式");
                // 首先,需要获取沙盒路径
                NSString * imageFilePath = [MYGIF_New_PATH stringByAppendingPathComponent:resource.originalFilename];
                // 拼接图片名为resource.originalFilename的路径
                [weakself deleteFileAtPath:imageFilePath];
                __block NSData *data = [[NSData alloc]init];
                [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource toFile:[NSURL fileURLWithPath:imageFilePath]  options:option completionHandler:^(NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"error:%@",error);
                        if(error.code == -1){//文件已存在
                            data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:imageFilePath]];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //完成了转换
                                [weakself gifToImagesArray:data invView:invView];
                            });
                        }else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [SVProgressHUD dismiss];
                                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"no_gif_resource", nil)];
                            });
                        }
                    } else {
                        data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:imageFilePath]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //完成了转换
                            [weakself gifToImagesArray:data invView:invView];
                        });
                    }

                }];

            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"no_gif_resource", nil)];
                });
                NSLog(@"jepg");
            }
        }];
    });
}

-(void)gifToImagesArray:(NSData *)data invView:(DXLINVView *)invView{
    
    NSString *MYGIF_New_PATH =  [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"MyNEWGIF"];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:MYGIF_New_PATH withIntermediateDirectories:YES attributes:nil error:nil];
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    NSMutableArray *images = [NSMutableArray array];
    for (size_t i = 0; i < count; i++) {
        NSString *imgPath = [NSString stringWithFormat:@"%@/%ld.png", MYGIF_New_PATH, i];
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        UIImage *img = [UIImage imageWithCGImage:image];
        CGImageRelease(image);
        @autoreleasepool {
            NSData *imgData = [NSData rawDataImage:img];
            [self deleteFileAtPath:imgPath];
            [imgData writeToFile:imgPath atomically:YES];
            [images addObject:imgPath];
            img = nil;
        }
    }
    CGFloat delayTime = 0.1;
    CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
    if (properties) {
        CFDictionaryRef gifProperties;
        BOOL result = CFDictionaryGetValueIfPresent(properties, kCGImagePropertyGIFDictionary, (const void **)&gifProperties);
        if (result) {
            const void *durationValue;
            if (CFDictionaryGetValueIfPresent(gifProperties, kCGImagePropertyGIFUnclampedDelayTime, &durationValue)) {
                delayTime = [(__bridge NSNumber *)durationValue doubleValue];
                if (delayTime < 0) {
                    if (CFDictionaryGetValueIfPresent(gifProperties, kCGImagePropertyGIFDelayTime, &durationValue)) {
                        delayTime = [(__bridge NSNumber *)durationValue doubleValue];
                    }
                }
            }
        }
    }
    CFRelease(source);
    
    NSLog(@"gif转换得到的数组：%@",images);
    [SVProgressHUD dismiss];
    
    [self imagesToVideoDelayTime:delayTime andImages:images invView:invView];
}

- (void)imagesToVideoDelayTime:(CGFloat)delayTime andImages:(NSArray *)imagesArray invView:(DXLINVView *)invView{
    
    [SVProgressHUD showProgress:0 status:@"处理中..."];
        
    NSString *MYGIF_New_PATH =  [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"MyNEWGIF"];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:MYGIF_New_PATH withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *outputPath = [NSString stringWithFormat:@"%@/shareGifToVidwo.mp4", MYGIF_New_PATH];
    
    UIImage *firstImg = [UIImage imageWithContentsOfFile:imagesArray.firstObject];
    
    NSMutableArray *imageMutableArray = [[NSMutableArray alloc] init];
    for (NSString *eachPath in imagesArray) {
        UIImage *eachImg = [UIImage imageWithContentsOfFile:eachPath];
        [imageMutableArray addObject:eachImg];
        
    }
    
    if (imageMutableArray.count<4) {
        NSArray *copyArry = imageMutableArray;
        [imageMutableArray addObjectsFromArray:copyArry];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MediaComposition *compsition = [[MediaComposition alloc] init];
        compsition.picTime = delayTime;
        compsition.frameNumber = 5;
        compsition.naturalSize = CGSizeMake(firstImg.size.width, firstImg.size.height);
        compsition.outputPath = outputPath;
        [compsition imagesVideoAnimationWith:imageMutableArray progress:^(float progress) {
            NSLog(@"%f",progress);
            if (progress>0) {
                [SVProgressHUD showProgress:progress status:@"处理中..."];
            }
        } success:^(NSString * success) {
            NSLog(@"%@",success);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                invView.isVideo = YES;
                invView.videoUrl = [NSURL fileURLWithPath:outputPath];;
                [SVProgressHUD dismiss];
            });
            

        } failure:^(NSString * failure) {
                            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }];
        
    });
}

- (void)deleteFileAtPath:(NSString *)path {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}
@end
