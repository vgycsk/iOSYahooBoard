//
//  TumblrClient.m
//  YahooBoard
//
//  Created by Yi-De Lin on 7/17/15.
//  Copyright (c) 2015 XXX. All rights reserved.
//

#import "TumblrClient.h"

@implementation TumblrClient

NSString * const kTumblrConsumerKey = @"BRMEWFUj0PKayqLE6gFLmmfTZ4QWNLhJyezG64R6ja395ePLdY";
NSString * const kTumblrConsumerSecret = @"UjL8RZmVzlXwxFcQiYlW94wNzos0RPClStTzy24cK23nzwcit8";
NSString * const kTumblrBaseAuthUrl = @"http://www.tumblr.com";
NSString * const kTumblrBaseAPIUrl = @"http://api.tumblr.com";

+ (TumblrClient *)sharedInstanceForType:(NSString *)type {
    static TumblrClient *authInstance = nil;
    static TumblrClient *apiInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (authInstance == nil) {
            authInstance = [[TumblrClient alloc] initWithBaseURL:[NSURL URLWithString:kTumblrBaseAuthUrl] consumerKey:kTumblrConsumerKey consumerSecret:kTumblrConsumerSecret];
        }
        if (apiInstance == nil) {
            apiInstance = [[TumblrClient alloc] initWithBaseURL:[NSURL URLWithString:kTumblrBaseAPIUrl] consumerKey:kTumblrConsumerKey consumerSecret:kTumblrConsumerSecret];
        }
    });
    if ([type isEqualToString:@"auth"]) {
        return authInstance;
    } else {
        return apiInstance;
    }
};


+ (TumblrClient *)sharedInstance {
    return [TumblrClient sharedInstanceForType:@"api"];
};

- (void)loginWithCompletion:(void (^)(Tumblr *user, NSError *error))completion {
    self.loginCompletion = completion;
    [self.requestSerializer removeAccessToken];
    [[TumblrClient sharedInstanceForType:@"api"].requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"idlycyme://oauth"] scope:nil success:^(BDBOAuth1Credential *request_token) {
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.tumblr.com/oauth/authorize?oauth_token=%@", request_token.token]];
        [[UIApplication sharedApplication] openURL:authURL];
    } failure:^(NSError *error) {
        NSLog(@"[ERROR] Failed with token retreival %@", error);
        self.loginCompletion(nil, error);
    }];
}

- (void)openURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        [[TumblrClient sharedInstanceForType:@"api"].requestSerializer saveAccessToken:accessToken];
        self.loginCompletion(nil, nil);
    } failure:^(NSError *error) {
        NSLog(@"[ERROR] Failed with token access %@", error);
        self.loginCompletion(nil, error);
    }];
}

- (void) searchPostWithTag:(NSString *)tag limit:(int)limit before:(int)timestamp completion:(void (^)(NSArray *, NSError *))callback{
    NSString *url = [NSString stringWithFormat:@"v2/tagged?tag=%@&api_key=%@", tag, kTumblrConsumerKey];
    [self GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        NSLog(@"response %@", responseObject);
        callback(nil, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[ERROR] tag posts retrieval failed");
        callback(nil, error);
    }];
}



@end
