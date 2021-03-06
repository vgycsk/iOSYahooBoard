//
//  NewsClient.m
//  YahooBoard
//
//  Created by Curtis Kang on 7/16/15.
//  Copyright (c) 2015 XXX. All rights reserved.
//

#import "NewsClient.h"

@interface NewsClient()

@end

// Do any additional setup after loading the view, typically from a nib.
NSString * const newsAPIKey = @"cc3843cff28b61c871478239b3bcab64:13:72500886";
NSString * const newAPIBaseUrl = @"http://api.nytimes.com/svc/search/v2/articlesearch.json";
NSString * const imageBaseUrl = @"http://www.nytimes.com/";

@implementation NewsClient
+ (NewsClient *)sharedInstance {
    static NewsClient *sharedInstance = nil;
    static dispatch_once_t initializer;
    
    dispatch_once(&initializer, ^{
        sharedInstance = [[NewsClient alloc] init];
    });
    return sharedInstance;
}

/*
  searchWord: search text
  category: Food, Style, Sports, World, Politics, Tech, Business, Opinion, Science, Health, Arts,Travel, Magazine
  sortBy: newest, oldest
*/

- (void) queryNewsWithParameter:(NSString *)searchWord category:(NSString *)category sortBy:(NSString *)sortBy completion:(void (^)(NSArray *newsArray, NSError *error))callback
{
    NSArray *categoryList = [NSArray arrayWithObjects:@"\"Food\"", @"\"Sports\"", @"\"Style\"", @"\"World\"", @"\"Politics\"", @"\"Tech\"", @"\"Business\"", @"\"Opinion\"", @"\"Science\"", @"\"Health\"", @"\"Arts\"",@"\"Travel\"", @"\"Magazine\"",nil];
    
    NSMutableString *queryString = [[NSMutableString alloc] init];
    if ( [searchWord isEqualToString:@""] || searchWord == NULL)
    {
        [ queryString appendFormat:@""];
    }
    else
    {
        [ queryString appendFormat:@"q=%@&",searchWord ];
    }
    if ( [categoryList containsObject:category] )
    {
        [ queryString appendFormat:@"fq=news_desk:(\"%@\")&",category ];
    }
    else
    {
        [ queryString appendFormat:@"&"];
        
    }
    if ( [sortBy isEqualToString:@""] )
    {
        [ queryString appendFormat:@"&"];
   
    }
    else
    {
        [ queryString appendFormat:@"sort=%@", sortBy];
    }
    
                   
    NSString *apiRawUrlString = [[NSString alloc] initWithFormat:@"%@?%@&api-key=%@",newAPIBaseUrl,queryString,newsAPIKey];
     NSLog(@"DEBUG %@,%@,%@",searchWord,category,sortBy);
    NSLog(@"DEBUG %@",apiRawUrlString);
    NSString *apiUrlString = [apiRawUrlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    dispatch_queue_t concurrentQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
   
    dispatch_async(concurrentQueue, ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:apiUrlString]];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError != NULL) {
                callback(nil, connectionError);
            }
            else {
                
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
               
                NSArray *argsArray = [[NSArray alloc] initWithArray:[dict valueForKeyPath:@"response.docs"]];
                NSArray *newsArray = [[NSArray alloc] initWithArray:[News newsWithArray:argsArray]];
                callback(newsArray, connectionError);
            };
        }];
        
        // 4) Present picker in main thread
        dispatch_async(dispatch_get_main_queue(), ^{
           // NSLog(@"debug 5%@", self.newsArray);
            //return nil;
            
        });
        
    });
    
    
    
}


@end
