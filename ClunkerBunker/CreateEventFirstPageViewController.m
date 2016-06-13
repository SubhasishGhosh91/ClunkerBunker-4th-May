//
//  createEventFirstPageViewController.m
//  ClunkerBunker
//
//  Created by Mindpace on 15/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import "CreateEventFirstPageViewController.h"
#import "CreateEventSecondPageViewController.h"

#import "EventsCreatedByMe.h"

@interface CreateEventFirstPageViewController ()
{
    AppDelegate *appDel;
    NSDate *startTime, *endTime;
    BOOL isStartTime, isEndTime, isDateSelected, isToday, isSavedEventSelected;
    NSMutableDictionary *detailsDictionary;
    NSString *typeString;
    EventsCreatedByMe *selectedSavedEvent;
    
    NSMutableArray *savedEventsName;
    NSArray *myEvents;
}

@end

@implementation CreateEventFirstPageViewController

@synthesize eventBtnOutlet,showBtnOutlet,saveEventsPicker,meetBtnOutlet,eventIconImgVw,showIconImgVw,meetIconImgVw,txtAddress,txtCost,txtViewDescription,txtNameofEvent,eventNameTickOrCrossImgVw,dateTickOrCrossImgVw,addressTickOrCrossImgVw,timeTickOrCrossImgVw,costTickOrCrossImgVw,descriptionTickOrCrossImgVw;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDel = [[UIApplication sharedApplication] delegate];
    appDel.leftPannelBarsImgVw = _barsImgVw;
    
    [_showLeftPannelBtnOutlet addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    self.scrollVw.contentSize = CGSizeMake(0, self.scrollVw.frame.size.height);
    //self.scrollVw.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    UITapGestureRecognizer *yourTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTap:)];
    [self.scrollVw addGestureRecognizer:yourTap];
    
    self.cancelBtnOutlet.layer.cornerRadius = 3.0f;
    self.cancelBtnOutlet.layer.masksToBounds = YES;
    
    [self.eventTimePicker setValue:[UIColor whiteColor] forKeyPath:@"textColor"];
    SEL selector_time = NSSelectorFromString(@"setHighlightsToday:");
    NSInvocation *invocation_time = [NSInvocation invocationWithMethodSignature:[UIDatePicker instanceMethodSignatureForSelector:selector_time]];
    BOOL no1 = NO;
    [invocation_time setSelector:selector_time];
    [invocation_time setArgument:&no1 atIndex:2];
    [invocation_time invokeWithTarget:self.eventTimePicker];
    
    [self.eventDatePicker setValue:[UIColor whiteColor] forKeyPath:@"textColor"];
    SEL selector_date = NSSelectorFromString(@"setHighlightsToday:");
    NSInvocation *invocation_date = [NSInvocation invocationWithMethodSignature:[UIDatePicker instanceMethodSignatureForSelector:selector_date]];
    BOOL no2 = NO;
    [invocation_date setSelector:selector_date];
    [invocation_date setArgument:&no2 atIndex:2];
    [invocation_date invokeWithTarget:self.eventDatePicker];
    
    [self eventAction:nil];
    
    //------------ Save Events created by me -----------------------
    
    savedEventsName = [[NSMutableArray alloc] init];
    myEvents = [self showAllValuesForEntity:@"EventsCreatedByMe"];
    
    for (EventsCreatedByMe *obj in myEvents)
    {
        [savedEventsName addObject:obj.eventName];
    }
    
    if (!myEvents.count) {
        _savedEventsDropDownOutlet.enabled = NO;
    }
    
    /*self.savedEventList.delegate = self;
    self.savedEventList.DropdownPlaceholderTextColor = [UIColor blackColor];
    [self.savedEventList SetObjects:savedEventsName PlaceholderTitle:@"Select from saved events"];*/
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action

-(IBAction)eventAction:(id)sender
{
    typeString = @"Event";
    eventBtnOutlet.selected = YES;
    showBtnOutlet.selected = NO;
    meetBtnOutlet.selected = NO;
    eventBtnOutlet.layer.cornerRadius = eventBtnOutlet.frame.size.height/2.0;
    eventBtnOutlet.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:35.0/255.0 blue:35.0/255.0 alpha:1.0];
    showBtnOutlet.backgroundColor = [UIColor clearColor];
    meetBtnOutlet.backgroundColor = [UIColor clearColor];
    eventIconImgVw.image =[UIImage imageNamed:@"flag.png"];
    showIconImgVw.image =[UIImage imageNamed:@"car-black.png"];
    meetIconImgVw.image =[UIImage imageNamed:@"group-black.png"];
    
}

-(IBAction)showAction:(id)sender
{
    typeString = @"Show";
    
    eventBtnOutlet.selected = NO;
    showBtnOutlet.selected = YES;
    meetBtnOutlet.selected = NO;
    
    showBtnOutlet.layer.cornerRadius = eventBtnOutlet.frame.size.height/2.0;
    
    showBtnOutlet .backgroundColor = [UIColor colorWithRed:35.0/255.0 green:35.0/255.0 blue:35.0/255.0 alpha:1.0];
    eventBtnOutlet.backgroundColor = [UIColor clearColor];
    meetBtnOutlet.backgroundColor = [UIColor clearColor];
    
    eventIconImgVw.image =[UIImage imageNamed:@"flag-black.png"];
    showIconImgVw.image =[UIImage imageNamed:@"car.png"];
    meetIconImgVw.image =[UIImage imageNamed:@"group-black.png"];
}

-(IBAction)meetAction:(id)sender
{
    typeString = @"Meet";
    
    eventBtnOutlet.selected = NO;
    showBtnOutlet.selected = NO;
    meetBtnOutlet.selected = YES;
    
    meetBtnOutlet.layer.cornerRadius = eventBtnOutlet.frame.size.height/2.0;
    
    meetBtnOutlet .backgroundColor = [UIColor colorWithRed:35.0/255.0 green:35.0/255.0 blue:35.0/255.0 alpha:1.0];
    eventBtnOutlet.backgroundColor = [UIColor clearColor];
    showBtnOutlet.backgroundColor = [UIColor clearColor];
    
    eventIconImgVw.image =[UIImage imageNamed:@"flag-black.png"];
    showIconImgVw.image =[UIImage imageNamed:@"car-black.png"];
    meetIconImgVw.image =[UIImage imageNamed:@"group.png"];
}

- (IBAction)showTimePickerforStartTimeAction:(id)sender
{
    [self.view endEditing:YES];
    
    _myPickerContainerVw.hidden=NO;
    _eventTimePicker.hidden=NO;
    _eventDatePicker.hidden=YES;
    saveEventsPicker.hidden = YES;
    isStartTime = YES;
    isEndTime = NO;
    isDateSelected = NO;
    isSavedEventSelected = NO;
}
- (IBAction)showTimePickerforEndTimeAction:(id)sender
{
    [self.view endEditing:YES];
    
    _myPickerContainerVw.hidden=NO;
    _eventTimePicker.hidden=NO;
    _eventDatePicker.hidden=YES;
    saveEventsPicker.hidden = YES;
    isStartTime = NO;
    isEndTime = YES;
    isDateSelected = NO;
    isSavedEventSelected = NO;
}

- (IBAction)pickDateAction:(id)sender
{
    [self.view endEditing:YES];
    
    _myPickerContainerVw.hidden=NO;
    _eventTimePicker.hidden=YES;
    _eventDatePicker.hidden=NO;
    saveEventsPicker.hidden = YES;
    isStartTime = NO;
    isEndTime = NO;
    isDateSelected = YES;
    isSavedEventSelected = NO;
}

- (IBAction)savedEventsDropDownAction:(id)sender
{
    [self.view endEditing:YES];
    
    _myPickerContainerVw.hidden = NO;
    
    saveEventsPicker.showsSelectionIndicator = YES;
    saveEventsPicker.hidden = NO;
    
    _eventDatePicker.hidden = YES;
    _eventTimePicker.hidden = YES;
    
    isStartTime = NO;
    isEndTime = NO;
    isDateSelected = NO;
    isSavedEventSelected = YES;
}

-(IBAction)toolbarCancelBtnAction:(id)sender
{
    _myPickerContainerVw.hidden=YES;
}

- (IBAction)toolbarDoneBtnAction:(id)sender
{
    
    if (isSavedEventSelected)
    {
        
        dateTickOrCrossImgVw.image = nil;
        
        [_savedEventsDropDownOutlet setTitle:selectedSavedEvent.eventName forState:UIControlStateNormal];
        
        [self autoFill:selectedSavedEvent];
        _myPickerContainerVw.hidden=YES;
        
    }
    else if (isDateSelected)
    {
        NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
        
        [dateFormatter3 setDateFormat:@"MMM dd yyyy"];
        
        NSDate *today = [NSDate date];
        NSDate *newDate = self.eventDatePicker.date;
        
        NSString *todayStr = [dateFormatter3 stringFromDate:today];
        NSString *selectedStr = [dateFormatter3 stringFromDate:newDate];
        
        NSDate *currentDate = [dateFormatter3 dateFromString:todayStr];
        NSDate *selectedDate = [dateFormatter3 dateFromString:selectedStr];
        
        NSComparisonResult result = [currentDate compare:selectedDate];
        
        if(result==NSOrderedDescending)
        {
            NSLog(@"Selected date is older");
            
            UIAlertView *dateAlertMsg=[[UIAlertView alloc] initWithTitle:@"" message:@"Selected date must be on or after today." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [dateAlertMsg show];
        }
        else
        {
            if(result == NSOrderedSame)
            {
                isToday = YES;
            } else
            {
                isToday = NO;
            }
            
            _lblDate.text = [selectedStr uppercaseString];
            
            _myPickerContainerVw.hidden=YES;
        }
    }
    else
    {
        if (_lblDate.text.length == 0)
        {
            UIAlertView *dateAlertMsg=[[UIAlertView alloc] initWithTitle:@"" message:@"Please select the date first" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [dateAlertMsg show];
            
            return;
        }
        
        if (isStartTime)
        {
            NSDateFormatter *timeFormatter=[[NSDateFormatter alloc] init];
            [timeFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            
            NSDate *todayTime = [NSDate date];
            NSDate *newDateTime = self.eventTimePicker.date;
            
            NSString *todayStrTime=[timeFormatter stringFromDate:todayTime];
            NSString *selectedStrTime=[timeFormatter stringFromDate:newDateTime];
            
            NSDate *currentDateTime=[timeFormatter dateFromString:todayStrTime];
            NSDate *selectedDateTime=[timeFormatter dateFromString:selectedStrTime];
            
            NSComparisonResult result1 = [currentDateTime compare:selectedDateTime];
            
            if(result1 == NSOrderedDescending &&  result1 == NSOrderedSame && isToday)
            {
                NSLog(@"newDate is less");
                UIAlertView *timeAlertMsg=[[UIAlertView alloc] initWithTitle:@"" message:@"Start time must be after current time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [timeAlertMsg show];
            }
            else
            {
                startTime = self.eventTimePicker.date;
                
                NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc]init];
                [dateFormatter1 setDateFormat:@"HH:mm"];
                
                _lblStartingTime.text = [dateFormatter1 stringFromDate:startTime];
                
                _myPickerContainerVw.hidden=YES;
            }
        }
        else
        {
            endTime = self.eventTimePicker.date;
            NSComparisonResult result2 = [startTime compare:endTime];
            if (result2 == NSOrderedAscending)
            {
                NSLog(@"date1 is earlier than date2");
                
                NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
                [dateFormatter2 setDateFormat:@"HH:mm"];
                
                _lblEndTime.text = [dateFormatter2 stringFromDate:endTime];
                
                _myPickerContainerVw.hidden=YES;
                
            }
            else if (result2 == NSOrderedDescending)
            {
                NSLog(@"date1 is later than date2");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"End time must be greater than start time"delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
            
            else if(result2 == NSOrderedSame)
            {
                
                NSLog(@"dates are the same");
                UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"" message:@"Start time must be different from end time" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alert1 show];
            }
            
        }
        
    }
}

- (IBAction)cancelAction:(id)sender {
    
    UIAlertView *cancelAlert = [[UIAlertView alloc] initWithTitle:@"Alert !!" message:@"All data will be lost. Do you want to leave this page?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [cancelAlert show];
}

- (IBAction)continueAction:(id)sender {
    
    NSString *tmp = nil;
    BOOL isError = NO;
    
    detailsDictionary= [[NSMutableDictionary alloc] init];
    
    [detailsDictionary setObject:typeString forKey:@"event_type"];
    
    tmp = [txtNameofEvent.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!tmp.length)
    {
        isError = YES;
        eventNameTickOrCrossImgVw.image =[UIImage imageNamed:@"red-delete.png"];
    }
    else
    {
        [detailsDictionary setObject:tmp forKey:@"event_name"];
        eventNameTickOrCrossImgVw.image =[UIImage imageNamed:@"green-check.png"];
    }
    
    tmp = [txtAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!tmp.length)
    {
        isError = YES;
        addressTickOrCrossImgVw.image =[UIImage imageNamed:@"red-delete.png"];
    }
    else
    {
        [detailsDictionary setObject:tmp forKey:@"event_address"];
        addressTickOrCrossImgVw.image =[UIImage imageNamed:@"green-check.png"];
    }
    
    tmp = [_lblDate.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!tmp.length)
    {
        isError = YES;
        dateTickOrCrossImgVw.image =[UIImage imageNamed:@"red-delete.png"];
    }
    else
    {
        [detailsDictionary setObject:tmp forKey:@"event_date"];
        dateTickOrCrossImgVw.image =[UIImage imageNamed:@"green-check.png"];
    }
    
    tmp = [txtCost.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!tmp.length)
    {
        isError = YES;
        costTickOrCrossImgVw.image =[UIImage imageNamed:@"red-delete.png"];
    }
    else
    {
        [detailsDictionary setObject:tmp forKey:@"cost"];
        costTickOrCrossImgVw.image =[UIImage imageNamed:@"green-check.png"];
    }
    
    
    if (![_lblStartingTime.text isEqualToString:@"Start"])
    {
        [detailsDictionary setObject:_lblStartingTime.text forKey:@"start_time"];
        timeTickOrCrossImgVw.image =[UIImage imageNamed:@"green-check.png"];
    }
    else
    {
        isError = YES;
        timeTickOrCrossImgVw.image =[UIImage imageNamed:@"red-delete.png"];
    }
    
    if (![_lblEndTime.text isEqualToString:@"End"])
    {
        [detailsDictionary setObject:_lblEndTime.text forKey:@"end_time"];
        timeTickOrCrossImgVw.image =[UIImage imageNamed:@"green-check.png"];
    }
    else
    {
        isError = YES;
        timeTickOrCrossImgVw.image =[UIImage imageNamed:@"red-delete.png"];
    }
    
    tmp = [txtViewDescription.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!tmp.length) {

        isError = YES;
        descriptionTickOrCrossImgVw.image =[UIImage imageNamed:@"red-delete.png"];
    } else {
        
        [detailsDictionary setObject:tmp forKey:@"event_details"];
        descriptionTickOrCrossImgVw.image =[UIImage imageNamed:@"green-check.png"];
    }
    
    if (isError) {
        return;
    }
    
    [self performSegueWithIdentifier:@"createEventFirstToCreateEventSecondPageSeg" sender:nil];
}

#pragma mark - Alert Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [self performSegueWithIdentifier:@"createEventFirstToHomePageSeg" sender:nil];
    }
}


#pragma  mark - Dropdown

-(void)SelectedDropdownIndex:(int)index {
    NSLog(@"Dropdown index:%d",index);
    
    [self autoFill:[myEvents objectAtIndex:index]];
}


-(void)autoFill:(NSManagedObject *)fillWithObj {

    EventsCreatedByMe *selectedObj = (EventsCreatedByMe *)fillWithObj;

    txtNameofEvent.text = selectedObj.eventName;
    txtAddress.text = selectedObj.eventAddress;
    
    _lblStartingTime.text = selectedObj.eventStartTime;
    _lblEndTime.text = selectedObj.eventEndTime;
    txtCost.text = selectedObj.eventCost;
    txtViewDescription.text = selectedObj.eventDesc;
    
    if ([selectedObj.eventType isEqualToString:@"event"]) {
        
        [self eventAction:nil];
    }
    else if ([selectedObj.eventType isEqualToString:@"show"]) {
        
        [self showAction:nil];
    }
    else {
        
        [self meetAction:nil];
    }
    
    [detailsDictionary setObject:selectedObj.eventContactMail forKey:@"contact_email"];
    [detailsDictionary setObject:selectedObj.eventFacebookPage forKey:@"Facebook_link"];
    [detailsDictionary setObject:selectedObj.eventWebsite forKey:@"website"];
    [detailsDictionary setObject:selectedObj.eventTag1 forKey:@"tag1"];
    [detailsDictionary setObject:selectedObj.eventTag2 forKey:@"tag2"];
    [detailsDictionary setObject:selectedObj.eventTag3 forKey:@"tag3"];
}

#pragma mark - Picker Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [savedEventsName count];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[savedEventsName objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [savedEventsName objectAtIndex:row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedSavedEvent = [myEvents objectAtIndex:row];
}

#pragma mark - Text Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)scrollTap:(UIGestureRecognizer*)gestureRecognizer {
    
    //make keyboard disappear , you can use resignFirstResponder too, it's depend.
    [self.view endEditing:YES];
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"createEventFirstToCreateEventSecondPageSeg"])
    {
        CreateEventSecondPageViewController *createEventSecondPageSeg = segue.destinationViewController;
        createEventSecondPageSeg.dataFromFirstPageDict = detailsDictionary;
    }
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
            [self setViewMovedUp:keyboardFrameEndRect.size.height/253.0 * 135];
        }
        else{
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
    
//    self.scrollVw.frame = CGRectMake(self.scrollVw.frame.origin.x, 0, self.scrollVw.frame.size.width, self.scrollVw.frame.size.height);
    
    self.scrollVw.contentSize = CGSizeMake(0, self.scrollVw.contentSize.height +movedUp);
    
    [UIView commitAnimations];
}

@end
