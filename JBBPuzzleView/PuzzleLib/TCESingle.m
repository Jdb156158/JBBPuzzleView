//
//  TCESingle.m
//  TrickEditPic
//
//  Created by zzb on 2019/5/9.
//  Copyright © 2019 json. All rights reserved.
//

#import "TCESingle.h"

static TCESingle *sigle = nil;

@implementation TCESingle

+(instancetype)tceSingle;
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sigle = [[TCESingle alloc] init];
    });
    return sigle;
}
@end
