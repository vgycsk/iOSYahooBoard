//
//  ImageCell.h
//  YahooBoard
//
//  Created by Shu-Yen Chang on 7/18/15.
//  Copyright (c) 2015 XXX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flickr.h"
#import "Tumblr.h"
#import "Flickr.h"


@class ImageCell;

@protocol ImageCellDelegate <NSObject>
-(void)imageCell:(ImageCell *)imageCell didTapFlickrPhoto:(Flickr *)flickr;
-(void)imageCell:(ImageCell *)imageCell didTapTumblrPhoto:(Tumblr *)tumblr;

@end

@interface ImageCell : UICollectionViewCell

@property (weak, nonatomic) Flickr *flickr;
@property (weak, nonatomic) Tumblr *tumblr;
@property (weak, nonatomic) IBOutlet UILabel *icon;
@property (weak, nonatomic) IBOutlet UIImageView *image;


@property (nonatomic, weak) id<ImageCellDelegate> delegate;

@end
