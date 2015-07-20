//
//  ImageCell.m
//  YahooBoard
//
//  Created by Shu-Yen Chang on 7/18/15.
//  Copyright (c) 2015 XXX. All rights reserved.
//

#import "ImageCell.h"
#import <UIImageView+AFNetworking.h>
#import "ImageCell.h"


@implementation ImageCell

- (void)awakeFromNib {
    // Initialization code
    // tap gesture
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickOnPicture:)];
    //[tapGestureRecognizer setNumberOfTouchesRequired:1];
    [tapGestureRecognizer setNumberOfTapsRequired:1];

    [self.image addGestureRecognizer:tapGestureRecognizer];
    self.image.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
}


- (void)setFlickr:(Flickr *)flickr{
    _flickr = flickr;
    [self.image setImageWithURL:self.flickr.photoUrl];
}


- (void)setTumblr:(Tumblr *)tumblr{
    _tumblr = tumblr;
    [self.image setImageWithURL: [NSURL URLWithString:self.tumblr.photoUrl]];
}

- (void)didClickOnPicture:(id)sender {
    
    if ([self.cellType isEqualToString:@"flickr"]) {
        [self.delegate imageCell:self didTapFlickrPhoto:self.flickr];
    } else {
        [self.delegate imageCell:self didTapTumblrPhoto:self.tumblr];
    }
}


@end
