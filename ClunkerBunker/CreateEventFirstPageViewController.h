//
//  createEventFirstPageViewController.h
//  ClunkerBunker
//
//  Created by Mindpace on 15/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EventsCreatedByMe.h"

@interface CreateEventFirstPageViewController : SuperViewController <UITextFieldDelegate,UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *showLeftPannelBtnOutlet;
@property (strong, nonatomic) IBOutlet UIPickerView *saveEventsPicker;

@property (weak, nonatomic) IBOutlet UIImageView *barsImgVw;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollVw;

@property (strong, nonatomic) IBOutlet UIButton *savedEventsDropDownOutlet;
@property (strong, nonatomic) IBOutlet UIButton *eventBtnOutlet;
@property (strong, nonatomic) IBOutlet UIImageView *eventIconImgVw;
@property (strong, nonatomic) IBOutlet UIButton *showBtnOutlet;
@property (strong, nonatomic) IBOutlet UIImageView *showIconImgVw;
@property (strong, nonatomic) IBOutlet UIButton *meetBtnOutlet;
@property (strong, nonatomic) IBOutlet UIImageView *meetIconImgVw;

@property (strong,nonatomic)  IBOutlet UITextField * txtNameofEvent;
@property (strong, nonatomic) IBOutlet UIImageView *eventNameTickOrCrossImgVw;

@property (strong, nonatomic) IBOutlet UIDatePicker *eventDatePicker;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UIImageView *dateTickOrCrossImgVw;
@property (strong, nonatomic) IBOutlet UIDatePicker *eventTimePicker;
@property (strong, nonatomic) IBOutlet UILabel *lblStartingTime;
@property (strong, nonatomic) IBOutlet UILabel *lblEndTime;
@property (strong, nonatomic) IBOutlet UIImageView *timeTickOrCrossImgVw;

@property (strong, nonatomic) IBOutlet UITextField *txtAddress;
@property (strong, nonatomic) IBOutlet UIImageView *addressTickOrCrossImgVw;
@property (strong, nonatomic) IBOutlet UITextField *txtCost;
@property (strong, nonatomic) IBOutlet UIImageView *costTickOrCrossImgVw;

@property (strong, nonatomic) IBOutlet UIImageView *descriptionTickOrCrossImgVw;
@property (strong, nonatomic) IBOutlet UITextView *txtViewDescription;

@property (strong, nonatomic) IBOutlet UIButton *cancelBtnOutlet;
@property (strong, nonatomic) IBOutlet UIButton *continueBtnOutlet;

@property (strong, nonatomic) IBOutlet UIView *myPickerContainerVw;

@property (strong, nonatomic) IBOutlet UIToolbar *toolBarOutlet;

- (IBAction)savedEventsDropDownAction:(id)sender;

- (IBAction)eventAction:(id)sender;
- (IBAction)showAction:(id)sender;
- (IBAction)meetAction:(id)sender;

- (IBAction)showTimePickerforStartTimeAction:(id)sender;
- (IBAction)showTimePickerforEndTimeAction:(id)sender;
- (IBAction)pickDateAction:(id)sender;

- (IBAction)cancelAction:(id)sender;
- (IBAction)continueAction:(id)sender;

- (IBAction)toolbarCancelBtnAction:(id)sender;

@end
