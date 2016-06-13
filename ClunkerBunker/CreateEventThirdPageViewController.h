//
//  CreateEventThirdPageViewController.h
//  ClunkerBunker
//
//  Created by Mindpace on 15/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateEventThirdPageViewController : SuperViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *eventImgVw;
@property (strong, nonatomic) IBOutlet UILabel *lblEventName;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UILabel * lblDate;
@property (strong, nonatomic) IBOutlet UILabel * lblStartTime;
@property (strong, nonatomic) IBOutlet UILabel * lblEndTime;
@property (strong, nonatomic) IBOutlet UILabel * lblAddress;
@property (strong, nonatomic) IBOutlet UILabel * lblDescriptionView;

@property (strong, nonatomic) IBOutlet UILabel * lblTag1;
@property (strong, nonatomic) IBOutlet UILabel * lblTag2;
@property (strong, nonatomic) IBOutlet UILabel * lblTag3;
@property (strong, nonatomic) IBOutlet UILabel * lblCost;

@property (strong, nonatomic) IBOutlet UIImageView *eventIconImgVw;
@property (strong, nonatomic) IBOutlet UIButton * btnEvent;
@property (strong, nonatomic) IBOutlet UIImageView *showIconImgVw;
@property (strong, nonatomic) IBOutlet UIButton * btnShow;
@property (strong, nonatomic) IBOutlet UIImageView *meetIconImgVw;
@property (strong, nonatomic) IBOutlet UIButton * btnMeet;

@property (strong, nonatomic) IBOutlet UIImageView *contactEmailImgVw;
@property (strong, nonatomic) IBOutlet UIImageView *websiteImgVw;
@property (strong, nonatomic) IBOutlet UIImageView *facebookPageImgVw;

@property (strong, nonatomic) IBOutlet UIButton *cancelBtnOutlet;

- (IBAction)backAction:(id)sender;
- (IBAction)editAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)submitAction:(id)sender;

@property (strong, nonatomic) NSMutableDictionary *dataFromSecondPageDict;
@property (strong, nonatomic) UIImage *eventImageFromSecondPage;

@end
