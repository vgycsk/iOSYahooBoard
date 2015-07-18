//
//  TumblrClient.h
//  YahooBoard
//
//  Created by Yi-De Lin on 7/17/15.
//  Copyright (c) 2015 XXX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDBOAuth1RequestOperationManager.h"
#import "Tumblr.h"

@interface TumblrClient : BDBOAuth1RequestOperationManager

@property (nonatomic, strong) void (^loginCompletion)(Tumblr *tumblr, NSError *error);

+ (TumblrClient *)sharedInstance;
+ (TumblrClient *)sharedInstanceForType:(NSString *)type;
- (void)loginWithCompletion:(void (^)(Tumblr *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;
- (void) searchPostWithTag:(NSString *)tag limit:(int)limit before:(int)timestamp completion:(void (^)(NSArray *, NSError *))callback;
@end
