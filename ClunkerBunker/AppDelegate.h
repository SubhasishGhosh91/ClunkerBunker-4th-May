//
//  AppDelegate.h
//  ClunkerBunker
//
//  Created by Mindpace on 11/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UISplitViewController *splitViewController;
@property (strong, nonatomic) UIStoryboard *storyboard;

@property (strong, nonatomic)UIImageView *leftPannelBarsImgVw;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void)setSplitViewController;


@end

