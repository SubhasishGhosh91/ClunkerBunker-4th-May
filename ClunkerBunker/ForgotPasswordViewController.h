//
//  forgotPasswordViewController.h
//  ClunkerBunker
//
//  Created by Mindpace on 12/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : SuperViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtEmail;

- (IBAction)backBtnAction:(id)sender;
- (IBAction)sendResetEmailBtnAction:(id)sender;


@end
