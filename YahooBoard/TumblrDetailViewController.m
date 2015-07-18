//
//  TumblrDetailViewController.m
//  YahooBoard
//
//  Created by Yi-De Lin on 7/17/15.
//  Copyright (c) 2015 XXX. All rights reserved.
//

#import "TumblrDetailViewController.h"
#import "TumblrClient.h"

@implementation TumblrDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    double timestamp =[[NSDate date] timeIntervalSince1970] * 1000;
    [[TumblrClient sharedInstance] searchPostWithTag:@"nba" limit:20 before:timestamp completion:^(NSArray *data, NSError *error) {
        if (data) {
            
        }
    }];
    // Do any additional setup after loading the view, typically from a nib.
}



- (void)setImage:(NSArray *)data {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
