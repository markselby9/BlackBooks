//
//  BBBookManager.h
//  BlackBooks
//
//  Created by 冯超逸 on 15/2/27.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
@interface BBBookManager : NSObject

+(NSArray*)getAllBooks;
+(NSArray *)getBookOfUsername:(NSString*)username;

@end
