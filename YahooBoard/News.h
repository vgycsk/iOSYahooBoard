//
//  News.h
//  YahooBoard
//
//  Created by Curtis Kang on 7/16/15.
//  Copyright (c) 2015 XXX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject
@property (nonatomic, strong) NSString *headline;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *pubDate;
@property (nonatomic, strong) NSString *thumbWideImageUrl;
@property (nonatomic, strong) NSDictionary *keywordDict;

- (id)initWithDictionary:(NSDictionary *)dictionary ;
+ (NSArray *)newsWithArray:(NSArray *)array;
@end
