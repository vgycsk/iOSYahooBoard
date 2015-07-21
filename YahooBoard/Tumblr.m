//
//  Tumblr.m
//  YahooBoard
//
//  Created by Shu-Yen Chang on 7/18/15.
//  Copyright (c) 2015 XXX. All rights reserved.
//

#import "Tumblr.h"

@implementation Tumblr

- (Tumblr *) initWithDictionary:(NSDictionary *)dictionary{
    self.blogName = dictionary[@"blog_name"];
    self.caption = dictionary[@"caption"];
    self.timestamp = [dictionary[@"timestamp"] doubleValue];
    self.type = dictionary[@"type"];
    self.rawData = dictionary;
    self.photos = dictionary[@"photos"];
    self.photoUrl = dictionary[@"photos"][0][@"alt_sizes"][2][@"url"];
    self.tags = dictionary[@"tags"];
    self.rawUrl = dictionary[@"post_url"];
    //NSLog(@"photo is %@ %@", self.photoUrl, self.photos);
    return self;
}

+ (NSArray *) tumblrsWithArrayFromRawResponse:responseObject filtredByType:(NSString *)type{
    if (responseObject[@"response"]) {
        NSMutableArray *arrays = [[NSMutableArray alloc] init];
        for (NSDictionary *object in responseObject[@"response"]) {
            if ((type && [type isEqualToString:object[@"type"]]) ||
                (type == nil)
                ) {
                [arrays addObject:[[Tumblr alloc] initWithDictionary:object]];
            }
        }
        return arrays;
    } else {
        return nil;
    }
}

+ (NSArray *) tumblrsWithArrayFromRawResponse:responseObject{
    return [self tumblrsWithArrayFromRawResponse:responseObject filtredByType:nil];
}


@end