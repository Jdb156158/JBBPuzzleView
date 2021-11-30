//
//  PBJVideoPlayerController.m
//
//  Created by Patrick Piemonte on 5/27/13.
//  Copyright (c) 2013-present, Patrick Piemonte, http://patrickpiemonte.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "PBJVideoPlayerController.h"
#import "PBJVideoView.h"
#import "CustomVideoCompositing.h"
#import "CustomVideoCompositionInstruction.h"

#import <AVFoundation/AVFoundation.h>

#define LOG_PLAYER 0
#ifndef DLog
#if !defined(NDEBUG) && LOG_PLAYER
#   define DLog(fmt, ...) NSLog((@"player: " fmt), ##__VA_ARGS__);
#else
#   define DLog(...)
#endif
#endif

static NSString * const PBJVideoPlayerObserverContext = @"PBJVideoPlayerObserverContext";
static NSString * const PBJVideoPlayerItemObserverContext = @"PBJVideoPlayerItemObserverContext";

static NSString * const PBJVideoPlayerControllerTracksKey = @"tracks";
static NSString * const PBJVideoPlayerControllerStatusKey = @"status";
static NSString * const PBJVideoPlayerControllerPlayableKey = @"playable";
static NSString * const PBJVideoPlayerControllerDurationKey = @"duration";
static NSString * const PBJVideoPlayerControllerRateKey = @"rate";
static NSString * const PBJVideoPlayerControllerEmptyBufferKey = @"playbackBufferEmpty";
static NSString * const PBJVideoPlayerControllerPlayerKeepUpKey = @"playbackLikelyToKeepUp";

// TODO: scrubbing support
//static float const PBJVideoPlayerControllerRates[PBJVideoPlayerRateCount] = { 0.25, 0.5, 0.75, 1, 1.5, 2 };
//static NSInteger const PBJVideoPlayerRateCount = 6;

@interface PBJVideoPlayerController () <
    UIGestureRecognizerDelegate>
{
    AVAsset *_asset;
    AVPlayer *_player;
    AVPlayerItem *_playerItem;

    PBJVideoView *_videoView;
    NSString *_videoPath;

    PBJVideoPlayerPlaybackState _playbackState;
    PBJVideoPlayerBufferingState _bufferingState;
    
    // flags
    struct
    {
        unsigned int readyForPlayback:1;
        unsigned int playbackLoops:1;
    } __block _flags;
}

@property (nonatomic, strong) AVMutableVideoComposition *videoComposition;
@property (nonatomic, strong) AVAssetExportSession *exportSession;
@property (nonatomic, strong) NSString *exportPath;


@end

@implementation PBJVideoPlayerController

@synthesize delegate = _delegate;
@synthesize videoPath = _videoPath;
@synthesize playbackState = _playbackState;
@synthesize bufferingState = _bufferingState;

- (void)clearView
{
    [self _setPlayerItem:nil];
}

#pragma mark - getters/setters

- (NSString *)videoPath
{
    return _videoPath;
}

- (void)setVideoPath:(NSString *)videoPath
{
    if (!videoPath || [videoPath length] == 0)
        return;

    NSURL *videoURL = [NSURL URLWithString:videoPath];
    if (!videoURL || ![videoURL scheme])
    {
        videoURL = [NSURL fileURLWithPath:videoPath];
    }
    _videoPath = videoPath;

    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    [self _setAsset:asset];
}

- (BOOL)playbackLoops
{
    return _flags.playbackLoops;
}

- (void)setPlaybackLoops:(BOOL)playbackLoops
{
    _flags.playbackLoops = (unsigned int)playbackLoops;
    if (!_player)
        return;
    
    if (!_flags.playbackLoops)
    {
        _player.actionAtItemEnd = AVPlayerActionAtItemEndPause;
    }
    else
    {
        _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    }
}

- (NSTimeInterval)maxDuration
{
    NSTimeInterval maxDuration = -1;
    
    if (CMTIME_IS_NUMERIC(_playerItem.duration))
    {
        maxDuration = CMTimeGetSeconds(_playerItem.duration);
    }
    
    return maxDuration;
}

- (void)_setAsset:(AVAsset *)asset
{
    if (_asset == asset)
        return;
    
    _flags.readyForPlayback = NO;

    if (_playbackState == PBJVideoPlayerPlaybackStatePlaying)
    {
        [self pause];
    }

    _bufferingState = PBJVideoPlayerBufferingStateUnknown;
    _asset = asset;

    if (!_asset)
    {
        [self _setPlayerItem:nil];
    }
    
    NSArray *keys = @[PBJVideoPlayerControllerTracksKey, PBJVideoPlayerControllerPlayableKey, PBJVideoPlayerControllerDurationKey];
    
    [_asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        [self _enqueueBlockOnMainQueue:^{
        
            // check the keys
            for (NSString *key in keys)
            {
                NSError *error = nil;
                AVKeyValueStatus keyStatus = [asset statusOfValueForKey:key error:&error];
                if (keyStatus == AVKeyValueStatusFailed)
                {
                    self->_playbackState = PBJVideoPlayerPlaybackStateFailed;
                    [self->_delegate videoPlayerPlaybackStateDidChange:self];
                    return;
                }
            }

            // check playable
            if (!self->_asset.playable)
            {
                self->_playbackState = PBJVideoPlayerPlaybackStateFailed;
                [self->_delegate videoPlayerPlaybackStateDidChange:self];
                return;
            }
            // videoComposition
            self.videoComposition = [self createVideoCompositionWithAsset:self->_asset];
            self.videoComposition.customVideoCompositorClass = [CustomVideoCompositing class];
            
            // setup player
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:self->_asset];
            [self _setPlayerItem:playerItem];
            self->_playerItem.videoComposition = self.videoComposition;
        }];
    }];
}

- (AVMutableVideoComposition *)createVideoCompositionWithAsset:(AVAsset *)asset {
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:asset];
    UIInterfaceOrientation videoOrientation = [self orientationForTrack:asset];
    int x = arc4random() % 100;
    NSInteger trackId = asset.tracks.firstObject.trackID + x;
    if (videoOrientation == UIInterfaceOrientationPortrait) {
        [self setShouldRightRotate90:YES withTrackID:trackId];
    } else {
        [self setShouldRightRotate90:NO withTrackID:trackId];
    }
    NSArray *instructions = videoComposition.instructions;
    NSMutableArray *newInstructions = [NSMutableArray array];
    for (AVVideoCompositionInstruction *instruction in instructions) {
        NSArray *layerInstructions = instruction.layerInstructions;
        // TrackIDs
        NSMutableArray *trackIDs = [NSMutableArray array];
        for (AVVideoCompositionLayerInstruction *layerInstruction in layerInstructions) {
            [trackIDs addObject:@(layerInstruction.trackID)];
        }
        CustomVideoCompositionInstruction *newInstruction = [[CustomVideoCompositionInstruction alloc] initWithSourceTrackIDs:trackIDs timeRange:instruction.timeRange];
        newInstruction.rotateId = trackId;
        newInstruction.layerInstructions = instruction.layerInstructions;
        [newInstruction setingFilterName:self.filterName];
        [newInstructions addObject:newInstruction];
    }
    videoComposition.instructions = newInstructions;
    return videoComposition;
}

- (void)setShouldRightRotate90:(BOOL)shouldRotate withTrackID:(NSInteger)trackID {
    NSString *identifier = [NSString stringWithFormat:@"TrackID_%ld", (long)trackID];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    if (shouldRotate)
    {
        [userDefaultes setBool:YES forKey:identifier];
    }
    else
    {
        [userDefaultes setBool:NO forKey:identifier];
    }
    
    [userDefaultes synchronize];
}

- (void)updateVideoFilter:(NSString *)filterName {
    self.filterName = filterName;
    self.videoComposition = [self createVideoCompositionWithAsset:_asset];
    self.videoComposition.customVideoCompositorClass = [CustomVideoCompositing class];
    _playerItem.videoComposition = self.videoComposition;

}

- (void)exportFilterVideoCompletion:(playerOutputBlock)completion {    
    // 创建导出任务
    self.exportSession = [[AVAssetExportSession alloc] initWithAsset:_asset presetName:AVAssetExportPresetMediumQuality];
    self.exportSession.videoComposition = self.videoComposition;
    

    
    self.exportSession.outputFileType = AVFileTypeMPEG4;
    
    NSString *fileName = [NSString stringWithFormat:@"%f.m4v", [[NSDate date] timeIntervalSince1970] * 1000];
    self.exportPath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    self.exportSession.outputURL = [NSURL fileURLWithPath:self.exportPath];

    __weak typeof(self) weakself = self;
    [self.exportSession exportAsynchronouslyWithCompletionHandler:^{
        if (completion) {
            completion([NSURL fileURLWithPath:weakself.exportPath]);
        }
    }];
}

- (void)_setPlayerItem:(AVPlayerItem *)playerItem
{
    if (_playerItem == playerItem)
        return;
    
    if (_playerItem)
    {
        // AVPlayerItem KVO
        [_playerItem removeObserver:self forKeyPath:PBJVideoPlayerControllerEmptyBufferKey context:(__bridge void *)(PBJVideoPlayerItemObserverContext)];
        [_playerItem removeObserver:self forKeyPath:PBJVideoPlayerControllerPlayerKeepUpKey context:(__bridge void *)(PBJVideoPlayerItemObserverContext)];
        [_playerItem removeObserver:self forKeyPath:PBJVideoPlayerControllerStatusKey context:(__bridge void *)(PBJVideoPlayerItemObserverContext)];

        // notifications
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:_playerItem];
    }
    
    _playerItem = playerItem;
    
    if (_playerItem)
    {
        // AVPlayerItem KVO
        [_playerItem addObserver:self forKeyPath:PBJVideoPlayerControllerEmptyBufferKey options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:(__bridge void *)(PBJVideoPlayerItemObserverContext)];
        [_playerItem addObserver:self forKeyPath:PBJVideoPlayerControllerPlayerKeepUpKey options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:(__bridge void *)(PBJVideoPlayerItemObserverContext)];
        [_playerItem addObserver:self forKeyPath:PBJVideoPlayerControllerStatusKey options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:(__bridge void *)(PBJVideoPlayerItemObserverContext)];
        
        // notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_playerItemDidPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_playerItemFailedToPlayToEndTime:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:_playerItem];
    }
    
    if (!_flags.playbackLoops)
    {
        _player.actionAtItemEnd = AVPlayerActionAtItemEndPause;
    }
    else
    {
        _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    }

    [_player replaceCurrentItemWithPlayerItem:_playerItem];
}

#pragma mark - init

- (void)dealloc
{
    _videoView.player = nil;
    _delegate = nil;

    // notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    // AVPlayer KVO
    [_player removeObserver:self forKeyPath:PBJVideoPlayerControllerRateKey context:(__bridge void *)PBJVideoPlayerObserverContext];

    // player
    [_player pause];
    
    // player item
    [self _setPlayerItem:nil];
    
//    [super dealloc];
}

#pragma mark - view lifecycle

- (void)loadView
{
    // AVPlayer
    _player = [[AVPlayer alloc] init];
    _player.actionAtItemEnd = AVPlayerActionAtItemEndPause;

    // AVPlayer KVO
    [_player addObserver:self forKeyPath:PBJVideoPlayerControllerRateKey options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:(__bridge void *)(PBJVideoPlayerObserverContext)];

    // Load the view
    _videoView = [[PBJVideoView alloc] initWithFrame:CGRectZero];
    _videoView.videoFillMode = AVLayerVideoGravityResize;
    _videoView.playerLayer.hidden = YES;
    self.view = _videoView;
    
    // Application NSNotifications
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];        
    [nc addObserver:self selector:@selector(_applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [nc addObserver:self selector:@selector(_applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [nc addObserver:self selector:@selector(_applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (_playbackState == PBJVideoPlayerPlaybackStatePlaying)
        [self pause];
}

#pragma mark - private methods

- (void)_videoPlayerAudioSessionActive:(BOOL)active
{
    NSString *category = active ? AVAudioSessionCategoryPlayback : AVAudioSessionCategoryAmbient;
    
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:category error:&error];
    if (error)
    {
        DLog(@"audio session active error (%@)", error);
    }
}

- (void)_updatePlayerRatio
{
}

#pragma mark - public methods

- (void)playFromBeginning
{
    DLog(@"playing from beginnging...");
    
    [_delegate videoPlayerPlaybackWillStartFromBeginning:self];
    [_player seekToTime:kCMTimeZero];
    [self playFromCurrentTime];
}

- (void)playFromCurrentTime
{
    DLog(@"playing...");
    
    _playbackState = PBJVideoPlayerPlaybackStatePlaying;
    [_delegate videoPlayerPlaybackStateDidChange:self];
    [_player play];
    
}

- (BOOL)isPlay {
    if (_player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
        return YES;
    }
    return NO;
}

- (void)pause
{
    if (_playbackState != PBJVideoPlayerPlaybackStatePlaying)
        return;
    
    DLog(@"pause");
    
    [_player pause];
    _playbackState = PBJVideoPlayerPlaybackStatePaused;
    [_delegate videoPlayerPlaybackStateDidChange:self];
}

- (void)stop
{
    if (_playbackState != PBJVideoPlayerPlaybackStatePlaying)
        return;

    DLog(@"stop");
    
    [_player pause];
    _playbackState = PBJVideoPlayerPlaybackStateStopped;
    [_delegate videoPlayerPlaybackStateDidChange:self];
    
    [_delegate videoPlayerPlaybackDidEnd:self];
}

#pragma mark - main queue helper

typedef void (^PBJVideoPlayerBlock)(void);

- (void)_enqueueBlockOnMainQueue:(PBJVideoPlayerBlock)block
{
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
}

#pragma mark - UIResponder

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_videoPath)
    {
        
        switch (_playbackState)
        {
            case PBJVideoPlayerPlaybackStateStopped:
            {
                [self playFromBeginning];
                break;
            }
            case PBJVideoPlayerPlaybackStatePaused:
            {
                [self playFromCurrentTime];
                break;
            }
            case PBJVideoPlayerPlaybackStatePlaying:
            case PBJVideoPlayerPlaybackStateFailed:
            default:
            {
                [self pause];
                break;
            }
        }
        
    }
    else
    {
        [super touchesEnded:touches withEvent:event];
    }
    
}

- (void)_handleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if (_playbackState == PBJVideoPlayerPlaybackStatePlaying)
    {
        [self pause];
    }
    else if (_playbackState == PBJVideoPlayerPlaybackStateStopped)
    {
        [self playFromBeginning];
    }
    else
    {
        [self playFromCurrentTime];
    }
}

#pragma mark - AV NSNotificaions

- (void)_playerItemDidPlayToEndTime:(NSNotification *)aNotification
{
    [_player seekToTime:kCMTimeZero];
    
    if (!_flags.playbackLoops)
        [self stop];
}

- (void)_playerItemFailedToPlayToEndTime:(NSNotification *)aNotification
{
    _playbackState = PBJVideoPlayerPlaybackStateFailed;
    [_delegate videoPlayerPlaybackStateDidChange:self];
    
    DLog(@"error (%@)", [[aNotification userInfo] objectForKey:AVPlayerItemFailedToPlayToEndTimeErrorKey]);
}

#pragma mark - App NSNotifications

- (void)_applicationWillResignActive:(NSNotification *)aNotfication
{
    if (_playbackState == PBJVideoPlayerPlaybackStatePlaying)
        [self pause];
}

- (void)_applicationWillEnterForeground:(NSNotification *)aNotfication
{
}

- (void)_applicationDidEnterBackground:(NSNotification *)aNotfication
{
    if (_playbackState == PBJVideoPlayerPlaybackStatePlaying)
        [self pause];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( context == (__bridge void *)(PBJVideoPlayerObserverContext) )
    {
    
    
    }
    else if ( context == (__bridge void *)(PBJVideoPlayerItemObserverContext) )
    {
    
        if (_playerItem.playbackBufferEmpty)
        {
            DLog(@"playback buffer is empty");
        }

        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status)
        {
            case AVPlayerStatusReadyToPlay:
            {
                _videoView.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
                [_videoView.playerLayer setPlayer:_player];
                _videoView.playerLayer.hidden = NO;
                [_delegate videoPlayerReady:self];
                break;
            }
            case AVPlayerStatusFailed:
            {
                _playbackState = PBJVideoPlayerPlaybackStateFailed;
                [_delegate videoPlayerPlaybackStateDidChange:self];
                break;
            }
            case AVPlayerStatusUnknown:
            default:
                break;
        }
        
    }
    else
    {
    
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	
    }
}

-(UIInterfaceOrientation)orientationForTrack:(AVAsset *)asset{
    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGSize size = [videoTrack naturalSize];
    CGAffineTransform txf = [videoTrack preferredTransform];
    
    if (size.width == txf.tx && size.height == txf.ty)
        return UIInterfaceOrientationLandscapeRight;
    else if (txf.tx == 0 && txf.ty == 0)
        return UIInterfaceOrientationLandscapeLeft;
    else if (txf.tx == 0 && txf.ty == size.width)
        return UIInterfaceOrientationPortraitUpsideDown;
    else
        return UIInterfaceOrientationPortrait;
}

@end
