//
//  MyCustomPinAnnotationView.h
//  ClunkerBunker
//
//  Created by Mindpace on 01/04/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import <MapKit/MapKit.h>
#import"MyCustomPointAnnotation.h"
#import "HomeViewController.h"

@interface MyCustomPinAnnotationView : MKAnnotationView

//@property int price;
//@property NSString *eventType;

@property (nonatomic, retain) NSString * eventAddress;
@property (nonatomic, retain) NSString * eventContactEmail;
@property (nonatomic, retain) NSString * eventCost;
@property (nonatomic, retain) NSString * eventDate;
@property (nonatomic, retain) NSString * eventDetails;
//@property (nonatomic, retain) NSString * eventDistence;
@property (nonatomic, retain) NSString * eventEndTime;
@property (nonatomic, retain) NSString * eventFacebookLink;
@property (nonatomic, retain) NSString * eventID;
//@property (nonatomic, retain) NSString * eventImage;
@property (nonatomic, retain) NSString * eventName;
@property (nonatomic, retain) NSString * eventStartTime;
@property (nonatomic, retain) NSString * eventTag1;
@property (nonatomic, retain) NSString * eventTag2;
@property (nonatomic, retain) NSString * eventTag3;
@property (nonatomic, retain) NSString * eventType;
@property (nonatomic, retain) NSString * eventWeblink;

-(instancetype)initWithAnnotation:(id<MKAnnotation>)annotation;

//@property(strong, nonatomic) CalloutView *calloutView ;
//@property (nonatomic) BOOL showCustomCallout;
//- (void)setShowCustomCallout:(BOOL)showCustomCallout animated:(BOOL)animated;


@end
