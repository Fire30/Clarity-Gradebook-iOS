//
//  SettingsViewController.h
//  claritygradebook
//
//  Created by tj on 10/6/13.
//  Copyright (c) 2013 Fire30. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsViewControllerDelegate <UIActionSheetDelegate>
- (void)settingsView:(UIViewController *)view didChangequarterIndex:(int)index;
@end

@interface SettingsViewController : UITableViewController <UIActionSheetDelegate>

@property (nonatomic, weak) id <SettingsViewControllerDelegate> delegate;
@property (nonatomic) UIActionSheet *aac;
@property (nonatomic) NSArray *periodList;
@end
