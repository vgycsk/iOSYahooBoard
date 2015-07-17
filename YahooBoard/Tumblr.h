//
//  Tumblr.h
//  YahooBoard
//
//  Created by Shu-Yen Chang on 7/15/15.
//  Copyright (c) 2015 XXX. All rights reserved.
//

#ifndef YahooBoard_Tumblr_h
#define YahooBoard_Tumblr_h

#import <Foundation/Foundation.h>
@interface Tumblr: NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSURL *photoUrl;
@property (nonatomic, strong) NSDictionary *rawData;

- (id) initWithDictionary:(NSDictionary *)dictionary;

@end

#endif
