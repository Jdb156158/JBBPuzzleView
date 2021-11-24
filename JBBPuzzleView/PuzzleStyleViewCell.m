//
//  PuzzleStyleViewCell.m
//  JBBPuzzleView
//
//  Created by 9haomi on 2021/11/23.
//

#import "PuzzleStyleViewCell.h"

@implementation PuzzleStyleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDict:(NSDictionary *)dict{
    
    _dict = dict;
    
    if (self.selected) {
        self.styleImageView.image = [UIImage imageNamed:_dict[@"selectimage"]];
    }else{
        self.styleImageView.image = [UIImage imageNamed:_dict[@"default"]];
    }
    
}

- (void)setSelected:(BOOL)selected{
    if (selected) {
        self.styleImageView.image = [UIImage imageNamed:_dict[@"selectimage"]];
    }else{
        self.styleImageView.image = [UIImage imageNamed:_dict[@"default"]];
    }
}

@end
