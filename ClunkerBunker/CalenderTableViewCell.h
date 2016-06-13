//
//  CalenderTableViewCell.h
//  ClunkerBunker
//
//  Created by Mindpace on 17/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalenderTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *calenderEventImgVw;

@property (strong, nonatomic) IBOutlet UILabel *lblEventName;

@property (strong, nonatomic) IBOutlet UILabel *lblEventStartingTime;

@property (strong, nonatomic) IBOutlet UIView *usersCountVw;

@property (strong, nonatomic) IBOutlet UILabel *lblUserCount;


@end
