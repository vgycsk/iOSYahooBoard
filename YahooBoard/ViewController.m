//
//  ViewController.m
//  YahooBoard
//
//  Created by Ufohead Tseng on 2015/7/8.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import "ViewController.h"
#import "FlickrKitClient.h"
#import "ImageCell.h"
#import "TumblrClient.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *cellImage;

@property (strong, nonatomic) NSMutableArray *flickrImageArray;
@property (strong, nonatomic) NSMutableArray *tumblrImageArray;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UINib *cellNib = [UINib nibWithNibName:@"ImageCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ImageCell"];
    
    self.flickrImageArray = [[NSMutableArray alloc]init];
    self.tumblrImageArray = [[NSMutableArray alloc]init];
    
    [self searchFlickrData:@"moon"];
    [self searchTumblrData:@"nba"];
    
    
    // search bar
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
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
    //return self.flickrImageArray.count;
    return self.tumblrImageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    if (indexPath.row %2 == 0 && self.flickrImageArray[indexPath.row] != nil) {
        cell.flickr = self.flickrImageArray[indexPath.row];
    }
    if (indexPath.row %2 == 1 && self.tumblrImageArray[indexPath.row] != nil) {
        cell.tumblr = self.tumblrImageArray[indexPath.row];
    }
    return cell;
}


#pragma mark - collection Methods
- (void)setupCollectionView {
    self.collectionView.delegate = self;
    self.collectionView.dataSource =self;
    
}



#pragma util method

- (void)searchFlickrData:(NSString *)searchKey {
    
    FlickrKitClient *client = [FlickrKitClient sharedInstance];
    [client searchPhotoWithText:searchKey page:10 pageCount:10 sortBy:@"relevance" completion:^(NSArray *data, NSError *error) {
        if (data) {
            //[self setImage:data];
            //NSLog(@"%@", data);
            self.flickrImageArray = data;
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
            self.tumblrImageArray = data;
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

}

// Reset searchbar on cancel
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    self.searchBar.text = @"";
    [searchBar resignFirstResponder];
}
@end
