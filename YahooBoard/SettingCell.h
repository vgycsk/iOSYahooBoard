//
//  SettingCell.h
//  YahooBoard
//
//  Created by Yi-De Lin on 7/20/15.
//  Copyright (c) 2015 XXX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingCell;

@protocol SettingCellDelegate <NSObject>
-(void)settingCell:(SettingCell *)settingCell didChangeSwitch:(NSString*)switchName;
@end

@interface SettingCell : UITableViewCell
@property (weak, nonatomic) id<SettingCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISwitch *settingSwitch;

@end
