//
//  detailViewController.m
//  Reportabug
//
//  Created by Ashish Tripathi on 24/02/14.
//  Copyright (c) 2014 Ashish Tripathi. All rights reserved.
//

#import "BugDescriptionViewController.h"
#import "CTAssetsPickerController.h"



@interface BugDescriptionViewController ()<UINavigationControllerDelegate, CTAssetsPickerControllerDelegate>

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation BugDescriptionViewController

#pragma mark ViewLifeCycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
    }
    return self;
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _viewForPictures.type = iCarouselTypeLinear;
    _txtViewDescriptions.text = @"Enter bug descriptions in detail";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(IBAction)btnPressedAddScreenShots:(id)sender{

    [self pickAssets:sender];
}
-(IBAction)btnPressedRemovePhoto:(id)sender {

    if (_viewForPictures.numberOfItems > 0)
    {
        NSInteger index = _viewForPictures.currentItemIndex;
        [_itemsImage removeObjectAtIndex:index];
        [_viewForPictures removeItemAtIndex:index animated:YES];
    }
}
-(IBAction)btnPressedSendReport:(id)sender {

    [self actionEmailComposer];
        
}
-(IBAction)btnPressedAddLogs:(id)sender {

    if (_btnCheckUncheck.isSelected) {
        
        [_btnCheckUncheck setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        [_btnCheckUncheck setSelected:NO];
        
    }
    else {
        [_btnCheckUncheck setSelected:YES];
         [_btnCheckUncheck setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    
    }
    
}
#pragma mark -
#pragma mark UIActionSheet methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0)
    {
        iCarouselType type = buttonIndex;
        [UIView beginAnimations:nil context:nil];
        _viewForPictures.type = type;
        [UIView commitAnimations];
    }
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [_itemsImage count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    ALAsset *asset = [self.itemsImage objectAtIndex:index];
 
    UIImageView *imgView;
    UIButton *btn;
    if (view == nil) {
        
        view =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
        [view addSubview:imgView];
        btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [view addSubview:btn];

    }
    
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    CGImageRef iref = [rep fullResolutionImage];
    imgView.image = nil;
    imgView.image = [UIImage imageWithCGImage:iref];
    [btn setBackgroundImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [btn setTag:index];
    [btn addTarget:self action:@selector(removeImage:) forControlEvents:UIControlEventTouchUpInside];



    return view;
}
-(IBAction)removeImage:(id)sender{

     NSInteger index = _viewForPictures.currentItemIndex;
    [_viewForPictures removeItemAtIndex:index animated:YES];
    [_itemsImage removeObjectAtIndex:index];
  
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 0;
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(UIView *)view
{

    return nil;
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * _viewForPictures.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return _wrap;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (_viewForPictures.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
}

#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSNumber *item = (self.itemsImage)[index];
    NSLog(@"Tapped view number: %@", item);
}

- (void)pickAssets:(id)sender
{
    if (!self.itemsImage)
        self.itemsImage = [[NSMutableArray alloc] init];
    
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.maximumNumberOfSelections = 10;
    picker.assetsFilter = [ALAssetsFilter allAssets];
    
    // only allow video clips if they are at least 5s
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(ALAsset* asset, NSDictionary *bindings) {
        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Assets Picker Delegate

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [_itemsImage  addObjectsFromArray:assets];
    [_viewForPictures reloadData];
    
}

#pragma mark - UITextView Delegate 
- (void)textViewDidBeginEditing:(UITextView *)textView {

    if ([_txtViewDescriptions.text isEqualToString:@"Enter bug descriptions in detail"]){
    
        _txtViewDescriptions.text = @"";
        _txtViewDescriptions.textColor = [UIColor blackColor];
    }

}
-(void) textViewDidChange:(UITextView *)textView
{
    if(textView.text.length == 0){
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"Enter bug descriptions in detail";
        [textView resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }

    else {
    
        return YES;
    }
    
    
}

-(void)actionEmailComposer{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:@"ReportaBug"];

        [mailViewController setToRecipients:[NSArray arrayWithObject:@"srits.ashish@gmail.com"]];
        [mailViewController setMessageBody:[NSString stringWithFormat:@"Bug Title: %@\n\nBug Description: %@", _txtFieldTitle.text, _txtViewDescriptions.text] isHTML:NO];

        if ([_itemsImage count]>0) {
            
            for (NSInteger i = 0; i < [_itemsImage count]; i++) {
                
                ALAsset *asset = [_itemsImage objectAtIndex:i];
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                CGImageRef iref = [rep fullResolutionImage];
                UIImage *img = [UIImage imageWithCGImage:iref];
                NSData *myData = UIImagePNGRepresentation(img);
                [mailViewController addAttachmentData:myData mimeType:@"image/jpeg" fileName:[NSString stringWithFormat:@"Image%d.jpg",i]];
                
            }
            
        }
        if ([_btnCheckUncheck isSelected]) {
            
            
            NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"logs/app_error_log.txt"];
            NSData *myData = [NSData dataWithContentsOfFile:filePath];
            [mailViewController addAttachmentData:myData mimeType:documentsDirectory fileName:@"app_error_log.txt"];

        }
       
        [self presentViewController:mailViewController animated:YES completion:nil];
        
    }
    else {
        
        NSLog(@"Device is unable to send email in its current state");
        
    }

    
}



-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
