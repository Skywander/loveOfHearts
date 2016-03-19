//
//  RightVieFactory.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/14.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "RightVieFactory.h"
#import "SosphoneSetting.h"
#import "PhoneListView.h"
#import "PhoneCanMakeList.h"
#import "BabyManageViewController.h"
#import "HistoryFenceList.h"
#import "AuthorityViewController.h"
#import "OtherSettingViewController.h"

@implementation RightVieFactory

+ (UIViewController *)factoryWithTag:(int)tag{
    UIViewController *viewController;
    
    switch (tag) {
        case 1:
            viewController = [BabyManageViewController new];
            break;
        case 2:
            viewController = [AuthorityViewController new];
            ;
            break;
        case 3:
            viewController = [SosphoneSetting new];
            break;
        case 4:
            viewController = [PhoneCanMakeList new];
            break;
        case 5:
            viewController = [PhoneListView new];
            break;
        case 6:
            viewController = [HistoryFenceList new];
            break;
        case 7:
            ;
            break;
        case 8:
            ;
            break;
        case 9:
            viewController = [OtherSettingViewController new];
            break;
        case 10:
            break;
            
        default:
            break;
    }
    
    return viewController;
}

@end
