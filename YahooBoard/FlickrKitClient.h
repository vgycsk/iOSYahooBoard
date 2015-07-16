
//
//  FlickrKitClient.h
//  YahooBoard
//

#ifndef YahooBoard_FlickrKitClient_h
#define YahooBoard_FlickrKitClient_h

#import <FlickrKit.h>
#import <Foundation/Foundation.h>

@interface FlickrKitClient : NSObject

+ (FlickrKitClient *)sharedInstance;
- (FlickrKit *)flickrKit;
- (void) searchPhotoWithText:(NSString *)searchText page:(int)page pageCount:(int)pageCount sortBy:(NSString *)sortBy completion:(void (^)(NSArray *, NSError *))callback;

@end


#endif
