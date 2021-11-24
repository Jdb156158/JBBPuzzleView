//
//  PickerCell.m
//  JBBPuzzleView
//
//  Created by 9haomi on 2021/11/24.
//

#import "PickerCell.h"
@interface PickerCell()

@property (assign, nonatomic) PHImageRequestID requestID, videoRequestID;

@end

@implementation PickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setPickerPHAsset:(PHAsset *)asset  index:(NSInteger)index{
    [self initCoverImg:asset index:index];
}

#pragma mark - 非公开
- (void)initCoverImg:(PHAsset *)asset index:(NSInteger)index {
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode   = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    options.synchronous = NO;
    options.networkAccessAllowed = YES;
    [self.coverImg setImage:nil];
    
    NSInteger magicIndex = index + 100;
    if (self.coverImg.tag != magicIndex) {
        [[PHImageManager defaultManager] cancelImageRequest:self.requestID];
    }
    
    self.coverImg.tag = magicIndex;
    CGSize size = [self sizeMaxWidth:300.f withAsset:asset];
    self.requestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.coverImg.tag != magicIndex) {
                return;
            }
            [self.coverImg setImage:result];
        });
    }];
    
    BOOL isVideo, isBurst, isPhoto,isGIF;
    isBurst = asset.representsBurst;
    isVideo = (asset.mediaType == PHAssetMediaTypeVideo);
    isPhoto = (asset.mediaType == PHAssetMediaTypeImage);
    if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"] ||
        [[asset valueForKey:@"filename"] hasSuffix:@"gif"]) {
        isGIF = YES;
    }else {
        isGIF = NO;
    }
    
    if (isGIF) {
        self.typeLabel.text = @"GIF";
    }else if(isVideo){
        self.typeLabel.text = @"Video";
    }else{
        self.typeLabel.text = @"Photo";
    }
}

- (CGSize)sizeMaxWidth:(float)maxWidth withAsset:(PHAsset *)asset {
    
    float scale = 1.0f;
    CGSize resultSize;
    if (asset.pixelWidth > asset.pixelHeight) {
        //原图 宽>高
        if (maxWidth > asset.pixelWidth) {
            scale = 1.0f;
        }else {
            scale = asset.pixelWidth / maxWidth;
        }
    }else {
        //原图 宽<=高
        if (maxWidth > asset.pixelHeight) {
            scale = 1.0f;
        }else {
            scale = asset.pixelHeight / maxWidth;
        }
    }
    resultSize = CGSizeMake(asset.pixelWidth/scale, asset.pixelHeight/scale);
    
//    NSLog(@"--------------------------");
//    NSLog(@"资源size%@， 缩小倍数%02f", NSStringFromCGSize(resultSize), (float)scale);
//    NSLog(@"--------------------------");
    return resultSize;
}
@end
