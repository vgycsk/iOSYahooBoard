//
//  Tumblr.h
//  YahooBoard
//
//  Created by Shu-Yen Chang on 7/18/15.
//  Copyright (c) 2015 XXX. All rights reserved.
//

#ifndef YahooBoard_Tumblr_h
#define YahooBoard_Tumblr_h

#import <Foundation/Foundation.h>
@interface Tumblr: NSObject

@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *blogName;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSDictionary *rawData;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, strong) NSString *rawUrl;
@property double timestamp;

- (Tumblr *) initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *) tumblrsWithArrayFromRawResponse:responseObject;
+ (NSArray *) tumblrsWithArrayFromRawResponse:responseObject filtredByType:(NSString *)type;

@end

#endif
