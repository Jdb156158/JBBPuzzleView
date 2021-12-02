//
//  JBBPuzzleViewController.m
//  JBBPuzzleView
//
//  Created by 9haomi on 2021/11/22.
//

#import "JBBPuzzleViewController.h"
#import "TcePuzzlePuzzleView.h"
#import "PuzzleStyleViewCell.h"
#import "PuzzleBgColorViewCell.h"
#import "CustomAlbumController.h"

#import "VideoThemesData.h"
#import "ExportEffects.h"
#import "PuzzleData.h"

@interface JBBPuzzleViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *canvasBgView;
@property (weak, nonatomic) IBOutlet UICollectionView *myModelCountCollectionView;//风格
@property (weak, nonatomic) IBOutlet UICollectionView *myColorCollectionView;//颜色
@property (weak, nonatomic) IBOutlet UICollectionView *myScaleCollectionView;//画布比例
@property (weak, nonatomic) IBOutlet UISlider *borderPxSlider;

@property (nonatomic, strong) TcePuzzlePuzzleView *tcePuzzleView;
@property (nonatomic, strong) NSMutableArray *modelCountImages;
@property (nonatomic, strong) NSMutableArray *colorsArray;
@property (nonatomic, strong) NSMutableArray *scaleArray;

@property (nonatomic, assign) NSInteger puzzleStyleIndex;
@property (nonatomic, assign) NSInteger puzzleStyleRow;
@end

@implementation JBBPuzzleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.modelCountImages = [[NSMutableArray alloc] initWithArray:@[
        @{@"default":@"style_2_3",@"selectimage":@"Select_style_2_3"},
        @{@"default":@"style_3_4",@"selectimage":@"Select_style_3_4"},
        @{@"default":@"style_4_6",@"selectimage":@"Select_style_4_6"},
        @{@"default":@"style_5_0",@"selectimage":@"Select_style_5_0"},
        @{@"default":@"style_6_1",@"selectimage":@"Select_style_6_1"},
        @{@"default":@"style_7_0",@"selectimage":@"Select_style_7_0"},
        @{@"default":@"style_8_0",@"selectimage":@"Select_style_8_0"},
        @{@"default":@"style_9_0",@"selectimage":@"Select_style_9_0"},
    ]];
    
    self.colorsArray = [[NSMutableArray alloc] initWithArray:@[
        @"#282A2D",@"#FFFFFF",@"#FA5150",@"#FEC200",@"#07C160",@"#10ADFF",@"#6467EF",@"#FF0000",@"#FF4500",@"#FFD700",@"#40E0D0",@"#4682B4",@"#6495ED",@"#483D8B",@"#9400D3",
        @"#8B008B",@"#C71585",@"#FF1493",@"#DC143C",@"#FFB6C1",@"#4B0082"
    ]];
    
    self.scaleArray = [[NSMutableArray alloc] initWithArray:@[
        @{@"default":@"GIF拼图画布1：1",@"selectimage":@"GIF拼图画布选中1：1"},
        @{@"default":@"GIF拼图画布16：9",@"selectimage":@"GIF拼图画布选中16：9"},
        @{@"default":@"GIF拼图画布9：16",@"selectimage":@"GIF拼图画布选中9：16"},
        @{@"default":@"GIF拼图画布1：2",@"selectimage":@"GIF拼图画布选中1：2"},
        @{@"default":@"GIF拼图画布2：1",@"selectimage":@"GIF拼图画布选中2：1"},
        @{@"default":@"GIF拼图画布2：3",@"selectimage":@"GIF拼图画布选中2：3"},
        @{@"default":@"GIF拼图画布3：2",@"selectimage":@"GIF拼图画布选中3：2"},
        @{@"default":@"GIF拼图画布3：4",@"selectimage":@"GIF拼图画布选中3：4"},
        @{@"default":@"GIF拼图画布4：3",@"selectimage":@"GIF拼图画布选中4：3"},
        @{@"default":@"GIF拼图画布4：5",@"selectimage":@"GIF拼图画布选中4：5"},
    ]];
        
    [self initColorCollectionView];
    
    [self initPuzzleSytleCollectionView];
    
    [self initScaleCollectionView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //默认选中第一行
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.myModelCountCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.myModelCountCollectionView didSelectItemAtIndexPath:indexPath];
        
        
        [self.myColorCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.myColorCollectionView didSelectItemAtIndexPath:indexPath];
        
        [self.myScaleCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.myScaleCollectionView didSelectItemAtIndexPath:indexPath];
        
    });
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shitu_jiangyaoxianshi_houtai_jin_qiantai) name:UIApplicationWillEnterForegroundNotification object:app];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.tcePuzzleView.manage) {
            [self.tcePuzzleView updatePlayVideoDXLINVManageView];
        }
    });
    
}


#pragma mark - /** 后台进前台 */
//从后台进前台记得也要重新播放
-(void) shitu_jiangyaoxianshi_houtai_jin_qiantai {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.tcePuzzleView.manage) {
            [self.tcePuzzleView updatePlayVideoDXLINVManageView];
        }
    });
}

- (void)initColorCollectionView{
    UICollectionViewFlowLayout *configLayout = [[UICollectionViewFlowLayout alloc]init];
    configLayout.itemSize = CGSizeMake(30, 30);
    configLayout.minimumLineSpacing = 10 ;
    configLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _myColorCollectionView.collectionViewLayout = configLayout;
    _myColorCollectionView.backgroundColor = [UIColor clearColor];
    _myColorCollectionView.delegate = self;
    _myColorCollectionView.dataSource = self;
    _myColorCollectionView.allowsMultipleSelection = NO;
    _myColorCollectionView.showsHorizontalScrollIndicator = NO;
    [_myColorCollectionView registerNib:[UINib nibWithNibName:@"PuzzleBgColorViewCell" bundle:nil] forCellWithReuseIdentifier:@"PuzzleBgColorViewCell"];
    _myColorCollectionView.tag = 1;
}

- (void)initPuzzleSytleCollectionView{
    UICollectionViewFlowLayout *configLayout = [[UICollectionViewFlowLayout alloc]init];
    configLayout.itemSize = CGSizeMake(50, 50);
    configLayout.minimumLineSpacing = 15 ;
    configLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    configLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _myModelCountCollectionView.collectionViewLayout = configLayout;
    _myModelCountCollectionView.backgroundColor = [UIColor colorWithHexString:@"#181A1E"];
    _myModelCountCollectionView.delegate = self;
    _myModelCountCollectionView.dataSource = self;
    _myModelCountCollectionView.allowsMultipleSelection = NO;
    _myModelCountCollectionView.showsHorizontalScrollIndicator = NO;
    [_myModelCountCollectionView registerNib:[UINib nibWithNibName:@"PuzzleStyleViewCell" bundle:nil] forCellWithReuseIdentifier:@"PuzzleStyleViewCell"];
    _myModelCountCollectionView.tag = 2;
}

- (void)initScaleCollectionView{
    UICollectionViewFlowLayout *configLayout = [[UICollectionViewFlowLayout alloc]init];
    configLayout.itemSize = CGSizeMake(30, 30);
    configLayout.minimumLineSpacing = 15 ;
    configLayout.sectionInset = UIEdgeInsetsMake(15, 0, 15, 15);
    configLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _myScaleCollectionView.collectionViewLayout = configLayout;
    _myScaleCollectionView.backgroundColor = [UIColor clearColor];
    _myScaleCollectionView.delegate = self;
    _myScaleCollectionView.dataSource = self;
    _myScaleCollectionView.allowsMultipleSelection = NO;
    _myScaleCollectionView.showsHorizontalScrollIndicator = NO;
    [_myScaleCollectionView registerNib:[UINib nibWithNibName:@"PuzzleStyleViewCell" bundle:nil] forCellWithReuseIdentifier:@"PuzzleStyleViewCell"];
    _myScaleCollectionView.tag = 3;
}

- (TcePuzzlePuzzleView *)tcePuzzleView
{
    if (!_tcePuzzleView){
        _tcePuzzleView = [[TcePuzzlePuzzleView alloc] initWithFrame:CGRectMake(0, 0, self.canvasBgView.frame.size.width, self.canvasBgView.frame.size.height)];
        _tcePuzzleView.backgroundColor = [UIColor colorWithHexString:@"#282A2D"];
        [self.canvasBgView addSubview:_tcePuzzleView];
    }
    return _tcePuzzleView;
}


#pragma mark -- -- -- -- -- - UICollectView Delegate & DataSource - -- -- -- -- --

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == 1) {
        return self.colorsArray.count;
    }else if(collectionView.tag == 2){
        return self.modelCountImages.count;
    }else{
        return self.scaleArray.count;
    }
   
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 1) {
        PuzzleBgColorViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PuzzleBgColorViewCell" forIndexPath:indexPath];
        NSString *colorName = self.colorsArray[indexPath.item];
        [cell setColorStr:colorName];
        return cell;
    }else if(collectionView.tag == 2){
        PuzzleStyleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PuzzleStyleViewCell" forIndexPath:indexPath];
        NSDictionary *dict = self.modelCountImages[indexPath.item];
        cell.dict = dict;
        return cell;
    }else{
        PuzzleStyleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PuzzleStyleViewCell" forIndexPath:indexPath];
        NSDictionary *dict = self.scaleArray[indexPath.item];
        cell.dict = dict;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1) {
        NSString *colorName = self.colorsArray[indexPath.item];
        _tcePuzzleView.backgroundColor = [UIColor colorWithHexString:colorName];
    }else if(collectionView.tag == 2){
        if (indexPath.item == 0) {
            // 重载界面
            [self.tcePuzzleView setTcePuzzleStyleIndex:2];
            [self.tcePuzzleView setTcePuzzleStyleRow:3];
            
            self.puzzleStyleIndex = 2;
            self.puzzleStyleRow = 3;
        }else if (indexPath.item == 1){
            // 重载界面
            [self.tcePuzzleView setTcePuzzleStyleIndex:3];
            [self.tcePuzzleView setTcePuzzleStyleRow:4];
            
            self.puzzleStyleIndex = 3;
            self.puzzleStyleRow = 4;
        }else if (indexPath.item == 2){
            // 重载界面
            [self.tcePuzzleView setTcePuzzleStyleIndex:4];
            [self.tcePuzzleView setTcePuzzleStyleRow:6];
            
            self.puzzleStyleIndex = 4;
            self.puzzleStyleRow = 6;
        }else if (indexPath.item == 3){
            // 重载界面
            [self.tcePuzzleView setTcePuzzleStyleIndex:5];
            [self.tcePuzzleView setTcePuzzleStyleRow:0];
            
            self.puzzleStyleIndex = 5;
            self.puzzleStyleRow = 0;
        }else if (indexPath.item == 4){
            // 重载界面
            [self.tcePuzzleView setTcePuzzleStyleIndex:6];
            [self.tcePuzzleView setTcePuzzleStyleRow:1];
            
            self.puzzleStyleIndex = 6;
            self.puzzleStyleRow = 1;
        }else if (indexPath.item == 5){
            // 重载界面
            [self.tcePuzzleView setTcePuzzleStyleIndex:7];
            [self.tcePuzzleView setTcePuzzleStyleRow:0];
            
            self.puzzleStyleIndex = 7;
            self.puzzleStyleRow = 0;
        }else if (indexPath.item == 6){
            // 重载界面
            [self.tcePuzzleView setTcePuzzleStyleIndex:8];
            [self.tcePuzzleView setTcePuzzleStyleRow:0];
            
            self.puzzleStyleIndex = 8;
            self.puzzleStyleRow = 0;
        }else if (indexPath.item == 7){
            // 重载界面
            [self.tcePuzzleView setTcePuzzleStyleIndex:9];
            [self.tcePuzzleView setTcePuzzleStyleRow:0];
            
            self.puzzleStyleIndex = 9;
            self.puzzleStyleRow = 0;
        }
    }else{
        //比例
        if (indexPath.item == 0) {
            //1:1
            _tcePuzzleView.frame = CGRectMake(0, 0, self.canvasBgView.frame.size.width, self.canvasBgView.frame.size.height);
        }else if(indexPath.item == 1){
            //16:9
            _tcePuzzleView.frame = CGRectMake(0, self.canvasBgView.frame.size.height/2-(self.canvasBgView.frame.size.width*9/16)/2, self.canvasBgView.frame.size.width, self.canvasBgView.frame.size.width*9/16);
        }else if(indexPath.item == 2){
            //9:16
            _tcePuzzleView.frame = CGRectMake(self.canvasBgView.frame.size.width/2-(self.canvasBgView.frame.size.height*9/16)/2, 0, self.canvasBgView.frame.size.height*9/16, self.canvasBgView.frame.size.height);
        }else if(indexPath.item == 3){
            //1:2
            _tcePuzzleView.frame = CGRectMake(self.canvasBgView.frame.size.width/2-(self.canvasBgView.frame.size.height*1/2)/2, 0, self.canvasBgView.frame.size.height*1/2, self.canvasBgView.frame.size.height);
        }else if(indexPath.item == 4){
            //2:1
            _tcePuzzleView.frame = CGRectMake(0, self.canvasBgView.frame.size.height/2-(self.canvasBgView.frame.size.width*1/2)/2, self.canvasBgView.frame.size.width, self.canvasBgView.frame.size.width*1/2);
        }else if(indexPath.item == 5){
            //2:3
            _tcePuzzleView.frame = CGRectMake(self.canvasBgView.frame.size.width/2-(self.canvasBgView.frame.size.height*2/3)/2, 0, self.canvasBgView.frame.size.height*2/3, self.canvasBgView.frame.size.height);
        }else if(indexPath.item == 6){
            //3:2
            _tcePuzzleView.frame = CGRectMake(0, self.canvasBgView.frame.size.height/2-(self.canvasBgView.frame.size.width*2/3)/2, self.canvasBgView.frame.size.width, self.canvasBgView.frame.size.width*2/3);
        }else if(indexPath.item == 7){
            //3:4
            _tcePuzzleView.frame = CGRectMake(self.canvasBgView.frame.size.width/2-(self.canvasBgView.frame.size.height*3/4)/2, 0, self.canvasBgView.frame.size.height*3/4, self.canvasBgView.frame.size.height);
        }else if(indexPath.item == 8){
            //4:3
            _tcePuzzleView.frame = CGRectMake(0, self.canvasBgView.frame.size.height/2-(self.canvasBgView.frame.size.width*3/4)/2, self.canvasBgView.frame.size.width, self.canvasBgView.frame.size.width*3/4);
        }else if(indexPath.item == 9){
            //4:5
            _tcePuzzleView.frame = CGRectMake(self.canvasBgView.frame.size.width/2-(self.canvasBgView.frame.size.height*4/5)/2, 0, self.canvasBgView.frame.size.height*4/5, self.canvasBgView.frame.size.height);
        }
        // 重载界面
        [self.tcePuzzleView setTcePuzzleStyleIndex:self.puzzleStyleIndex];
        [self.tcePuzzleView setTcePuzzleStyleRow:self.puzzleStyleRow];
    }
    
}

#pragma mark - 滑块滑动中
- (IBAction)sendersliderValueOnChange:(UISlider *)sender {
    NSLog(@"==滑块滑动中==");
    self.tcePuzzleView.grpValue = sender.value;
}

#pragma mark - 滑块滑动结束
- (IBAction)slderTouchUp:(UISlider *)sender {
    NSLog(@"==滑块滑动结束==");
    self.borderPxSlider.value = sender.value;
    self.tcePuzzleView.grpValue = sender.value;
}

- (IBAction)clickSaveBtn:(id)sender {
    
    
    [SVProgressHUD showWithStatus:@"处理中..."];
    
    //设置背景音乐
    [[[VideoThemesData sharedInstance] getThemeByType:kThemeCustom] setBgMusicFile:nil];
    
    //处理进度监听
    [[ExportEffects sharedInstance] setThemeCurrentType:kThemeCustom];
    [[ExportEffects sharedInstance] setExportProgressBlock: ^(NSNumber *percentage, NSString *title) {
        NSLog(@"===当前处理进度===%@",percentage);
        NSString *currentPrecentage = [NSString stringWithFormat:@"%d%%", (int)([percentage floatValue] * 100)];
        [SVProgressHUD showWithStatus:currentPrecentage];
    }];
    [[ExportEffects sharedInstance] setFinishVideoBlock: ^(BOOL success, id result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success){
                NSString *outputPath = [ExportEffects sharedInstance].filenameBlock();
                NSLog(@"===处理后的视频合成地址===%@",outputPath);
                [SVProgressHUD showSuccessWithStatus:@"处理完成"];
            } else {
                NSLog(@"===处理失败===");
                [SVProgressHUD showErrorWithStatus:@"处理失败"];
            }
        });
    }];
    
    NSMutableArray *assetVideoUrlArr = [NSMutableArray array];//视频素材
    NSMutableArray *photoViewArray = [NSMutableArray array];//图片素材
    
    for (DXLINVView *item in self.tcePuzzleView.manage.invViews) {
        if (item.isVideo) {
            [assetVideoUrlArr addObject:item.videoUrl];
        } else {
            UIImage *newimage = [self getImage:item];
            if (newimage){
                [photoViewArray addObject:[self getImage:item]];// 获取展示图片
            }
        }
    }
    
    // frame
    // superSizeOriginal
    //画布的大小
    CGSize superSizeOriginal = CGSizeMake(self.tcePuzzleView.frame.size.width*2, self.tcePuzzleView.frame.size.height*2);
    CGSize superSize = CGSizeMake(self.tcePuzzleView.frame.size.width*2, self.tcePuzzleView.frame.size.height*2);
    superSize = [self sizeScaleWithSize:superSize scale:2.0f];

    [[PuzzleData sharedInstance] setSuperFrame:superSizeOriginal];
    
    // frames
    NSMutableArray *frames = [NSMutableArray array];
    NSMutableArray *photoViewFrames = [NSMutableArray array];
    NSMutableArray *cropViewFrames = [NSMutableArray array];

    for (DXLINVView *item in self.tcePuzzleView.manage.invViews) {
        if (item.isVideo) {
            CGRect rectOriginal = [self reductionRect:item.frame andSuperSize:superSize];
            rectOriginal.origin.y = fabs(superSizeOriginal.height - rectOriginal.origin.y - CGRectGetHeight(rectOriginal));
            [frames addObject:[NSValue valueWithCGRect:rectOriginal]];
            
            // 获取裁剪区域
            CGRect videoRect = item.videoContentView.frame;
            CGRect videoOriginalRect = item.videoVideOriginalRect;

            CGFloat fixelW = CGImageGetWidth(item.imageFrameView.image.CGImage);
            CGFloat fixelH = CGImageGetHeight(item.imageFrameView.image.CGImage);
            CGFloat w = item.frame.size.width;
            CGFloat h = item.frame.size.height;
            
            CGFloat uiwh = w/h;
            CGFloat imagewh = fixelW/fixelH;

            // 原框大小除去伸缩比
            CGFloat cropRectScal = videoRect.size.width/videoOriginalRect.size.width;// 视频视图显示大小除去原始大小得到伸缩比
            CGFloat cropRectX = fabs(videoRect.origin.x)/cropRectScal*2;
            CGFloat cropRectY = fabs(videoRect.origin.y)/cropRectScal*2;
            
            CGFloat cropRectW = 0.0;
            CGFloat cropRectH = 0.0;

            if (uiwh>imagewh){
                cropRectW = fixelW/cropRectScal;
                CGFloat radio = w / fixelW;
                cropRectH = item.frame.size.height/radio/cropRectScal;
            } else {
                cropRectH = fixelH/cropRectScal;
                CGFloat radio = h / fixelH;
                cropRectW = item.frame.size.width/radio/cropRectScal;

            }

            CGRect cropRect = CGRectMake(cropRectX, cropRectY, cropRectW, cropRectH);
            [cropViewFrames addObject:[NSValue valueWithCGRect:cropRect]];

        } else {
            CGRect rectOriginal = [self reductionRect:item.frame andSuperSize:superSize];
            rectOriginal.origin.y = fabs(superSizeOriginal.height - rectOriginal.origin.y - CGRectGetHeight(rectOriginal));
            [photoViewFrames addObject:[NSValue valueWithCGRect:rectOriginal]];
        }
    }
    [[PuzzleData sharedInstance] setFrames:frames];
    [[PuzzleData sharedInstance] setCropFramesArray:cropViewFrames];
    
    //设置背景颜色
    [[PuzzleData sharedInstance] setBgColor:self.tcePuzzleView.backgroundColor];
    
    // 获取相片视图
    [[PuzzleData sharedInstance] setPhotoViewArray:photoViewArray];
    [[PuzzleData sharedInstance] setPhotoViewFramesArray:photoViewFrames];
    
    // 合成
    [[ExportEffects sharedInstance] addEffectToVideo:assetVideoUrlArr];
}

/** 获取图片 */
- (UIImage *)getImage:(UIView *)view {
    //1.开启一个位图上下文
    CGSize size = CGSizeMake(view.layer.bounds.size.width, view.layer.bounds.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    //2.把画板上的内容渲染到上下文当中
    CGContextRef ctx =  UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    //3.从上下文当中取出一张图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    //4.关闭上下文
    UIGraphicsEndImageContext();

    return newImage;
}

- (CGRect)reductionRect:(CGRect)rect andSuperSize:(CGSize)superSize {
    CGRect rRect = CGRectZero;
    rRect.origin.x = rect.origin.x / self.tcePuzzleView.frame.size.width*superSize.width * 2;
    rRect.origin.y = rect.origin.y / self.tcePuzzleView.frame.size.height*superSize.height * 2;
    rRect.size.width = rect.size.width / self.tcePuzzleView.frame.size.width*superSize.width * 2;
    rRect.size.height = rect.size.height / self.tcePuzzleView.frame.size.height*superSize.height * 2;
    
    return rRect;
}

- (CGSize)sizeScaleWithSize:(CGSize)size scale:(CGFloat)scale {
    if (scale <= 0)
    {
        scale = 1.0f;
    }
    
    CGSize retSize = CGSizeZero;
    retSize.width = size.width/scale;
    retSize.height = size.height/scale;
    return  retSize;
}


@end
