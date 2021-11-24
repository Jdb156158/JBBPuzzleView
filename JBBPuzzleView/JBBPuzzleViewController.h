//
//  JBBPuzzleViewController.h
//  JBBPuzzleView
//
//  Created by 9haomi on 2021/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JBBPuzzleViewController : UIViewController
/** view 比例 */
@property (nonatomic, assign) NSInteger TcePuzzleStyleIndex;

@property (nonatomic, assign) NSInteger TcePuzzleStyleRow;
@property (nonatomic, assign) NSInteger borderValue;
@property (nonatomic, assign) NSInteger grpValue;
@property (nonatomic, strong) UIImage *tceImage;
@end

NS_ASSUME_NONNULL_END
