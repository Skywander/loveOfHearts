
//
//  OtherSettingFactory.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/19.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "OtherSettingFactory.h"
#import "AccountMessage.h"

@implementation OtherSettingFactory

+(UIViewController *)factoryWithTag:(int)i{
    UIViewController *viewController = [UIViewController new];

    
    switch (i) {
        case 0:
            viewController = [NoDisturbingTime new];
            break;
        case 1:
            viewController = [RedFlowerViewController new];
            break;
        case 2:
            viewController = [HealthViewController new];
            break;
        case 3:
            viewController = [AlarmSettingView new];
            break;
        case 4:
            viewController = [ModeChoiceViewController new];
            break;
        case 5:
            break;
        case 6:
            break;
        case 7:
            viewController = [ChangePassword new];
            break;
        case 8:
            viewController = [CallPoliceViewController new];
            break;
        case 9:
            break;
        default:
            break;
    }
    return viewController;
}

@end
