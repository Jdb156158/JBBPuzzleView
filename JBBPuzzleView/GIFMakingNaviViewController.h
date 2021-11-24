//
//  GIFMakingNaviViewController.h
//  GIFMakingMastery
//  
//  Created by db J on 2021/3/26.
//

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [UIViewController popGestureClose:self]; //关闭边缘返回
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [UIViewController popGestureOpen:self]; //启动边缘返回
//}


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GIFMakingNaviViewController : UINavigationController
+ (void)popGestureClose:(UIViewController *)VC;
+ (void)popGestureOpen:(UIViewController *)VC;
@end

NS_ASSUME_NONNULL_END
