//
//  ViewController.h
//  claritygradebook
//
//  Created by tj on 10/3/13.
//  Copyright (c) 2013 Fire30. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *aboutButton;
@property (weak,nonatomic)IBOutlet UISegmentedControl *rememberSwitch;

+(NSArray *)getUsernameAndPassword;

@end
