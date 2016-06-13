//
//  EditProfileViewController.h
//  ClunkerBunker
//
//  Created by Mindpace on 16/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileViewController : SuperViewController<UISplitViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageVwForBlurImage;
@property (strong, nonatomic) IBOutlet UIImageView *profileImgVw;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextView *txtVwGarrageAddress;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIButton *customBtnSwitchOutlet;
@property (strong, nonatomic) IBOutlet UILabel *lblConnectedViaType;
@property (strong, nonatomic) IBOutlet UILabel *lblConnectedPersonName;
@property (strong, nonatomic) IBOutlet UIButton *btnUnlinkOutlet;
@property (strong, nonatomic) IBOutlet UIImageView *switchImgVw;





- (IBAction)backBtnAction:(id)sender;
- (IBAction) editAction:(id)sender;
- (IBAction) saveAction:(id)sender;
- (IBAction)customBtnSwitchAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *unlinkAction;


@end
