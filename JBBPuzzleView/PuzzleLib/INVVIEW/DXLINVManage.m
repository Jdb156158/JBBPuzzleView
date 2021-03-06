//
//  DXLINVManage.m
//  UIGestureRecognizer
//
//  Created by ztc on 16/10/8.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import "DXLINVManage.h"

@interface DXLINVManage()<UIGestureRecognizerDelegate,DXLINVViewDelegate>
@end


@implementation DXLINVManage


- (void)setInvViews:(NSMutableArray *)invViews{
    _invViews = invViews;
    
    //先删除所有手势
    for(DXLINVView * _view in _invViews){
        for (int i =0; i<[[_view gestureRecognizers] count]; i++) {
            [_view removeGestureRecognizer:[_view.gestureRecognizers firstObject]];
        }
    }
    
    [self addGesture];
}

- (void)addGesture{
    //点击手势
    for(DXLINVView * _view in _invViews){
        _view.delegate = self;
        
        UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        tap.delegate=self;
        [_view addGestureRecognizer:tap];
        
        //拖动手势
        UIPanGestureRecognizer* pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        pan.delegate=self;
        [_view addGestureRecognizer:pan];
        
        //捏合手势
        UIPinchGestureRecognizer* pinch=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
        pinch.delegate=self;
        [_view addGestureRecognizer:pinch];
        
        //旋转手势
//        UIRotationGestureRecognizer* rotate=[[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotate:)];
//        rotate.delegate=self;
//        [_view addGestureRecognizer:rotate];
        
        //轻扫手势
        UISwipeGestureRecognizer* swipeDefault=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDefault:)];
        swipeDefault.delegate=self;
        swipeDefault.direction=UISwipeGestureRecognizerDirectionRight;
        [_view addGestureRecognizer:swipeDefault];
        
        UISwipeGestureRecognizer* swipeLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDefault:)];
        swipeLeft.delegate=self;
        swipeLeft.direction=UISwipeGestureRecognizerDirectionLeft;
        [_view addGestureRecognizer:swipeLeft];
        
        UISwipeGestureRecognizer* swipeDown=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDefault:)];
        swipeDown.delegate=self;
        swipeDown.direction=UISwipeGestureRecognizerDirectionDown;
        [_view addGestureRecognizer:swipeDown];
        
        UISwipeGestureRecognizer* swipeUp=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDefault:)];
        swipeUp.delegate=self;
        swipeUp.direction=UISwipeGestureRecognizerDirectionUp;
        [_view addGestureRecognizer:swipeUp];
        
        //长按手势
        UILongPressGestureRecognizer* longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        longPress.delegate=self;
        [_view addGestureRecognizer:longPress];
    }
}

-(void)longPress:(UILongPressGestureRecognizer *)longPress{
    //按住的时候回调用一次，松开的时候还会再调用一次
    NSLog(@"长按图片");
}

-(void)swipeDefault:(UISwipeGestureRecognizer*)swipe{
    if (swipe.direction==UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"向右轻扫");
    }else if(swipe.direction==UISwipeGestureRecognizerDirectionLeft){
        NSLog(@"向左轻扫");
    }else if(swipe.direction==UISwipeGestureRecognizerDirectionUp){
        NSLog(@"向上轻扫");
    }else{
        NSLog(@"向下轻扫");
    }
}

-(void)rotate:(UIRotationGestureRecognizer*)rotate{
    DXLINVView * invView = (DXLINVView*)rotate.view;
    if (invView.isVideo) {
        invView.videoContentView.transform=CGAffineTransformRotate(invView.videoContentView.transform, rotate.rotation);
    } else {
        invView.imageView.transform=CGAffineTransformRotate(invView.imageView.transform, rotate.rotation);
    }
    //复位
    rotate.rotation=0;
}

-(void)pinch:(UIPinchGestureRecognizer*)pinch{
    DXLINVView * invView = (DXLINVView*)pinch.view;
//    CGSize finSize = invView.imageView.frame.size;
    CGFloat scale=pinch.scale;
    NSLog(@"scale-----%f",scale);
    if (invView.isVideo) {
        if (scale<1.0 && (invView.videoContentView.frame.origin.x>0 || invView.videoContentView.frame.origin.y>0) ) {
            invView.videoContentView.transform = invView.videoContentViewTransform;
        }else{
            invView.videoContentView.transform = CGAffineTransformScale(invView.videoContentView.transform, scale, scale);
            NSLog(@"videoContentView-------x:%f,y:%f,w:%f,h:%f",invView.videoContentView.frame.origin.x,invView.videoContentView.frame.origin.y,invView.videoContentView.frame.size.width,invView.videoContentView.frame.size.height);
        }
        
    } else {
        invView.imageView.transform=CGAffineTransformScale(invView.imageView.transform, scale, scale);
    }
    
//    invView.imageView.bounds=CGRectMake(0, 0, finSize.width*pinch.scale, finSize.height* pinch.scale);
//    if (pinch.state==UIGestureRecognizerStateEnded || pinch.state== UIGestureRecognizerStateCancelled) {
//        finSize=CGSizeMake(finSize.width*pinch.scale, finSize.height*pinch.scale);
//    }
    pinch.scale=1;

}

-(void)pan:(UIPanGestureRecognizer*)pan{

        
    //如果出现复制对象。原view不发生任何变化
    DXLINVView * invView = (DXLINVView*)pan.view;
    UIGestureRecognizerState state = pan.state;
    
    
    CGPoint loc = [pan locationInView:invView];
    CGPoint location = [pan locationInView:invView.superview];
    if(loc.x<0 || loc.x>invView.bounds.size.width || loc.y<0|| loc.y>invView.bounds.size.height){
        if(!_snapshot){
            if (invView.isVideo) {
                _snapshot = [self customSnapshoFromView:invView.imageFrameView];
            } else {
                _snapshot = [self customSnapshoFromView:invView.imageView];
            }
            _snapshot.parentView = invView;
            [invView.superview addSubview:_snapshot];
            _snapshot.bounds = invView.bounds;// 用显示视图的大小
            _snapshot.center = location;

        }
    }
    if(_snapshot){
        switch (state) {
            case UIGestureRecognizerStatePossible: {
                [self setAllViewType:INVViewtatusNone];
                break;
            }
            case UIGestureRecognizerStateBegan: {
                break;
            }
            case UIGestureRecognizerStateChanged: {
                [self moviesnapshot:location];
                break;
            }
            case UIGestureRecognizerStateEnded: {
                [self endmoviesnapshot:location];
                break;
            }
            case UIGestureRecognizerStateCancelled: {
                [_snapshot removeFromSuperview];
                _snapshot = nil;
                break;
            }
            case UIGestureRecognizerStateFailed: {
                [_snapshot removeFromSuperview];
                _snapshot = nil;
                break;
            }
        }
        return;
    }

    [invView setInvViewtatus:INVViewtatusNone];
    CGPoint transP=[pan translationInView:invView];
    if (invView.isVideo) {
        //不能超过边界
        if(transP.x >0 && invView.videoContentView.frame.origin.x >= 0){
            transP.x = 0;
            invView.videoContentView.center = CGPointMake(invView.videoContentView.center.x+transP.x, invView.videoContentView.center.y+transP.y);
        }else if(transP.x < 0 && invView.videoContentView.frame.origin.x<0){
            transP.x = 0;
            invView.videoContentView.center = CGPointMake(invView.videoContentView.center.x+transP.x, invView.videoContentView.center.y+transP.y);
        }else if(transP.y > 0 && invView.videoContentView.frame.origin.y >= 0){
            transP.y = 0;
            invView.videoContentView.frame = CGRectMake(invView.videoContentView.frame.origin.x, 0, invView.videoContentView.frame.size.width, invView.videoContentView.frame.size.height);
            return;
        }else if(transP.y < 0 && invView.videoContentView.frame.origin.y+ invView.videoContentView.frame.size.height<= invView.frame.size.height){
            invView.videoContentView.frame = CGRectMake(invView.videoContentView.frame.origin.x, -(invView.videoContentView.frame.size.height-invView.frame.size.height), invView.videoContentView.frame.size.width, invView.videoContentView.frame.size.height);
            return;
        }else{
            invView.videoContentView.center = CGPointMake(invView.videoContentView.center.x+transP.x, invView.videoContentView.center.y+transP.y);
        }

        
        NSLog(@"videoContentView-------x:%f,y:%f,w:%f,h:%f",invView.videoContentView.frame.origin.x,invView.videoContentView.frame.origin.y,invView.videoContentView.frame.size.width,invView.videoContentView.frame.size.height);

    } else {
        //不能超过1/4
        if(transP.x >0 && invView.imageView.frame.origin.x >= invView.frame.size.width*3/4.f){
            return;
        }else if(transP.x < 0 && invView.imageView.frame.origin.x+ invView.imageView.frame.size.width <= invView.frame.size.width/4.f){
            return;
        }else if(transP.y > 0 && invView.imageView.frame.origin.y >= invView.frame.size.height*3/4.f){
            return;
        }else if(transP.y < 0 && invView.imageView.frame.origin.y+ invView.imageView.frame.size.height<= invView.frame.size.height/4.f){
            return;
        }

        invView.imageView.center = CGPointMake(invView.imageView.center.x+transP.x, invView.imageView.center.y+transP.y);
    }


    [pan setTranslation:CGPointZero inView:invView];

}

-(void)tap:(UITapGestureRecognizer*)tap{
    DXLINVView * invView = (DXLINVView*)tap.view;
    [self setINVViewEdit:invView];

}

//允许多事件同时发生
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return  YES;
}

- (snapShotView *)customSnapshoFromView:(UIView *)inputView {
    // 用cell的图层生成UIImage，方便一会显示
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 自定义这个快照的样子（下面的一些参数可以自己随意设置）
    snapShotView * snapview = [[snapShotView alloc] initWithImage:image];
    snapview.contentMode = UIViewContentModeCenter;
    snapview.layer.masksToBounds = YES;
    snapview.layer.cornerRadius = 0.0;
    snapview.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapview.layer.shadowRadius = 5.0;
    snapview.layer.shadowOpacity = 0.4;
    snapview.alpha = 0.8;
    return snapview;
}

//移动sna
- (void)moviesnapshot:(CGPoint)loc{
    static DXLINVView *tempview;
     _snapshot.center = loc;
    DXLINVView* view = (DXLINVView*)[self inInvView:loc];
    DXLINVView* parentView = (DXLINVView*)_snapshot.parentView;
    [self setAllViewType:INVViewtatusNone];
    if(view && view != parentView){
        tempview = view;
        [view setInvViewtatus:INVViewtatusChange];
    }
}

//移动结束
- (void)endmoviesnapshot:(CGPoint)loc{
    DXLINVView* view = (DXLINVView*)[self inInvView:loc];
    DXLINVView* parentView = (DXLINVView*)_snapshot.parentView;
    if(view && view != parentView){
        if (view.isVideo || parentView.isVideo) {// 视频移动结束
            NSLog(@"视频移动结束");
            if (parentView.isVideo && view.isVideo) {// 交换双方都是视频
                PHAsset *asset = view.videoAsset;
                NSString *filterName = view.filterName;
                view.filterName = parentView.filterName;
                parentView.filterName = filterName;
                [view setVideoResources:parentView.videoAsset];
                [parentView setVideoResources:asset];
            } else if (parentView.isVideo && !view.isVideo) {
                NSString *filterName = view.filterName;
                view.filterName = parentView.filterName;
                parentView.filterName = filterName;
                
                if ([filterName isEqualToString:@""]) {
                    [parentView resetWithimage:view.image];
                } else {
                    //加滤镜
                    //[parentView resetWithimage:[view.originalImage applyFilterWithFilterTitle:parentView.filterName]];
                }
                parentView.originalImage = view.originalImage;
                parentView.isVideo = NO;
                
                [view setVideoResources:parentView.videoAsset];
                view.isVideo = YES;
            } else if (!parentView.isVideo && view.isVideo) {
                NSString *filterName = view.filterName;
                view.filterName = parentView.filterName;
                parentView.filterName = filterName;
                
                if ([filterName isEqualToString:@""]) {
                    [view resetWithimage:parentView.image];
                } else {
                    //加滤镜
                    //[view resetWithimage:[parentView.originalImage applyFilterWithFilterTitle:view.filterName]];
                }
                
                view.originalImage = parentView.originalImage;
                view.isVideo = NO;

                [parentView setVideoResources:view.videoAsset];
                parentView.isVideo = YES;
            }
        } else {
            UIImage * image = view.image;
            UIImage * originalImage = view.originalImage;
            [view resetWithimage:parentView.image];
            [parentView resetWithimage:image];
            view.originalImage = parentView.originalImage;
            parentView.originalImage = originalImage;
        }
    }
    [_snapshot removeFromSuperview];
    _snapshot = nil;

}

//编辑状态
- (void)setINVViewEdit:(DXLINVView*)view{
    if(view.invViewtatus == INVViewtatusNone){
        [self setAllViewType:INVViewtatusNone];
        [view setInvViewtatus:INVViewtatusEdit];
    }else{
        [view setInvViewtatus:INVViewtatusNone];
    }
}

- (void)setAllViewType:(INVViewtatus)statue{
    for(DXLINVView *view in _invViews){
        [view setInvViewtatus:statue];
    }
}

//是否在别的view里面
- (BOOL)isInInvView:(CGPoint)loc{
    for(UIView *view in _invViews){
        if(loc.x > view.frame.origin.x && loc.y > view.frame.origin.y && loc.x < view.frame.origin.x+view.frame.size.width && loc.y < view.frame.origin.y+view.frame.size.height){
            return YES;
        }
    }
    return NO;
}

- (UIView*)inInvView:(CGPoint)loc{
    for(UIView *view in _invViews){
        if(loc.x > view.frame.origin.x && loc.y > view.frame.origin.y && loc.x < view.frame.origin.x+view.frame.size.width && loc.y < view.frame.origin.y+view.frame.size.height){
            return view;
        }
    }
    return nil;
}

- (void)changeBtnClick:(DXLINVView*)invView{
//    if (invView.isVideo) {
//        if ([invView.videoPlayerController isPlay]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [invView.videoPlayerController pause];
//            });
//        } else {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [invView.videoPlayerController playFromCurrentTime];
//            });
//        }
//    }
    
    if(self.delegate && [_delegate respondsToSelector:@selector(changeImageClick:)]){
        [self.delegate changeImageClick:invView];
    }
}




@end

@implementation snapShotView

@end
