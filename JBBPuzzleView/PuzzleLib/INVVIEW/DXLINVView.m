//
//  DXLINVView.m
//  UIGestureRecognizer
//
//  Created by ztc on 16/10/5.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import "DXLINVView.h"
#import <Masonry/Masonry.h>

@interface DXLINVView()<UIGestureRecognizerDelegate,PBJVideoPlayerControllerDelegate>
{
     UIView       *bordView ;//边界view
     UIButton     *changePicBtn ;//边界view
    UIButton     *addPicBtn ;//添加
}
@end

@implementation DXLINVView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self UIInit];
    }
    return self;
}

- (void)setNeedsLayout{

}

- (void)UIInit{
    self.clipsToBounds = YES;
//    _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    _imageView = [[UIImageView alloc] init];

    _imageView.userInteractionEnabled = YES;
    [self addSubview:_imageView];
    
//    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
    changePicBtn = [[UIButton alloc]init];
    [changePicBtn setImage:[UIImage imageNamed:@"changeBtn"] forState:UIControlStateNormal];
    changePicBtn.bounds = CGRectMake(0, 0, 20, 20);
    changePicBtn.center = _imageView.center;
    changePicBtn.hidden = YES;
    [changePicBtn addTarget:self action:@selector(changePic:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:changePicBtn];
    
    // 添加按钮
    addPicBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    addPicBtn.center = self.videoContentView.center;
    addPicBtn.backgroundColor = [UIColor clearColor];
    addPicBtn.hidden = NO;
    [addPicBtn setImage:[UIImage imageNamed:@"编辑加"] forState:UIControlStateNormal];
    [addPicBtn addTarget:self action:@selector(changePic:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addPicBtn];
    [addPicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@35);
        make.height.equalTo(@35);
    }];

}

- (void)resetWithimage:(UIImage*)image{
    _image = image;
//    [_imageView removeFromSuperview];
//    _imageView = [[UIImageView alloc] init];
//
//    _imageView.image = image;
//    [self addSubview:_imageView];
//    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
    [self updateImageViewConstraint];

    [self bringSubviewToFront:changePicBtn];
    [self setInvViewtatus:INVViewtatusNone];
}

- (void)updateImageViewConstraint {
    [self layoutIfNeeded];
    CGFloat endW;
    CGFloat endH;
    
    CGFloat fixelW = CGImageGetWidth(_image.CGImage);
    CGFloat fixelH = CGImageGetHeight(_image.CGImage);
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    CGFloat uiwh = w/h;
    CGFloat imagewh = fixelW/fixelH;
    if (uiwh>imagewh){
        //以宽作为伸缩比例
        endW = w;
        CGFloat radio = w / fixelW;
        endH = radio * fixelH;
        
    } else {
        endH = h;
        CGFloat radio = h / fixelH;
        endW = radio * fixelW;
    }
    

    [_imageView removeFromSuperview];
    [self.videoContentView removeFromSuperview];

    _imageView = [[UIImageView alloc] init];

    _imageView.image = _image;
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(endW, endH));
    }];
    
    // 替换按钮
    [changePicBtn removeFromSuperview];
    changePicBtn = [[UIButton alloc]init];
    changePicBtn.center = _imageView.center;
    changePicBtn.backgroundColor = [UIColor clearColor];
    changePicBtn.hidden = YES;
    [changePicBtn addTarget:self action:@selector(changePic:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:changePicBtn];
    [changePicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setImage:(UIImage *)image{
    [self resetWithimage:image];
}

- (void)setInvViewtatus:(INVViewtatus)invViewtatus{
    
    if(_invViewtatus == invViewtatus){
        return;
    }
    _invViewtatus = invViewtatus;
    
    if(!bordView){
//        CGRect rect = [self.superview convertRect:self.frame toView:self.superview];
        bordView = [[UIView alloc]init];
//        bordView.frame =rect;
        bordView.backgroundColor = [UIColor clearColor];
        bordView.userInteractionEnabled = NO;
        [self.superview addSubview:bordView];
        [bordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    changePicBtn.hidden = YES;

    switch (invViewtatus) {
        case INVViewtatusNone:
        {
            bordView.layer.borderColor = [UIColor clearColor].CGColor;
            bordView.layer.borderWidth = 0.5;
            break;
        }
        case INVViewtatusEdit:
        {
            changePicBtn.hidden = NO;
            [self changePic:nil];// 显示通知调用编辑事件
            bordView.layer.borderColor = [UIColor whiteColor].CGColor;
            bordView.layer.borderWidth = 2;
            
            break;
        }
        case INVViewtatusChange:
        {
            bordView.layer.borderColor = [UIColor whiteColor].CGColor;
            bordView.layer.borderWidth = 2;
            break;
        }
        default:
            break;
    }

}

- (void)changePic:(UIButton*)btn{
    if(self.delegate && [_delegate respondsToSelector:@selector(changeBtnClick:)]){
        [self.delegate changeBtnClick:self];
    }
}

- (void)setVideoResources:(PHAsset *)asset {
    self.videoAsset = asset;
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
        if ([asset isKindOfClass:[AVURLAsset class]]) {
            AVURLAsset* urlAsset = (AVURLAsset*)asset;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.videoUrl = urlAsset.URL;
            });
     }
    }];
}

- (void)setVideoUrl:(NSURL *)videoUrl{
    
    addPicBtn.hidden = YES;
    
    _videoUrl = videoUrl;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createVideoPlayView:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) withURL:videoUrl];
        
        [self bringSubviewToFront:self->changePicBtn];
        
        [self setInvViewtatus:INVViewtatusNone];
    });
}

- (void)createVideoPlayView:(CGRect)frame withURL:(NSURL*)url {
    [self layoutIfNeeded];
    [self.videoContentView removeFromSuperview];
    [_imageView removeFromSuperview];

    UIImage *imageFrame = [self getImageFromVideoFrame:url aTimae:CMTimeMake(1, 30)];
    CGFloat endW;
    CGFloat endH;
    CGFloat endX;
    CGFloat endY;
    
    CGFloat fixelW = CGImageGetWidth(imageFrame.CGImage);
    CGFloat fixelH = CGImageGetHeight(imageFrame.CGImage);
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    CGFloat uiwh = w/h;
    CGFloat imagewh = fixelW/fixelH;
    if (uiwh>imagewh){
        //以宽作为伸缩比例
        endW = w;
        CGFloat radio = w / fixelW;
        endH = radio * fixelH;
        
        endX = 0;
        endY = -(endH/2 - h/2);
    } else {
        endH = h;
        CGFloat radio = h / fixelH;
        endW = radio * fixelW;
        
        endX = -(endW/2 - w/2);
        endY = 0;
    }
    // 用于移动时显示的图片
    self.imageFrameView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, endW, endH)];
    self.imageFrameView.image = imageFrame;
    
    self.videoContentView =  [[UIView alloc] initWithFrame:CGRectMake(endX, endY, endW, endH)];
    [self addSubview:self.videoContentView];
    // 记录原始rect数据
    self.videoVideOriginalRect = CGRectMake(endX, endY, endW, endH);
    
    PBJVideoPlayerController *videoPlayerController = [[PBJVideoPlayerController alloc] init];
    videoPlayerController.view.frame = self.videoContentView.bounds;
    videoPlayerController.view.clipsToBounds = YES;
    videoPlayerController.videoView.videoFillMode = AVLayerVideoGravityResizeAspect;
    videoPlayerController.delegate = self;
    videoPlayerController.filterName = self.filterName;// 默认滤镜
    videoPlayerController.playbackLoops = YES;
    [self.videoContentView addSubview:videoPlayerController.view];
    self.videoPlayerController = videoPlayerController;
    
//    if (imageFrame.size.width > CGRectGetWidth(frame)) {
//        videoPlayerController.videoView.videoFillMode = AVLayerVideoGravityResizeAspectFill;
//    }
    // 替换按钮
    [changePicBtn removeFromSuperview];
    changePicBtn = [[UIButton alloc]init];
    changePicBtn.center = self.videoContentView.center;
    changePicBtn.backgroundColor = [UIColor clearColor];
    changePicBtn.hidden = YES;
    [changePicBtn addTarget:self action:@selector(changePic:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:changePicBtn];
    [changePicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self playDemoVideo:[url absoluteString] withinVideoPlayerController:videoPlayerController];
    
    self.videoContentViewTransform = self.videoContentView.transform;
}

- (void)playDemoVideo:(NSString*)inputVideoPath withinVideoPlayerController:(PBJVideoPlayerController*)videoPlayerController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        videoPlayerController.videoPath = inputVideoPath;
        [videoPlayerController playFromBeginning];
    });
}


#pragma mark - PBJVideoPlayerControllerDelegate
- (void)videoPlayerReady:(PBJVideoPlayerController *)videoPlayer
{
    //NSLog(@"Max duration of the video: %f", videoPlayer.maxDuration);
}

- (void)videoPlayerPlaybackStateDidChange:(PBJVideoPlayerController *)videoPlayer
{
}

- (void)videoPlayerPlaybackWillStartFromBeginning:(PBJVideoPlayerController *)videoPlayer
{
//    if (videoPlayer == _demoVideoPlayerController)
//    {
//        _demoPlayButton.alpha = 1.0f;
//        _demoPlayButton.hidden = NO;
//
//        [UIView animateWithDuration:0.1f animations:^{
//
//            _demoPlayButton.alpha = 0.0f;
//        } completion:^(BOOL finished)
//         {
//             _demoPlayButton.hidden = YES;
//         }];
//    }
}

- (void)videoPlayerPlaybackDidEnd:(PBJVideoPlayerController *)videoPlayer
{
//    if (videoPlayer == _demoVideoPlayerController)
//    {
//        _demoPlayButton.hidden = NO;
//
//        [UIView animateWithDuration:0.1f animations:^{
//
//            _demoPlayButton.alpha = 1.0f;
//        } completion:^(BOOL finished)
//         {
//
//         }];
//    }
}

- (UIImage* )getImageFromVideoFrame:(NSURL *)videoFileURL aTimae:(CMTime)atTime{
    NSURL *inputUrl = videoFileURL;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:inputUrl options:nil];
    
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:atTime actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
    {
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    }
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    if (thumbnailImageRef)
    {
        CGImageRelease(thumbnailImageRef);
    }
    
    return thumbnailImage;
}

- (void)updateVideoContentViewConstraint{
    
    if (self.imageFrameView.image) {
        //有视频的尺寸了
        [self updateVideoContentViewConstraintimageFrame:self.imageFrameView.image];
    }else{
        //没有视频尺寸的情况
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHVideoRequestOptionsVersionOriginal;
        [[PHImageManager defaultManager] requestAVAssetForVideo:self.videoAsset options:options resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
            if ([asset isKindOfClass:[AVURLAsset class]]) {
                AVURLAsset* urlAsset = (AVURLAsset*)asset;
                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                    UIImage *imageFrame = [self getImageFromVideoFrame:urlAsset.URL aTimae:CMTimeMake(1, 30)];
                    [self updateVideoContentViewConstraintimageFrame:imageFrame];
                    
                });
         }
        }];
    }
}

-(void)updateVideoContentViewConstraintimageFrame:(UIImage *)imageFrame{

    CGFloat endW;
    CGFloat endH;
    CGFloat endX;
    CGFloat endY;
    
    CGFloat fixelW = CGImageGetWidth(imageFrame.CGImage);
    CGFloat fixelH = CGImageGetHeight(imageFrame.CGImage);
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    CGFloat uiwh = w/h;
    CGFloat imagewh = fixelW/fixelH;
    if (uiwh>imagewh){
        //以宽作为伸缩比例
        endW = w;
        CGFloat radio = w / fixelW;
        endH = radio * fixelH;
        
        endX = 0;
        endY = -(endH/2 - h/2);
    } else {
        endH = h;
        CGFloat radio = h / fixelH;
        endW = radio * fixelW;
        
        endX = -(endW/2 - w/2);
        endY = 0;
    }
    
    // 用于移动时显示的图片
    self.imageFrameView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, endW, endH)];
    self.imageFrameView.image = imageFrame;
    
    // 用于播放视频的VIEW
    self.videoContentView.frame = CGRectMake(endX, endY, endW, endH);
    
    // 记录原始rect数据
    self.videoVideOriginalRect = CGRectMake(endX, endY, endW, endH);
    self.videoPlayerController.view.frame = self.videoContentView.bounds;
    self.videoPlayerController.view.clipsToBounds = YES;
    self.videoPlayerController.videoView.videoFillMode = AVLayerVideoGravityResizeAspect;
}

@end
