//
//  PickerCell.h
//  JBBPuzzleView
//
//  Created by 9haomi on 2021/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PickerCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImg;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
- (void)setPickerPHAsset:(PHAsset *)asset  index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
