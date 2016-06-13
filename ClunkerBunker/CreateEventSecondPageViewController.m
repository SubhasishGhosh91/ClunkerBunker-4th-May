//
//  createEventViewController.m
//  ClunkerBunker
//
//  Created by Mindpace on 15/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import "CreateEventSecondPageViewController.h"
#import "CreateEventThirdPageViewController.h"

@interface CreateEventSecondPageViewController ()

@end

@implementation CreateEventSecondPageViewController
@synthesize eventImage, txtFacebookLink, txtContact, txtWebsite, txtTag1, txtTag2, txtTag3;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.cancelBtnOutlet.layer.cornerRadius = 3.0f;
    self.cancelBtnOutlet.layer.masksToBounds = YES;
    
    txtContact.text = [self.dataFromFirstPageDict objectForKey:@"contact_email"];
    txtFacebookLink.text = [self.dataFromFirstPageDict objectForKey:@"Facebook_link"];
    txtWebsite.text = [self.dataFromFirstPageDict objectForKey:@"website"];
    
    txtTag1.text = [self.dataFromFirstPageDict objectForKey:@"tag1"];
    txtTag2.text = [self.dataFromFirstPageDict objectForKey:@"tag2"];
    txtTag3.text = [self.dataFromFirstPageDict objectForKey:@"tag3"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToCreateEventFirstPageAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelBtnAction:(id)sender {
    
    UIAlertView *cancelAlert = [[UIAlertView alloc] initWithTitle:@"Alert !!" message:@"All data will be lost. Do you want to leave this page?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [cancelAlert show];
}

- (IBAction)upLoadImageFromGalaryButton:(id)sender;
{
    [self.view endEditing:YES];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Image Gallary", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}


- (IBAction)continueToNextPageAction:(id)sender {
    NSString *tmp = @"";
    
    tmp = [txtFacebookLink.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self.dataFromFirstPageDict setObject:tmp forKey:@"Facebook_link"];
    
    tmp = [txtContact.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self.dataFromFirstPageDict setObject:tmp forKey:@"contact_email"];
    
    tmp = [txtWebsite.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self.dataFromFirstPageDict setObject:tmp forKey:@"website"];
    
    tmp = [txtTag1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self.dataFromFirstPageDict setObject:tmp forKey:@"tag1"];
    
    tmp = [txtTag2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self.dataFromFirstPageDict setObject:tmp forKey:@"tag2"];
    
    tmp = [txtTag3.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self.dataFromFirstPageDict setObject:tmp forKey:@"tag3"];
    
    /*if (eventImage.image == nil) {
        [self.dataFromFirstPageDict setObject:@"" forKey:@"UIImagePickerControllerOriginalImage"];
    }
    else {
        [self.dataFromFirstPageDict setObject:eventImage.image forKey:@"UIImagePickerControllerOriginalImage"];
    }*/
    
    [self performSegueWithIdentifier:@"createEventSecondToCreateEventThirdPageSeg" sender:nil];
}

#pragma mark - Alert Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [self performSegueWithIdentifier:@"createEventSecondToHomePageSeg" sender:nil];
    }
}


#pragma mark - Action Sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
#if TARGET_IPHONE_SIMULATOR
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Camera is not available." message:@"Please run on device to open camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
#elif TARGET_OS_IPHONE
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
#endif
        }
            break;
        case 1:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
    }
}

#pragma mark - ImagePicker Delegate

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    eventImage.image = [[UIImage alloc] initWithData:UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],0.3)];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"createEventSecondToCreateEventThirdPageSeg"])
    {
        CreateEventThirdPageViewController *createEventThirdPageSeg = segue.destinationViewController;
        createEventThirdPageSeg.dataFromSecondPageDict = self.dataFromFirstPageDict;
        createEventThirdPageSeg.eventImageFromSecondPage = self.eventImage.image;
        NSLog(@"%@",createEventThirdPageSeg.eventImageFromSecondPage);
    }
}

#pragma mark - Text Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Keyboard Notificaion

-(void)keyboardWillShow:(NSNotification *)notification {
    // Animate the current view out of the way
    
    CGRect keyboardFrameBeginRect = [[[notification userInfo] valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect keyboardFrameEndRect = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (keyboardFrameBeginRect.origin.y == self.view.frame.size.height) {
        // keyboard is still hidden
        
        CGFloat heightChange = (keyboardFrameEndRect.size.height - keyboardFrameBeginRect.size.height);
        // Manage your other frame changes
        if (heightChange == 0) {
            // keyboard height with QuickType is 253.0 in 5s
            [self setViewMovedUp:keyboardFrameEndRect.size.height/253.0 * 250];
        }
        else{
            [self setViewMovedUp:heightChange];
        }
    }
}

-(void)keyboardWillHide:(NSNotification *)notification {
    // (self.view.frame.origin.y - 0) is the height to move down
    [self setViewMovedUp:self.view.frame.origin.y];  // will be a -ve value
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(float)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    
    rect.origin.y -= movedUp;
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

@end
