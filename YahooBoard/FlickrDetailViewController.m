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
    [self.flickrImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.flickrImageView.layer setBorderWidth:2.0f];
    self.flickrTitle.text = self.flickr.title;
    [self.flickrImageView setImageWithURL:self.flickr.photoUrl];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFlickr:(Flickr *)flickr{
    _flickr = flickr;
     self.flickrTitle.text = self.flickr.title;
    [self.flickrImageView setImageWithURL:self.flickr.photoUrl];

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
