//
//  ViewController.m
//  ClunkerBunker
//
//  Created by Mindpace on 11/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()
{
    AppDelegate *appDel;
}
@end

@implementation SignInViewController
@synthesize txtContainingView,txtSignInEmail,txtSignInPassword,submitBtnOutlet;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERID]) {
        //if already logged  in then just open HomeVC
        [self performSegueWithIdentifier:@"showRevealViewFromSignIn" sender:nil];
    }
    
    appDel = [[UIApplication sharedApplication] delegate];
    
    txtContainingView.layer.cornerRadius = 5.0f;
    self.submitBtnOutlet.layer.cornerRadius = 5.0f;
    
    ///****DEVICE IMEI****
    NSString *UDID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [self setUserDefaultValue:UDID ForKey:IMEI];
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Facebook Observations

- (void)observeProfileChange:(NSNotification *)notfication
{
    if ([FBSDKProfile currentProfile]) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:FBSDKProfileDidChangeNotification object:nil];
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"picture.type(large), email,first_name,last_name"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 [SuperViewController stopActivity:self.view];
                 
                 NSLog(@"fetched user:%@", result);
                 /*
                  {
                  "first_name" = Andy;
                  id = 115544762194939;
                  "last_name" = Jones;
                  picture =     {
                  data =         {
                  "is_silhouette" = 0;
                  url = "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xft1/v/t1.0-1/p200x200/13240620_115171585565590_9193365495661852457_n.jpg?oh=3ae675f2843abbf6c8a04f6078b9ce4f&oe=57D1D9DF&__gda__=1474414230_6e43cc99814f96a7439555b509d221ba";
                  };
                  };
                  }
                  */
                 
                 NSMutableDictionary *loginDict = [[NSMutableDictionary alloc]init];
                 if (result[@"email"] == nil)
                 {
                     [loginDict setObject:@"" forKey:EMAIL];
                 }
                 else
                 {
                     [loginDict setObject:result[@"email"] forKey:EMAIL];
                 }
                 [loginDict setObject:result[@"id"] forKey:UNIQUEUSERID];
                 [loginDict setObject:@"F" forKey:REGISTRATIONTYPE];
                 [loginDict setObject:result[@"first_name"] forKey:FIRSTNAME];
                 [loginDict setObject:result[@"last_name"] forKey:LASTNAME];
                 [loginDict setObject:result[@"picture"][@"data"][@"url"] forKey:PROFILEIMAGE];
                 [loginDict setObject:[self getUserDefaultValueForKey:IMEI] forKey:IMEI];
                 [loginDict setObject:@"" forKey:PASSWORD];
                 
                 [self loginDetailsFromSignIn:loginDict];
                 
             }  else {
                 NSLog(@"FBError: %@",error);
                 [SuperViewController stopActivity:self.view];
             }
             
         }];
    }
}

- (void)observeTokenChange:(NSNotification *)notfication {
    if (![FBSDKAccessToken currentAccessToken]) {
        
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:FBSDKAccessTokenDidChangeNotification object:nil];
        [self observeProfileChange:nil];
    }
}

#pragma mark - Button Action

- (IBAction)fbBtnSignInAction:(id)sender {
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:FBSDKAccessTokenDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:FBSDKProfileDidChangeNotification object:nil];
        //[self observeProfileChange:nil];
    }
    else {
        [SuperViewController startActivity:self.view];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeTokenChange:) name:FBSDKAccessTokenDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeProfileChange:) name:FBSDKProfileDidChangeNotification object:nil];
        
        NSArray *requiredPermissions = @[@"email"]; //@"user_friends"
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        
        [login logInWithReadPermissions:requiredPermissions
                     fromViewController:nil
                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                    if (error) {
                                        // Process error
                                        [SuperViewController stopActivity:self.view];
                                    } else if (result.isCancelled) {
                                        // Handle cancellations
                                        [SuperViewController stopActivity:self.view];
                                    } else {
                                        // If you ask for multiple permissions at once, you
                                        // should check if specific permissions missing
                                        if ([result.grantedPermissions containsObject:requiredPermissions]) {
                                            // Do work
                                        }
                                    }
                                }];
    }
}

- (IBAction)submitAction:(id)sender
{
    
    NSMutableDictionary *signInDict = [[NSMutableDictionary alloc]init];
    NSString *tmp = nil;
    
    tmp=[txtSignInEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(!tmp.length) {
        
        UIAlertView *emailMissingAlert = [[UIAlertView alloc] initWithTitle:@"Email Missing !!"
                                                                   message:@"Please enter your email"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
        [emailMissingAlert show];
        return;
    }
    [signInDict setObject:tmp forKey:EMAIL];
    
    tmp=[txtSignInPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(!tmp.length) {
        UIAlertView *passwordMissingAlert = [[UIAlertView alloc] initWithTitle:@"Password Missing !!"
                                                                    message:@"Please enter your password"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
        [passwordMissingAlert show];
        return;
    }
    [signInDict setObject:tmp forKey:PASSWORD];
    [signInDict setObject:[self getUserDefaultValueForKey:IMEI] forKey:IMEI];
    [signInDict setObject:@"N" forKey:REGISTRATIONTYPE];

    [signInDict setObject:@"" forKey:PROFILEIMAGE];
    [signInDict setObject:@"" forKey:UNIQUEUSERID];
    [signInDict setObject:@"" forKey:FIRSTNAME];
    [signInDict setObject:@"" forKey:LASTNAME];
    
    [self loginDetailsFromSignIn:signInDict];
}

- (IBAction)registerNewAccountAction:(id)sender {
}

- (IBAction)forgotPasswordAction:(id)sender {
}

#pragma mark - Login Web Service

-(void)loginDetailsFromSignIn:(NSMutableDictionary *)signInDict
{
    [SuperViewController startActivity:self.view];
    
    NSMutableURLRequest *request = [self prepareUrl:signInDict suffixOfURL:LOGIN];
    
    SuperViewController *connectionforRegistration = [[SuperViewController alloc] initWithRequest:request];
    
    [connectionforRegistration setCompletitionBlock:^(id responseObject, NSError *error)
     {
         if (!error)
         {
             NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             NSLog(@"Request Successful, response '%@'", responseStr);
             NSMutableDictionary *jsonResponseDict= [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
             NSLog(@"Response Dictionary:: %@",jsonResponseDict);
             
             /*
              {"status":"2","message":"successfully logged in.","response":{"user_details":{"UserID":"1","unique_userid":"aviru.bhattacharjee@mindpacetech.com","FirstName":"avi","LastName":"bhattacharjee","Email":"aviru.bhattacharjee@mindpacetech.com","ProfileImage":"","PrivateProfile":"Yes","reg_type":"N","FacebookConnect":"No","City":"","Country":"","deviceToken":"N"},"user_event_details":[{"event_id":"29","event_name":"NFS2","event_date":"2016-04-11","event_address":"newtown,kolkata","latitude":"22.5765243","longitude":"88.4796344","start_time":"03:08 PM","end_time":"05:08 PM","cost":"10","event_details":"etc","event_type":"event","contact_email":"syed.aniruddha@gmail.com","Facebook_link":"","website":"www.clunkerbunker.com","tag1":"Euro","tag2":"Carsandcoffee","tag3":"Meet"},{"event_id":"30","event_name":"cars and cofee","event_date":"2016-05-12","event_address":"technopolish,saltlake,koolkata","latitude":"22.5800708","longitude":"88.438096","start_time":"12:36 PM","end_time":"01:36 PM","cost":"20","event_details":"car ridding in technopolish","event_type":"event","contact_email":"syed.aniruddha@gmail.com","Facebook_link":"","website":"www.clunkerbunker.com","tag1":"Euro","tag2":"Carsandcoffee","tag3":"Meet"}]}}
              */
             
             if ([[jsonResponseDict objectForKey:@"status"] intValue] != 0)
             {
                 [self setUserDefaultValue:jsonResponseDict[@"response"][@"user_details"][USERID] ForKey:USERID];
                 
                 //------------ Save My Profile Details -----------------------

                 NSArray *allEvents = [self showAllValuesForEntity:@"ProfileDetails"];
                 
                 NSManagedObject *profDetails;
                 if (allEvents.count) {
                     profDetails = [allEvents objectAtIndex:0];
                 }
                 else {
                     profDetails = [NSEntityDescription insertNewObjectForEntityForName:@"ProfileDetails" inManagedObjectContext:[appDel managedObjectContext]];
                 }

                 [profDetails setValue:jsonResponseDict [@"response"][@"user_details"][USERID] forKey:@"userId"];
                 [profDetails setValue:jsonResponseDict [@"response"][@"user_details"][FIRSTNAME] forKey:@"firstName"];
                 [profDetails setValue:jsonResponseDict [@"response"][@"user_details"][LASTNAME] forKey:@"lastName"];
                 if (jsonResponseDict [@"response"][@"user_details"][EMAIL])
                 {
                     [profDetails setValue:jsonResponseDict [@"response"][@"user_details"][EMAIL] forKey:@"email"];
                 }
                 else
                     [profDetails setValue:@"" forKey:@"email"];
                 
                 [profDetails setValue:jsonResponseDict [@"response"][@"user_details"][REGISTRATIONTYPE] forKey:REGISTRATIONTYPE];
                 
                 [profDetails setValue:jsonResponseDict [@"response"][@"user_details"][PROFILEIMAGE] forKey:@"profileImage"];
                 
                 NSError *error = nil;
                 // Save the object to persistent store
                 if (![[appDel managedObjectContext] save:&error]) {
                     NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                 }
                 else
                 {
                     NSLog(@"Data added to database successfully");
                 }
                 
                 //------------ Save Events created by me -----------------------
                 
                 [self deleteAllValuesFromEntity:@"EventsCreatedByMe"];
                
                 //for Event Table datastore

                 for (NSDictionary *myEvent in jsonResponseDict[@"response"][@"user_event_details"]) {
                     
                     NSManagedObject *myEventDetails = [NSEntityDescription insertNewObjectForEntityForName:@"EventsCreatedByMe" inManagedObjectContext:[appDel managedObjectContext]];
                     
                     [myEventDetails setValue:myEvent[@"event_name"] forKey:@"eventName"];
                     [myEventDetails setValue:myEvent[@"event_type"] forKey:@"eventType"];
                     [myEventDetails setValue:myEvent[@"event_date"] forKey:@"eventDate"];
                     [myEventDetails setValue:myEvent[@"start_time"] forKey:@"eventStartTime"];
                     [myEventDetails setValue:myEvent[@"end_time"] forKey:@"eventEndTime"];
                     [myEventDetails setValue:myEvent[@"event_address"] forKey:@"eventAddress"];
                     [myEventDetails setValue:myEvent[@"cost"] forKey:@"eventCost"];
                     [myEventDetails setValue:myEvent[@"event_details"] forKey:@"eventDesc"];
                     
                     [myEventDetails setValue:myEvent[@"Facebook_link"] forKey:@"eventFacebookPage"];
                     [myEventDetails setValue:myEvent[@"contact_email"] forKey:@"eventContactMail"];
                     [myEventDetails setValue:myEvent[@"website"] forKey:@"eventWebsite"];
                     [myEventDetails setValue:myEvent[@"tag1"] forKey:@"eventTag1"];
                     [myEventDetails setValue:myEvent[@"tag2"] forKey:@"eventTag2"];
                     [myEventDetails setValue:myEvent[@"tag3"] forKey:@"eventTag3"];
                     
                     // Save the object to persistent store
                     if (![[appDel managedObjectContext] save:&error]) {
                         NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                     }
                     else
                     {
                         NSLog(@"Data added to database successfully");
                     }
                     
                 }

                 
                 
                 [self addDeviceToken];
             }
             else
             {
                 [SuperViewController stopActivity:self.view];
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:jsonResponseDict[@"message"]
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 [alert show];
                 
                 
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

#pragma mark - Adding Device Token

- (void)addDeviceToken
{
    NSMutableDictionary *deviceTokenDict = [[NSMutableDictionary alloc] init];
    
    [deviceTokenDict setObject:[self getUserDefaultValueForKey:USERID] forKey:USERID];
    [deviceTokenDict setObject:@"Iphone" forKey:DEVICETYPE];
    [deviceTokenDict setObject:[self getUserDefaultValueForKey:IMEI] forKey:IMEI]; //2847D1F5-5BEF-4A0C-8274-4CAE75B52B1D
    
#if TARGET_IPHONE_SIMULATOR
    // Simulator
    [deviceTokenDict setObject:@"fe3c1c39fb267847300fd9bd5fb30fc3df6a22c5d00f59743c138bfe15429d48" forKey:DEVICETOKEN];
#else
    // iPhones
    [deviceTokenDict setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:DEVICETOKEN]] forKey:DEVICETOKEN];
#endif
    
    NSMutableURLRequest *request = [self prepareUrl:deviceTokenDict suffixOfURL:ADDDEVICETOKEN];
    
    SuperViewController *connectionforAddDeviceToken = [[SuperViewController alloc] initWithRequest:request];
    
    [connectionforAddDeviceToken setCompletitionBlock:^(id responseObject, NSError *error) {
        
        if (!error)
        {
            NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Request Successful, response '%@'", responseStr);
            NSMutableDictionary *jsonResponseDict= [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            NSLog(@"Response Dictionary:: %@",jsonResponseDict);
            
            [self setUserDefaultValue:@"YES" ForKey:ISLOGGEDIN];
            
            [SuperViewController stopActivity:self.view];
            
            [self performSegueWithIdentifier:@"showRevealViewFromSignIn" sender:self];
            
        }
        else
        {
            //There was an error
            NSLog(@"error:%@",error);
            [SuperViewController stopActivity:self.view];
        }
        
    }];
    
    [connectionforAddDeviceToken start];
    
}


#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Keyboard Notificaion

-(void)keyboardWillShow:(NSNotification *)notification {
    // Animate the current view out of the way
    
    CGRect keyboardFrameBeginRect = [[[notification userInfo] valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect keyboardFrameEndRect = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (keyboardFrameBeginRect.origin.y == self.view.frame.size.height) {
        // keyboard is still hidden
        
        CGFloat heightChange = (keyboardFrameEndRect.size.height - keyboardFrameBeginRect.size.height);
        // Manage your other frame changes
        if (heightChange == 0) {
            // keyboard height with QuickType is 253.0 in 5s
            [self setViewMovedUp:keyboardFrameEndRect.size.height/253.0 * 120];
        }
        else {
            [self setViewMovedUp:heightChange];
        }
    }
}

-(void)keyboardWillHide:(NSNotification *)notification {
    // (self.view.frame.origin.y - 0) is the height to move down
    [self setViewMovedUp:self.view.frame.origin.y];  // will be a -ve value
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(float)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    
    rect.origin.y -= movedUp;
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

@end
