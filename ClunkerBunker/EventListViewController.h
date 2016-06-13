//
//  EventListViewController.h
//  ClunkerBunker
//
//  Created by Mindpace on 17/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventListViewController : SuperViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *barsImgVw;

@property (strong, nonatomic) IBOutlet UISearchBar *searchEvent;
@property (strong, nonatomic) IBOutlet UITableView *eventTableVw;
@property (strong, nonatomic) IBOutlet UIProgressView *distanceProgressBar;
@property (strong, nonatomic) IBOutlet UILabel *lblDistance;
@property (strong, nonatomic) IBOutlet UIButton *showLeftPannelBtnOutlet;


@end
