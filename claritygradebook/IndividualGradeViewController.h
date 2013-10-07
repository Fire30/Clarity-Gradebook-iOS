//
//  IndividualGradeViewController.h
//  claritygradebook
//
//  Created by tj on 10/6/13.
//  Copyright (c) 2013 Fire30. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndividualGradeViewController : UITableViewController

-(id)initWithJSON:(NSArray *)JSON classname:(NSString *)classname;

@property(nonatomic) NSArray *theJson;

@end
