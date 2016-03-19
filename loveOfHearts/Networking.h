//
//  Networking.h
//  喔喔农机
//
//  Created by 于恩聪 on 15/12/22.
//  Copyright © 2015年 于恩聪. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>
@interface Networking : NSObject


+ (void)registerwithDict:(id)dict;
+ (void)loginwithUsername:(NSString *)username and:(NSString *)password;
+ (void)addWatchWithParamaters:(NSDictionary *)paramaters;
- (void)getDevicesMessageWithParamaters:(NSDictionary *)paramater;
- (NSArray *)getDeviceMessage;

- (void)getUsersMessageWithParamaters:(NSDictionary *)paramater;
- (NSArray *)getUsersArray;

+ (int)getLoginMessage;
+ (int)getRegisterMessage;
@end
