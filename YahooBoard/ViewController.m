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

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UIImageView *cellImage;

@property (strong, nonatomic) NSMutableArray *imageArray;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.imageArray = [[NSMutableArray alloc]init];
    
    [self searchFlickrData:@"moon"];
    
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
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    cell.flickr = self.imageArray[indexPath.row];
    NSLog(@"=================....");
    
    return cell;
}

#pragma util method



- (void)searchFlickrData:(NSString *)searchKey {
    //NSString *searchText = searchKey;
    NSString *searchText = @"moon";
    
    FlickrKitClient *client = [FlickrKitClient sharedInstance];
    [client searchPhotoWithText:searchText page:10 pageCount:10 sortBy:@"relevance" completion:^(NSArray *data, NSError *error) {
        if (data) {
            //[self setImage:data];
            //NSLog(@"%@", data);
            self.imageArray = data;
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
