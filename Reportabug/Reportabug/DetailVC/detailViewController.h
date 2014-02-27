//
//  detailViewController.h
//  Reportabug
//
//  Created by Ashish Tripathi on 24/02/14.
//  Copyright (c) 2014 Ashish Tripathi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import <MessageUI/MFMailComposeViewController.h>
@interface detailViewController : UIViewController <iCarouselDataSource, iCarouselDelegate,MFMailComposeViewControllerDelegate>

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
