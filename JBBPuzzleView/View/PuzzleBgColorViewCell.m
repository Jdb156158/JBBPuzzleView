//
//  PuzzleBgColorViewCell.m
//  JBBPuzzleView
//
//  Created by 9haomi on 2021/11/23.
//

#import "PuzzleBgColorViewCell.h"

@implementation PuzzleBgColorViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
}

-(void)setColorStr:(NSString *)colorStr{
    _colorStr = colorStr;
    self.backgroundColor = [UIColor colorWithHexString:_colorStr];
    self.layer.cornerRadius = self.frame.size.width/2;
}

-(void)setSelected:(BOOL)selected{
    if (selected) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
    }else{
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end
