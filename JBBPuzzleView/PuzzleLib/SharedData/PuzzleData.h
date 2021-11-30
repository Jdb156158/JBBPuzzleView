//
//  PuzzleData.h
//  VideoMoments
//
//  Created by Johnny Xu(徐景周) on 8/4/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PuzzleData : NSObject

@property (nonatomic, strong) NSMutableArray *puzzlePaths;
@property (nonatomic, strong) NSMutableArray *frames;

@property (nonatomic, strong) NSMutableArray *photoViewArray;
@property (nonatomic, strong) NSMutableArray *photoViewFramesArray;

@property (nonatomic, strong) NSMutableArray *customImgViewArray;
@property (nonatomic, strong) NSMutableArray *customImgViewFramesArray;

@property (nonatomic, strong) NSMutableArray *cropFramesArray;//裁剪区域

@property (nonatomic, strong) NSMutableArray *filterNameArray;//视频滤镜

@property (nonatomic, strong) NSMutableArray *videoDurationArray;//视频时长



@property (nonatomic, assign) CGSize superFrame;
@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, strong) UIColor *bgColor;

+ (PuzzleData *)sharedInstance;

@end
