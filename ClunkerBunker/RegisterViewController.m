//
//  RegisterViewController.m
//  ClunkerBunker
//
//  Created by Mindpace on 12/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController {
    
    AppDelegate *appDel;
}
@synthesize txtFirstName, txtLastName, txtUserNameOrEmail, txtSignupPassword, txtConfirmPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDel = [[UIApplication sharedApplication] delegate];
    
    self.registrationBtnOutlet.layer.cornerRadius = 5.0f;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Facebook Observations

- (void)observeProfileChange:(NSNotification *)notfication
{
    if ([FBSDKProfile currentProfile]) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:FBSDKProfileDidChangeNotification object:nil];
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"picture.type(large), email,first_name,last_name"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
                 
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
                 
                 [self loginDetailsFromSignUp:loginDict];
                 
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

#pragma mark - Login Web Service

-(void)loginDetailsFromSignUp:(NSMutableDictionary *)signInDict
{
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
                 
                 NSManagedObjectContext *managedObjectContext = [appDel managedObjectContext];
                 
                 NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ProfileDetails"];
                 NSArray *allEvents = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
                 
                 NSManagedObject *profDetails;
                 if (allEvents.count) {
                     profDetails = [allEvents objectAtIndex:0];
                 }
                 else {
                     profDetails = [NSEntityDescription insertNewObjectForEntityForName:@"ProfileDetails" inManagedObjectContext:managedObjectContext];
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
                 if (![managedObjectContext save:&error]) {
                     NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                 }
                 else
                 {
                     NSLog(@"Data added to database successfully");
                 }
                 
                 //------------ Save Events created by me -----------------------
                 
                 NSFetchRequest *fetchRequestForMyEvents = [[NSFetchRequest alloc] initWithEntityName:@"EventsCreatedByMe"];
                 NSArray *myEvents = [[managedObjectContext executeFetchRequest:fetchRequestForMyEvents error:nil] mutableCopy];
                 
                 for (NSManagedObject *managedObject in myEvents)
                 {
                     [managedObjectContext deleteObject:managedObject];
                 }
                 
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

#pragma mark - Button Action

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)fbRegisterBtnAction:(id)sender {
    
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

- (IBAction)normalRegisterBtnAction:(id)sender {
    
    NSMutableDictionary *registerDict = [[NSMutableDictionary alloc] init];
    NSString *tmp = nil;
    
    tmp=[txtFirstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(!tmp.length) {
        UIAlertView *firstNameMissingAlert = [[UIAlertView alloc] initWithTitle:@"First Name Missing !!"
                                                                    message:@"Please enter your first name"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
        [firstNameMissingAlert show];
        return;
    }
    [registerDict setObject:tmp forKey:FIRSTNAME];
    
    tmp=[txtLastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(!tmp.length) {
        UIAlertView *lastNameMissingAlert = [[UIAlertView alloc] initWithTitle:@"Last Name Missing !!"
                                                                        message:@"Please enter your last name"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
        [lastNameMissingAlert show];
        return;
    }
    [registerDict setObject:tmp forKey:LASTNAME];

    
    tmp=[txtUserNameOrEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(!tmp.length || ![self validEmail:tmp]) {
        //check email validation
        UIAlertView *emailInvalidAlert = [[UIAlertView alloc] initWithTitle:@"Invalid Email !!"
                                                                       message:@"Please enter a vaild email"
                                                                      delegate:nil
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil];
        [emailInvalidAlert show];
        return;
    }
    [registerDict setObject:tmp forKey:EMAIL];
    
    if(txtSignupPassword.text.length < 6) {
        
        UIAlertView *passwordShortAlert = [[UIAlertView alloc] initWithTitle:@"Password is too short !!"
                                                                    message:@"Password must be atleast 6 characters"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
        [passwordShortAlert show];
        return;
    }
    if(![txtConfirmPassword.text isEqualToString:txtSignupPassword.text]) {
        
        UIAlertView *passwordMismatchAlert = [[UIAlertView alloc] initWithTitle:@"Password Mismatch !!"
                                                                     message:@"Please enter the same password as above"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
        [passwordMismatchAlert show];
        return;
    }
    [registerDict setObject:txtConfirmPassword.text forKey:PASSWORD];
    
    [registerDict setObject:@"N" forKey:REGISTRATIONTYPE];
    
    NSLog(@"RegDict: %@",registerDict);
    
    [SuperViewController startActivity:self.view];
    
    NSMutableURLRequest *request = [self prepareUrl:registerDict suffixOfURL:REGISTRATION];
    
    SuperViewController *connectionforRegistration = [[SuperViewController alloc] initWithRequest:request];
    
    [connectionforRegistration setCompletitionBlock:^(id responseObject, NSError *error) {
        
        if (!error)
        {
            NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Request Successful, response '%@'", responseStr);
            NSMutableDictionary *jsonResponseDict= [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            NSLog(@"Response Dictionary:: %@",jsonResponseDict);
            
            if ([[jsonResponseDict objectForKey:@"status"] intValue] == 1)
            {
                NSString *userID = [NSString stringWithFormat:@"%@",jsonResponseDict[USERID]];
                [self setUserDefaultValue:userID ForKey:USERID];
                
                NSManagedObjectContext *context = [appDel managedObjectContext];
                
                NSManagedObject *profDetails = [NSEntityDescription insertNewObjectForEntityForName:@"ProfileDetails" inManagedObjectContext:context];
                
                [profDetails setValue:userID forKey:@"userId"];
                [profDetails setValue:[registerDict objectForKey:FIRSTNAME] forKey:@"firstName"];
                [profDetails setValue:[registerDict objectForKey:LASTNAME] forKey:@"lastName"];
                [profDetails setValue:[registerDict objectForKey:EMAIL] forKey:@"email"];
                [profDetails setValue:@"" forKey:@"profileImage"];
                [profDetails setValue:@"N" forKey:@"reg_type"];
                
                NSError *error = nil;
                // Save the object to persistent store
                if (![context save:&error]) {
                    NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                }
                else
                {
                    NSLog(@"Data added to database successfully");
                }
                
                [self addDeviceToken];
            }
            
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:jsonResponseDict[@"message"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
            
            [self performSegueWithIdentifier:@"showRevealViewFromRegister" sender:nil];
            
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

#pragma mark - keyboard movements

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -keyboardSize.height;
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
}

@end
