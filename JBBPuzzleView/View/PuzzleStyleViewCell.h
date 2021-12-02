//
//  PuzzleStyleViewCell.h
//  JBBPuzzleView
//
//  Created by 9haomi on 2021/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PuzzleStyleViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *styleImageView;
@property (strong, nonatomic) NSDictionary *dict;
@end

NS_ASSUME_NONNULL_END
