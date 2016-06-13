//
//  EventDetails.h
//  ClunkerBunker
//
//  Created by Apple on 18/04/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EventDetails : NSManagedObject

@property (nonatomic, retain) NSString * eventAddress;
@property (nonatomic, retain) NSString * eventContactEmail;
@property (nonatomic, retain) NSString * eventCost;
@property (nonatomic, retain) NSString * eventDate;
@property (nonatomic, retain) NSString * eventDetails;
@property (nonatomic, retain) NSString * eventDistence;
@property (nonatomic, retain) NSString * eventEndTime;
@property (nonatomic, retain) NSString * eventFacebookLink;
@property (nonatomic, retain) NSString * eventID;
@property (nonatomic, retain) NSString * eventImage;
@property (nonatomic, retain) NSString * eventName;
@property (nonatomic, retain) NSString * eventStartTime;
@property (nonatomic, retain) NSString * eventTag1;
@property (nonatomic, retain) NSString * eventTag2;
@property (nonatomic, retain) NSString * eventTag3;
@property (nonatomic, retain) NSString * eventType;
@property (nonatomic, retain) NSString * eventWeblink;

@end
