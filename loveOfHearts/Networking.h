//
//  Networking.h
//  喔喔农机
//
//  Created by 于恩聪 on 15/12/22.
//  Copyright © 2015年 于恩聪. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>

@class WatchMessage;

typedef void (^getImage)(UIImage *image);

typedef void(^getDict)(NSDictionary *dict);

typedef void (^getData)(NSData *data);

typedef void (^getInt)(int i);


@interface Networking : NSObject

+ (void)registerwithDict:(id)dict block:(getDict)getDict;

+ (void)loginwithUsername:(NSString *)username and:(NSString *)password block:(getDict)getDict;

+ (void)addWatchWithParamaters:(NSDictionary *)paramaters;

+ (void)getDevicesMessageWithParamaters:(NSDictionary *)paramater  block:(getDict)getDict;

+ (void)getUsersMessageWithParamaters:(NSDictionary *)paramater block:(getDict)getDict;

+ (void)getWatchPortiartWithDict:(NSDictionary *)dict blockcompletion:(getImage)getImage;

+ (void)uploadPortraitWithDict:(NSDictionary *)dict andImageData:(NSData *)imageData imageName:(NSString *)imageName block:(getInt)getInt;

+ (void)uploadVoiceWithDict:(NSDictionary *)dict andVoiceData:(NSData *)voiceData voiceName:(NSString *)voiceName;

+ (void)downloadVoiceWithDict:(NSDictionary *)dict block:(getData)getData;

+ (void)getHistoryTrack:(NSDictionary *)dict block:(getDict)getDict;

+ (void)updateWatchInfoWithDict:(NSDictionary *)paramaater block:(getInt)getInt;

+ (void)getallrecordesWithDict:(NSDictionary *)dict block:(getDict)getDict;

+ (void)uploalDataWithAddress:(NSString *)address dict:(NSDictionary *)paramater block:(getInt)getInt;

+ (void)getWatchMessageWithParamater:(NSString *)paramater block:(getDict)getDict;

+ (void)deleteWatchWithDict:(NSDictionary *)paramater block:(getDict)getDict;
@end
