//
//  settingsViewController.m
//  ClunkerBunker
//
//  Created by Mindpace on 12/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsTableViewCell.h"

@interface SettingsViewController ()
{
     NSMutableArray *sectionTitle;
    SettingsTableViewCell *settingsCell;
    AppDelegate *appDel;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sectionTitle = [[NSMutableArray alloc]initWithObjects:@"GENERAL", @"SOCIAL", @"ABOUT", nil];
    
    appDel = [[UIApplication sharedApplication] delegate];
    appDel.leftPannelBarsImgVw = _barsImgVw;
    
    [_showLeftPannelBtnOutlet addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
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

#pragma mark - Table view Delegates and Data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 4;
    }
    else if(section == 1)
    {
        return 4;
    }
    else
        return 3;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, tableView.frame.size.width, 15)];
    label.textColor = [UIColor colorWithRed:60.0/255.0 green:60.0/255.0 blue:60.0/255.0 alpha:1.0];
    NSString *string = [sectionTitle objectAtIndex:section];
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    //[view setBackgroundColor:[UIColor blackColor]]; //your background color...
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0 || indexPath.row == 1)
        {
            static NSString *cellIdentifier = @"settingsCell1";
            settingsCell = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (indexPath.row == 0)
            {
                settingsCell.lblNameCell1.text = @"Push notifications";
                
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isPushOn"])
                    [settingsCell.cell1SwitchOutlet setOn:YES animated:YES];
                else
                    [settingsCell.cell1SwitchOutlet setOn:NO animated:YES];
                
                [settingsCell.cell1SwitchOutlet addTarget:self action:@selector(switchPushNotification:) forControlEvents:UIControlEventValueChanged];
                
                
                
            }
            if (indexPath.row == 1)
            {
                settingsCell.lblNameCell1.text = @"Location services";
                
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLocationOn"])
                    [settingsCell.cell1SwitchOutlet setOn:YES animated:YES];
                else
                    [settingsCell.cell1SwitchOutlet setOn:NO animated:YES];
                
                [settingsCell.cell1SwitchOutlet addTarget:self action:@selector(switchMap:) forControlEvents:UIControlEventValueChanged];
            }
            
        }
        
        if (indexPath.row == 2 || indexPath.row == 3)
        {
            static NSString *cellIdentifier = @"settingsCell2";
            settingsCell = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (indexPath.row == 2)
            {
                settingsCell.lblNameCell2.text = @"Report an issue";
                
                settingsCell.imageVwCell2.image = [UIImage imageNamed:@"setting-edit.png"];
            }
            
            if (indexPath.row == 3)
            {
                settingsCell.lblNameCell2.text = @"My account";
                
                settingsCell.imageVwCell2.frame = CGRectMake(settingsCell.imageVwCell2.frame.origin.x, settingsCell.imageVwCell2.frame.origin.y, 25, 20);
                settingsCell.imageVwCell2.image = [UIImage imageNamed:@"setting-next.png"];
            }
        }
        
    }
    
    if (indexPath.section == 1)
    {
        static NSString *cellIdentifier = @"settingsCell2";
        settingsCell = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (indexPath.row == 0)
        {
            settingsCell.lblNameCell2.text = @"Like us on Facebook";
            
            settingsCell.imageVwCell2.frame = CGRectMake(settingsCell.imageVwCell2.frame.origin.x, settingsCell.imageVwCell2.frame.origin.y, 12, 25);
            settingsCell.imageVwCell2.image = [UIImage imageNamed:@"fb-setting.png"];
        }
        
        if (indexPath.row == 1)
        {
            settingsCell.lblNameCell2.text = @"Follow us on Twitter";
            
            settingsCell.imageVwCell2.frame = CGRectMake(settingsCell.imageVwCell2.frame.origin.x-3, settingsCell.imageVwCell2.frame.origin.y, 23, 20);
            settingsCell.imageVwCell2.image = [UIImage imageNamed:@"setting-twt.png"];
        }
        
        if (indexPath.row == 2)
        {
            settingsCell.lblNameCell2.text = @"Share with us on Instagram";
            
            settingsCell.imageVwCell2.image = [UIImage imageNamed:@"setting-ins.png"];
        }
        
        if (indexPath.row == 3)
        {
            settingsCell.lblNameCell2.text = @"Review us on the App Store";
            
            settingsCell.imageVwCell2.image = [UIImage imageNamed:@"setting-msg.png"];
        }
    }
    
    if (indexPath.section == 2)
    {
        static NSString *cellIdentifier = @"settingsCell2";
        settingsCell = (SettingsTableViewCell *)[_settingsTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        settingsCell.imageVwCell2.frame = CGRectMake(settingsCell.imageVwCell2.frame.origin.x, settingsCell.imageVwCell2.frame.origin.y, 25, 20);
        if (indexPath.row == 0)
        {
            settingsCell.lblNameCell2.text = @"Help";
            
            settingsCell.imageVwCell2.image = [UIImage imageNamed:@"setting-next.png"];
        }
        
        if (indexPath.row == 1)
        {
            settingsCell.lblNameCell2.text = @"Privacy";
            
            settingsCell.imageVwCell2.image = [UIImage imageNamed:@"setting-next.png"];
        }
        
        if (indexPath.row == 2)
        {
            settingsCell.lblNameCell2.text = @"Terms of Service";
            
            settingsCell.imageVwCell2.image = [UIImage imageNamed:@"setting-next.png"];
        }
        
    }
    
    return settingsCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 2)
        {
            MFMailComposeViewController * mailComposer = [[MFMailComposeViewController alloc]init];
            mailComposer.mailComposeDelegate = self;
            [mailComposer setSubject:@""];
            [mailComposer setMessageBody:@"" isHTML:NO];
            [self presentViewController:mailComposer animated:YES completion:nil];
            
        }
        if (indexPath.row == 3)
        {
            [self performSegueWithIdentifier:@"settingsToProfileSeg" sender:nil];
            
        }
    }
}

#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
        NSLog(@"Result : %d",result);
    }
    if (error) {
        NSLog(@"Error : %@",error);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - switchButton for Update ON or OFF

-(void)switchPushNotification:(UISwitch *)mySwitch
{
    if ([mySwitch isOn])
    {
        NSLog(@"Notification on!");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPushOn"];
        
    } else {
        NSLog(@"Notification off!");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isPushOn"];
        
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)switchMap:(UISwitch *)mySwitch
{
    if ([mySwitch isOn])
    {
        NSLog(@"Notification on!");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLocationOn"];
        
    } else {
        NSLog(@"Notification off!");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLocationOn"];
        
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


@end
