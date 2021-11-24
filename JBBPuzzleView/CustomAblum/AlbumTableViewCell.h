//
//  AlbumTableViewCell.h
//  GIFMakingMastery
//
//  Created by 9haomi on 2021/11/2.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlbumTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *albumNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumAssetCoutnLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoSelectView;

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) PHAssetCollection *assetCollection;
@end

NS_ASSUME_NONNULL_END
