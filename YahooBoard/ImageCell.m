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
    CGRect oframe = self.frame;
    UICollectionView *superView = (UICollectionView *)self.superview;
    CGRect vframe = superView.bounds;
    CGRect nframeCell = CGRectMake(0, vframe.origin.y-80, self.window.frame.size.width, self.window.frame.size.height + 80);
    CGRect nframeImage = CGRectMake(0, 0, nframeCell.size.width, nframeCell.size.height);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.image.frame = nframeImage;
        [self.superview bringSubviewToFront:self];
        [UIView animateWithDuration:1 animations:^{
            self.frame = nframeCell;
        } completion:^(BOOL finished){
            if ([self.cellType isEqualToString:@"flickr"]) {
                [self.delegate imageCell:self didTapFlickrPhoto:self.flickr];
            } else {
                [self.delegate imageCell:self didTapTumblrPhoto:self.tumblr];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                self.frame = oframe;
                self.image.frame = oframe;;
            });
            
        }
        ];
    });

}


@end
