/*
 File Name: HomeViewController
 
 Description: This file execute after App Delegate class and this will come out with UITable view and Report a bug cell.
 
 Creator: Ashish Tripathi
 
 Copyright 2014 ioslovers
 */

#import "HomeViewController.h"
#import "Logger.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

#pragma UIView life cycles Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

void uncaughtExceptionHandler(NSException *exception) {
    
    //Logger file will get exection if any failure
     [Logger error:@"error code" exception:exception];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
   //Setup a handler for exeptions.
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
   
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView Data Source Methods

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
