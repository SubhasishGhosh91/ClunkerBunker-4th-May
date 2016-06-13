//
//  EventsCreatedByMe.h
//  ClunkerBunker
//
//  Created by Mindpace on 16/04/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EventsCreatedByMe : NSManagedObject

@property (nonatomic, retain) NSString * eventAddress;
@property (nonatomic, retain) NSString * eventContactMail;
@property (nonatomic, retain) NSString * eventCost;
@property (nonatomic, retain) NSString * eventDate;
@property (nonatomic, retain) NSString * eventDesc;
@property (nonatomic, retain) NSString * eventEndTime;
@property (nonatomic, retain) NSString * eventFacebookPage;
@property (nonatomic, retain) NSString * eventName;
@property (nonatomic, retain) NSString * eventStartTime;
@property (nonatomic, retain) NSString * eventTag1;
@property (nonatomic, retain) NSString * eventTag2;
@property (nonatomic, retain) NSString * eventTag3;
@property (nonatomic, retain) NSString * eventType;
@property (nonatomic, retain) NSString * eventWebsite;

@end
