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
    
    if (!_TcePuzzleContentViewArray)
    {
        _TcePuzzleContentViewArray = [NSMutableArray array];
    }
    
    _TcePuzzleFirstView.tag  = 1;
    _TcePuzzleSecondView.tag = 2;
    _TcePuzzleThirdView.tag  = 3;
    _TcePuzzleFourthView.tag = 4;
    _TcePuzzleFiveView.tag   = 5;
    _TcePuzzleSixView.tag = 6;
    _TcePuzzleSevenView.tag  = 7;
    _TcePuzzleEightView.tag = 8;
    _TcePuzzleNineView.tag   = 9;
    
    [_TcePuzzleContentViewArray addObject:_TcePuzzleFirstView];
    [_TcePuzzleContentViewArray addObject:_TcePuzzleSecondView];
    [_TcePuzzleContentViewArray addObject:_TcePuzzleThirdView];
    [_TcePuzzleContentViewArray addObject:_TcePuzzleFourthView];
    [_TcePuzzleContentViewArray addObject:_TcePuzzleFiveView];
    [_TcePuzzleContentViewArray addObject:_TcePuzzleSixView];
    [_TcePuzzleContentViewArray addObject:_TcePuzzleSevenView];
    [_TcePuzzleContentViewArray addObject:_TcePuzzleEightView];
    [_TcePuzzleContentViewArray addObject:_TcePuzzleNineView];
    
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
    [self.manage setInvViews:_TcePuzzleContentViewArray];
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
    [view setBackgroundColor:[UIColor grayColor]];
}


- (void)setTcePuzzleStyleIndex:(NSInteger)TcePuzzleStyleIndex
{
    _points = [TcePuzzleViewFrameAndPoint tceGetArrayWithQuantity:TcePuzzleStyleIndex];
    self.TcePuzzleStyleRow = [TCESingle tceSingle].tceStyleRow;
    self.grpValue = [TCESingle tceSingle].tceGra;
    if (_points)
    {
        [self TcePuzzleResetAllView];
        [self TcePuzzleResetStyle];
    }
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
            CGRect rect = CGRectZero;
            UIBezierPath *path = nil;
                        
            NSDictionary *subDict = [subPoints objectAtIndex:j];
            
            rect = [self TcePuzzleRectWithArray:subDict[@"pointArray"] andSuperSize:superSize];
            
            NSArray *pointArray = [subDict objectForKey:@"pointArray"];
            NSArray *gapArray = [subDict objectForKey:@"gap"];
            
            if (pointArray){//} && gapArray) {

                path = [UIBezierPath bezierPath];
                
                if (pointArray.count > 2) {
                    for(int i = 0; i < [pointArray count]; i++)
                    {
                        NSString *pointString = [pointArray objectAtIndex:i];
                        NSString *gapString = [gapArray objectAtIndex:i];
                        
                        if (pointString){ //&& gapString) {
                            
                            CGPoint point = CGPointFromString(pointString);
                            CGPoint gap = CGPointFromString(gapString);
                            
                            //外边距
                            if (point.x == 0) {
                                point.x += self.grpValue*0.5;
                            }
                            if (point.y == 0) {
                                point.y += self.grpValue;
                            }
                            if (point.x == 720) {
                                point.x -= self.grpValue*0.5;
                            }
                            if (point.y == 960){
                                point.y -= self.grpValue;
                            }
                            
                            //内边距
                            if (self.grpValue) {
                                point.x = point.x + (gap.x * self.grpValue);
                                point.y = point.y + (gap.y * self.grpValue);
                            }
                            
                            
                            point = [TcePuzzlePuzzleView TcePuzzlePointScaleWithPoint:point scale:2.0f];
                            point.x = (point.x)*self.frame.size.width/superSize.width -rect.origin.x;
                            point.y = (point.y)*self.frame.size.height/superSize.height -rect.origin.y;
                            
                            
                            
                            if (i == 0) {
                                [path moveToPoint:point];
                            } else {
                                [path addLineToPoint:point];
                            }
                        }
                    }
                } else
                {
                    [path moveToPoint:CGPointMake(0, 0)];
                    [path addLineToPoint:CGPointMake(rect.size.width, 0)];
                    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
                    [path addLineToPoint:CGPointMake(0, rect.size.height)];
                }
                [path closePath];
            }
            if (j < self.TcePuzzleContentViewArray.count) {
                DXLINVView *imageView = (DXLINVView *)self.TcePuzzleContentViewArray[j];
                imageView.frame = rect;
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
                NSArray *array = @[@"#2B2B2B",@"#FA5150",@"#FEC200",@"#07C160",@"#10ADFF",@"#6467EF",@"#FF0000",@"#FF4500",@"#FFD700",@"#40E0D0",@"#4682B4",@"#6495ED",@"#483D8B",@"#9400D3",
                    @"#8B008B",@"#C71585",@"#FF1493",@"#DC143C",@"#FFB6C1",@"#4B0082"
                ];
                imageView.backgroundColor = [UIColor colorWithHexString:array[j]];

            }
        }
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

- (void)toAlbumChangeInvView:(DXLINVView *)invView {
    
    CustomAlbumController *nextview = [[CustomAlbumController alloc] init];
    nextview.didSelextAssetfinsh = ^(PHAsset * _Nonnull asset) {
        //如果是图片
        if (asset.mediaType == PHAssetMediaTypeImage) {
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
            
        }else if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"] ||
                  [[asset valueForKey:@"filename"] hasSuffix:@"gif"]){
            NSLog(@"====选的是GIF资源====");
        }else if(asset.mediaType == PHAssetMediaTypeVideo){
            NSLog(@"====选的是视频资源====");
            invView.isVideo = YES;
            [invView setVideoResources:asset];
        }
        
        //
        for(DXLINVView *view in self.manage.invViews){
            if (view.isVideo) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [view.videoPlayerController playFromCurrentTime];
                });
            }
        }
    };
    [[UIViewController currentViewController].navigationController pushViewController:nextview animated:YES];
}

@end
