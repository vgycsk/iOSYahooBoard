//
//  SettingViewController.h
//  YahooBoard
//
//  Created by Yi-De Lin on 7/20/15.
//  Copyright (c) 2015 XXX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingViewController;
@protocol SettingViewDelegate <NSObject>
-(void)settingViewController:(SettingViewController *)controller didChangeCategory:(NSString*)category;
@end


@interface SettingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *newsCategoryTable;
@property int currentOnCategoryIndex;
@property (weak, nonatomic) NSString *currentCategory;
@property (weak, nonatomic) id<SettingViewDelegate> delegate;

@end
