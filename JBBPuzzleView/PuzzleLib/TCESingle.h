//
//  TCESingle.h
//  TrickEditPic
//
//  Created by zzb on 2019/5/9.
//  Copyright © 2019 json. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCESingle : NSObject
@property (nonatomic, assign) NSInteger tceStyleRow;
@property (nonatomic, assign) NSInteger tceGra;
@property (nonatomic, assign) NSInteger tceBorder;
@property (nonatomic, copy) UIImage *tceImage;

+(instancetype)tceSingle;
@end

NS_ASSUME_NONNULL_END
