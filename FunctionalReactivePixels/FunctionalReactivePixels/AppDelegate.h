//
//  AppDelegate.h
//  FunctionalReactivePixels
//
//  Created by Heping on 2018/6/7.
//  Copyright © 2018年 BONC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, readonly) PXAPIHelper* apiHelper;

@end

