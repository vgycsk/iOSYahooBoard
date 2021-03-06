//
//  ViewController.m
//  YahooBoard
//
//  Created by Ufohead Tseng on 2015/7/8.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import "ViewController.h"
#import "FlickrKitClient.h"
#import "TumblrClient.h"
#import "FlickrDetailViewController.h"
#import "TumblrDetailViewController.h"
#import "SettingViewController.h"
#import "NewsClient.h"


@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate,ImageCellDelegate, SettingViewDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *cellImage;

@property (strong, nonatomic) NSMutableArray *flickrImageArray;
@property (strong, nonatomic) NSMutableArray *tumblrImageArray;
@property (strong, nonatomic) NSMutableArray *newsLists;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (strong, nonatomic) FlickrDetailViewController *flickrDetailViewController;
@property (strong, nonatomic) TumblrDetailViewController *tumblrDetailViewController;

@property (nonatomic, strong) UISearchBar *searchBar;
@property  int queryStatusCount;
@property  int newsCount;

@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGesture;

@end

NSString *defaultSearchTerm = @"candy";
NSString *currentSearchTerm;
NSString *defaultSearchCategory = @"All";
NSString *currentSearchCategory;

// load more parameters
int currentFlickrPage;
double currentTumblrTimestamp;
BOOL loadMoreFlickr;
BOOL loadMoreTumblr;
CGPoint panNewsStartLocation;
CGPoint panNewsStopLocation;
CGRect defaultNewsFrame;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UINib *cellNib = [UINib nibWithNibName:@"ImageCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ImageCell"];

    self.flickrImageArray = [[NSMutableArray alloc]init];
    self.tumblrImageArray = [[NSMutableArray alloc]init];
    self.newsLists = [[NSMutableArray alloc]init];
    
    [self searchNewsData:defaultSearchTerm];

    // search bar
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    self.navigationController.navigationBar.backgroundColor = [UIColor grayColor];
    self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    self.searchBar.placeholder = defaultSearchTerm;

    //setup controler
    self.flickrDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"flickrDetailView"];
    self.tumblrDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tumblrDetailView"];

    // news header
    //[self.newsHeaderLabel.layer setBorderColor:[UIColor whiteColor].CGColor];
    //[self.newsHeaderLabel.layer setBorderWidth:1.0f];
    //[self.newsHeaderLabel.layer setCornerRadius:7.0f];
    currentSearchCategory = defaultSearchCategory;
    currentSearchTerm = defaultSearchTerm;
    
    [self showLoad];
    self.queryStatusCount = 0;
    [self searchFlickrData:defaultSearchTerm];
    [self searchTumblrData:defaultSearchTerm];
    [self searchNewsData:defaultSearchTerm];
    
    [self resetSearch];


    // swipe news
    self.swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(switchNews:)];
    [self.swipeGesture setNumberOfTouchesRequired:1];
    [self.swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft];
    NSLog(@"swipe %@", self.swipeGesture);
    [self.newsHeaderLabel addGestureRecognizer:self.swipeGesture];
    
}

- (void)viewDidAppear:(BOOL)animated {
    defaultNewsFrame = self.newsHeaderLabel.frame;
    NSLog(@"------------ %f", defaultNewsFrame.size.width);
}

- (void)resetSearch {
    currentTumblrTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    currentFlickrPage = 0;
    loadMoreFlickr = NO;
    loadMoreTumblr = NO;
    self.tumblrImageArray = [[NSMutableArray alloc] init];
    self.flickrImageArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma Collection view method
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSUInteger count;
    count = (self.flickrImageArray.count < self.tumblrImageArray.count)? self.flickrImageArray.count : self.tumblrImageArray.count ;
    return (count-1)*2;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = [self collectionView:collectionView numberOfItemsInSection:(NSInteger)0]/2;
    if (indexPath.row %2 == 0 && count <= indexPath.row/2+1 && !loadMoreFlickr) {
        loadMoreFlickr = YES;
        NSLog(@"load more flickr");
        [self searchFlickrData:currentSearchTerm];
    }
    if (indexPath.row %2 == 1 && count <= (indexPath.row+1)/2+1 && !loadMoreTumblr) {
        loadMoreTumblr = YES;
        NSLog(@"load more tumblr");
        [self searchTumblrData:currentSearchTerm];
    }
    
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];

    [cell.layer setBorderWidth:2.0f];
    [cell.layer setCornerRadius:75.0f];

    if (indexPath.row %2 == 0 && self.flickrImageArray[indexPath.row/2] != nil) {
        cell.flickr = self.flickrImageArray[indexPath.row/2];
        cell.delegate = self;
        cell.cellType = @"flickr";
        [cell.layer setBorderColor:[UIColor whiteColor].CGColor];
    }
    if (indexPath.row %2 == 1 && self.tumblrImageArray[(indexPath.row+1)/2] != nil) {
        cell.tumblr = self.tumblrImageArray[(indexPath.row+1)/2];
        cell.delegate = self;
        cell.cellType = @"tumblr";
            [cell.layer setBorderColor:[UIColor whiteColor].CGColor];
    }
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)
collectionView layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 20, 0, 20); // top, left, bottom, right
}


#pragma mark - collection Methods
- (void)setupCollectionView {
    self.collectionView.delegate = self;
    self.collectionView.dataSource =self;

}

#pragma util method

- (void)searchNewsData:(NSString *)searchKey {
    NSString *catString = [NSString stringWithFormat:@"\"%@\"", currentSearchCategory];
    NSString *keyString = [NSString stringWithFormat:@"\"%@\"", searchKey];
    NSLog(@"cat is %@", catString);
    [[NewsClient sharedInstance] queryNewsWithParameter:keyString category:catString sortBy:@"newest" completion:^(NSArray *newsArray, NSError *error) {
        if (newsArray) {
            [self loadNewsLabel:newsArray];
        }
    }];
}

- (void)loadNewsLabel:(NSArray *)newsList {
    NSString *displayText = nil;
    
    if (newsList.count == 0) {
        return;
    }
    self.newsLists = [NSMutableArray arrayWithArray:newsList];
    self.newsCount = 1;
    for(News *news in newsList)
    {
        if (![news.headline isEqual:[NSNull null]]) {
            displayText = news.headline;
        } else if (![news.content isEqual:[NSNull null]]) {
            displayText = news.content;
        }

        //NSLog(@"headline= %@", news.headline);
        //NSLog(@"content= %@", news.content);
        //NSLog(@"displayText %@", displayText);
        /*
        NSLog(@"pubDate= %@", news.pubDate);
        NSLog(@"keywords= %@", news.keywordDict);
        NSLog(@"image= %@", news.thumbWideImageUrl);
        */
        if (![displayText isEqual:[NSNull null]]) {
            self.newsHeaderLabel.text = displayText;
            return;
        }
    }
    
}

- (void)searchFlickrData:(NSString *)searchKey {
    FlickrKitClient *client = [FlickrKitClient sharedInstance];
    [client searchPhotoWithText:searchKey page:currentFlickrPage pageCount:10 sortBy:@"relevance" completion:^(NSArray *data, NSError *error) {
        if (data) {
            //[self setImage:data];
            //NSLog(@"%@", data);
            [self.flickrImageArray addObjectsFromArray:data];
            
            [self.collectionView reloadData];
        } else {
            NSLog(@"[WARNING] No Flickr posts with tag %@ found", searchKey);
        }
        self.queryStatusCount +=1;
        if ( self.queryStatusCount == 2) {
            [SVProgressHUD dismiss];
        }
        loadMoreFlickr = NO;
    }];
}

- (void)searchTumblrData:(NSString *)searchKey {
    //double timestamp =[[NSDate date] timeIntervalSince1970] * 1000;
    [[TumblrClient sharedInstance] searchPostWithTag:searchKey limit:10 before:currentTumblrTimestamp type:@"photo" completion:^(NSArray *data, NSError *error) {
        if ([data count]) {
            //NSLog(@"data %@", data);
            Tumblr *t = data[[data count]-1];
            currentTumblrTimestamp = t.timestamp;
            NSLog(@"time stamp is %f", currentTumblrTimestamp);
            [self.tumblrImageArray addObjectsFromArray:data];
            [self.collectionView reloadData];
            
        } else {
            NSLog(@"[WARNING] No tumblr posts with tag %@ found", searchKey);
        }
        self.queryStatusCount +=1;
        if ( self.queryStatusCount == 2) {
            [SVProgressHUD dismiss];
        }
        loadMoreTumblr = NO;
    }];
}
/*
 - (void)setImage:(NSArray *)data {
 Flickr *flickrObj = data[0];
 NSLog(@"%@", flickrObj.title);
 [self.flickrImageView setImageWithURL:flickrObj.photoUrl];
 }
 */

#pragma mark - Search methods
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    //[searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *query = self.searchBar.text;

    //[self fetchBusinessesWithQuery:query params:nil];
    [searchBar setShowsCancelButton:NO];
    //self.searchBar.text = @"";
    self.newsHeaderLabel.text = @"  Loading";
    [searchBar resignFirstResponder];
    
    [self resetSearch];
    
    [self showLoad];
    self.queryStatusCount = 0;
    [self searchFlickrData:query];
    [self searchTumblrData:query];
    [self searchNewsData:query];
    currentSearchTerm = query;
}

// Reset searchbar on cancel
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    self.searchBar.text = @"";
    self.newsHeaderLabel.text = @"";
    [SVProgressHUD dismiss];
    [searchBar resignFirstResponder];
}

-(void)imageCell:(ImageCell *)imageCell didTapFlickrPhoto:(Flickr *)flickr {
    [self.flickrDetailViewController  setFlickr:flickr];
    if(self.navigationController != nil) {
        [self.navigationController pushViewController:self.flickrDetailViewController  animated:YES];
    }

}

-(void)imageCell:(ImageCell *)imageCell didTapTumblrPhoto:(Tumblr *)tumblr {
    [self.tumblrDetailViewController  setTumblr:tumblr];
    if(self.navigationController != nil) {
        [self.navigationController pushViewController:self.tumblrDetailViewController  animated:YES];
    }

}

-(void)settingViewController:(SettingViewController *)controller didChangeCategory:(NSString*)category {
    currentSearchCategory = category;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"home2setting"]) {
        SettingViewController *controller = (SettingViewController *)segue.destinationViewController;
        controller.currentCategory = currentSearchCategory;
        controller.delegate = self;
    }
}


- (void) showLoad {
    
    UIColor *backgroundColor =[UIColor
                               colorWithRed:0.0
                               green:0.5
                               blue:1.0
                               alpha:0.5];
    [SVProgressHUD setBackgroundColor:backgroundColor];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setRingThickness:(CGFloat)10.0];
    [SVProgressHUD show];
    [SVProgressHUD showWithStatus:@"Loading"];
}

- (IBAction)switchNews:(id)sender {

    self.newsCount += 1;
    if (self.newsLists.count == self.newsCount) {
        self.newsCount = 1;
    }
    if (self.newsLists.count > self.newsCount) {
        NSString *displayText = nil;
        News *news = self.newsLists[self.newsCount];
        if (![news.headline isEqual:[NSNull null]]) {
            displayText = news.headline;
        } else if (![news.content isEqual:[NSNull null]]) {
            displayText = news.content;
        }
        
        if (![displayText isEqual:[NSNull null]]) {
            self.newsHeaderLabel.text = displayText;
            return;
        }
    }

}

- (IBAction)onEnlargingNewsLabel:(UIPanGestureRecognizer *)sender {
    //NSLog(@"on enlarge label");
    //self.normalFrame = CGRectMake(cFrame.origin.x, self.frame.origin.y, cFrame.size.width, self.frame.size.height);
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        panNewsStartLocation = [sender locationInView:self.newsHeaderLabel];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint stopLocation = [sender locationInView:self.newsHeaderLabel];
        CGFloat dy = (stopLocation.y - panNewsStartLocation.y) * -1;
        CGFloat dx = (stopLocation.x - panNewsStartLocation.x);
        
        if (fabs(dx) > 40) {
            [self switchNews:sender];
            return;
        }
        
        if (dy >= -20) {
            [UIView animateWithDuration:0.05 animations:^{
                self.newsHeaderLabel.frame = defaultNewsFrame;
                //[self.newsHeaderLabel sizeToFit];
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect cFrame = defaultNewsFrame;
                self.newsHeaderLabel.frame = CGRectMake(cFrame.origin.x, cFrame.origin.y, cFrame.size.width, cFrame.size.height - dy);
            }];
            
        }
    }
    
}

@end
