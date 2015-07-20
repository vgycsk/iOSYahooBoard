//
//  SettingCell.m
//  YahooBoard
//
//  Created by Yi-De Lin on 7/20/15.
//  Copyright (c) 2015 XXX. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

- (IBAction)onSwitchChanged:(id)sender {
    [self.delegate settingCell:self didChangeSwitch:self.textLabel.text];
}

@end
