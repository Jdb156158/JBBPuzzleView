//
//  TcePuzzlePuzzleEditScrollView.m
//  ConstellationCamera
//
//  Created by zzb on 2019/1/9.
//  Copyright © 2019年 ConstellationCamera. All rights reserved.
//

#import "TcePuzzlePuzzleEditScrollView.h"
@interface TcePuzzlePuzzleEditScrollView()<UIScrollViewDelegate>
@property (nonatomic, retain) UIScrollView  *TcePuzzleContentScrollView;
@property (nonatomic, retain) UIButton *addImageButton;
@end

@implementation TcePuzzlePuzzleEditScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        [self TcePuzzleInitEditView];
    }
    return self;
}

- (void)TcePuzzleInitEditView
{
    self.backgroundColor = [UIColor clearColor];
    
    _TcePuzzleContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectInset(self.bounds, 0, 0)];
    _TcePuzzleContentScrollView.delegate = self;
    _TcePuzzleContentScrollView.showsHorizontalScrollIndicator = NO;
    _TcePuzzleContentScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_TcePuzzleContentScrollView];
    
    //普通图片
    self.TcePuzzleImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.TcePuzzleImageView.frame = CGRectMake(0, 0, kScreenWidth * 2.5, kScreenWidth * 2.5);
    self.TcePuzzleImageView.userInteractionEnabled = YES;
    [_TcePuzzleContentScrollView addSubview:self.TcePuzzleImageView];
    
    //动态图片
//    self.TcePuzzleAnimatedImageView = [[YYAnimatedImageView alloc] initWithFrame:self.bounds];
//    self.TcePuzzleAnimatedImageView.frame = CGRectMake(0, 0, kScreenWidth * 2.5, kScreenWidth * 2.5);
//    self.TcePuzzleAnimatedImageView.userInteractionEnabled = YES;
//    [_TcePuzzleContentScrollView addSubview:self.TcePuzzleAnimatedImageView];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Comp_1" ofType:@"gif"];
//    NSData *gifData = [NSData dataWithContentsOfFile:path];
//    YYImage *img = [YYImage imageWithData:gifData];
//    self.TcePuzzleAnimatedImageView.image = img;
//    [self setImageViewData:self.TcePuzzleAnimatedImageView.image];
//    NSLog(@"=====图片的宽高[%f,%f]===",self.TcePuzzleAnimatedImageView.image.size.width,self.TcePuzzleAnimatedImageView.image.size.height);
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TcePuzzleHandleDoubleTap:)];
    doubleTap.numberOfTouchesRequired = 2;
    [self.TcePuzzleImageView addGestureRecognizer: doubleTap];
    
    UITapGestureRecognizer *clickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TcePuzzleHandleclickTapTap:)];
    [self.TcePuzzleImageView addGestureRecognizer: clickTap];
    
    //设置scrollview 放大缩小倍率
    float minimumScale = self.frame.size.width / self.TcePuzzleImageView.frame.size.width;
    [_TcePuzzleContentScrollView setMinimumZoomScale:minimumScale];
    [_TcePuzzleContentScrollView setZoomScale:minimumScale];
    
    self.addImageButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-25, self.frame.size.height/2-25, 50, 50)];
    [self.addImageButton setImage:[UIImage imageNamed:@"编辑加"] forState:UIControlStateNormal];
    [self addSubview:self.addImageButton];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _TcePuzzleContentScrollView.frame = CGRectInset(self.bounds, 0, 0);
    self.TcePuzzleImageView.frame = CGRectMake(0, 0, kScreenWidth * 2.5, kScreenWidth * 2.5);
    float minimumScale = self.frame.size.width / self.TcePuzzleImageView.frame.size.width;
    [_TcePuzzleContentScrollView setMinimumZoomScale:minimumScale];
    [_TcePuzzleContentScrollView setZoomScale:minimumScale];
    
    self.addImageButton.frame = CGRectMake(self.frame.size.width/2-25, self.frame.size.height/2-25, 50, 50);
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    _TcePuzzleContentScrollView.frame = CGRectInset(self.bounds, 0, 0);
    self.TcePuzzleImageView.frame = CGRectMake(0, 0, kScreenWidth * 2.5, kScreenWidth * 2.5);
    float minimumScale = self.frame.size.width / self.TcePuzzleImageView.frame.size.width;
    [_TcePuzzleContentScrollView setMinimumZoomScale:minimumScale];
    [_TcePuzzleContentScrollView setZoomScale:minimumScale];
    
    self.addImageButton.frame = CGRectMake(self.frame.size.width/2-25, self.frame.size.height/2-25, 50, 50);
}

- (void)setNotReloadFrame:(CGRect)frame;
{
    [super setFrame:frame];
}

- (void)setImageViewData:(UIImage *)image
{
    self.TcePuzzleImageView.image= image;
    if (image == nil) return;
    CGRect  rect  = CGRectZero;
    CGFloat w = 0.0f;
    CGFloat h = 0.0f;
    if(self.TcePuzzleContentScrollView.frame.size.width > self.TcePuzzleContentScrollView.frame.size.height)
    {
        w = self.TcePuzzleContentScrollView.frame.size.width;
        h = w * image.size.height / image.size.width;
        if(h < self.TcePuzzleContentScrollView.frame.size.height)
        {
            h = self.TcePuzzleContentScrollView.frame.size.height;
            w = h * image.size.width / image.size.height;
        }
        
    } else {
        
        h = self.TcePuzzleContentScrollView.frame.size.height;
        w = h * image.size.width / image.size.height;
        if(w < self.TcePuzzleContentScrollView.frame.size.width)
        {
            w = self.TcePuzzleContentScrollView.frame.size.width;
            h = w * image.size.height / image.size.width;
        }
    }
    rect.size = CGSizeMake(w, h+1);
    
    @synchronized(self){
        self.TcePuzzleImageView.frame = rect;
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = self.TcePuzzleRealCellPath.CGPath;
        maskLayer.fillColor = [[UIColor yellowColor] CGColor];
        maskLayer.frame = self.TcePuzzleImageView.frame;
        self.layer.mask = maskLayer;
        [_TcePuzzleContentScrollView setZoomScale:0.1 animated:YES];
        [self setNeedsLayout];
    }
}

- (void)setImageViewData:(UIImage *)image rect:(CGRect)rect
{
    self.frame = rect;
    [self setImageViewData:image];
}

- (void)setTcePuzzleOldRect:(CGRect)TcePuzzleOldRect{
    //self.frame = TcePuzzleOldRect;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL contained = [self.TcePuzzleRealCellPath containsPoint:point];
    if ([self.editDelegate respondsToSelector:@selector(TcePuzzleTapWithEditView:)])
    {
        [self.editDelegate TcePuzzleTapWithEditView:nil];
    }
    return contained;
}

//双击放大
- (void)TcePuzzleHandleDoubleTap:(UITapGestureRecognizer *)tap
{
    float newScale = _TcePuzzleContentScrollView.zoomScale * 1.2;
    CGRect zoomRect = [self TcePuzzleZoomRectForScale:newScale withCenter:[tap locationInView:self.TcePuzzleImageView]];
    //zoomRect: 给定矩形的大小进行缩放
    [_TcePuzzleContentScrollView zoomToRect:zoomRect animated:YES];
}

//单击选中
- (void)TcePuzzleHandleclickTapTap:(UITapGestureRecognizer *)tap
{
//    if (self.ClickChooseView) {
//        self.ClickChooseView(self.tag);
//    }
    NSString *viewTag = [NSString stringWithFormat:@"%ld", self.tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PuzzleHandleclickTapTap" object:viewTag];
}

//某点为中心放大
- (CGRect)TcePuzzleZoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    if (scale == 0)
    {
        scale = 1;
    }
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.TcePuzzleImageView;
    //return self.TcePuzzleAnimatedImageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    //setZoomScale：animated 根据比例缩放
    [scrollView setZoomScale:scale animated:NO];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touch = [[touches anyObject] locationInView:self.superview];
    self.TcePuzzleImageView.center = touch;
    //self.TcePuzzleAnimatedImageView.center = touch;
    
}
@end
