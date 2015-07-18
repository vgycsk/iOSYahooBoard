//
//  ImageCell.m
//  YahooBoard
//
//  Created by Shu-Yen Chang on 7/18/15.
//  Copyright (c) 2015 XXX. All rights reserved.
//

#import "ImageCell.h"
#import <UIImageView+AFNetworking.h>

@implementation ImageCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setFlickr:(Flickr *)flickr{
    _flickr = flickr;
    [self.image setImageWithURL:self.flickr.photoUrl];
}


- (void)setTumblr:(Tumblr *)tumblr{
    _tumblr = tumblr;
    [self.image setImageWithURL: [NSURL URLWithString:self.tumblr.photoUrl]];
}
@end
