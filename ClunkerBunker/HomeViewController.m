//
//  HomeViewController.m
//  ClunkerBunker
//
//  Created by Mindpace on 17/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import "HomeViewController.h"
#import "SWRevealViewController.h"

#import "MyCustomPinAnnotationView.h"
#import "MyCustomPointAnnotation.h"

#define kUTTypeMessage @"public.message"

@interface HomeViewController ()
{
    AppDelegate *appDel;
    BOOL isEvnentDetailsViewShown;
    CGFloat screenHeight, eventNameFontSize;
    UIImage *screenToBeShared;
    
    CLLocationManager * location;
}

@end

@implementation HomeViewController
@synthesize mapView;

/*-(NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDel = [[UIApplication sharedApplication] delegate];
    
    screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    eventNameFontSize = self.lblEventName.font.pointSize;
    
    appDel.leftPannelBarsImgVw = _barsImgVw;
    
    [_showLeftPannelBtnOutlet addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [mapView setShowsUserLocation:YES];
    [mapView setUserTrackingMode:YES];
    
    location = [[CLLocationManager alloc] init];
    if ([location respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [location requestAlwaysAuthorization];
    }
    location.delegate = self;
    location.desiredAccuracy = kCLLocationAccuracyBest;
    location.distanceFilter = 100;
    
    [location startUpdatingLocation];
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

#pragma mark - Button Action

- (IBAction)likeAction:(id)sender {
}

- (IBAction)favouriteAction:(id)sender {
}

- (IBAction)rsvpAction:(id)sender {
}

- (IBAction)shareAction:(id)sender {
    
    screenToBeShared = [self screenshot:self.view];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share Via.." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                  @"Facebook",
                                  @"Message",
                                  @"E-Mail",
                                  nil];
    [actionSheet showInView:self.view];
}

- (IBAction)fbBtnAction:(id)sender {
}

- (IBAction)contactAction:(id)sender {
}

- (IBAction)websiteBtnAction:(id)sender {
}

- (IBAction)showEventDetailsAction:(id)sender
{
    [UIView animateWithDuration:0.4
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         //                                 self.eventDetailsView.frame = [self getEventDetailsViewFrame:screenHeight :self.eventDetailsView :isEvnentDetailsViewShown];
                         self.eventDetailsView.frame = CGRectMake(_eventDetailsView.frame.origin.x, self.view.frame.size.height , _eventDetailsView.frame.size.width, _eventDetailsView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                         _showEventDetailsBtnOutlet.hidden = YES;
                         //[self.eventDetailsView removeFromSuperview];
                     }];
    isEvnentDetailsViewShown = NO;
}

#pragma mark - Location Manager

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    //Kolkata lat-long  (22.576487, 88.433261)
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(manager.location.coordinate, 100000, 100000);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    //call api from here
    
    NSMutableDictionary *showAllEvent = [[NSMutableDictionary alloc] init];
    
    [showAllEvent setObject:@"10" forKey:@"distance"];
    [showAllEvent setObject:[NSString stringWithFormat:@"%f",manager.location.coordinate.latitude] forKey:@"latitude"];
    [showAllEvent setObject:[NSString stringWithFormat:@"%f",manager.location.coordinate.longitude] forKey:@"longitude"];
    
    NSMutableURLRequest *request = [self prepareUrl:showAllEvent suffixOfURL:SHOWALLEVENT];
    
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
              {"status":"1","detailsEvent":[{"event_id":"30","event_name":"cars and cofee","event_date":"2016-05-12","event_address":"technopolish,saltlake,koolkata","latitude":"22.5800708","longitude":"88.438096","event_distance":"0.3921","start_time":"12:36 PM","end_time":"01:36 PM","cost":"20","event_details":"car ridding in technopolish","event_type":"event","contact_email":"syed.aniruddha@gmail.com","Facebook_link":"","website":"www.clunkerbunker.com","tag1":"Euro","tag2":"Carsandcoffee","tag3":"Meet"},{"event_id":"29","event_name":"NFS2","event_date":"2016-04-11","event_address":"newtown,kolkata","latitude":"22.5765243","longitude":"88.4796344","event_distance":"2.9540","start_time":"03:08 PM","end_time":"05:08 PM","cost":"10","event_details":"etc","event_type":"event","contact_email":"syed.aniruddha@gmail.com","Facebook_link":"","website":"www.clunkerbunker.com","tag1":"Euro","tag2":"Carsandcoffee","tag3":"Meet"}],"message":"All Event details get successfully."}
              */
             
             //longitude
             if ([[jsonResponseDict objectForKey:@"status"] intValue] == 1)
             {
                 //detailsEvent
                 NSMutableArray *totalData=[[jsonResponseDict objectForKey:@"detailsEvent"] mutableCopy];
                 
                 NSManagedObjectContext *context = [appDel managedObjectContext];
                 
                 // for delete
                 NSFetchRequest *deleteAll = [[NSFetchRequest alloc] init];
                 [deleteAll setEntity:[NSEntityDescription entityForName:@"EventDetails" inManagedObjectContext:context]];
                 NSArray *allEvents = [context executeFetchRequest:deleteAll error:nil];
                 
                 for (NSManagedObject *managedObject in allEvents)
                 {
                     [context deleteObject:managedObject];
                 }
                 
                 for (NSDictionary *dic in totalData)
                 {
                     NSString *latitudeString = [dic objectForKey:@"latitude"];
                     NSString *longtitudeString = [dic objectForKey:@"longitude"];
                     
                     //for map pin page
                     MyCustomPointAnnotation *point = [[MyCustomPointAnnotation alloc] init];
                     point.coordinate = CLLocationCoordinate2DMake([latitudeString floatValue], [longtitudeString floatValue]);
                     point.eventType = [dic objectForKey:@"event_type"];
                     
                     point.eventID = [dic objectForKey:@"event_id"];
                     point.eventName = [dic objectForKey:@"event_name"];
                     point.eventDate = [dic objectForKey:@"event_date"];
                     point.eventStartTime = [dic objectForKey:@"start_time"];
                     point.eventEndTime = [dic objectForKey:@"end_time"];

                     point.eventCost = [dic objectForKey:@"cost"];
                     point.eventDetails = [dic objectForKey:@"event_details"];
                     point.eventAddress = [dic objectForKey:@"event_address"];
                     
                     point.eventFacebookLink = [dic objectForKey:@"Facebook_link"];
                     point.eventContactEmail = [dic objectForKey:@"contact_email"];
                     point.eventWeblink = [dic objectForKey:@"website"];
                     point.eventTag1 = [dic objectForKey:@"tag1"];
                     point.eventTag2 = [dic objectForKey:@"tag2"];
                     point.eventTag2 = [dic objectForKey:@"tag3"];

                    // point.title = @"Custom view here";
                     
                     [self.mapView addAnnotation:point];
                     
                     //for Event Table datastore
                     NSManagedObject *eventDetails = [NSEntityDescription insertNewObjectForEntityForName:@"EventDetails" inManagedObjectContext:context];
                     
                     [eventDetails setValue:dic[@"event_id"] forKey:@"eventID"];
                     [eventDetails setValue:dic[@"event_name"] forKey:@"eventName"];
                     
                     [eventDetails setValue:dic[@"event_date"] forKey:@"eventDate"];
                     [eventDetails setValue:dic[@"start_time"] forKey:@"eventStartTime"];
                     [eventDetails setValue:dic[@"end_time"] forKey:@"eventEndTime"];
                     [eventDetails setValue:dic[@"cost"] forKey:@"eventCost"];
                     [eventDetails setValue:dic[@"event_details"] forKey:@"eventDetails"];
                     
                     [eventDetails setValue:dic[@"event_address"] forKey:@"eventAddress"];
                     [eventDetails setValue:dic[@"event_distance"] forKey:@"eventDistence"];
                     
                     [eventDetails setValue:dic[@"contact_email"] forKey:@"eventContactEmail"];
                     [eventDetails setValue:dic[@"Facebook_link"] forKey:@"eventFacebookLink"];
                     [eventDetails setValue:dic[@"website"] forKey:@"eventWeblink"];
                     [eventDetails setValue:dic[@"tag1"] forKey:@"eventTag1"];
                     [eventDetails setValue:dic[@"tag2"] forKey:@"eventTag2"];
                     [eventDetails setValue:dic[@"tag3"] forKey:@"eventTag3"];
                     
                     [eventDetails setValue:@"" forKey:@"eventImage"];
                     
                     NSError *error = nil;
                     // Save the object to persistent store
                     if (![context save:&error]) {
                         NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                     }
                     else
                     {
                         NSLog(@"Data added to database successfully");
                     }
                 }
                 
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:jsonResponseDict[@"message"]
                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // Don't do anything if it's the user's location point
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // We could display multiple types of point annotations
    if([annotation isKindOfClass:[MyCustomPointAnnotation class]])
    {
        MyCustomPinAnnotationView *pin = [[MyCustomPinAnnotationView alloc] initWithAnnotation:annotation];
        return pin;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)map annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    printf("yes tapped!");
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    if([view isKindOfClass:[MyCustomPinAnnotationView class]])
    {
        MyCustomPinAnnotationView *selectedPin = (MyCustomPinAnnotationView *)view;
        NSLog(@"PinType: %@",selectedPin.eventType);
        
        self.lblEventName.attributedText = [self firstLetterBigger:selectedPin.eventName forLabel:self.lblEventName];
        self.lblDate.text = selectedPin.eventDate;
        self.lblTimerange.text = [NSString stringWithFormat:@"%@ - %@",selectedPin.eventStartTime,selectedPin.eventEndTime];
        self.lblCost.text = selectedPin.eventCost;
        self.lblAddress.text = selectedPin.eventAddress;
        self.txtVwEventDescription.text = selectedPin.eventDetails;
        
        selectedPin.eventFacebookLink.length ? [_fbPageBtn setEnabled:YES] : [_fbPageBtn setEnabled:NO];
        selectedPin.eventContactEmail.length ? [_contactEmailBtn setEnabled:YES] : [_contactEmailBtn setEnabled:NO];
        selectedPin.eventWeblink.length ? [_websiteBtn setEnabled:YES] : [_websiteBtn setEnabled:NO];
        
        if (isEvnentDetailsViewShown == NO)  //For animation from bottom to top
        {
            [UIView animateWithDuration:0.4
                                  delay:0.1
                                options: UIViewAnimationOptionCurveEaseIn
                             animations:^{
//                                 self.eventDetailsView.frame = [self getEventDetailsViewFrame:screenHeight :self.eventDetailsView :isEvnentDetailsViewShown];
                                 
                                 self.eventDetailsView.frame = CGRectMake(_eventDetailsView.frame.origin.x, self.view.frame.size.height/568.0f *143.0f , _eventDetailsView.frame.size.width, _eventDetailsView.frame.size.height);
                             }
                             completion:^(BOOL finished)
             {
                 if (finished)
                 {
                     _showEventDetailsBtnOutlet.hidden = NO;
                     
                     [self.view addSubview:self.eventDetailsView];
                 }
             }];
            isEvnentDetailsViewShown = YES;
        }
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if ([view isKindOfClass:[MyCustomPinAnnotationView class]]) {
        
        [UIView animateWithDuration:0.4
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             //                                 self.eventDetailsView.frame = [self getEventDetailsViewFrame:screenHeight :self.eventDetailsView :isEvnentDetailsViewShown];
                             self.eventDetailsView.frame = CGRectMake(_eventDetailsView.frame.origin.x, self.view.frame.size.height , _eventDetailsView.frame.size.width, _eventDetailsView.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             [self.lblEventName setFont:[self.lblEventName.font fontWithSize:eventNameFontSize]];
                             
                             _showEventDetailsBtnOutlet.hidden = YES;
                             //[self.eventDetailsView removeFromSuperview];
                         }];
        isEvnentDetailsViewShown = NO;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        //NSLog(@"Facebook");
        
        SLComposeViewController *fbVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [fbVC setInitialText:@"Check out this event!It looks fun"];
        //[fbVC addImage:[UIImage imageNamed:@"sim.png"]];
        [fbVC addImage:screenToBeShared];
        [fbVC setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result)
            {
                case SLComposeViewControllerResultDone:
                    NSLog(@"Share Done");
                    break;
                    
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Share cancel");
                    break;
                    
                default:
                    break;
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
         ];
        
        [self presentViewController:fbVC animated:YES completion:nil];
        
    }
    else if (buttonIndex==1)
    {
        NSLog(@"MMS");
        
        MFMessageComposeViewController *composer = [[MFMessageComposeViewController alloc] init];
        composer.messageComposeDelegate = self;
        //        [composer setSubject:@"My Subject"];
        //composer.recipients = [NSArray arrayWithObject:@"8906624239"];
        composer.body = @"Check out this event! It looks fun.";
        
        // These checks basically make sure it's an MMS capable device with iOS7
        if([MFMessageComposeViewController respondsToSelector:@selector(canSendAttachments)] && [MFMessageComposeViewController canSendAttachments])
        {
            // NSData* attachment = UIImageJPEGRepresentation([UIImage imageNamed:@"porche.jpg"], 1.0);
            NSData* attachment = UIImageJPEGRepresentation(screenToBeShared, 1.0);
            NSString* uti = (NSString*)kUTTypeMessage;
            [composer addAttachmentData:attachment typeIdentifier:uti filename:@"ClunkeBunkerMMS.jpg"];
        }
        
        [self presentViewController:composer animated:YES completion:nil];
        
    }
    
    else if (buttonIndex==2)
    {
        NSLog(@"E-mail");
        
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc]init];
        mailComposer.mailComposeDelegate = self;
        
        [mailComposer setSubject:@""];
        [mailComposer setMessageBody:@"Check out this event!it looks fun." isHTML:NO];
        if ([MFMailComposeViewController canSendMail])
        {
            
            NSData* attachment = UIImageJPEGRepresentation(screenToBeShared, 1.0);
            NSString* uti = (NSString*)kUTTypeMessage;
            [mailComposer addAttachmentData:attachment mimeType:uti fileName:@"ClunkeBunkerMMS.jpg"];
            [self presentViewController:mailComposer animated:YES completion:nil];
        }
    }
    else
    {
        NSLog(@"cancel");
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

#pragma mark - message composer delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result;
{
    
    if (result == MessageComposeResultCancelled || result == MessageComposeResultSent) {
        NSLog(@"Result : %d",result);
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        UIAlertView *mmsFailed = [[UIAlertView alloc] initWithTitle:@"" message:@"Your message can not be sent" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [mmsFailed show];
    }
    
}


@end
