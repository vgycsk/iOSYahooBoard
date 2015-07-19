//
//  NewsClient.h
//  YahooBoard
//
//  Created by Curtis Kang on 7/16/15.
//  Copyright (c) 2015 XXX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsClient : NSObject
- (void) queryNewsWithParameter:(NSString *)searchWord category:(NSString *)category sortBy:(NSString *)sortBy completion:(void (^)(NSArray *newsArray, NSError *error))callback;
- (void) queryNews:(NSString *)queryString;
+ (NewsClient *)sharedInstance;
@property (strong, nonatomic) NSMutableArray *newsList;
@end
