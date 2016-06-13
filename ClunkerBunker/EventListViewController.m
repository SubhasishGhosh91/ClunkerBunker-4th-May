//
//  EventListViewController.m
//  ClunkerBunker
//
//  Created by Mindpace on 17/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import "EventListViewController.h"
#import "EventListTableViewCell.h"

@interface EventListViewController ()
{
    NSMutableArray *imgArr;
    NSMutableArray *eventArr;
    NSMutableArray *eventTimeArr;
    NSMutableArray *weekDayArr;
    AppDelegate *appDel;
}

@end

@implementation EventListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    appDel = [[UIApplication sharedApplication] delegate];
    appDel.leftPannelBarsImgVw = _barsImgVw;
    
    [_showLeftPannelBtnOutlet addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    imgArr = [[NSMutableArray alloc]initWithObjects:@"racingcar_image1.png",@"racingcar_image2.png",@"racingcar_image3.jpg",@"racingcar_image4.jpg", nil];
    eventArr = [[NSMutableArray alloc]initWithObjects:@"CARS AND COFFEE",@"GUMBALL 2000",@"SOCIAL EURO",@"RACING", nil];
    eventTimeArr = [[NSMutableArray alloc]initWithObjects:@"09 AM",@"12 PM",@"01 PM",@"08 PM", nil];
    
    weekDayArr = [[NSMutableArray alloc]initWithObjects:@"MONDAY JAN 11",@"TUESDAY JAN 12",@"FRIDAY JAN 15",@"SATURDAY JAN 20", nil];
   
}

#pragma mark - Table View Delegates and Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [eventArr count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [weekDayArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 15)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, tableView.frame.size.width, 14)];
    label.textColor = [UIColor colorWithRed:124.0/255.0 green:124.0/255.0 blue:124.0/255.0 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"MyriadPro-Regular" size:10.0f];
    NSString *string = [weekDayArr objectAtIndex:section];
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    //[view setBackgroundColor:[UIColor blackColor]]; //your background color...
    
    return view;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"eventListCell";
    EventListTableViewCell *cell = (EventListTableViewCell *)[_eventTableVw dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.eventImgVw.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[imgArr objectAtIndex:indexPath.row]]];
    
    //[cell.eventImgVw addSubview:[self blurView:cell.eventImgVw.bounds]];
    
    cell.lblEventName.text = [eventArr objectAtIndex:indexPath.row];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
