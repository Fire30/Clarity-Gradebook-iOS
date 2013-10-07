//
//  IndividualGradeViewController.m
//  claritygradebook
//
//  Created by tj on 10/6/13.
//  Copyright (c) 2013 Fire30. All rights reserved.
//

#import "IndividualGradeViewController.h"

@interface IndividualGradeViewController ()

@end

@implementation IndividualGradeViewController

@synthesize theJson;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithJSON:(NSArray *)JSON classname:(NSString *)classname
{
    self = [super init];
    if(self)
    {
        self.title = classname;
        theJson = JSON;
        NSLog(@"%@",theJson[0][0]);
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
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleBordered target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem = backButton;
}
- (IBAction)Back
{
    [self dismissViewControllerAnimated:YES completion:nil]; // ios 6
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
    return [theJson count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [theJson[[indexPath section]][0] objectForKey:@"assignment_name"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:CellIdentifier];
        NSString *gradeName = [theJson[[indexPath section]][0] objectForKey:@"assignment_name"];
        cell.textLabel.text = [gradeName substringToIndex: MIN(22, [gradeName length])];
        cell.detailTextLabel.text = [theJson[[indexPath section]][1] objectForKey:@"score"];
    }
    
    // Configure the cell...
    
    return cell;
}


@end
