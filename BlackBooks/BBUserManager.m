//
//  BBUserManager.m
//  BlackBooks
//
//  Created by 冯超逸 on 15/3/2.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import "BBUserManager.h"

@implementation BBUserManager

+(AVUser*)findUserByName:(NSString *)name{
    AVQuery * query = [AVUser query];
    AVUser *result = nil;
    [query whereKey:@"username" equalTo:name];
    NSArray* results = [query findObjects];
    result = [results objectAtIndex:0];
    return result;
}
@end
