//
//  leftPannelTableViewController.m
//  ClunkerBunker
//
//  Created by Mindpace on 17/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import "LeftPannelTableViewController.h"
#import "LeftPannelTableViewCell.h"
#import "HomeViewController.h"
#import "EditProfileViewController.h"
#import "CalenderViewController.h"
#import "EventListViewController.h"
#import "SettingsViewController.h"
#import "SignInViewController.h"

@interface LeftPannelTableViewController ()
{
   // leftPannelTableViewCell *cell;
    
    NSArray *menuItems;
}

@end

@implementation LeftPannelTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

     menuItems = @[@"profile", @"home", @"createEvent", @"calender", @"eventList", @"settings", @"logout"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    LeftPannelTableViewCell *cell = (LeftPannelTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UIView * selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:34.0/255.0 green:191.0/255.0 blue:100.0/255.0 alpha:1.0]]; // set color here
    cell.selectedBackgroundView = selectedBackgroundView;
    
    return cell;
}

/*
- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    //destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    
    if ([segue.identifier isEqualToString:@"showHomeView"])
    {
        NSLog(@"%@",self.navigationController.viewControllers);
        
         HomeViewController *homeVC = segue.destinationViewController;
    }
    
    if ([segue.identifier isEqualToString:@"showEditProfile"])
    {
        NSLog(@"%@",self.navigationController.viewControllers);
        
        EditProfileViewController *editVC = segue.destinationViewController;
    }
    
    if ([segue.identifier isEqualToString:@"showCalender"])
    {
        NSLog(@"%@",self.navigationController.viewControllers);
        
        CalenderViewController *calenderVC = segue.destinationViewController;
    }
    
    if ([segue.identifier isEqualToString:@"showHomeView"])
    {
        NSLog(@"%@",self.navigationController.viewControllers);
        
        HomeViewController *homeVC = segue.destinationViewController;
    }
    
    if ([segue.identifier isEqualToString:@"showHomeView"])
    {
        NSLog(@"%@",self.navigationController.viewControllers);
        
        HomeViewController *homeVC = segue.destinationViewController;
    }
    
    if ([segue.identifier isEqualToString:@"showHomeView"])
    {
        NSLog(@"%@",self.navigationController.viewControllers);
        
        HomeViewController *homeVC = segue.destinationViewController;
    }
    
}
 
 

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.splitViewController.preferredDisplayMode=UISplitViewControllerDisplayModePrimaryHidden;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setBackgroundColor:[UIColor colorWithRed:34.0/255.0 green:191.0/255.0 blue:100.0/255.0 alpha:1.0]];
    
    if (indexPath.row == 0)
    {
         [self performSegueWithIdentifier:@"showHomeViewFromLeftPannel" sender:self];
    }
    if (indexPath.row == 1)
    {
        [self performSegueWithIdentifier:@"showEditProfileFromLeftPannel" sender:self];
    }
    if (indexPath.row == 2)
    {
        [self performSegueWithIdentifier:@"showCalenderFromLeftPannel" sender:self];
    }
    if (indexPath.row == 3)
    {
        [self performSegueWithIdentifier:@"showEventListFromLeftPannel" sender:self];
    }
    if (indexPath.row == 4)
    {
        [self performSegueWithIdentifier:@"showSettingsFromLeftPannel" sender:self];
    }
    if (indexPath.row == 5)
    {
        
    }
}
 
 */

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 6)
    {
        UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Do you want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [logoutAlert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [self logOut];
    }
}


-(void)logOut {
    
    [SuperViewController startActivity:self.view];
        
    NSMutableDictionary *logoutDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[self getUserDefaultValueForKey:USERID], USERID, [self getUserDefaultValueForKey:IMEI], @"IMEI", nil];
    NSLog(@"logoutDict: %@",logoutDict);

    NSMutableURLRequest *request = [self prepareUrl:logoutDict suffixOfURL:LOGOUT];
    
    SuperViewController *connectionforRegistration = [[SuperViewController alloc] initWithRequest:request];
    
    [connectionforRegistration setCompletitionBlock:^(id responseObject, NSError *error)
     {
         if (!error)
         {
             NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             NSLog(@"Request Successful, response '%@'", responseStr);
             NSMutableDictionary *jsonResponseDict= [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
             NSLog(@"Response Dictionary:: %@",jsonResponseDict);

             /*{"status":1,"message":"logout successfully."}*/
             
             if ([[jsonResponseDict objectForKey:@"status"] intValue] != 0)
             {
                 [self RemoveUserDefaultValueForKey:USERID];
                 
                 [self deleteAllValuesFromEntity:@"EventsCreatedByMe"];
                 
                 [self performSegueWithIdentifier:@"showSignFromLeftPannel" sender:self];
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:jsonResponseDict[@"message"]
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 [alert show];
                 
                 [SuperViewController stopActivity:self.view];
             }
             
         }
         else
         {
             //There was an error
             
             NSLog(@"error:%@",error);
             [SuperViewController stopActivity:self.view];
         }
         
     }];
    
    [connectionforRegistration start];
    
}

@end
