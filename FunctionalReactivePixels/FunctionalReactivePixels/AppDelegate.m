//
//  AppDelegate.m
//  FunctionalReactivePixels
//
//  Created by Heping on 2018/6/7.
//  Copyright © 2018年 BONC. All rights reserved.
//

#import "AppDelegate.h"
#import "FRPGalleryCollectionViewController.h"

@interface AppDelegate ()
@property (nonatomic,strong,readwrite) PXAPIHelper* apiHelper;
@property (nonatomic,strong) UINavigationController* navigationController;
@end

static const NSString* key=@"ufpJVdMfdrlcerksovwxWv4RYvL2z2NGVbm9r3mI";
static const NSString* secret=@"yQ2gyWWS6NxPLgNsVm0fGFo1rA1deGTM0SEyaRhi";

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.apiHelper = [[PXAPIHelper alloc]initWithHost:nil consumerKey:key consumerSecret:secret];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    [self.navigationController pushViewController:[[FRPGalleryCollectionViewController alloc]init] animated:YES];
    return YES;
}

- (UIWindow *)window
{
    if (!_window) {
        _window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        _window.backgroundColor = [UIColor whiteColor];
    }
    return _window;
}

- (UINavigationController*)navigationController
{
    if (!_navigationController) {
        _navigationController = [[UINavigationController alloc]init];
        _navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};
    }
    return _navigationController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
