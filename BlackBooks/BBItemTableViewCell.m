//
//  BBItemTableViewCell.m
//  BlackBooks
//
//  Created by 冯超逸 on 15/3/9.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import "BBItemTableViewCell.h"

@implementation BBItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)showImage:(id)sender{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
