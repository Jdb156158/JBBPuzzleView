//
//  CustomAlbumController.m
//  JBBPuzzleView
//
//  Created by 9haomi on 2021/11/24.
//

#import "CustomAlbumController.h"
#import "PickerCell.h"
#import "AlbumTableViewCell.h"

@interface CustomAlbumController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) NSMutableArray *pickerModels, *selectedIndexs,*albumArray;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (strong, nonatomic) UIImageView *arrowIcon;
@property (strong, nonatomic) UILabel *titleLb;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSIndexPath *indexPathSelect;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCenterViewLayoutWidth;
@property (weak, nonatomic) IBOutlet UIView *topCenterView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navaHeightLayout;
@property (weak, nonatomic) IBOutlet UIButton *selectArrowIconBtn;

@end

@implementation CustomAlbumController


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navaHeightLayout.constant = kSafeAreaNavTopHeight+KSTA_H;
    
    [self initTopCenterViewAndArrowIcon];
    
    if (@available(iOS 14, *)) {
        [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                NSLog(@"====允许相册访问====");
                [self initAlbumData];
            }else if(status == PHAuthorizationStatusLimited){
                NSLog(@"====允许相册访问====");
                [self initAlbumData];
            }else{
                NSLog(@"====不允许相册访问====");
            }
        }];
    } else {
        // Fallback on earlier versions
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                NSLog(@"====允许相册访问====");
                [self initAlbumData];
            }else if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
                NSLog(@"====不允许相册访问====");
            }
        }];
    }
    
    
}

- (void)showAlbumNameTableView{
    CGRect bgselectVieFrame = self.tableView.frame;
    [UIView animateWithDuration:.3 animations:^{
        self.tableView.frame = CGRectMake(0,kSafeAreaNavTopHeight+KSTA_H, K_W, bgselectVieFrame.size.height);
    }];
}

- (void)hiddenAlbumNameTableView{
    CGRect bgselectVieFrame = self.tableView.frame;
    [UIView animateWithDuration:.5 animations:^{
        self.tableView.frame = CGRectMake(0,- bgselectVieFrame.size.height, K_W, bgselectVieFrame.size.height);
    }];
}

- (IBAction)clickCloseBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)clickTopViewBtn:(id)sender {
    
    self.selectArrowIconBtn.selected = !self.selectArrowIconBtn.selected;
    self.selectArrowIconBtn.userInteractionEnabled = NO;
    if (self.selectArrowIconBtn.selected) {
        [UIView animateWithDuration:0.25 animations:^{
            self.arrowIcon.transform = CGAffineTransformMakeRotation(2 * M_PI);
        } completion:^(BOOL finished) {
            self.selectArrowIconBtn.userInteractionEnabled = YES;
            [self showAlbumNameTableView];
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.arrowIcon.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            self.selectArrowIconBtn.userInteractionEnabled = YES;
            [self hiddenAlbumNameTableView];
        }];
    }
    
}

- (void)initTopCenterViewAndArrowIcon{
    
    [self.view addSubview:self.collectionView];
    
    [self.view addSubview:self.tableView];

    [self.view bringSubviewToFront:self.topView];
    
    [self.topCenterView addSubview:self.titleLb];
    [self.topCenterView addSubview:self.arrowIcon];
    self.topCenterView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    [self.topCenterView hx_radiusWithRadius:15 corner:UIRectCornerAllCorners];
    
    self.titleLb.hx_centerY = self.topCenterView.hx_h / 2;
    self.arrowIcon.hx_centerY = self.titleLb.hx_centerY;
    self.titleLb.hx_x = 10;
    self.arrowIcon.hx_x = CGRectGetMaxX(self.titleLb.frame) + 5;
    self.titleLb.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f] ;
    self.arrowIcon.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    
    self.topCenterViewLayoutWidth.constant = self.titleLb.hx_w + 10 + self.arrowIcon.hx_w + 15 ;
}

- (void)updaeTopCenterViewAndArrowIcon{
    CGFloat textWidth = self.titleLb.hx_getTextWidth;
    self.titleLb.hx_w = textWidth+10;
    self.arrowIcon.hx_x = CGRectGetMaxX(self.titleLb.frame) + 5;
    self.topCenterViewLayoutWidth.constant = self.titleLb.hx_w + 10 + self.arrowIcon.hx_w + 15 ;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.hidden = YES;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_tableView registerNib:[UINib nibWithNibName:@"AlbumTableViewCell" bundle:nil] forCellReuseIdentifier:@"AlbumTableViewCell"];
    }
    return _tableView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *configLayout = [[UICollectionViewFlowLayout alloc]init];
        configLayout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-12)/3, ([UIScreen mainScreen].bounds.size.width-12)/3);
        configLayout.minimumLineSpacing = 1 ;
        configLayout.minimumInteritemSpacing = 1 ;
        configLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        configLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kSafeAreaNavTopHeight+KSTA_H, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-(kSafeAreaNavTopHeight+KSTA_H)) collectionViewLayout:configLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;//隐藏滚动条
        _collectionView.backgroundColor = [UIColor clearColor];

        [_collectionView registerNib:[UINib nibWithNibName:@"PickerCell" bundle:nil] forCellWithReuseIdentifier:@"PickerCell"];

    }
    return _collectionView;
}
#pragma mark - 初始化相册数据
- (void)initAlbumData{
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
        //刷新前清空一下
        [self.albumArray removeAllObjects];
        
        //PHAssetCollectionTypeAlbum      = 1, // 用户自定义相册
        //PHAssetCollectionTypeSmartAlbum = 2, // 系统相册
        PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
        for (PHAssetCollection *assetCollection in assetCollections) {
            NSLog(@"相册名称：%@",assetCollection.localizedTitle);
            PHFetchOptions *fetchOption = [[PHFetchOptions alloc] init];
            PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOption];
            if (assets.count>0) {
                [self.albumArray addObject:assetCollection];
            }
        }
        
        PHFetchResult<PHAssetCollection *> *assetCollections2 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
        for (PHAssetCollection *assetCollection2 in assetCollections2) {
            NSLog(@"相册名称：%@",assetCollection2.localizedTitle);
            PHFetchOptions *fetchOption2 = [[PHFetchOptions alloc] init];
            PHFetchResult<PHAsset *> *assets2 = [PHAsset fetchAssetsInAssetCollection:assetCollection2 options:fetchOption2];
            if (assets2.count>0) {
                [self.albumArray addObject:assetCollection2];
            }
        }
        
        if (self.albumArray.count>0) {
            PHAssetCollection *assetCollection = self.albumArray.firstObject;
            //显示当前相册下图片
            [self initPickerData:assetCollection];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.albumArray.count>0) {
                
                PHAssetCollection *assetCollection = self.albumArray.firstObject;
                self.titleLb.text = assetCollection.localizedTitle;
                [self updaeTopCenterViewAndArrowIcon];
                self.topCenterView.hidden = NO;
                
                CGFloat height = K_H-kSafeAreaNavTopHeight-KSTA_H;
                self.tableView.frame = CGRectMake(0, -height, K_W, height);
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            }else{
                self.topCenterView.hidden = YES;
                self.tableView.hidden = YES;
            }
            
        });
        
    });
}

- (void)initPickerData:(PHAssetCollection *)assetCollection {
    
    [self enumerateAssetsInAssetCollection:assetCollection original:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //相册数据获取完成
        [self.collectionView reloadData];
    });
    
}


//细分照片类型
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original{
    
    [self.selectedIndexs removeAllObjects];
    [self.pickerModels removeAllObjects];
    
    PHFetchOptions *fetchOption = [[PHFetchOptions alloc] init];
    //fetchOption.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOption];
    
    NSLog(@"===图片数量:%ld===%@",assets.count,assetCollection.localizedTitle);
    
    for (NSInteger i = assets.count-1;i>=0;i--) {
        
        PHAsset * asset = assets[i];
        
        BOOL isLivePhoto, isVideo, isBurst, isPhoto;
        BOOL isNotLivePhoto;
        BOOL isGIF = NO;
        if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"] ||
            [[asset valueForKey:@"filename"] hasSuffix:@"gif"]) {
            isGIF = YES;
        }else {
            isGIF = NO;
        }
        if (@available(iOS 9.1, *)){
            isLivePhoto = (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive || asset.mediaSubtypes == 520);    //livephot 属于 照片细分type
            if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive || asset.mediaSubtypes == 520) {
                isNotLivePhoto = NO;
            }else{
                isNotLivePhoto = YES;
            }
        }else {
            isLivePhoto = NO;
            isNotLivePhoto = YES;
        }
        isBurst = asset.representsBurst;
        isVideo = (asset.mediaType == PHAssetMediaTypeVideo);
        isPhoto = (asset.mediaType == PHAssetMediaTypeImage);// && isNotLivePhoto && !isGIF;
        
        if (isPhoto || isGIF || isVideo) {
            [self.pickerModels addObject:asset];
            continue;
        }
    }
}

#pragma mark - get
- (NSMutableArray *)pickerModels {
    
    if (!_pickerModels) {
        _pickerModels = [NSMutableArray array];
    }
    return _pickerModels;
}

- (NSMutableArray *)albumArray {
    
    if (!_albumArray) {
        _albumArray = [NSMutableArray array];
    }
    return _albumArray;
}

- (NSMutableArray *)selectedIndexs {
    if (!_selectedIndexs) {
        _selectedIndexs = [NSMutableArray array];
    }
    return _selectedIndexs;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        CGFloat textWidth = self.titleLb.hx_getTextWidth;
        _titleLb.hx_w = textWidth+10;
        _titleLb.hx_h = 30;
        _titleLb.font = [UIFont boldSystemFontOfSize:17];
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}
- (UIImageView *)arrowIcon {
    if (!_arrowIcon) {
        
        _arrowIcon = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"hx_nav_title_down"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        _arrowIcon.transform = CGAffineTransformMakeRotation(M_PI);
        _arrowIcon.hx_size = _arrowIcon.image.size;
    }
    return _arrowIcon;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albumArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AlbumTableViewCell" forIndexPath:indexPath];
    PHAssetCollection *assetCollection = self.albumArray[indexPath.row];
    cell.indexPath = indexPath;
    cell.assetCollection = assetCollection;
    if (indexPath.row == self.indexPathSelect.row) {
        cell.photoSelectView.hidden = NO;
    }else{
        cell.photoSelectView.hidden = YES;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.indexPathSelect = indexPath;
    [self.tableView reloadData];
    [self hiddenAlbumNameTableView];
    PHAssetCollection *assetCollection = self.albumArray[indexPath.row];
    self.titleLb.text = assetCollection.localizedTitle;
    [self updaeTopCenterViewAndArrowIcon];
    [self clickTopViewBtn:nil];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initPickerData:assetCollection];
    });
}

#pragma mark - collectiondelegate


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pickerModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PickerCell" forIndexPath:indexPath];
    PHAsset *asset = self.pickerModels[indexPath.item];
    [cell setPickerPHAsset:asset index:indexPath.item];
    cell.backgroundColor = [UIColor grayColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        
    if (indexPath.item >= self.pickerModels.count) {
        NSLog(@"数组越界");
        return;
    }
    
    PHAsset *asset = self.pickerModels[indexPath.row];
    
    if (self.didSelextAssetfinsh) {
        self.didSelextAssetfinsh(asset);
    }
}


@end
