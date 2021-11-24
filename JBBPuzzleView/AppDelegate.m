//
//  AppDelegate.m
//  JBBPuzzleView
//
//  Created by 9haomi on 2021/11/22.
//

#import "AppDelegate.h"
#import "JBBPuzzleViewController.h"
#import "GIFMakingNaviViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    GIFMakingNaviViewController* navigationController = [[GIFMakingNaviViewController alloc] initWithRootViewController:[[JBBPuzzleViewController alloc]init]];
    [self.window setRootViewController:navigationController];
    [self.window makeKeyAndVisible];
    
    
    //相册权限询问
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
    } completionHandler:^(BOOL success, NSError *error) {
    }];
    
    return YES;
}

@end
