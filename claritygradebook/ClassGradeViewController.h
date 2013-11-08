//
//  ClassGradeViewController.h
//  claritygradebook
//
//  Created by tj on 10/5/13.
//  Copyright (c) 2013 Fire30. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SettingsViewController.h"
#import "MBProgressHUD.h"

@interface ClassGradeViewController:UITableViewController <SettingsViewControllerDelegate>
{
    
}
@property(nonatomic) NSDictionary *classDict;
@property(nonatomic)NSArray *classArray;
@property(nonatomic)NSMutableArray *classNames;
@property(nonatomic)NSMutableArray *enrollIds;
@property(nonatomic)NSArray *periods;
@property(nonatomic)int quarterIndex;
@property(nonatomic)NSArray *termIds;
@property(nonatomic)NSArray *gradeValues;
@property(nonatomic)NSString *periodString;
@property(nonatomic)NSArray *theJson;
@property(nonatomic)NSString *aspxAuth;
@property(nonatomic)NSString *studentId;
- (id)initWithJSON:(NSArray *)JSON;
@end
