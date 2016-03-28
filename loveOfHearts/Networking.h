//
//  Networking.h
//  喔喔农机
//
//  Created by 于恩聪 on 15/12/22.
//  Copyright © 2015年 于恩聪. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>

typedef void (^getImage)(UIImage *image);

typedef void(^getDict)(NSDictionary *dict);


@interface Networking : NSObject

+ (void)registerwithDict:(id)dict;

+ (void)loginwithUsername:(NSString *)username and:(NSString *)password block:(getDict)getDict;

+ (void)addWatchWithParamaters:(NSDictionary *)paramaters;

- (void)getDevicesMessageWithParamaters:(NSDictionary *)paramater  block:(getDict)getDict;

- (NSArray *)getDeviceMessage;

- (void)getUsersMessageWithParamaters:(NSDictionary *)paramater;

- (void)getWatchPortiartWithDict:(NSDictionary *)dict blockcompletion:(getImage)getImage;
- (NSArray *)getUsersArray;

+ (int)getRegisterMessage;
@end
