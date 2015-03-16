//
//  BBBook.h
//  BlackBooks
//
//  Created by 冯超逸 on 15/2/27.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

@interface BBBook : AVObject<AVSubclassing>

@property (nonatomic, copy) NSString *bookname;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, assign) int originalprice;
@property (nonatomic, assign) int price;
@property (nonatomic, strong) AVFile *photo;
@property (nonatomic, copy) NSString *situation;
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *story;
@property (nonatomic, copy) NSString *bookOwnerName;

//-(void)saveBook;

@end
