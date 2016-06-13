//
//  CreateEventThirdPageViewController.m
//  ClunkerBunker
//
//  Created by Mindpace on 15/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import "CreateEventThirdPageViewController.h"
#import "CreateEventSecondPageViewController.h"
#import "CreateEventFirstPageViewController.h"
#import "HomeViewController.h"

@interface CreateEventThirdPageViewController ()

@end

@implementation CreateEventThirdPageViewController {
    AppDelegate *appDel;
    NSMutableDictionary *responseDict;
}
@synthesize scrollView,eventImgVw,lblEventName,lblDate,lblStartTime,lblEndTime,lblAddress,lblDescriptionView,lblTag1,lblTag2,lblTag3,lblCost,btnEvent,btnShow,btnMeet,eventIconImgVw,showIconImgVw,meetIconImgVw,contactEmailImgVw,websiteImgVw,facebookPageImgVw,dataFromSecondPageDict;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.cancelBtnOutlet.layer.cornerRadius = 3.0f;
    self.cancelBtnOutlet.layer.masksToBounds = YES;
    
    eventImgVw.image = self.eventImageFromSecondPage;
    
    lblEventName.attributedText = [self firstLetterBigger:[dataFromSecondPageDict objectForKey:@"event_name"] forLabel:lblEventName];
    
    lblDate.text = [dataFromSecondPageDict objectForKey:@"event_date"];
    lblStartTime.text = [dataFromSecondPageDict objectForKey:@"start_time"];
    lblEndTime.text = [dataFromSecondPageDict objectForKey:@"end_time"];
    lblAddress.text = [dataFromSecondPageDict objectForKey:@"event_address"];
    lblDescriptionView.text = [dataFromSecondPageDict objectForKey:@"event_details"];
   
    lblCost.text = [dataFromSecondPageDict objectForKey:@"cost"];
    
    lblTag1.text = [dataFromSecondPageDict objectForKey:@"tag1"];
    lblTag2.text = [dataFromSecondPageDict objectForKey:@"tag2"];
    lblTag3.text = [dataFromSecondPageDict objectForKey:@"tag3"];
    
    [self setEventType:[dataFromSecondPageDict objectForKey:@"event_type"]];
    
    NSString *contactEmail = [[dataFromSecondPageDict objectForKey:@"contact_email"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (contactEmail.length > 0) {
        contactEmailImgVw.hidden = NO;
    }
    
    NSString *websiteUrl = [[dataFromSecondPageDict objectForKey:@"website"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (websiteUrl.length > 0) {
        websiteImgVw.hidden = NO;
    }
    
    NSString *fbPageLink = [[dataFromSecondPageDict objectForKey:@"Facebook_link"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (fbPageLink.length > 0) {
        facebookPageImgVw.hidden = NO;
    }
    
    self.scrollView.contentSize = CGSizeMake(0,facebookPageImgVw.frame.origin.y + facebookPageImgVw.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setEventType:(NSString *)eventType
{
    if([eventType isEqualToString:@"Event"])
    {
        btnEvent.layer.cornerRadius = btnEvent.frame.size.height/2.0;
        
        [btnEvent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnEvent.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:35.0/255.0 blue:35.0/255.0 alpha:1.0];
        
        eventIconImgVw.image =[UIImage imageNamed:@"flag.png"];
    }
    else if([eventType isEqualToString:@"Show"])
    {
        btnShow.layer.cornerRadius = btnShow.frame.size.height/2.0;
        
        [btnShow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnShow.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:35.0/255.0 blue:35.0/255.0 alpha:1.0];

        showIconImgVw.image =[UIImage imageNamed:@"car.png"];
    }
    else
    {
        btnMeet.layer.cornerRadius = btnMeet.frame.size.height/2.0;
        
        [btnMeet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnMeet.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:35.0/255.0 blue:35.0/255.0 alpha:1.0];
        
        meetIconImgVw.image =[UIImage imageNamed:@"group.png"];
    }
}


#pragma mark - Button Action

- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editAction:(id)sender {
    
    //[self performSegueWithIdentifier:@"createEventThirdToCreateEventFirstPageSeg" sender:nil];
    
    NSArray *array = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[array objectAtIndex:array.count-3] animated:YES];
}

- (IBAction)cancelAction:(id)sender
{    
    UIAlertView *cancelAlert = [[UIAlertView alloc] initWithTitle:@"Alert !!" message:@"All data will be lost. Do you want to leave this page?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [cancelAlert show];
    cancelAlert.tag = 2;
}

- (IBAction)submitAction:(id)sender
{
    
    NSMutableDictionary *addEventDict = [[NSMutableDictionary alloc] init];
    
    [addEventDict setObject:[self getUserDefaultValueForKey:USERID] forKey:@"UserID"];
    
    [addEventDict setObject:[dataFromSecondPageDict objectForKey:@"event_type"] forKey:@"event_type"];
    [addEventDict setObject:[dataFromSecondPageDict objectForKey:@"event_name"] forKey:@"event_name"];
    [addEventDict setObject:[dataFromSecondPageDict objectForKey:@"event_date"] forKey:@"event_date"];
    [addEventDict setObject:[dataFromSecondPageDict objectForKey:@"event_address"] forKey:@"event_address"];
    [addEventDict setObject:[dataFromSecondPageDict objectForKey:@"start_time"] forKey:@"start_time"];
    [addEventDict setObject:[dataFromSecondPageDict objectForKey:@"end_time"] forKey:@"end_time"];
    [addEventDict setObject:[dataFromSecondPageDict objectForKey:@"cost"] forKey:@"cost"];
    [addEventDict setObject:[dataFromSecondPageDict objectForKey:@"event_details"] forKey:@"event_details"];
    [addEventDict setObject:[dataFromSecondPageDict objectForKey:@"Facebook_link"] forKey:@"Facebook_link"];
    [addEventDict setObject:[dataFromSecondPageDict objectForKey:@"contact_email"] forKey:@"contact_email"];
    [addEventDict setObject:[dataFromSecondPageDict objectForKey:@"website"] forKey:@"website"];
    [addEventDict setObject:[dataFromSecondPageDict objectForKey:@"tag1"] forKey:@"tag1"];
    [addEventDict setObject:[dataFromSecondPageDict objectForKey:@"tag2"] forKey:@"tag2"];
    [addEventDict setObject:[dataFromSecondPageDict objectForKey:@"tag3"] forKey:@"tag3"];
    
    [addEventDict setObject:@"" forKey:@"event_image"];
    
    [SuperViewController startActivity:self.view];
    
    NSMutableURLRequest *request = [self prepareUrl:addEventDict suffixOfURL:ADDDEVENT];
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
              {"status":1,"event_details":{"Facebook_link":"","contact_email":"syed.aniruddha@gmail.com","event_type":"Event","tag3":"Meet","event_name":"race ","event_date":"2016-03-28","tag2":"Carsandcoffee","start_time":"01:04 PM","event_image":"","event_address":"pune","event_details":"des test","tag1":"Euro","end_time":"02:04 PM","website":"www.clunkerbunker.com","UserID":"1","cost":"10","AddDate":"2016-03-28","event_id":12},"message":"Insert successfull."}
              */
             
             if ([[jsonResponseDict objectForKey:@"status"] intValue] == 1)
             {
                 responseDict = [jsonResponseDict mutableCopy];
                 
                 if ([[self showAllValuesForEntity:@"EventsCreatedByMe"] count]) {
                     
                     [self saveEvent:jsonResponseDict];
                 }
                 else {
                     
                     UIAlertView *saveEventAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"We noticed that this is the first time you create this event. Would you like us to save it for you?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
                     [saveEventAlert show];
                     saveEventAlert.tag = 1;
                 }
                 
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:jsonResponseDict[@"message"]
                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
             }
             
             [SuperViewController stopActivity:self.view];
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

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1 && alertView.tag == 1) {
        [self saveEvent:responseDict];
    }
    else {
        //Home View from here
        [self performSegueWithIdentifier:@"createEventThirdToHomePageSeg" sender:nil];
    }
}

-(void)saveEvent:(NSMutableDictionary *)jsonRespDict {
    
    //for Event Table datastore
    NSManagedObject *myEventDetails = [NSEntityDescription insertNewObjectForEntityForName:@"EventsCreatedByMe" inManagedObjectContext:[appDel managedObjectContext]];
    
    [myEventDetails setValue:jsonRespDict[@"event_details"][@"event_name"] forKey:@"eventName"];
    [myEventDetails setValue:jsonRespDict[@"event_details"][@"event_type"] forKey:@"eventType"];
    [myEventDetails setValue:jsonRespDict[@"event_details"][@"event_date"] forKey:@"eventDate"];
    [myEventDetails setValue:jsonRespDict[@"event_details"][@"start_time"] forKey:@"eventStartTime"];
    [myEventDetails setValue:jsonRespDict[@"event_details"][@"end_time"] forKey:@"eventEndTime"];
    [myEventDetails setValue:jsonRespDict[@"event_details"][@"event_address"] forKey:@"eventAddress"];
    [myEventDetails setValue:jsonRespDict[@"event_details"][@"cost"] forKey:@"eventCost"];
    [myEventDetails setValue:jsonRespDict[@"event_details"][@"event_details"] forKey:@"eventDesc"];
    
    [myEventDetails setValue:jsonRespDict[@"event_details"][@"Facebook_link"] forKey:@"eventFacebookPage"];
    [myEventDetails setValue:jsonRespDict[@"event_details"][@"contact_email"] forKey:@"eventContactMail"];
    [myEventDetails setValue:jsonRespDict[@"event_details"][@"website"] forKey:@"eventWebsite"];
    [myEventDetails setValue:jsonRespDict[@"event_details"][@"tag1"] forKey:@"eventTag1"];
    [myEventDetails setValue:jsonRespDict[@"event_details"][@"tag2"] forKey:@"eventTag2"];
    [myEventDetails setValue:jsonRespDict[@"event_details"][@"tag3"] forKey:@"eventTag3"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![[appDel managedObjectContext] save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else
    {
        NSLog(@"Data added to database successfully");
    }
    
    //Home View from here
    [self performSegueWithIdentifier:@"createEventThirdToHomePageSeg" sender:nil];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"createEventThirdToHomePageSeg"])
    {
        HomeViewController *homeVCSeg = segue.destinationViewController;
    }
    else {
        CreateEventFirstPageViewController *createEventFirstPageSeg = segue.destinationViewController;
        
    }
 
}

@end
