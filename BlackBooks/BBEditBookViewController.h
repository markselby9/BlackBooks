//
//  BBEditBookViewController.h
//  BlackBooks
//
//  Created by 冯超逸 on 15/3/2.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLFormViewController.h"
#import "BBBook.h"

@interface BBEditBookViewController : XLFormViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(nonatomic) BBBook* book;

@end
