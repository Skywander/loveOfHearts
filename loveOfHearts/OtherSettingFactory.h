//
//  OtherSettingFactory.h
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/19.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RedFlowerViewController.h"
#import "CallPoliceViewController.h"
#import "ModeChoiceViewController.h"
#import "NoDisturbingTime.h"
#import "ChangePassword.h"
#import "AlarmSettingView.h"
@interface OtherSettingFactory : NSObject

+ (UIViewController *)factoryWithTag:(int)i;

@end
