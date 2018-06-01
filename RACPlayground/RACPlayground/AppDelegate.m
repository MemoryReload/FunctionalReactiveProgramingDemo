//
//  AppDelegate.m
//  RACPlayground
//
//  Created by Heping on 2018/5/30.
//  Copyright © 2018年 BONC. All rights reserved.
//

#import "AppDelegate.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSArray* array = @[@(1), @(2), @(3), @(4), @(5), @(6)];
    RACSequence* sequence = [array rac_sequence];
    [sequence map:^id _Nullable(id  _Nullable value) {
        return @(pow([(NSNumber*)value integerValue], 2));
    }];
    NSLog(@"pow array: %@",[sequence array]);
    
    NSLog(@"even array: %@",[[[array rac_sequence] filter:^BOOL(id  _Nullable value) {
        return [(NSNumber*)value integerValue] % 2 == 0;
    }] array]);
    
    NSLog(@"fold string : %@",[[[array rac_sequence] map:^id _Nullable(id  _Nullable value) {
        return [(NSNumber*)value stringValue];
    }] foldLeftWithStart:@"" reduce:^id _Nullable(id  _Nullable accumulator, id  _Nullable value) {
        return [(NSString*)accumulator stringByAppendingString:(NSString*)value];
    }]);
    return YES;
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
