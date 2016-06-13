//
//  profileTableViewCell.h
//  ClunkerBunker
//
//  Created by Mindpace on 16/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *eventImgBlurImageVw;

@property (strong, nonatomic) IBOutlet UILabel *lblEeventName;

@property (strong, nonatomic) IBOutlet UIView *usersJoinedEventCountView;

@property (strong, nonatomic) IBOutlet UILabel *lblUserCount;


@end
