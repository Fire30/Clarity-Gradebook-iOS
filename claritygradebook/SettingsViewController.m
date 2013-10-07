//
//  SettingsViewController.m
//  claritygradebook
//
//  Created by tj on 10/6/13.
//  Copyright (c) 2013 Fire30. All rights reserved.
//

#import "SettingsViewController.h"
#import "ClassGradeViewController.h"
#import "ViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#define LOGINURL "http://tcorley.me/clarity/login?"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setTitle:@"Settings"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleBordered target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem = backButton;
    [super viewWillAppear:animated];
}
- (IBAction)Back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:CellIdentifier];
        switch ([indexPath row]) {
            case 0:
                cell.textLabel.text = @"Grading Period";
                break;
            case 1:
                cell.textLabel.text = @"Refresh Grade Data";
                break;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == 0)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Sorry :(" message: @"This feature is not supported yet. It will work by second quarter though!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if ([indexPath row] == 1)
    {
            NSString *username = [ViewController getUsernameAndPassword][0];
            NSString *password = [ViewController getUsernameAndPassword][1];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            NSString* loginUrl =  [NSString stringWithFormat:@"%susername=%@&password=%@",LOGINURL,username,password];
            [manager GET:loginUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                ClassGradeViewController *vc2 = [[ClassGradeViewController alloc]initWithJSON:JSON];
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc2];
                [self.navigationController presentViewController:navController animated:YES completion:nil];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Could Not Refresh Grades!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
        
    }
    }


@end
