//
//  LAAppDelegate.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 27/02/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NOAppDelegate.h"
#import "SPUtilidades.h"
#import "NOSplashViewController.h"

@implementation NOAppDelegate
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Eliminamos el directorio temporal de imágenes
    [SPUtilidades eliminarDirectorio:@"Noctua/temp"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Cambiamos el color del texto de la barra de estado
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    // Activamos las notificaciones PUSH
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    NSDictionary *pushDict = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(pushDict)
    {
        [self iniciarConPush:pushDict Entrada:YES];
    }
    else self.window.rootViewController = [[NOSplashViewController alloc] init];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = RGB(97, 168, 221);
    [self.window makeKeyAndVisible];
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{  
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
}

#pragma mark - 
#pragma mark PUSH Delegate
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:
(NSData *)deviceToken {
    NSString* newToken = [[[NSString stringWithFormat:@"%@",deviceToken]
                           stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [SPUtilidades guardarDatosAPN:newToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:
(NSError *)error {
    NSLog(@"Failed to register for remote notifications: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // Comprobamos lo que hemos leido
    if ([[userInfo objectForKey:@"ventana"] isEqual:@"Chat"])
    {
        NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
        
        MPGNotification *notification =
        [MPGNotification notificationWithTitle:[userInfo objectForKey:@"titulo"]
                                      subtitle:[apsInfo objectForKey:@"alert"]
                               backgroundColor:RGB(97, 168, 221)
                                     iconImage:[UIImage imageNamed:@"chats.png"]];
        
        // auto-dismiss after desired time in seconds
        notification.duration = 6.0;
        
        // button & touch handling
        notification.backgroundTapsEnabled = YES;
        [notification setButtonConfiguration:MPGNotificationButtonConfigrationZeroButtons withButtonTitles:nil];
        
        // set animation type
        notification.animationType = MPGNotificationAnimationTypeDrop;
        
        [notification showWithButtonHandler:^(MPGNotification *notification, NSInteger buttonIndex) {
            [self iniciarConPush:userInfo Entrada:NO];
        }];
    }
    
    // Si es un amigo
    if ([[userInfo objectForKey:@"ventana"] isEqual:@"Amigo"])
    {
        NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
        
        MPGNotification *notification =
        [MPGNotification notificationWithTitle:[userInfo objectForKey:@"titulo"]
                                      subtitle:[apsInfo objectForKey:@"alert"]
                               backgroundColor:RGB(97, 168, 221)
                                     iconImage:[UIImage imageNamed:@"amigos.png"]];
        
        // auto-dismiss after desired time in seconds
        notification.duration = 6.0;
        
        // button & touch handling
        notification.backgroundTapsEnabled = YES;
        [notification setButtonConfiguration:MPGNotificationButtonConfigrationZeroButtons withButtonTitles:nil];
        
        // set animation type
        notification.animationType = MPGNotificationAnimationTypeDrop;
        
        [notification showWithButtonHandler:^(MPGNotification *notification, NSInteger buttonIndex) {
            [self iniciarConPush:userInfo Entrada:NO];
        }];
    }
}

-(void) iniciarConPush: (NSDictionary *) userInfo
               Entrada: (BOOL) entrada
{
    // Si es una ventana de chat
    if ([[userInfo objectForKey:@"ventana"] isEqual:@"Chat"])
    {
        // Si hemos entrado directamente
        if (entrada)
        {
            // Creamos el controlador
            NOChatViewController *chatVC = [[NOChatViewController alloc] initWithCodigo: [userInfo objectForKey:@"codigo"] Entrada:entrada];
            
            // Creamos una UINavigationController que controle la aplicación
            // Apila las vistas o 'stack'
            UINavigationController *controladorVistas = [[UINavigationController alloc] initWithRootViewController:chatVC];
            
            // Cambiamos el color del texto de la barra de estado
            [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
            
            // Establecemos el UINavigationController como transparent
            controladorVistas.navigationBar.hidden = YES;
            
            // Creamos el menú
            RESideMenu *menuApp = [[RESideMenu alloc] initWithContentViewController:controladorVistas
                                                             leftMenuViewController:[[NOMenuIzquierdaViewController  alloc] init]
                                                            rightMenuViewController:nil];
           
            // Color preferido para la barra de estado
            menuApp.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
           
            // Configuramos el menú de la aplicación
            self.window.backgroundColor = RGB(97, 168, 221);
            menuApp.delegate           = ((NOAppDelegate *)[UIApplication sharedApplication].delegate);
            
            // Mostramos la vista
            self.window.rootViewController = menuApp;
        }
        else
        {
            // Buscamos el chat
            UIViewController * chat = [SPUtilidades encontrarChat:[userInfo objectForKey:@"codigo"]];
            UINavigationController *navController = [SPUtilidades getNavigationController];
            
            // Si existe
            if (chat != nil) [navController popToViewController:chat animated:YES];
            else [navController pushViewController:[[NOChatViewController alloc] initWithCodigo:[userInfo objectForKey:@"codigo"] Entrada:NO] animated:YES];
        }
    }
    
    // Si es una ventana de amigo
    if ([[userInfo objectForKey:@"ventana"] isEqual:@"Amigo"])
    {
        // Si hemos entrado directamente
        if (entrada)
        {
            // Creamos el controlador
            NOAmigosViewController *chatVC = [[NOAmigosViewController alloc] init];
            
            // Creamos una UINavigationController que controle la aplicación
            // Apila las vistas o 'stack'
            UINavigationController *controladorVistas = [[UINavigationController alloc] initWithRootViewController:chatVC];
            
            // Cambiamos el color del texto de la barra de estado
            [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
            
            // Establecemos el UINavigationController como transparent
            controladorVistas.navigationBar.hidden = YES;
            
            // Creamos el menú
            RESideMenu *menuApp = [[RESideMenu alloc] initWithContentViewController:controladorVistas
                                                             leftMenuViewController:[[NOMenuIzquierdaViewController  alloc] init]
                                                            rightMenuViewController:nil];
            
            // Color preferido para la barra de estado
            menuApp.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
            
            // Configuramos el menú de la aplicación
            self.window.backgroundColor = RGB(97, 168, 221);
            menuApp.delegate           = ((NOAppDelegate *)[UIApplication sharedApplication].delegate);
            
            // Mostramos la vista
            self.window.rootViewController = menuApp;
        }
        else
        {
            UINavigationController *navController = [SPUtilidades getNavigationController];
            [navController pushViewController:[[NOAmigosViewController alloc] init] animated:YES];
        }
    }
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Modelo" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Noctua.sqlite"];
    
    // Creamos un diccionario con las optiones a configurar
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES};
 
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory
// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
@end
