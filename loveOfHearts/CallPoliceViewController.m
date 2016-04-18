//
//  CallPoliceViewController.m
//  爱之心
//
//  Created by 于恩聪 on 15/9/4.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "CallPoliceViewController.h"
#import "Constant.h"
#import "Command.h"
#import "Navigation.h"
#import "AccountMessage.h"
#import "Networking.h"
@interface CallPoliceViewController()
{
    UIButton *sosButton;
    UIButton *lowPowerButton;
    UIButton *takeDownWatch;
    UIButton *messageButton;
    
    UISwitch *swits[5];
    NSMutableArray *switsState;
    
    AccountMessage *accountMessage ;
}

@end
@implementation CallPoliceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [Networking getWatchMessageWithParamater:[AccountMessage sharedInstance].wid block:^(NSDictionary *dict) {
        NSLog(@"watchMessage: %@",dict);
        
        [[AccountMessage sharedInstance] setWatchInfor:dict];
        
        [self initData];
        [self initUI];
        
    }];
}

- (void)initData {
    switsState = [NSMutableArray new];
    
    accountMessage = [AccountMessage sharedInstance];
    
    if (accountMessage.smsonoff == NULL) {
        accountMessage.smsonoff = @"0";
    }
    
    if (accountMessage.lowbat == NULL) {
        accountMessage.lowbat = @"0";
    }
    if (accountMessage.remove == NULL) {
        accountMessage.remove = @"0";
    }
    if (accountMessage.sossms == NULL) {
        accountMessage.sossms = @"0";
    }
    
    [switsState addObject:accountMessage.smsonoff];
    [switsState addObject:accountMessage.lowbat];
    [switsState addObject:accountMessage.remove];
    [switsState addObject:accountMessage.sossms];
    
    NSLog(@"switState%@",switsState);
}

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    Navigation *navigation = [Navigation new];
    [self.view addSubview:navigation];
    
    CGFloat basicMove = 55;

    sosButton = [self buttonWthName:@"      短信总开关" andPointY:70];
    
    lowPowerButton = [self buttonWthName:@"     低电报警" andPointY:70 + basicMove];
    
    takeDownWatch = [self buttonWthName:@"      脱落报警" andPointY:70 + basicMove * 2];
    
    
    messageButton = [self buttonWthName:@"      SOS报警" andPointY:70 + basicMove * 3];
}

- (UIButton *)buttonWthName:(NSString *)name andPointY:(CGFloat)y {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(6, y, SCREEN_WIDTH - 12, 50)];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:DEFAULT_FONT_COLOR forState:UIControlStateNormal];
    [button setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    [button.layer setCornerRadius:6.f];
    [button.layer setBorderColor:[UIColor grayColor].CGColor];
    [button.layer setBorderWidth:0.3f];
    if (y != 0) {
        UISwitch *swit = [UISwitch new];
        [swit setFrame:CGRectMake(SCREEN_WIDTH - 12 - 60, 5, 10, 40)];
        [swit setOnTintColor:DEFAULT_PINK];
        [swit addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventTouchUpInside];
        [button addSubview:swit];
        
        int i = (y - 70)/55;
        swits[i] = swit;
        [swit setTag:i];
        
        
        if ([[switsState objectAtIndex:i] intValue] == 1) {
            
            [swit setOn:YES animated:NO];
            
        }else {
            [swit setOn:NO animated:NO];
        }

    }
    [self.view addSubview:button];
    
    return button;
}

- (void)clickSwitch:(UISwitch *)sender{
    
    if ([AccountMessage sharedInstance].isAdmin != 1) {
        [JKAlert showMessage:@"您不是管理员"];
        
        return;
    }

    NSString *userId = accountMessage.userId;
    NSString *wid = accountMessage.wid;
    
    if (sender.isOn) {
        switsState[sender.tag] = @"1";
    }
    if (!sender.isOn) {
        switsState[sender.tag] = @"0";
    }
    
    if (sender.tag == 0) {
        
        NSDictionary *sosDict = @{
                                  @"userId":userId,
                                  @"wid":wid,
                                  @"smsonoff":[switsState objectAtIndex:0]
                                  };
        [Command commandWithAddress:@"watch_smsonoff" andParamater:sosDict block:^(NSInteger type) {
            if (type == 100) {
                ;
            }
        }];
    }
    if (sender.tag == 1) {
        
        NSDictionary *lowpowerDict = @{
                                       @"userId":userId,
                                       @"wid":wid,
                                       @"lowbat":[switsState objectAtIndex:1]
                                       };
        [Command commandWithAddress:@"watch_lowbatsms" andParamater:lowpowerDict block:^(NSInteger type) {
            if (type == 100) {
                ;
            }
        }];
    }
    if (sender.tag == 2) {
        NSDictionary *offDict = @{
                                  @"userId":userId,
                                  @"wid":wid,
                                  @"remove":[switsState objectAtIndex:2]
                                  };
        
        
        [Command commandWithAddress:@"watch_removesms" andParamater:offDict block:^(NSInteger type) {
            if (type == 100) {
                ;
            }
        }];

    }
    if (sender.tag == 3) {
        NSDictionary *smsDict = @{
                                  @"userId":userId,
                                  @"wid":wid,
                                  @"sossms":[switsState objectAtIndex:3]
                                  };
        

        [Command commandWithAddress:@"watch_sossms" andParamater:smsDict block:^(NSInteger type) {
            if (type == 100) {
                ;
            }
        }];

    }
}

@end
