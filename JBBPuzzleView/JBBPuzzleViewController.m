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
@property (weak, nonatomic) IBOutlet UICollectionView *myModelCountCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *myColorCollectionView;
@property (weak, nonatomic) IBOutlet UISlider *borderPxSlider;
@property (weak, nonatomic) IBOutlet UIButton *Scale1bi1Btn;
@property (weak, nonatomic) IBOutlet UIButton *Scale16bi9Btn;
@property (weak, nonatomic) IBOutlet UIButton *Scale9bi16Btn;
@property (nonatomic, strong) TcePuzzlePuzzleView *tcePuzzleView;
@property (nonatomic, strong) NSMutableArray *modelCountImages;
@property (nonatomic, strong) NSMutableArray *colorsArray;

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
        @"#FFFFFF",@"#2B2B2B",@"#FA5150",@"#FEC200",@"#07C160",@"#10ADFF",@"#6467EF",@"#FF0000",@"#FF4500",@"#FFD700",@"#40E0D0",@"#4682B4",@"#6495ED",@"#483D8B",@"#9400D3",
        @"#8B008B",@"#C71585",@"#FF1493",@"#DC143C",@"#FFB6C1",@"#4B0082"
    ]];
        
    [self initColorCollectionView];
    
    [self initPuzzleSytleCollectionView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //默认选中第一行
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.myModelCountCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.myModelCountCollectionView didSelectItemAtIndexPath:indexPath];
        
        
    });
    
    [self updateBiliBtnStatus:0];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.tcePuzzleView.manage) {
            [self.tcePuzzleView updatePlayVideoDXLINVManageView];
        }
    });
    
}

//从后台进前台记得也要重新播放

- (void)initColorCollectionView{
    UICollectionViewFlowLayout *configLayout = [[UICollectionViewFlowLayout alloc]init];
    configLayout.itemSize = CGSizeMake(60, 30);
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
    configLayout.itemSize = CGSizeMake(60, 60);
    configLayout.minimumLineSpacing = 10 ;
    configLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _myModelCountCollectionView.collectionViewLayout = configLayout;
    _myModelCountCollectionView.backgroundColor = [UIColor clearColor];
    _myModelCountCollectionView.delegate = self;
    _myModelCountCollectionView.dataSource = self;
    _myModelCountCollectionView.allowsMultipleSelection = NO;
    _myModelCountCollectionView.showsHorizontalScrollIndicator = NO;
    [_myModelCountCollectionView registerNib:[UINib nibWithNibName:@"PuzzleStyleViewCell" bundle:nil] forCellWithReuseIdentifier:@"PuzzleStyleViewCell"];
    _myModelCountCollectionView.tag = 2;
}

- (TcePuzzlePuzzleView *)tcePuzzleView
{
    if (!_tcePuzzleView){
        _tcePuzzleView = [[TcePuzzlePuzzleView alloc] initWithFrame:CGRectMake(0, 0, self.canvasBgView.frame.size.width, self.canvasBgView.frame.size.height)];
        _tcePuzzleView.backgroundColor = [UIColor whiteColor];
        _tcePuzzleView.grpValue = 5;
        [self.canvasBgView addSubview:_tcePuzzleView];
    }
    return _tcePuzzleView;
}


#pragma mark -- -- -- -- -- - UICollectView Delegate & DataSource - -- -- -- -- --

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == 1) {
        return self.colorsArray.count;
    }else{
        return self.modelCountImages.count;
    }
   
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 1) {
        PuzzleBgColorViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PuzzleBgColorViewCell" forIndexPath:indexPath];
        NSString *colorName = self.colorsArray[indexPath.item];
        [cell setColorStr:colorName];
        return cell;
    }else{
        PuzzleStyleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PuzzleStyleViewCell" forIndexPath:indexPath];
        NSDictionary *dict = self.modelCountImages[indexPath.item];
        cell.dict = dict;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1) {
        NSString *colorName = self.colorsArray[indexPath.item];
        _tcePuzzleView.backgroundColor = [UIColor colorWithHexString:colorName];
    }else{
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


#pragma mark - 比例调整

- (IBAction)clickScale1bi1Btn:(id)sender {
    
    _tcePuzzleView.frame = CGRectMake(0, 0, self.canvasBgView.frame.size.width, self.canvasBgView.frame.size.height);
    
    
    // 重载界面
    [self.tcePuzzleView setTcePuzzleStyleIndex:self.puzzleStyleIndex];
    [self.tcePuzzleView setTcePuzzleStyleRow:self.puzzleStyleRow];
    
    [self updateBiliBtnStatus:0];
}

- (IBAction)clickScale16bi9Btn:(id)sender {
    
    _tcePuzzleView.frame = CGRectMake(0, self.canvasBgView.frame.size.height/2-(self.canvasBgView.frame.size.width*9/16)/2, self.canvasBgView.frame.size.width, self.canvasBgView.frame.size.width*9/16);
    
    
    // 重载界面
    [self.tcePuzzleView setTcePuzzleStyleIndex:self.puzzleStyleIndex];
    [self.tcePuzzleView setTcePuzzleStyleRow:self.puzzleStyleRow];
    
    [self updateBiliBtnStatus:1];
}

- (IBAction)clickScale9bi16Btn:(id)sender {
    
    _tcePuzzleView.frame = CGRectMake(self.canvasBgView.frame.size.width/2-(self.canvasBgView.frame.size.height*9/16)/2, 0, self.canvasBgView.frame.size.height*9/16, self.canvasBgView.frame.size.height);
    
    
    // 重载界面
    [self.tcePuzzleView setTcePuzzleStyleIndex:self.puzzleStyleIndex];
    [self.tcePuzzleView setTcePuzzleStyleRow:self.puzzleStyleRow];
    
    [self updateBiliBtnStatus:2];
        
}

- (void)updateBiliBtnStatus:(NSInteger)index{
    
    self.Scale1bi1Btn.layer.borderWidth = index==0?1:0;
    self.Scale1bi1Btn.layer.borderColor = index==0?[UIColor whiteColor].CGColor:[UIColor clearColor].CGColor;
    
    self.Scale16bi9Btn.layer.borderWidth = index==1?1:0;
    self.Scale16bi9Btn.layer.borderColor = index==1?[UIColor whiteColor].CGColor:[UIColor clearColor].CGColor;
    
    self.Scale9bi16Btn.layer.borderWidth = index==2?1:0;
    self.Scale9bi16Btn.layer.borderColor = index==2?[UIColor whiteColor].CGColor:[UIColor clearColor].CGColor;
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
    CGSize superSizeOriginal = CGSizeMake(960, 960);
    CGSize superSize = CGSizeMake(960, 960);
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
            CGFloat cropRectX = fabs(videoRect.origin.x)/cropRectScal*1.5;
            CGFloat cropRectY = fabs(videoRect.origin.y)/cropRectScal*1.5;
            
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
