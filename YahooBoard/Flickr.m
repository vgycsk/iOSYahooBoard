//
//  Flickr.m
//  YahooBoard
//

#import "Flickr.h"

@implementation Flickr

- (id) initWithDictionary:(NSDictionary *)dictionary potoUrl:(NSURL *)photoUrl {
    //NSLog(@"%@",dictionary);
    self.rawPhotoInfo = dictionary;
    self.title = dictionary[@"title"];
    self.author = dictionary[@"owner"];
    
    if (photoUrl) {
        self.photoUrl = photoUrl;
    }
    
    return self;
}



@end
