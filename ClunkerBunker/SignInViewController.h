//
//  ViewController.h
//  ClunkerBunker
//
//  Created by Mindpace on 11/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : SuperViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *txtContainingView;
@property (strong, nonatomic) IBOutlet UITextField *txtSignInEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtSignInPassword;
@property (weak, nonatomic) IBOutlet UIButton *submitBtnOutlet;

- (IBAction)fbBtnSignInAction:(id)sender;
- (IBAction)submitAction:(id)sender;
- (IBAction)registerNewAccountAction:(id)sender;
- (IBAction)forgotPasswordAction:(id)sender;



@end

