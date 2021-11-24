//
//  CustomAlbumController.h
//  JBBPuzzleView
//
//  Created by 9haomi on 2021/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomAlbumController : UIViewController
@property (nonatomic,copy) void (^didSelextAssetfinsh)(PHAsset *asset);
@end

NS_ASSUME_NONNULL_END
