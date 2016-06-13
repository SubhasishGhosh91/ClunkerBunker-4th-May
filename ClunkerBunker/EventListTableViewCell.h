//
//  EventListTableViewCell.h
//  ClunkerBunker
//
//  Created by Mindpace on 17/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *eventImgVw;

@property (strong, nonatomic) IBOutlet UILabel *lblEventName;

@property (strong, nonatomic) IBOutlet UIView *timeVw;

@property (strong, nonatomic) IBOutlet UILabel *lblTime;

@property (strong, nonatomic) IBOutlet UIView *distanceVw;

@property (strong, nonatomic) IBOutlet UILabel *lblDistance;

@end
