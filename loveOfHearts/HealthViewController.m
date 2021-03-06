//
//  HealthViewController.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/23.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "HealthViewController.h"

#import "Navigation.h"

#import "AccountMessage.h"

#import "Command.h"

#import "Networking.h"

@interface HealthViewController ()
{
    AccountMessage *accountMessage;
    
    NSString *pedo;
    NSString *roll;
    
    NSString *userId;
    NSString *wid;
    
    UISwitch *swits[2];
    NSMutableArray *switsState;
    
    UIButton *pedoButton;
    UIButton *rollButton;
}

@end

@implementation HealthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Networking getWatchMessageWithParamater:[AccountMessage sharedInstance].wid block:^(NSDictionary *dict) {
        NSLog(@"watchMessage: %@",dict);
        
        [[AccountMessage sharedInstance] setWatchInfor:dict];
        
        [self initData];
        [self initView];
        
    }];
}

- (void)initData{
    accountMessage = [AccountMessage sharedInstance];
    
    pedo = accountMessage.pedo;
    
    if (pedo == NULL) {
        pedo = @"0";
    }
    
    roll = accountMessage.turn;
    
    if ([roll isEqualToString:@" "] || [roll isEqualToString:@"00:00-00:00"] || roll == NULL) {
        roll = @"0";
    }
    
    if ([roll isEqualToString:@"00:00-23:59"]) {
        roll = @"1";
    }
    
    userId = accountMessage.userId;
    
    wid = accountMessage.wid;
    
    switsState = [NSMutableArray new];
    
    [switsState addObject:pedo];
    
    [switsState addObject:roll];
    
    
    
}

- (void)initView{
    [self.view setBackgroundColor:DEFAULT_COLOR];
    
    Navigation *navigationView = [Navigation new];
    
    [self.view addSubview:navigationView];
    
    CGFloat basicMove = 60;
    
    pedoButton = [self buttonWthName:@"      计步开关" andPointY:70];
    
    rollButton = [self buttonWthName:@"     翻转警告" andPointY:70 + basicMove];
}

- (UIButton *)buttonWthName:(NSString *)name andPointY:(CGFloat)y {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(6, y, SCREEN_WIDTH - 12, 50)];
    [button setBackgroundColor:[UIColor whiteColor]];
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
        
        int i = (y - 70)/40;
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

    if (sender.isOn) {
        switsState[sender.tag] = @"1";
    }
    if (!sender.isOn) {
        switsState[sender.tag] = @"0";
    }
    
    if (sender.tag == 0) {
        NSDictionary *dict = @{
                                @"userId":userId,
                                @"wid":wid,
                                @"pedo":switsState[sender.tag]
                               };
        [Command commandWithAddress:@"watch_pedo" andParamater:dict block:^(NSInteger type) {
            if (type == 100) {
            }
        }];
    }
    if (sender.tag == 1) {
        
        NSString *timeString = [NSString new];
        
        if (sender.isOn) {
            timeString = @"00:00-23:59";
        }else{
            timeString = @"00:00-00:00";
        }
        
        NSDictionary *dict = @{
                                @"userId":userId,
                                @"wid":wid,
                                @"turnTime":timeString
                               };
        
        [Command commandWithAddress:@"watch_turnSwitch" andParamater:dict block:^(NSInteger type) {
            if (type == 100) {
            };
        }];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
