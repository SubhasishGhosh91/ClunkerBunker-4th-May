//
//  CalenderViewController.h
//  ClunkerBunker
//
//  Created by Mindpace on 17/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalenderViewController : SuperViewController<UITableViewDelegate,UITableViewDataSource,UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *barsImgVw;

@property (strong, nonatomic) IBOutlet UITableView *calenderEventTableVw;

@property (strong, nonatomic) IBOutlet UIButton *exportAllToCalenderBtnOutlet;

@property (strong, nonatomic) IBOutlet UIButton *showLeftPannelBtnOutlet;


- (IBAction)exportAllToCalenderAction:(id)sender;

@end
