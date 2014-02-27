//
//  ViewController.m
//  Reportabug
//
//  Created by Ashish Tripathi on 24/02/14.
//  Copyright (c) 2014 Ashish Tripathi. All rights reserved.
//

#import "ViewController.h"
#import "Logger.h"
@interface ViewController ()

@end

@implementation ViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
void uncaughtExceptionHandler(NSException *exception) {
    
     [Logger error:@"error code" exception:exception];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
   
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = @"Report a Bug";
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
@end
