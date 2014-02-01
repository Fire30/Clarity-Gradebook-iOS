//
//  ClassGradeViewController.m
//  claritygradebook
//
//  Created by tj on 10/5/13.
//  Copyright (c) 2013 Fire30. All rights reserved.
//

#import "ClassGradeViewController.h"
#import "IndividualGradeViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "SettingsViewController.h"
#import "ViewController.h"

@interface ClassGradeViewController ()
{
    
}
@end

@implementation ClassGradeViewController

@synthesize classDict;
@synthesize classArray;
@synthesize classNames;
@synthesize enrollIds;
@synthesize periods;
@synthesize quarterIndex;
@synthesize gradeValues;
@synthesize termIds;
@synthesize periodString;
@synthesize theJson;
@synthesize aspxAuth;
@synthesize studentId;

- (id)initWithJSON:(NSArray *)JSON
{
    self = [super init];
    if (self) {
        theJson = JSON;
        quarterIndex = [[JSON[2] objectForKey:@"quarter_index"] intValue];
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(Settings)];
        self.navigationItem.rightBarButtonItem = anotherButton;
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleBordered target:self action:@selector(Back)];
        self.navigationItem.leftBarButtonItem = backButton;
        
        classArray = [theJson[0] objectForKey:@"classes"];
        periods = [theJson[1] objectForKey:@"periods"];
        quarterIndex = [[theJson[2] objectForKey:@"quarter_index"] intValue];
        aspxAuth =  [theJson[3] objectForKey:@"credentials"][0];
        studentId = [theJson[3] objectForKey:@"credentials"][1];
        
        classNames = [[NSMutableArray alloc]init];
        enrollIds = [[NSMutableArray alloc]init];
        gradeValues = [self getGradeValues:quarterIndex];
        periodString = [periods objectAtIndex:quarterIndex];
        termIds = [self getTermIds:quarterIndex];
        periodString = [periods objectAtIndex:quarterIndex];
        [self setTitle:periodString];
        for (NSDictionary *class in classArray)
        {
            [classNames addObject:[class objectForKey:@"class_name"]];
            [enrollIds addObject:[class objectForKey:@"enroll_id"]];
        }
        NSString *msg = [theJson[4] objectForKey:@"message"];
        if(![msg  isEqual: @""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message:msg delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (IBAction)Back
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"startView"];
    [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [sfvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:sfvc animated:YES completion:nil];
    
}
-(IBAction)Settings
{
    SettingsViewController *vc2 = [[SettingsViewController alloc]initWithStyle:UITableViewStyleGrouped];
    vc2.delegate = self;
    vc2.periodList = periods;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc2];
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}
- (void)settingsView:(UIViewController *)view didChangequarterIndex:(int)index
{
    self.quarterIndex = index;
    gradeValues = [self getGradeValues:quarterIndex];
    periodString = [periods objectAtIndex:quarterIndex];
    termIds = [self getTermIds:quarterIndex];
    periodString = [periods objectAtIndex:quarterIndex];
    [self setTitle:periodString];
    self.tableView  = [[UITableView alloc] init];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSArray *)getTermIds:(int)quarterNumber;
{
    NSMutableArray *termIdsTemp = [[NSMutableArray alloc] init];
    for (NSDictionary *class in classArray)
    {
        [termIdsTemp addObject:[[class objectForKey:@"term_ids"]objectAtIndex:quarterNumber]];
    }
    return termIdsTemp;

}
-(NSArray *)getGradeValues:(int)quarterNumber;
{
    NSMutableArray *gradeValuesTemp = [[NSMutableArray alloc] init];
    for (NSDictionary *class in classArray)
    {
        [gradeValuesTemp addObject:[[class objectForKey:@"grade_values"]objectAtIndex:quarterNumber]];
    }
    return gradeValuesTemp;
    
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [classNames count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:CellIdentifier];
        cell.textLabel.text = [classNames objectAtIndex:[indexPath section]];
        cell.detailTextLabel.text = [gradeValues objectAtIndex:[indexPath section]];
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // Configure the cell...
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tabelView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableView.frame.size.height / ([classNames count] + 1);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = [classNames objectAtIndex:[indexPath section]];
    NSString *termId = [termIds objectAtIndex:[indexPath section]][0];
    NSString *enrollmentId = [enrollIds objectAtIndex:[indexPath section]][0];
    if(![termId  isEqual: @"0"])
    {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSString* loginUrl =  [NSString stringWithFormat:@"http://tcorley.me/clarity/grade?enroll_id=%@&term_id=%@&student_id=%@&aspx=%@",enrollmentId,termId,studentId,aspxAuth];
        [manager GET:loginUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [HUD hide:YES];
            NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@",JSON);
            IndividualGradeViewController *vc2 = [[IndividualGradeViewController alloc]initWithJSON:JSON classname:className];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc2];
            [self presentViewController:navController animated:YES completion:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSString *username = [ViewController getUsernameAndPassword][0];
            NSString *password = [ViewController getUsernameAndPassword][1];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            NSString* loginUrl =  [NSString stringWithFormat:@"%@username=%@&password=%@",@"http://tcorley.me/clarity/login?",username,password];
            [manager GET:loginUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [HUD hide:YES];
                NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                theJson = JSON;
                [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                [HUD hide:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Could Not Get Grade Data!\nTry logging out and loggin back in!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }];
            
    }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"There have been no grades inputted for this class so far" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
@end
