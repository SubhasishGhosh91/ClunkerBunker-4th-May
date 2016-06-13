//
//  EditProfileViewController.m
//  ClunkerBunker
//
//  Created by Mindpace on 16/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()
{
    BOOL isSwitchBtnOn;
}

@end

@implementation EditProfileViewController
@synthesize lblConnectedViaType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isSwitchBtnOn = YES;
    
    _imageVwForBlurImage.image = [UIImage imageNamed:@"nature.png"];
    [_imageVwForBlurImage addSubview:[self blurView:_imageVwForBlurImage.bounds]];
    
    lblConnectedViaType.layer.cornerRadius = 5.0f;
    lblConnectedViaType.layer.borderColor = [UIColor colorWithRed:62.0f/255.0f green:112.0f/255.0f blue:229.0f/255.0f alpha:1.0f].CGColor;
    lblConnectedViaType.layer.borderWidth = 1.0f;
    
    
    
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


- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) editAction:(id)sender {
    
}
- (IBAction) saveAction:(id)sender {
    
}

- (IBAction)customBtnSwitchAction:(id)sender
{
   /* if (isSwitchBtnOn)
    {
        [_customBtnSwitchOutlet setBackgroundImage:[UIImage imageNamed:@"switch.png"] forState:UIControlStateNormal];
    }
    else
    {
      [_customBtnSwitchOutlet setBackgroundImage:[UIImage imageNamed:@"switch-gray.png"] forState:UIControlStateNormal];
    }
    
    
    [UIView animateWithDuration:1.0 animations:^{
        _customBtnSwitchOutlet.layer.transform = CATransform3DMakeRotation(M_PI,0.0,1.0,0.0);
    } completion:^(BOOL finished)
    {
        // code to be executed when flip is completed
        
        if (isSwitchBtnOn)
        {
            [_customBtnSwitchOutlet setBackgroundImage:[UIImage imageNamed:@"switch.png"] forState:UIControlStateNormal];
        }
        else
        {
            [_customBtnSwitchOutlet setBackgroundImage:[UIImage imageNamed:@"switch-gray.png"] forState:UIControlStateNormal];
        }
    }];
    */
    
    if (isSwitchBtnOn)
    {
        self.switchImgVw.image = [UIImage imageNamed:@"switch.png"];
        
        isSwitchBtnOn = NO;
    }
    else
    {
        self.switchImgVw.image = [UIImage imageNamed:@"switch-gray.png"];
        
        isSwitchBtnOn = YES;
    }
    
    
    
}
@end
