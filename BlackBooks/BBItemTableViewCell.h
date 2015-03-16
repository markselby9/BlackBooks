//
//  BBItemTableViewCell.h
//  BlackBooks
//
//  Created by 冯超逸 on 15/3/9.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *BigLabel;
@property (weak, nonatomic) IBOutlet UILabel *smallLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (copy, nonatomic) void (^actionBlock)(void);

@end
