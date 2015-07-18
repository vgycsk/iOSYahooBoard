//
//  Flickr.h
//  YahooBoard
//

#import <Foundation/Foundation.h>

@interface Flickr : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSURL *photoUrl;
@property (nonatomic, strong) NSDictionary *rawPhotoInfo;

- (id) initWithDictionary:(NSDictionary *)dictionary potoUrl:(NSURL *)photoUrl;

@end