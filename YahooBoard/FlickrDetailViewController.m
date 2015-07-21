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
    [self setFlickrButton];
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

- (IBAction)onFlickrIcon:(id)sender {
    NSURL *url = [NSURL URLWithString:self.flickr.rawUrl];
    [[UIApplication sharedApplication] openURL:url];
}

-(void) onFlickrBar{
    NSURL *url = [NSURL URLWithString:self.flickr.rawUrl];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)setFlickrButton{
    UIImage *flickrImage = [UIImage imageNamed:@"flickr2.png"];
    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    face.bounds = CGRectMake( 0, 0, 40, 40 );
    [face setImage:flickrImage forState:UIControlStateNormal];
    
    [face addTarget:self action:@selector(onFlickrBar) forControlEvents:UIControlEventTouchUpInside];
    [face.layer setBorderColor:[UIColor whiteColor].CGColor];
    [face.layer setBorderWidth:3.0f];
    //[face.layer setCornerRadius:5.0f];
    
    UIBarButtonItem *flickrBtn = [[UIBarButtonItem alloc] initWithCustomView:face];
    self.navigationItem.rightBarButtonItem = flickrBtn;
}

@end
