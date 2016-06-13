//
//  ProfileDetails.h
//  ClunkerBunker
//
//  Created by Apple on 15/04/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ProfileDetails : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * profileImage;
@property (nonatomic, retain) NSString * reg_type;
@property (nonatomic, retain) NSString * userId;

@end
