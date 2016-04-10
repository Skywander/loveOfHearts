//
//  Command.h
//  爱之心
//
//  Created by 于恩聪 on 15/9/19.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^getInteger)(NSInteger type);

typedef void (^getDict)(NSDictionary *dict);


@interface Command : NSObject


+ (void)commandWithName:(NSString *)command block:(getInteger)getInteger;


+ (void)commandWithAddress:(NSString *)address andParamater:(NSDictionary *)paramater block:(getInteger)getInteger;


+ (void)commandWithAddress:(NSString *)address andParamater:(NSDictionary *)paramater dictBlock:(getDict)getDict;


@end
