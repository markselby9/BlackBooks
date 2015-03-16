//
//  BBUserStatus.m
//  BlackBooks
//
//  Created by 冯超逸 on 15/3/8.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import "BBUserStatus.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation BBUserStatus

#pragma mark -
+(BOOL)isUserLoggedIn{
    AVUser *user = [AVUser currentUser];
    if (user){
        return YES;
    }else{
        return NO;
    }
}

@end
