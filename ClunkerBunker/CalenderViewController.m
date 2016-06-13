//
//  CalenderViewController.m
//  ClunkerBunker
//
//  Created by Mindpace on 17/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import "CalenderViewController.h"
#import "CalenderTableViewCell.h"

@interface CalenderViewController ()
{
   // CalenderTableViewCell *cell;
    NSMutableArray *imgArr;
    NSMutableArray *eventArr;
    NSMutableArray *eventTimeArr;
    AppDelegate *appDel;
}

@end

@implementation CalenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDel = [[UIApplication sharedApplication] delegate];
    appDel.leftPannelBarsImgVw = _barsImgVw;
    
    self.exportAllToCalenderBtnOutlet.layer.cornerRadius = 3.0f;
    
    [_showLeftPannelBtnOutlet addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    imgArr = [[NSMutableArray alloc]initWithObjects:@"racingcar_image1.png",@"racingcar_image2.png",@"racingcar_image3.jpg",@"racingcar_image4.jpg", nil];
    
    eventArr = [[NSMutableArray alloc]initWithObjects:@"CARS AND COFFEE",@"GUMBALL 2000",@"SOCIAL EURO",@"RACING", nil];
    
    eventTimeArr = [[NSMutableArray alloc]initWithObjects:@"09 AM",@"12 PM",@"01 PM",@"08 PM", nil];
    
}

#pragma mark - Table View Delegates and Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [eventArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"calenderCell";
    CalenderTableViewCell *cell = (CalenderTableViewCell *)[_calenderEventTableVw dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.calenderEventImgVw.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[imgArr objectAtIndex:indexPath.row]]];
    
    //[cell.calenderEventImgVw addSubview:[self blurView:cell.calenderEventImgVw.bounds]];
    
    cell.lblEventName.text = [eventArr objectAtIndex:indexPath.row];
    
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


- (IBAction)exportAllToCalenderAction:(id)sender {
}
@end
