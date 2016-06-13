//
//  forgotPasswordViewController.m
//  ClunkerBunker
//
//  Created by Mindpace on 12/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController
@synthesize txtEmail;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Button Action

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendResetEmailBtnAction:(id)sender {
    
    NSMutableDictionary *forgotPassDict = [[NSMutableDictionary alloc] init];
    NSString *tmp = nil;
    
    tmp=[txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(!tmp.length || ![self validEmail:tmp]) {
        //check email validation
        UIAlertView *emailInvalidAlert = [[UIAlertView alloc] initWithTitle:@"Invalid Email !!"
                                                                    message:@"Please enter a vaild email"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
        [emailInvalidAlert show];
        return;
    }
    [forgotPassDict setObject:txtEmail.text forKey:EMAIL];

    [SuperViewController startActivity:self.view];
    
    NSMutableURLRequest *request = [self prepareUrl:forgotPassDict suffixOfURL:FORGOTPASSWORD];
    
    SuperViewController *connectionforRegistration = [[SuperViewController alloc] initWithRequest:request];
    
    [connectionforRegistration setCompletitionBlock:^(id responseObject, NSError *error)
     {
         if (!error)
         {
             NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             NSLog(@"Request Successful, response '%@'", responseStr);
             NSMutableDictionary *jsonResponseDict= [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
             NSLog(@"Response Dictionary:: %@",jsonResponseDict);
             
             if ([[jsonResponseDict objectForKey:@"status"] intValue] == 1)
             {
                 UIAlertView *emailInvalidAlert = [[UIAlertView alloc] initWithTitle:@""
                                                                             message:@"Password has been sent to your registered email"
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                 [emailInvalidAlert show];
             }
             
         }
         else
         {
             //There was an error
             
             NSLog(@"error:%@",error);
             [SuperViewController stopActivity:self.view];
         }
         
     }];
    
    [connectionforRegistration start];
}

@end
