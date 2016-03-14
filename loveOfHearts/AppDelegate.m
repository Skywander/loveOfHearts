//
//  AppDelegate.m
//  爱之心
//
//  Created by 于恩聪 on 16/3/9.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "AppDelegate.h"

#import <SMS_SDK/SMSSDK.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

#import "IIViewDeckController.h"
#import "IISideController.h"

#import "RightViewController.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //键盘管理
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    //短信验证码
    [SMSSDK registerApp:@"da719593615f" withSecret:@"8fa14cec08625888dd27bfb4df589ac6"];
    
    RightViewController *rightController = [RightViewController new];
    
    RightViewController *leftController = [RightViewController new];
    
    ViewController *centerController = [ViewController new];
    
    
    IIViewDeckController* deckController = [[IIViewDeckController alloc] initWithCenterViewController:[[UINavigationController alloc] initWithRootViewController:centerController]
                                                                                   leftViewController:[IISideController autoConstrainedSideControllerWithViewController:
                                                                                                       leftController]
                                                                                  rightViewController:[IISideController autoConstrainedSideControllerWithViewController:rightController]];
    
    deckController.navigationController.navigationBar.hidden = YES;

    self.window.rootViewController = deckController;
    
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
