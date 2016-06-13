//
//  settingsViewController.h
//  ClunkerBunker
//
//  Created by Mindpace on 12/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SettingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *settingsTableView;

@property (weak, nonatomic) IBOutlet UIImageView *barsImgVw;
@property (strong, nonatomic) IBOutlet UIButton *showLeftPannelBtnOutlet;


@end
