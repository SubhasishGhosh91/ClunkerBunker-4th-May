//
//  RegisterViewController.h
//  ClunkerBunker
//
//  Created by Mindpace on 12/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : SuperViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtUserNameOrEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtSignupPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtConfirmPassword;

@property (strong, nonatomic) IBOutlet UIButton *registrationBtnOutlet;

- (IBAction)backBtnAction:(id)sender;
- (IBAction)fbRegisterBtnAction:(id)sender;
- (IBAction)normalRegisterBtnAction:(id)sender;



@end
