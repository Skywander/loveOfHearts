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
#import <CoreLocation/CoreLocation.h>
#import "LoginViewController.h"
#import "AccountMessage.h"
#import "Mymapview.h"
#import "Networking.h"
#import "JKAlert.h"
#define NotifyActionKey "NotifyAction"

NSString *const NotificationCategoryIdent = @"ACTIONABLE";
NSString *const NotificationActionOneIdent = @"ACTION_ONE";
NSString *const NotificationActionTwoIdent = @"ACTION_TWO";

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
    manager.enableAutoToolbar = YES;
    //短信验证码
    [SMSSDK registerApp:@"da719593615f" withSecret:@"8fa14cec08625888dd27bfb4df589ac6"];
    
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    // 该方法需要在主线程中调用
    [self startSdkWith:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret];
    
    // [2]:注册APNS
    [self registerRemoteNotification];
    
    
    [GeTuiSdk bindAlias:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userAccount"]]];
    
    // [2-EXT]: 获取启动时收到的APN数据
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], userInfo];
        
        NSLog(@"%@ record",record);
    }
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                
                [JKAlert showMessage:@"未知网络"];
                
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                NSLog(@"没有网络(断网)");
                [JKAlert showMessage:@"没有网络(断网)"];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                NSLog(@"WIFI");
                break;
        }
    }];
    
    // 3.开始监控
    [mgr startMonitoring];

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

#pragma mark - background fetch  唤醒
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    //[5] Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - 用户通知(推送) _自定义方法

/** 注册远程通知 */
- (void)registerRemoteNotification {
    
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //IOS8 新的通知机制category注册
        UIMutableUserNotificationAction *action1;
        action1 = [[UIMutableUserNotificationAction alloc] init];
        [action1 setActivationMode:UIUserNotificationActivationModeBackground];
        [action1 setTitle:@"取消"];
        [action1 setIdentifier:NotificationActionOneIdent];
        [action1 setDestructive:NO];
        [action1 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationAction *action2;
        action2 = [[UIMutableUserNotificationAction alloc] init];
        [action2 setActivationMode:UIUserNotificationActivationModeBackground];
        [action2 setTitle:@"回复"];
        [action2 setIdentifier:NotificationActionTwoIdent];
        [action2 setDestructive:NO];
        [action2 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationCategory *actionCategory;
        actionCategory = [[UIMutableUserNotificationCategory alloc] init];
        [actionCategory setIdentifier:NotificationCategoryIdent];
        [actionCategory setActions:@[ action1, action2 ]
                        forContext:UIUserNotificationActionContextDefault];
        
        NSSet *categories = [NSSet setWithObject:actionCategory];
        UIUserNotificationType types = (UIUserNotificationTypeAlert |
                                        UIUserNotificationTypeSound |
                                        UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        UIUserNotificationType apn_type = (UIUserNotificationType)(UIUserNotificationTypeSound |
                                                                       UIUserNotificationTypeAlert |
                                                                       UIUserNotificationTypeBadge);
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:apn_type categories:nil]];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                   UIRemoteNotificationTypeSound |
                                                                   UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}

#pragma mark - 远程通知(推送)回调

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
    // [3]:向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@",[NSString stringWithFormat:@"didFailToRegisterForRemoteNotificationsWithError:%@", [error localizedDescription]]);
}

#pragma mark - APP运行中接收到通知(推送)处理

/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台)  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    // [4-EXT]:处理APN
    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], userInfo];
    NSLog(@" record : %@",record);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - 启动GeTuiSdk

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret {
    //[1-1]:通过 AppId、 appKey 、appSecret 启动SDK
    //该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:appID appKey:appKey appSecret:appSecret delegate:self];
    
    //[1-2]:设置是否后台运行开关
    [GeTuiSdk runBackgroundEnable:YES];
    //[1-3]:设置电子围栏功能，开启LBS定位服务 和 是否允许SDK 弹出用户定位请求
    [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
}

#pragma mark - GeTuiSdkDelegate

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    NSLog(@">>>[GeTuiSdk RegisterClient]:%@", clientId);
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    // [4]: 收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes
                                              length:payloadData.length
                                            encoding:NSUTF8StringEncoding];
    }
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"dit : %@",dict);
    
    NSDictionary *data = [dict objectForKey:@"data"];
    
    NSInteger type = [[dict objectForKey:@"type"] integerValue];
    
    if (type == 1) {
        NSDictionary *data = [dict objectForKey:@"data"];
        
        if (![[data objectForKey:@"wid"] isEqualToString:[AccountMessage sharedInstance].wid]) {
            return;
        }
        
        NSDictionary *sendMessage = @{
                                @"gsm":[NSString stringWithFormat:@"%@",[data objectForKey:@"gsm"]],
                                @"power":[NSString stringWithFormat:@"%@",[data objectForKey:@"power"]],
                                @"lat":[data objectForKey:@"lat"],
                                @"lng":[data objectForKey:@"lng"],
                                @"way":[data objectForKey:@"islocation"],
                               };
        
        NSNotification *notification =[NSNotification notificationWithName:@"updateSignal" object:sendMessage userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        NSLog(@"send notification");

    }
    
    if (type == 2) {
        
        NSString *createdAtDate = [data objectForKey:@"createdAt"];
        
        NSString *updatedAtDate = [data objectForKey:@"updatedAt"];
        
        NSDictionary *voiceDict = @{
                                    @"createdAt":createdAtDate,
                                    @"filename":[data objectForKey:@"filename"],
                                    @"fromId":[data objectForKey:@"fromId"],
                                    @"isheard":[data objectForKey:@"isheard"],
                                    @"updatedAt":updatedAtDate,
                                    @"wid":[data objectForKey:@"wid"]
                                    };
        
        
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"receiveVoice" object:voiceDict userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];

    }
    
    if (type >= 4) {
        [JKAlert showMessageWithType:type];
    }
    
    // 汇报个推自定义事件
    [GeTuiSdk sendFeedbackMessage:90001 taskId:taskId msgId:msgId];
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
    NSLog(@" record : %@",record);
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
//    [_viewController logMsg:[NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]];
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // [EXT]:通知SDK运行状态
}

//SDK设置推送模式回调
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {}
//        [_viewController logMsg:[NSString stringWithFormat:@">>>[SetModeOff error]: %@", [error localizedDescription]]];
//        return;
//    }
//    
//    [_viewController logMsg:[NSString stringWithFormat:@">>>[GexinSdkSetModeOff]: %@", isModeOff ? @"开启" : @"关闭"]];
    
//    UIViewController *vc = _naviController.topViewController;
//    if ([vc isKindOfClass:[ViewController class]]) {
//        ViewController *nextController = (ViewController *) vc;
//        [nextController updateModeOffButton:isModeOff];
//    }
}

- (NSString *)formateTime:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:date];
    return dateTime;
}


@end
