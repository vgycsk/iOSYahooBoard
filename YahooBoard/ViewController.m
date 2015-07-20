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

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) FlickrDetailViewController *flickrDetailViewController;
@property (strong, nonatomic) TumblrDetailViewController *tumblrDetailViewController;

@property (nonatomic, strong) UISearchBar *searchBar;

@end

NSString *defaultSearchTerm = @"nba";
NSString *defaultSearchCategory = @"Sports";
NSString *currentSearchCategory;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UINib *cellNib = [UINib nibWithNibName:@"ImageCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ImageCell"];
    
    self.flickrImageArray = [[NSMutableArray alloc]init];
    self.tumblrImageArray = [[NSMutableArray alloc]init];
    
    [self searchNewsData:defaultSearchTerm];
    
    // search bar
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    self.searchBar.placeholder = defaultSearchTerm;
    
    //setup controler
    self.flickrDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"flickrDetailView"];
    self.tumblrDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tumblrDetailView"];
    
    currentSearchCategory = defaultSearchCategory;
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
    //return self.flickrImageArray.count + self.tumblrImageArray.count;
    return self.flickrImageArray.count;

    //NSInteger *count = self.flickrImageArray.count + self.tumblrImageArray.count;
    //return count;
    //return self.tumblrImageArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    
    [cell.layer setBorderWidth:2.0f];
    [cell.layer setCornerRadius:50.0f];
    
    if (indexPath.row %2 == 0 && self.flickrImageArray[indexPath.row] != nil) {
        cell.flickr = self.flickrImageArray[indexPath.row];
        cell.delegate = self;
        cell.cellType = @"flickr";
        [cell.layer setBorderColor:[UIColor whiteColor].CGColor];
    }
    if (indexPath.row %2 == 1 && self.tumblrImageArray[indexPath.row] != nil) {
        cell.tumblr = self.tumblrImageArray[indexPath.row];
        cell.delegate = self;
        cell.cellType = @"tumblr";
            [cell.layer setBorderColor:[UIColor blueColor].CGColor];
    }
    return cell;
}


#pragma mark - collection Methods
- (void)setupCollectionView {
    self.collectionView.delegate = self;
    self.collectionView.dataSource =self;
    
}

#pragma util method

- (void)searchNewsData:(NSString *)searchKey {
    NSString *catString = [NSString stringWithFormat:@"\"%@\"", currentSearchCategory];
    NSLog(@"cat is %@", catString);
    [[NewsClient sharedInstance] queryNewsWithParameter:searchKey category:catString sortBy:@"newest" completion:^(NSArray *newsArray, NSError *error) {
        if (newsArray) {
            [self loadNewsLabel:newsArray];
        }
    }];
}

- (void)loadNewsLabel:(NSArray *)newsList {
    NSString *displayText = nil;
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
            [self searchFlickrData:defaultSearchTerm];
            [self searchTumblrData:defaultSearchTerm];
            return;
        }
    }
}

- (void)searchFlickrData:(NSString *)searchKey {
    
    FlickrKitClient *client = [FlickrKitClient sharedInstance];
    [client searchPhotoWithText:searchKey page:10 pageCount:10 sortBy:@"relevance" completion:^(NSArray *data, NSError *error) {
        if (data) {
            //[self setImage:data];
            //NSLog(@"%@", data);
            self.flickrImageArray = [NSMutableArray arrayWithArray:data];
            [self.collectionView reloadData];
        } else {
            NSLog(@"[WARNING] No Flickr posts with tag %@ found", searchKey);
        }
    }];
}

- (void)searchTumblrData:(NSString *)searchKey {
    double timestamp =[[NSDate date] timeIntervalSince1970] * 1000;
    [[TumblrClient sharedInstance] searchPostWithTag:searchKey limit:20 before:timestamp type:@"photo" completion:^(NSArray *data, NSError *error) {
        if ([data count]) {
            //NSLog(@"data %@", data);
            self.tumblrImageArray = [NSMutableArray arrayWithArray:data];
            [self.collectionView reloadData];
        } else {
            NSLog(@"[WARNING] No tumblr posts with tag %@ found", searchKey);
        }
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
    [searchBar resignFirstResponder];
    [self searchFlickrData:query];
    [self searchTumblrData:query];
    [self searchNewsData:query];
}

// Reset searchbar on cancel
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    self.searchBar.text = @"";
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

@end
