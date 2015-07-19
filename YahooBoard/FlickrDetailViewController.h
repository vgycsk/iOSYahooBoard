//
//  FlickrDetailViewController.h
//  YahooBoard
//
//  Created by Yi-De Lin on 7/16/15.
//  Copyright (c) 2015 XXX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrKitClient.h"
#import "Flickr.h"

@interface FlickrDetailViewController : UIViewController



@property (weak, nonatomic) IBOutlet UILabel *flickrTitle;
@property (weak, nonatomic) IBOutlet UIImageView *flickrImageView;
@property (weak, nonatomic) Flickr *flickr;

@end
