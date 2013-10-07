//
//  ViewController.m
//  claritygradebook
//
//  Created by tj on 10/3/13.
//  Copyright (c) 2013 Fire30. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "AFURLResponseSerialization.h"
#import "SOTextField.h"
#include "MBProgressHUD.h"
#include "ClassGradeViewController.h"
#import "AboutController.h"

#define LOGINURL "http://tcorley.me/clarity/login?"

@interface ViewController ()

@end

@implementation ViewController

@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize loginButton;
@synthesize rememberSwitch;
@synthesize aboutButton;

NSString *staticUsername;
NSString *staticPassword;


+(NSArray *)getUsernameAndPassword
{
    return @[staticUsername,staticPassword];
}
+(void)setUsername:(NSString*)username password:(NSString *)password
{
    staticUsername = username;
    staticPassword = password;
}
- (void)viewDidLoad
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    passwordTextField.text = [defaults objectForKey:@"password"];
    usernameTextField.text = [defaults objectForKey:@"username"];


    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
-(IBAction)about:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"aboutView"];
    [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:sfvc animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    
    BOOL didResign = [textField resignFirstResponder];
    if (!didResign) return NO;
    
    if ([textField isKindOfClass:[SOTextField class]])
        dispatch_async(dispatch_get_main_queue(),
                       ^ { [[(SOTextField *)textField nextField] becomeFirstResponder]; });
    
    return YES;
    
}
-(IBAction)clicked:(id)sender {
    if ((UIButton *)sender == loginButton) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            NSString* loginUrl =  [NSString stringWithFormat:@"%susername=%@&password=%@",LOGINURL,usernameTextField.text,passwordTextField.text];
            [manager GET:loginUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                ClassGradeViewController *vc2 = [[ClassGradeViewController alloc]initWithJSON:JSON];
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc2];
                [self presentViewController:navController animated:YES completion:nil];
                [[self class]setUsername:usernameTextField.text password:passwordTextField.text];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                if([rememberSwitch selectedSegmentIndex] == 0)
                {
                    [defaults setObject:usernameTextField.text forKey:@"username"];
                    [defaults setObject:passwordTextField.text forKey:@"password"];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
                }
                [[NSUserDefaults standardUserDefaults]synchronize ];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Could Not Log In!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
        
    }
}

@end