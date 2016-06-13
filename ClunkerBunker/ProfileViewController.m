//
//  profileViewController.m
//  ClunkerBunker
//
//  Created by Mindpace on 16/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileTableViewCell.h"

@interface ProfileViewController ()
{
    ProfileTableViewCell *profileCell;
    NSMutableArray *imgArr;
    NSMutableArray *eventArr;
     AppDelegate *appDel;
}

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _profileImgBlurImgVw.image = [UIImage imageNamed:@"nature.png"];
    [_profileImgBlurImgVw addSubview:[self blurView:_profileImgBlurImgVw.bounds]];
    
    imgArr = [[NSMutableArray alloc]initWithObjects:@"racingcar_image1.png",@"racingcar_image2.png",@"racingcar_image3.jpg",@"racingcar_image4.jpg", nil];
    
    eventArr = [[NSMutableArray alloc]initWithObjects:@"CARS AND COFFEE",@"GUMBALL 2000",@"SOCIAL EURO",@"RACING", nil];
    
   
    appDel = [[UIApplication sharedApplication] delegate];
    appDel.leftPannelBarsImgVw = _barsImgVw;
    
    [_showLeftPannelBtnOutlet addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

#pragma mark - Table View Delegates and Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [eventArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"profileCell";
    profileCell = (ProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    profileCell.eventImgBlurImageVw.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[imgArr objectAtIndex:indexPath.row]]];
    
    [profileCell.eventImgBlurImageVw addSubview:[self blurView:profileCell.eventImgBlurImageVw.bounds]];
    
    profileCell.lblEeventName.text = [eventArr objectAtIndex:indexPath.row];
    
    return profileCell;
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


- (IBAction)profileEditAction:(id)sender {
}
@end
