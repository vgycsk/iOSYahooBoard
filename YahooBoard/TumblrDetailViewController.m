//
//  TumblrDetailViewController.m
//  YahooBoard
//
//  Created by Yi-De Lin on 7/17/15.
//  Copyright (c) 2015 XXX. All rights reserved.
//

#import "TumblrDetailViewController.h"
#import "TumblrClient.h"
#import <UIImageView+AFNetworking.h>

@implementation TumblrDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    NSString *tag = @"nba";
    [self getSearchedPostWithTag:tag];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)setTumblr:(Tumblr *)tumblr{
    _tumblr = tumblr;
    [self.image setImageWithURL: [NSURL URLWithString:self.tumblr.photoUrl]];
    self.author.text = self.tumblr.blogName;
    self.desc.text = self.tumblr.caption;
    self.tags = self.tumblr.tags;
}

- (void)getSearchedPostWithTag:(NSString *)tag {
    double timestamp =[[NSDate date] timeIntervalSince1970] * 1000;
    [[TumblrClient sharedInstance] searchPostWithTag:tag limit:20 before:timestamp type:@"photo" completion:^(NSArray *data, NSError *error) {
        if ([data count]) {
            //NSLog(@"data %@", data);
            [self displayTumblrPostDetail:data[0]];
        } else {
            NSLog(@"[WARNING] No tumblr posts with tag %@ found", tag);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayTumblrPostDetail:(Tumblr *)post {
    self.author.text = post.blogName;
    self.desc.text = post.caption;
    self.tags.text = [post.tags componentsJoinedByString:@", "];
    [self setImageWithTumblr:post];
}

- (void)setImageWithTumblr:(Tumblr *)data {
    NSURL *imageUrl = [NSURL URLWithString:data.photoUrl];
    NSLog(@"image url is %@", data.photoUrl);
    [self.image setImageWithURL:imageUrl];
}

@end
