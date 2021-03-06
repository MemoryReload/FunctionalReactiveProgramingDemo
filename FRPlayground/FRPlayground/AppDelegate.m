//
//  AppDelegate.m
//  FRPlayground
//
//  Created by Heping on 2018/5/28.
//  Copyright © 2018年 BONC. All rights reserved.
//

#import "AppDelegate.h"
#import <RXCollections/RXCollection.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSArray* array = @[@(1), @(2), @(3), @(4), @(5), @(6)];
    NSArray* powArray = [array rx_mapWithBlock:^id(id each) {
        return @(pow([(NSNumber*)each integerValue], 2));
    }];
    NSLog(@"pow array: %@",powArray);
    
    NSArray* evenArray = [array rx_filterWithBlock:^BOOL(id each) {
        return [(NSNumber*)each integerValue] % 2 == 0;
    }];
    NSLog(@"even array: %@",evenArray);
    
    NSNumber* sum = [array rx_foldWithBlock:^id(id memo, id each) {
        return @([(NSNumber*)memo integerValue] + [(NSNumber*)each integerValue]);
    }];
    NSLog(@"sum = %@",sum);
    
    NSString* str = [[array rx_mapWithBlock:^id(id each) {
        return [each stringValue];
    }] rx_foldInitialValue:@"" block:^id(id memo, id each) {
        return [memo stringByAppendingString:each];
    }];
    NSLog(@"fold string: %@",str);
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
