//
//  PostersCollageSingeToolView.m
//  babyPhoto
//
//  Created by 彭新凯 on 2021/8/26.
//

#import "PostersCollageSingeToolView.h"

@implementation PostersCollageSingeToolView

- (void)awakeFromNib {
    [super awakeFromNib];
    NSArray *titles = @[@"滤镜",@"替换",@"旋转",@"放大",@"缩小"];
    [self.titlesLabelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lab = obj;
        lab.text = titles[idx];
    }];
}

- (IBAction)filterAction:(id)sender {
    if (self.postersCollageSingeToolBlock) {
        self.postersCollageSingeToolBlock(0);
    }
}

- (IBAction)changeAction:(id)sender {
    if (self.postersCollageSingeToolBlock) {
        self.postersCollageSingeToolBlock(1);
    }
}

- (IBAction)xuanzhuanAction:(id)sender {
    if (self.postersCollageSingeToolBlock) {
        self.postersCollageSingeToolBlock(2);
    }
}

- (IBAction)toBigAction:(id)sender {
    if (self.postersCollageSingeToolBlock) {
        self.postersCollageSingeToolBlock(3);
    }
}

- (IBAction)toSmallAction:(id)sender {
    if (self.postersCollageSingeToolBlock) {
        self.postersCollageSingeToolBlock(4);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
