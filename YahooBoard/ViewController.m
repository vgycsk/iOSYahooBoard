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

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UIImageView *cellImage;

@property (strong, nonatomic) NSMutableArray *imageArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UINib *cellNib = [UINib nibWithNibName:@"ImageCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ImageCell"];
    
    self.imageArray = [[NSMutableArray alloc]init];
    
    //[self searchFlickrData:@"moon"];
    [self searchTumblrData:@"nba"];
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
    return [self.imageArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    //cell.flickr = self.imageArray[indexPath.row];
    cell.tumblr = self.imageArray[indexPath.row];
    
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
            self.imageArray = data;
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
            self.imageArray = data;
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
@end
