//
//  BBBook.m
//  BlackBooks
//
//  Created by 冯超逸 on 15/2/27.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import "BBBook.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation BBBook

@dynamic bookname;
@dynamic author;
@dynamic originalprice;
@dynamic price;
@dynamic photo;
@dynamic situation;
@dynamic contact;
@dynamic story;
@dynamic bookOwnerName;

+(NSString *)parseClassName{
    return @"Book";
}



@end
