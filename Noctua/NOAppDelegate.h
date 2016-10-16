//
//  LAAppDelegate.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 27/02/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import <FacebookSDK/FacebookSDK.h>
#import <MPGNotification.h>
#import "NOChatViewController.h"
#import "NOAmigosViewController.h"

@interface NOAppDelegate : UIResponder <UIApplicationDelegate, RESideMenuDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FBSession *session;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
