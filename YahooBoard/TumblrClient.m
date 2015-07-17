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

+ (TumblrClient *)sharedAuthInstance {
    static TumblrClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TumblrClient alloc] initWithBaseURL:[NSURL URLWithString:kTumblrBaseAuthUrl] consumerKey:kTumblrConsumerKey consumerSecret:kTumblrConsumerSecret];
        }
    });
    //NSLog(@"ins %@", instance);
    return instance;
};


+ (TumblrClient *)sharedInstance {
    static TumblrClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TumblrClient alloc] initWithBaseURL:[NSURL URLWithString:kTumblrBaseAPIUrl] consumerKey:kTumblrConsumerKey consumerSecret:kTumblrConsumerSecret];
        }
    });
    //NSLog(@"ins %@", instance);
    return instance;
};

- (void)loginWithCompletion:(void (^)(Tumblr *user, NSError *error))completion {
    self.loginCompletion = completion;
    [[TumblrClient sharedInstance].requestSerializer removeAccessToken];
    [[TumblrClient sharedAuthInstance] fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"idlycyme2://oauth"] scope:nil success:^(BDBOAuth1Credential *request_token) {
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.tumblr.com/oauth/authorize?oauth_token=%@", request_token.token]];
        [[UIApplication sharedApplication] openURL:authURL];
    } failure:^(NSError *error) {
        NSLog(@"[ERROR] Failed with token retreival %@", error);
        self.loginCompletion(nil, error);
    }];
}

- (void)openURL:(NSURL *)url {
    BDBOAuth1Credential *c = [BDBOAuth1Credential credentialWithQueryString:url.query];
    NSLog(@"adsfdafadsf %@ %@", url.query, c);
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"aaa %@", accessToken);
        
        [[TumblrClient sharedInstance].requestSerializer saveAccessToken:accessToken];
        [[TumblrClient sharedInstance] GET:@"v2/user/info" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            //User *user = [[User alloc] initWithDictionary:responseObject];
            //NSLog(@"current user %@", responseObject);
            //self.loginCompletion(user, nil);
            NSLog(@"aaa  aaa %@", responseObject);
            //[User setCurrentUser:user];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"[ERROR] Failed with credential verification %@", error);
            self.loginCompletion(nil, error);
        }];
    } failure:^(NSError *error) {
        NSLog(@"[ERROR] Failed with token access %@", error);
    }];
}


@end
