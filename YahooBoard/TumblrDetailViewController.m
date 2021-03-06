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
    
    [self displayTumblrPostDetail:self.tumblr];
    [self setTumblrButton];
    
    [self.image.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.image.layer setBorderWidth:4.0f];
    [self.image.layer setCornerRadius:5.0f];
     
    [self.descScrollView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.descScrollView.layer setBorderWidth:1.0f];
    [self.descScrollView.layer setCornerRadius:5.0f];
    self.tags.text = self.tumblr.tags[0];;
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)setTumblr:(Tumblr *)tumblr{
    _tumblr = tumblr;
    [self.image setImageWithURL: [NSURL URLWithString:self.tumblr.photoUrl]];
    self.author.text = self.tumblr.blogName;
    self.desc.text = [self stringByStrippingHTML:self.tumblr.caption];
    self.tags.text = self.tumblr.tags[0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.desc sizeToFit];
        //self.desc.preferredMaxLayoutWidth = self.desc.bounds.size.width;
        [self.descScrollView setContentSize:self.desc.frame.size];
    });
}


-(NSString *)stringByStrippingHTML:(NSString*)str
{
    NSRange r;
    while ((r = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location     != NSNotFound)
    {
        str = [str stringByReplacingCharactersInRange:r withString:@""];
    }
    return str;
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
    self.desc.text = [self stringByStrippingHTML:self.tumblr.caption];
    self.tags.text = [post.tags componentsJoinedByString:@", "];
    [self setImageWithTumblr:post];
}

- (void)setImageWithTumblr:(Tumblr *)data {
    NSURL *imageUrl = [NSURL URLWithString:data.photoUrl];
    NSLog(@"image url is %@", data.photoUrl);
    [self.image setImageWithURL:imageUrl];
}

- (IBAction)onTumblrIcon:(id)sender {
    NSURL *url = [NSURL URLWithString:self.tumblr.rawUrl];
    [[UIApplication sharedApplication] openURL:url];
}

-(void) onTumblrBar{
    NSURL *url = [NSURL URLWithString:self.tumblr.rawUrl];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)setTumblrButton{
    UIImage *tumblrImage = [UIImage imageNamed:@"tumblr.png"];
    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    face.bounds = CGRectMake( 0, 0, 40, 40 );
    //[face setImage:tumblrImage forState:UIControlStateNormal];
    [face setBackgroundImage:tumblrImage forState:UIControlStateNormal];
    [face addTarget:self action:@selector(onTumblrBar) forControlEvents:UIControlEventTouchUpInside];
    [face.layer setBorderColor:[UIColor whiteColor].CGColor];
    [face.layer setBorderWidth:1.0f];
    [face.layer setCornerRadius:5.0f];
    
    UIBarButtonItem *tumblrBtn = [[UIBarButtonItem alloc] initWithCustomView:face];
    self.navigationItem.rightBarButtonItem = tumblrBtn;
    
}

@end
