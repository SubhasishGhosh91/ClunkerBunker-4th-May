//
//  profileViewController.h
//  ClunkerBunker
//
//  Created by Mindpace on 16/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : SuperViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *barsImgVw;

@property (strong, nonatomic) IBOutlet UIImageView *profileImgBlurImgVw;
@property (strong, nonatomic) IBOutlet UIImageView *userProfileImgVw;
@property (strong, nonatomic) IBOutlet UIView *showLikeRatingCountVw;
@property (strong, nonatomic) IBOutlet UILabel *lblLikeCount;
@property (strong, nonatomic) IBOutlet UILabel *lblJoinedEventCount;
@property (strong, nonatomic) IBOutlet UILabel *lblFavouritesCount;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UITableView *attendedEventTableView;
@property (strong, nonatomic) IBOutlet UIButton *showLeftPannelBtnOutlet;



- (IBAction)profileEditAction:(id)sender;




@end
