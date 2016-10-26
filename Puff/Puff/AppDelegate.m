//
//  AppDelegate.m
//  Puff
//
//  Created by bob.sun on 16/9/14.
//  Copyright © 2016年 bob.sun. All rights reserved.
//

#import "AppDelegate.h"

#import <MMDrawerController/MMDrawerController.h>
#import <MMDrawerController/MMDrawerVisualState.h>

#import "NSObject+Events.h"
#import "MasterViewController.h"
#import "PFDrawerViewController.h"
#import "PFSetMasterPasswordViewController.h"
#import "PFCategoryUtil.h"
#import "PFDBManager.h"
#import "PFAccountManager.h"
#import "PFTypeManager.h"
#import "PFCategoryManager.h"
#import "PFKeychainHelper.h"
#import "PFAppLock.h"

@interface AppDelegate ()
@property (strong, nonatomic) MasterViewController *mainViewController;
@property (strong, nonatomic) PFAppLock *appLock;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[[PFCategoryUtil alloc] init] initBuiltins];;
    
    _appLock = [PFAppLock sharedLock];
    
    UIStoryboard* mainStoryboard;
    
    PFDrawerViewController *navViewController;
    MMDrawerController *drawerViewController;

    mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:self.class]];
    
    _mainViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MasterViewController"];
    navViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"PFDrawerViewController"];
    
    navViewController.delegate = _mainViewController;
    
    drawerViewController = [[MMDrawerController alloc] initWithCenterViewController: _mainViewController leftDrawerViewController:navViewController];
    
    [drawerViewController setRestorationIdentifier:@"PFDrawer"];
    [drawerViewController setDrawerVisualStateBlock:[MMDrawerVisualState slideVisualStateBlock]];
    [drawerViewController setMaximumLeftDrawerWidth:260.0];
    [drawerViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerViewController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [drawerViewController setShouldStretchDrawer:NO];
    [drawerViewController setShowsShadow:NO];
    
    
    if (!self.window) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    
    self.window.rootViewController = drawerViewController;

    [self.window makeKeyAndVisible];
    
    
    if (![[PFKeychainHelper sharedInstance] hasMasterPassword]) {
        PFSetMasterPasswordViewController *vc = [PFSetMasterPasswordViewController viewControllerFromStoryBoard];
        vc.showMode = showModeSet;
        [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
    } else {
        [_appLock showLock];
    }
    
    [NSObject setDispatchQueue:[NSOperationQueue mainQueue]];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [_appLock showLock];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    [_appLock showLock];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
//    [self saveContext];
}


#pragma mark - Split view
//
//- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
//    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
//        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
//        return YES;
//    } else {
//        return NO;
//    }
//}

#pragma mark - Core Data stack

//@synthesize persistentContainer = _persistentContainer;
//
//- (NSPersistentContainer *)persistentContainer {
//    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
//    @synchronized (self) {
//        if (_persistentContainer == nil) {
//            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Puff"];
//            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
//                if (error != nil) {
//                    // Replace this implementation with code to handle the error appropriately.
//                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                    
//                    /*
//                     Typical reasons for an error here include:
//                     * The parent directory does not exist, cannot be created, or disallows writing.
//                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                     * The device is out of space.
//                     * The store could not be migrated to the current model version.
//                     Check the error message to determine what the actual problem was.
//                    */
//                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//                    abort();
//                }
//            }];
//        }
//    }
//    
//    return _persistentContainer;
//}

#pragma mark - Core Data Saving support

//- (void)saveContext {
//    NSManagedObjectContext *context = self.persistentContainer.viewContext;
//    NSError *error = nil;
//    if ([context hasChanges] && ![context save:&error]) {
//        // Replace this implementation with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//        abort();
//    }
//}

@end
