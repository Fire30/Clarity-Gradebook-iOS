//
//  AboutController.m
//  claritygradebook
//
//  Created by tj on 10/6/13.
//  Copyright (c) 2013 Fire30. All rights reserved.
//

#import "AboutController.h"
#import "ViewController.h"

@interface AboutController ()

@end

@implementation AboutController

@synthesize backButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)aboutBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
