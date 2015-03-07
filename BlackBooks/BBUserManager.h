//
//  BBUserManager.h
//  BlackBooks
//
//  Created by 冯超逸 on 15/3/2.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

@interface BBUserManager : NSObject

+(AVUser*)findUserByName:(NSString*)name;

@end
