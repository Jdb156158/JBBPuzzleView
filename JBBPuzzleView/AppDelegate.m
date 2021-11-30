//
//  AppDelegate.m
//  JBBPuzzleView
//
//  Created by 9haomi on 2021/11/22.
//

#import "AppDelegate.h"
#import "JBBPuzzleViewController.h"
#import "GIFMakingNaviViewController.h"
#import <CoreText/CoreText.h>

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
    
    /*
    //自己做字库名称获取用的
    NSString *path = [[NSBundle mainBundle] pathForResource:@"站酷酷黑体" ofType:@"ttf"];
    NSLog(@"字体路径：%@",path);

    NSURL *fontUrl = [NSURL fileURLWithPath:path];

    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);

    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);

    CGDataProviderRelease(fontDataProvider);

    CTFontManagerRegisterGraphicsFont(fontRef, NULL);

    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    
    NSLog(@"=======自定义字体名称：%@",fontName);

    CGFontRelease(fontRef);*/
    
    return YES;
}

@end
