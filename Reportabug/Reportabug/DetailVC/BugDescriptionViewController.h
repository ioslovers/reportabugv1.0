/*
 File Name: BugDescriptionViewController
 
 Description: This file execute after HomeViewController and In this file User can setup a Bug title/ descriptions with Logger file and multiple images.
 Creator: Ashish Tripathi
 
 Copyright 2014 ioslovers
 */


#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import <MessageUI/MFMailComposeViewController.h>
@interface BugDescriptionViewController : UIViewController <iCarouselDataSource, iCarouselDelegate,MFMailComposeViewControllerDelegate>

@property (strong,nonatomic) IBOutlet UITextField *txtFieldTitle;
@property (strong,nonatomic) IBOutlet UITextView *txtViewDescriptions;
@property (strong,nonatomic) IBOutlet UIButton *btnDeleteImage;
@property (strong,nonatomic) IBOutlet UIButton *btnCheckUncheck;
@property (strong,nonatomic) IBOutlet iCarousel *viewForPictures;
@property (nonatomic, assign) BOOL wrap;
@property (nonatomic, strong) NSMutableArray *itemsImage;


-(IBAction)btnPressedAddScreenShots:(id)sender;
-(IBAction)btnPressedRemovePhoto:(id)sender;
-(IBAction)btnPressedSendReport:(id)sender;
-(IBAction)btnPressedAddLogs:(id)sender;
@end
