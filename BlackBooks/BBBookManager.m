//
//  BBBookManager.m
//  BlackBooks
//
//  Created by 冯超逸 on 15/2/27.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import "BBBookManager.h"
#import "BBBook.h"

@implementation BBBookManager

-(BBBook*)getBookOfId:(NSString*)bookId{
    AVQuery *query = [AVQuery queryWithClassName:@"Book"];
    AVObject* result = nil;
    if ((result = [query getObjectWithId:bookId])){
        return (BBBook*)result;
    }else{
        return nil;
    }
}

+(NSArray *)getAllBooks{
    AVQuery *query = [AVQuery queryWithClassName:@"Book"];
    NSArray* result =[query findObjects];
    return result;
}

+(NSArray *)getBookOfUsername:(NSString*)username{
    AVQuery *query = [BBBook query];
    [query whereKey:@"bookOwnerName" equalTo:username];
    NSArray *result = [query findObjects];
    return result;
}


@end
