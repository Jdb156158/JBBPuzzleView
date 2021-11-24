//
//  TcePuzzlePuzzleView.m
//  ConstellationCamera
//
//  Created by zzb on 2019/1/9.
//  Copyright © 2019年 ConstellationCamera. All rights reserved.
//

#import "TcePuzzlePuzzleView.h"
#import "TcePuzzlePuzzleEditScrollView.h"
#import "TcePuzzleViewFrameAndPoint.h"
//#import <AssetsLibrary/AssetsLibrary.h>
#import "TCESingle.h"

@interface TcePuzzlePuzzleView() <TcePuzzlePuzzleEditScrollViewDelegate>
{
    BOOL contain;
    CGPoint startPoint;
    CGPoint originPoint;
}
@property (nonatomic, strong) TcePuzzlePuzzleEditScrollView *TcePuzzleFirstView;
@property (nonatomic, strong) TcePuzzlePuzzleEditScrollView *TcePuzzleSecondView;
@property (nonatomic, strong) TcePuzzlePuzzleEditScrollView *TcePuzzleThirdView;
@property (nonatomic, strong) TcePuzzlePuzzleEditScrollView *TcePuzzleFourthView;
@property (nonatomic, strong) TcePuzzlePuzzleEditScrollView *TcePuzzleFiveView;

@property (nonatomic, strong) TcePuzzlePuzzleEditScrollView *TcePuzzleSixView;
@property (nonatomic, strong) TcePuzzlePuzzleEditScrollView *TcePuzzleSevenView;
@property (nonatomic, strong) TcePuzzlePuzzleEditScrollView *TcePuzzleEightView;
@property (nonatomic, strong) TcePuzzlePuzzleEditScrollView *TcePuzzleNineView;

@property (nonatomic, strong) TcePuzzlePuzzleEditScrollView *TcePuzzleTempView;
@property (nonatomic, strong) UIImageView *borderView ;
@property (nonatomic, strong) NSArray *points;

@property (nonatomic, strong) CAShapeLayer *border;//选中边框

@end

@implementation TcePuzzlePuzzleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self TcePuzzleInitPuzzleView];
        [self InitBorderView];
    }
    return self;
}

- (void)InitBorderView
{
    _borderView = [[UIImageView alloc] init];
    _borderView.image = [UIImage imageNamed:@"编辑水印1"];
    _borderView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_borderView];
    [_borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(60);
    }];
}

- (void)TcePuzzleInitPuzzleView
{
    _TcePuzzleFirstView  = [[TcePuzzlePuzzleEditScrollView alloc] initWithFrame:CGRectZero];
    _TcePuzzleSecondView = [[TcePuzzlePuzzleEditScrollView alloc] initWithFrame:CGRectZero];
    _TcePuzzleThirdView  = [[TcePuzzlePuzzleEditScrollView alloc] initWithFrame:CGRectZero];
    _TcePuzzleFourthView = [[TcePuzzlePuzzleEditScrollView alloc] initWithFrame:CGRectZero];
    _TcePuzzleFiveView   = [[TcePuzzlePuzzleEditScrollView alloc] initWithFrame:CGRectZero];
    _TcePuzzleSixView    = [[TcePuzzlePuzzleEditScrollView alloc] initWithFrame:CGRectZero];
    _TcePuzzleSevenView  = [[TcePuzzlePuzzleEditScrollView alloc] initWithFrame:CGRectZero];
    _TcePuzzleEightView  = [[TcePuzzlePuzzleEditScrollView alloc] initWithFrame:CGRectZero];
    _TcePuzzleNineView   = [[TcePuzzlePuzzleEditScrollView alloc] initWithFrame:CGRectZero];
    
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

- (void)TcePuzzleStyleSettingWithView:(TcePuzzlePuzzleEditScrollView *)view
{
    view.frame = CGRectZero;
    [view setClipsToBounds:YES];
    [view setUserInteractionEnabled:YES];
    [view setBackgroundColor:[UIColor grayColor]];
    view.TcePuzzleImageView.image = nil;
    view.TcePuzzleRealCellPath = nil;
    [view setImageViewData:nil];
    
//    [view addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(TcePuzzleLongPress:)]];
}


- (void)setTcePuzzleAssetArray:(NSMutableArray *)TcePuzzleAssetArray
{
    _TcePuzzleAssetArray = TcePuzzleAssetArray;
}

- (void)setTcePuzzleStyleIndex:(NSInteger)TcePuzzleStyleIndex
{
    _points = [TcePuzzleViewFrameAndPoint tceGetArrayWithQuantity:TcePuzzleStyleIndex];
    self.TcePuzzleStyleRow = [TCESingle tceSingle].tceStyleRow;
    self.grpValue = [TCESingle tceSingle].tceGra;
    self.borderValue = [TCESingle tceSingle].tceBorder;
    self.tceImage = [TCESingle tceSingle].tceImage;
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
            
            NSDictionary *assetDict = self.TcePuzzleAssetArray[j];
            
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
                TcePuzzlePuzzleEditScrollView *imageView = (TcePuzzlePuzzleEditScrollView *)self.TcePuzzleContentViewArray[j];
                imageView.editDelegate = self;
                imageView.frame = rect;
                NSLog(@"======imageView.frame:[x:%f,y:%f,width:%f,hieght:%f]",imageView.frame.origin.x,imageView.frame.origin.y,imageView.frame.size.width,imageView.frame.size.height);
                if (j == 0) {
                    imageView.backgroundColor = [UIColor grayColor];
                }else{
                    imageView.backgroundColor = [UIColor yellowColor];
                }
                
                
//                imageView.TcePuzzleRealCellPath = path;
//                NSData * imagedata = assetDict[@"data"];
//                UIImage *image = [UIImage imageWithData:imagedata];
//                [imageView setImageViewData:image rect:rect];
                
                
//                NSString *path = [[NSBundle mainBundle] pathForResource:@"Comp_1" ofType:@"gif"];
//                NSData *gifData = [NSData dataWithContentsOfFile:path];
//                YYImage *img = [YYImage imageWithData:gifData];
//                [imageView setImageViewData:img rect:rect];
                
                
                imageView.TcePuzzleOldRect = rect;
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

#pragma mark - TcePuzzlePuzzleEditScrollViewDelegate
- (void)TcePuzzleTapWithEditView:(TcePuzzlePuzzleEditScrollView *)editView;
{
    if ([self.puzzleDelegate respondsToSelector:@selector(TcePuzzleMoveEditView)])
    {
        [self.puzzleDelegate TcePuzzleMoveEditView];
    }
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



#pragma mark - 长按交换图片
- (void)TcePuzzleLongPress:(UILongPressGestureRecognizer *)ges
{
    TcePuzzlePuzzleEditScrollView *editView = (TcePuzzlePuzzleEditScrollView *)ges.view;
    if (ges.state == UIGestureRecognizerStateBegan)
    {
        startPoint = [ges locationInView:ges.view];
        originPoint = editView.center;
        [self bringSubviewToFront:editView];
        [UIView animateWithDuration:0.2 animations:^{
            editView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            editView.alpha = 0.7;
        }];
    } else if (ges.state == UIGestureRecognizerStateChanged)
    {
        CGPoint newPoint = [ges locationInView:ges.view];
        CGFloat deltaX = newPoint.x-startPoint.x;
        CGFloat deltaY = newPoint.y-startPoint.y;
        editView.center = CGPointMake(editView.center.x + deltaX,editView.center.y + deltaY);
        NSInteger index = [self TcePuzzleIndexOfPoint:editView.center withButton:editView];
        if (index<0)
        {
            contain = NO;
            _TcePuzzleTempView = nil;
        }
        else
        {
            if (index != -1) {
                _TcePuzzleTempView = self.TcePuzzleContentViewArray[index];
            }
        }
    } else if (ges.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.2 animations:^{
            editView.transform = CGAffineTransformIdentity;
            editView.alpha = 1.0;
            if (!contain)
            {
                if (_TcePuzzleTempView) {
                    [self exchangeFromIndex:editView.tag-1 toIndex:_TcePuzzleTempView.tag-1];
                }else{
                    
                    [editView setNotReloadFrame:editView.TcePuzzleOldRect];
                }
            }
            _TcePuzzleTempView = nil;
        }];
    }
}

- (void)exchangeFromIndex:(NSInteger)fIndex toIndex:(NSInteger)toIndex
{
    UIImage *a = self.TcePuzzleAssetArray[fIndex];
    UIImage *b = self.TcePuzzleAssetArray[toIndex];
    TcePuzzlePuzzleEditScrollView *fromView = [_TcePuzzleContentViewArray objectAtIndex:fIndex];
    TcePuzzlePuzzleEditScrollView *toView = [_TcePuzzleContentViewArray objectAtIndex:toIndex];
    [_TcePuzzleContentViewArray replaceObjectAtIndex:fIndex withObject:toView];
    [_TcePuzzleContentViewArray replaceObjectAtIndex:toIndex withObject:fromView];
    TcePuzzlePuzzleEditScrollView *ttView = [[TcePuzzlePuzzleEditScrollView alloc] init];
    ttView.TcePuzzleRealCellPath = fromView.TcePuzzleRealCellPath;
    ttView.TcePuzzleOldRect = fromView.TcePuzzleOldRect;
    ttView.tag = fromView.tag;
    
    fromView.frame = toView.TcePuzzleOldRect;
    fromView.TcePuzzleRealCellPath = toView.TcePuzzleRealCellPath;
    [fromView setImageViewData:a rect:toView.TcePuzzleOldRect];
    fromView.tag = toView.tag;
    fromView.TcePuzzleOldRect = toView.TcePuzzleOldRect;
    
    toView.frame = ttView.TcePuzzleOldRect;
    toView.TcePuzzleRealCellPath = ttView.TcePuzzleRealCellPath;
    [toView setImageViewData:b rect:ttView.TcePuzzleOldRect];
    toView.tag = ttView.tag;
    toView.TcePuzzleOldRect = ttView.TcePuzzleOldRect;
    ttView = nil;
}

- (NSInteger)TcePuzzleIndexOfPoint:(CGPoint)point withButton:(TcePuzzlePuzzleEditScrollView *)btn
{
    for (NSInteger i = 0; i<self.TcePuzzleContentViewArray.count;i++)
    {
        TcePuzzlePuzzleEditScrollView *view = self.TcePuzzleContentViewArray[i];
        if (view != btn)
        {
            if (CGRectContainsPoint(view.TcePuzzleOldRect, point))
            {
                return i;
            }
        }
    }
    return -1;
}

#pragma mark - seter
- (void)setBorderValue:(NSInteger)borderValue
{
    _borderValue = borderValue;
    [TCESingle tceSingle].tceBorder = borderValue;
    if (_points)
    {
        [self TcePuzzleResetAllView];
        [self TcePuzzleResetStyle];
    }
}

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

- (void)setTceImage:(UIImage *)tceImage
{
    [TCESingle tceSingle].tceImage = tceImage;
    _tceImage = tceImage;
//    _tceImage = [UIImage OriginImage:tceImage scaleToSize:CGSizeMake(60, 60)];
//    _tceImage = [_tceImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    self.borderView.image = _tceImage;
}


@end

/***************************************************************/

#define kWindow [UIApplication sharedApplication].keyWindow
#define kCellIdentifier @"cellIdentifier"
#define kDropMenuCellID @"DropMenuCellID"

@interface JMDropMenu()<UITableViewDelegate,UITableViewDataSource>
/** 蒙版 */
@property (nonatomic, strong) UIView *cover;
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** 存放标题和图片数组 */
@property (nonatomic, strong) NSMutableArray *titleImageArrM;
/** rowHeight */
@property (nonatomic, assign) CGFloat rowHeight;
/** rgb的可变数组 */
@property (nonatomic, strong) NSMutableArray *RGBStrValueArr;
/** 类型(qq或者微信) */
@property (nonatomic, assign) JMDropMenuType type;
@end

@implementation JMDropMenu

- (NSMutableArray *)titleImageArrM {
    if (!_titleImageArrM) {
        _titleImageArrM = [NSMutableArray array];
    }
    return _titleImageArrM;
}

- (NSMutableArray *)RGBStrValueArr {
    if (!_RGBStrValueArr) {
        _RGBStrValueArr = [NSMutableArray array];
    }
    return _RGBStrValueArr;
}

- (instancetype)initWithFrame:(CGRect)frame ArrowOffset:(CGFloat)arrowOffset TitleArr:(NSArray *)titleArr ImageArr:(NSArray *)imageArr Type:(JMDropMenuType)type LayoutType:(JMDropMenuLayoutType)layoutType RowHeight:(CGFloat)rowHeight Delegate:(id<JMDropMenuDelegate>)delegate {
    if (self = [super initWithFrame:frame]) {
        //初始化赋值
        self.frame = frame;
        _arrowOffset = arrowOffset;
        _type = type;
        _LayoutType = layoutType;
        _rowHeight = rowHeight;
        _delegate = delegate;
        //类型判断
        if (type == JMDropMenuTypeWeChat) {
            self.RGBStrValueArr = [NSMutableArray arrayWithObjects:@(54),@(54),@(54), nil];
            _titleColor = [UIColor whiteColor];
            _lineColor = [UIColor whiteColor];
        } else {
            self.RGBStrValueArr = [NSMutableArray arrayWithObjects:@(255),@(255),@(255), nil];
            _titleColor = [UIColor blackColor];
            _lineColor = [UIColor lightGrayColor];
        }
        //字典转模型
        for (int i = 0; i < titleArr.count; i++) {
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
            [tempDict setObject:titleArr[i] forKey:@"title"];
            if (i != imageArr.count) {
                [tempDict setObject:imageArr[i] forKey:@"image"];
            }
            [tempDict setObject:@(layoutType) forKey:@"layoutType"];
            [tempDict setObject:@(type) forKey:@"type"];
            JMDropMenuModel *model = [JMDropMenuModel dropMenuWithDictonary:tempDict];
            [self.titleImageArrM addObject:model];
        }
        
        
        [kWindow addSubview:self.cover];
        UITapGestureRecognizer *tapCover = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCoverClick)];
        [self.cover addGestureRecognizer:tapCover];
        
        self.backgroundColor = [UIColor clearColor];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        [self addSubview:self.tableView];
    }
    return self;
}

+ (instancetype)showDropMenuFrame:(CGRect)frame ArrowOffset:(CGFloat)arrowOffset TitleArr:(NSArray *)titleArr ImageArr:(NSArray *)imageArr Type:(JMDropMenuType)type LayoutType:(JMDropMenuLayoutType)layoutType RowHeight:(CGFloat)rowHeight Delegate:(id<JMDropMenuDelegate>)delegate{
    return [[self alloc] initWithFrame:frame ArrowOffset:arrowOffset TitleArr:titleArr ImageArr:imageArr Type:type LayoutType:layoutType RowHeight:rowHeight Delegate:delegate];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 8, self.frame.size.width, self.frame.size.height - 8) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 6.f;
        if (_type == JMDropMenuTypeWeChat) {
            _tableView.backgroundColor = [UIColor colorWithRed:54 / 255.0 green:54 / 255.0 blue:54 / 255.0 alpha:1];
        } else {
            _tableView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
        }
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleImageArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMDropMenuCell *cell = [JMDropMenuCell dropMenuCellWithTableView:tableView];
    cell.model = self.titleImageArrM[indexPath.row];
    float r = [self.RGBStrValueArr[0] floatValue] / 255.0;
    float g = [self.RGBStrValueArr[1] floatValue] / 255.0;
    float b = [self.RGBStrValueArr[2] floatValue] / 255.0;
    cell.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
    cell.titleL.textColor = _titleColor;
    cell.line1.backgroundColor = _lineColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JMDropMenuModel *model = self.titleImageArrM[indexPath.row];
    if ([_delegate respondsToSelector:@selector(didSelectRowAtIndex:Title:Image:)]) {
        [_delegate didSelectRowAtIndex:indexPath.row Title:model.title Image:model.image];
    }
    [self removeDropMenu];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _rowHeight;
}

- (UIView *)cover {
    if (!_cover) {
        _cover = [[UIView alloc] initWithFrame:kWindow.bounds];
        _cover.backgroundColor = [UIColor blackColor];
        _cover.alpha = 0.1;
    }
    return _cover;
}

#pragma mark - 蒙版点击
- (void)tapCoverClick {
    [self removeDropMenu];
}

#pragma mark - 隐藏蒙版
- (void)removeDropMenu {
    [self.tableView removeFromSuperview];
    [self.cover removeFromSuperview];
    [self removeFromSuperview];
}

// 覆盖drawRect方法，你可以在此自定义绘画和动画
- (void)drawRect:(CGRect)rect
{
    //An opaque type that represents a Quartz 2D drawing environment.
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    /*画三角形*/
    CGPoint sPoints[3];//坐标点
    sPoints[0] = CGPointMake(_arrowOffset, 0);//坐标1
    sPoints[1] = CGPointMake(_arrowOffset - 8, 8);//坐标2
    sPoints[2] = CGPointMake(_arrowOffset + 8, 8);//坐标3
    CGContextAddLines(context, sPoints, 3);//添加线
    //填充色
    float r = [self.RGBStrValueArr[0] floatValue] / 255.0;
    float g = [self.RGBStrValueArr[1] floatValue] / 255.0;
    float b = [self.RGBStrValueArr[2] floatValue] / 255.0;
    UIColor *aColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
    CGContextSetFillColorWithColor(context, aColor.CGColor);
    //画线笔颜色
    CGContextSetRGBStrokeColor(context,r, g, b,1.0);//画笔线的颜色
    CGContextClosePath(context);//封起来
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
}

//将UIColor转换为RGB值
- (NSMutableArray *)changeUIColorToRGB:(UIColor *)color
{
    NSMutableArray *RGBStrValueArr = [[NSMutableArray alloc] init];
    NSString *RGBStr = nil;
    //获得RGB值描述
    NSString *RGBValue = [NSString stringWithFormat:@"%@",color];
    //将RGB值描述分隔成字符串
    NSArray *RGBArr = [RGBValue componentsSeparatedByString:@" "];
    //获取红色值
    int r = [[RGBArr objectAtIndex:1] intValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d",r];
    [RGBStrValueArr addObject:RGBStr];
    //获取绿色值
    int g = [[RGBArr objectAtIndex:2] intValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d",g];
    [RGBStrValueArr addObject:RGBStr];
    //获取蓝色值
    int b = [[RGBArr objectAtIndex:3] intValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d",b];
    [RGBStrValueArr addObject:RGBStr];
    //返回保存RGB值的数组
    return RGBStrValueArr;
}

//16进制颜色(html颜色值)字符串转为UIColor
- (NSMutableArray *)hexStringToColor:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    //    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    //    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [NSMutableArray arrayWithObjects:@(r),@(g),@(b), nil];
}

#pragma mark - 箭头x偏移值
- (void)setArrowOffset:(CGFloat)arrowOffset {
    _arrowOffset = arrowOffset;
    [self setNeedsDisplay];
}
#pragma mark - 类型
- (void)setLayoutType:(JMDropMenuLayoutType)LayoutType {
    _LayoutType = LayoutType;
    for (JMDropMenuModel *model in self.titleImageArrM) {
        model.layoutType = LayoutType;
    }
    [self.tableView reloadData];
}

#pragma mark - 箭头颜色
- (void)setArrowColor:(UIColor *)arrowColor {
    _arrowColor = arrowColor;
    self.RGBStrValueArr = [self changeUIColorToRGB:arrowColor];
    [self setNeedsDisplay];
}

- (void)setArrowColor16:(NSString *)arrowColor16 {
    _arrowColor16 = arrowColor16;
    self.RGBStrValueArr = [self hexStringToColor:arrowColor16];
    [self setNeedsDisplay];
}

#pragma mark - 文字颜色
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self.tableView reloadData];
}

#pragma mark - 线条颜色
- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self.tableView reloadData];
}

@end


@interface JMDropMenuCell()
/** 屏幕中心点 */
@property (nonatomic, assign) CGFloat screenCenter;
@end

@implementation JMDropMenuCell

+ (instancetype)dropMenuCellWithTableView:(UITableView *)tableView {
    JMDropMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kDropMenuCellID];
    if (!cell) {
        cell = [[JMDropMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDropMenuCellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imageIV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageIV];
        
        self.titleL = [[UILabel alloc] init];
        self.titleL.textColor = [UIColor blackColor];
        self.titleL.font = [UIFont systemFontOfSize:15.f];
        [self.contentView addSubview:self.titleL];
        
        self.line1 = [[UIImageView alloc] init];
        self.line1.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.line1];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.screenCenter = self.contentView.frame.size.height * 0.5;
    
    self.imageIV.frame = CGRectMake(10, self.screenCenter - 8, 16, 16);
    if (self.model.layoutType == JMDropMenuLayoutTypeTitle) {
        self.titleL.frame = CGRectMake(10, self.screenCenter - 10, self.frame.size.width, 20);
    } else {
        self.titleL.frame = CGRectMake(CGRectGetMaxX(self.imageIV.frame) + 10, self.screenCenter - 10, self.contentView.frame.size.width - 50, 20);
    }
    self.line1.frame = CGRectMake(0, self.contentView.frame.size.height - 0.5, self.contentView.frame.size.width, 0.5);
}

- (void)setModel:(JMDropMenuModel *)model {
    _model = model;
    if (model.layoutType == JMDropMenuLayoutTypeTitle) {
        self.titleL.frame = CGRectMake(10, self.screenCenter - 10, self.frame.size.width, 20);
    } else {
        self.imageIV.image = [UIImage imageNamed:model.image];
    }
    if (model.type == JMDropMenuTypeQQ) {
        self.titleL.textColor = [UIColor blackColor];
        self.line1.backgroundColor = [UIColor lightGrayColor];
    } else {
        self.titleL.textColor = [UIColor whiteColor];
        self.line1.backgroundColor = [UIColor whiteColor];
    }
    self.titleL.text = model.title;
}

@end


@interface JMDropMenuModel()
@end
@implementation JMDropMenuModel

- (instancetype)initWithDictonary:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)dropMenuWithDictonary:(NSDictionary *)dict {
    return [[self alloc] initWithDictonary:dict];
}

@end
