//
//  FlickrDetailViewController.m
//  YahooBoard
//

#import "FlickrDetailViewController.h"
#import <UIImageView+AFNetworking.h>

@interface FlickrDetailViewController ()

@property (retain, nonatomic) NSArray *photoData;
@property (nonatomic) int pageCount;

@end

@implementation FlickrDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.flickrImageView setImageWithURL:self.flickr.photoUrl];
    self.flickrTitle.text = self.flickr.title;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFlickr:(Flickr *)flickr{
    _flickr = flickr;

}

- (void)loadImages {
    NSString *searchText = @"moon";
    FlickrKitClient *client = [FlickrKitClient sharedInstance];
    [client searchPhotoWithText:searchText page:10 pageCount:10 sortBy:@"relevance" completion:^(NSArray *data, NSError *error) {
        if (data) {
            [self setImage:data];
        }
    }];
}

- (void)setImage:(NSArray *)data {
    Flickr *flickrObj = data[0];
    NSLog(@"%@", flickrObj.title);
    [self.flickrImageView setImageWithURL:flickrObj.photoUrl];
}



@end
