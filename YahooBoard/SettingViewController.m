//
//  SettingViewController.m
//  YahooBoard
//
//  Created by Yi-De Lin on 7/20/15.
//  Copyright (c) 2015 XXX. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"

@interface SettingViewController() <UITableViewDataSource, UITableViewDelegate, SettingCellDelegate>
@end

@implementation SettingViewController
NSArray *categories;
//Foods, Style, Sports, World, Politics, Tech, Business, Opinion, Science, Health, Arts,Travel, Magazine
- (void)viewDidLoad {
    categories = @[@"Foods", @"Style", @"Sports", @"World", @"Politics", @"Tech", @"Business", @"Opinion", @"Science", @"Health", @"Arts", @"Travel", @"Magazine"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"categoryFilterCell";
    SettingCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:cellId];
    }
    cell.textLabel.text = categories[indexPath.row];
    cell.delegate = self;
    if ([cell.textLabel.text isEqualToString:self.currentCategory]) {
        cell.settingSwitch.on = YES;
    } else {
        cell.settingSwitch.on = NO;
    }
    
    return cell;
}

-(void)settingCell:(SettingCell *)settingCell didChangeSwitch:(NSString *)switchName {
    //NSLog(@"switch name is %@", switchName);
    self.currentCategory = switchName;
    [self.newsCategoryTable reloadData];
    [self.delegate settingViewController:self didChangeCategory:switchName];
}

@end
