//
//  News.m
//  YahooBoard
//
//  Created by Curtis Kang on 7/16/15.
//  Copyright (c) 2015 XXX. All rights reserved.
//
#import "News.h"

@implementation News
- (id)initWithDictionary:(NSDictionary *)itemDict {
    self = [ super self];
    //NSMutableArray *newsList =[[ NSMutableArray alloc] init];
    if (self)
    {
            
            self.headline = [ itemDict valueForKey:@"abstract" ];
            self.content = [ itemDict valueForKey:@"snippet" ];
            self.pubDate = [ itemDict valueForKey:@"pub_date" ];
            if ( [[ itemDict valueForKeyPath:@"multimedia.url"] count] > 0)
            {
              NSString *thumbWide = [ itemDict valueForKeyPath:@"multimedia.url"][0];
              self.thumbWideImageUrl = [[ NSString alloc] initWithFormat:@"http://www.nytimes.com/%@",thumbWide];
            }
            self.keywordDict = [ itemDict valueForKeyPath:@"keywords.value" ];
          }
    return self;
}
+ (NSArray *)newsWithArray:(NSDictionary *)array {
    NSMutableArray *news =[ NSMutableArray array];
    
    for(NSDictionary *dictionary in array) {
        [news addObject:[[News alloc] initWithDictionary:dictionary]];
    }
    return news;
}
@end
