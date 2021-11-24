//
//  TceEditImageView.m
//  JBBPuzzleView
//
//  Created by 9haomi on 2021/11/24.
//

#import "TceEditImageView.h"

@interface TceEditImageView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *addView;

@end

@implementation TceEditImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //初始化
        [self initView];
    }
    return self;
}


- (void)initView{
    
    //添加单击手势
    UITapGestureRecognizer * TapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
    TapRecognizer.numberOfTapsRequired = 1;
    TapRecognizer.delegate = self;
    
    [self addGestureRecognizer:TapRecognizer];
    
    //默认加号
    self.addView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-30/2, self.frame.size.height/2-30/2, 30, 30)];
    self.addView.image = [UIImage imageNamed:@"编辑加"];
    [self addSubview:self.addView];
    
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.addView.frame = CGRectMake(self.frame.size.width/2-30/2, self.frame.size.height/2-30/2, 30, 30);
    
}

- (void)setIsSelect:(bool)isSelect{
    _isSelect = isSelect;
}

- (void)gestureTap:(UITapGestureRecognizer *)sender
{
    NSLog(@"====点击了VIEW====");
    
    if ([self.editDelegate respondsToSelector:@selector(TcePuzzleTapWithEditView:)])
    {
        [self.editDelegate TcePuzzleTapWithEditView:self];
    }
    
}
@end
