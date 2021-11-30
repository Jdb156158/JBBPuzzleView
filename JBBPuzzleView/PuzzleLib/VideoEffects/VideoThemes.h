//
//  VideoThemes
//  VideoMoments
//
//  Created by Johnny Xu(徐景周) on 7/23/14.
//  Copyright (c) 2014 Future Studio. All rights reserved.
//

@interface VideoThemes : NSObject
{
    int _ID;
    NSString  *_thumbImageName;
    NSString *_name;
    NSString *_textStar;
    NSString *_textSparkle;
    NSString *_textGradient;
    NSString *_bgMusicFile;
    NSString *_imageFile;
    NSMutableArray *_animationImages;
    NSArray *_keyFrameTimes;
    NSMutableArray *_scrollText;

    NSString *_imageVideoBorder;
    NSURL *_bgVideoFile;
    
    NSArray *_animationActions;
}

@property (nonatomic, assign) int ID;
@property (nonatomic, copy) NSString *thumbImageName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *textStar;
@property (nonatomic, copy) NSString *textSparkle;
@property (nonatomic, copy) NSString *textGradient;
@property (nonatomic, copy) NSString *bgMusicFile;
@property (nonatomic, copy) NSString *imageFile;
@property (nonatomic, retain) NSMutableArray *scrollText;
@property (nonatomic, retain) NSMutableArray *animationImages;
@property (nonatomic, retain) NSArray *keyFrameTimes;

@property (nonatomic, copy) NSString *imageVideoBorder;
@property (nonatomic, copy) NSURL *bgVideoFile;

@property (nonatomic, retain) NSArray *animationActions;

@end
