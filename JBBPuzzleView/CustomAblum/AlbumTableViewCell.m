//
//  AlbumTableViewCell.m
//  GIFMakingMastery
//
//  Created by 9haomi on 2021/11/2.
//

#import "AlbumTableViewCell.h"
@interface AlbumTableViewCell()
@property (assign, nonatomic) PHImageRequestID requestID;
@end
@implementation AlbumTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#1A1A1A"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setAssetCollection:(PHAssetCollection *)assetCollection{
    
    _assetCollection = assetCollection;
    
    PHFetchOptions *fetchOption = [[PHFetchOptions alloc] init];
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOption];
    self.albumNameLabel.text = assetCollection.localizedTitle;
    self.albumAssetCoutnLabel.text = [NSString stringWithFormat:@"(%ld)",assets.count];
    if (assets.count>0) {
        PHAsset * asset = assets.firstObject;
        [self initCoverImg:asset index:self.indexPath.row];
    }else{
        [self.leftIconImageView setImage:nil];
    }
}

#pragma mark - 非公开
- (void)initCoverImg:(PHAsset *)asset index:(NSInteger)index {
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode   = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    options.synchronous = NO;
    options.networkAccessAllowed = YES;
    [self.leftIconImageView setImage:nil];
    
    NSInteger magicIndex = index + 100;
    if (self.leftIconImageView.tag != magicIndex) {
        [[PHImageManager defaultManager] cancelImageRequest:self.requestID];
    }
    
    self.leftIconImageView.tag = magicIndex;
    self.requestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.leftIconImageView.tag != magicIndex) {
                return;
            }
            [self.leftIconImageView setImage:result];
        });
    }];
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}
@end
