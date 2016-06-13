//
//  createEventViewController.h
//  ClunkerBunker
//
//  Created by Mindpace on 15/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateEventSecondPageViewController : SuperViewController <UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *eventImage;
@property (strong, nonatomic) IBOutlet UITextField *txtFacebookLink;
@property (strong, nonatomic) IBOutlet UITextField *txtContact;
@property (strong, nonatomic) IBOutlet UITextField *txtWebsite;
@property (strong, nonatomic) IBOutlet UITextField *txtTag1;
@property (strong, nonatomic) IBOutlet UITextField *txtTag2;
@property (strong, nonatomic) IBOutlet UITextField *txtTag3;


@property (strong, nonatomic) IBOutlet UIButton *cancelBtnOutlet;
@property (strong, nonatomic) IBOutlet UIButton *continueBtnOutlet;

- (IBAction)upLoadImageFromGalaryButton:(id)sender;
- (IBAction)backToCreateEventFirstPageAction:(id)sender;
- (IBAction)cancelBtnAction:(id)sender;
- (IBAction)continueToNextPageAction:(id)sender;

@property (strong, nonatomic) NSMutableDictionary *dataFromFirstPageDict;


@end
