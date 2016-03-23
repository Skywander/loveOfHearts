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
#import "Navview.h"
#import "AccountMessage.h"
@interface CallPoliceViewController()
{
    UIButton *sosButton;
    UIButton *lowPowerButton;
    UIButton *takeDownWatch;
    UIButton *messageButton;
    
    UISwitch *swits[5];
    NSMutableArray *switsState;
    
    UIButton *sureButton;
    
    AccountMessage *accountMessage ;
}

@end
@implementation CallPoliceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initData];
    [self initUI];
}

- (void)initData {
    switsState = [NSMutableArray new];
    
    accountMessage = [AccountMessage sharedInstance];
    
    [switsState addObject:accountMessage.smsonoff];
    [switsState addObject:accountMessage.lowbat];
    [switsState addObject:accountMessage.remove];
    [switsState addObject:accountMessage.sossms];
    
    NSLog(@"switState%@",switsState);
}

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    Navview *navigation = [Navview new];
    [self.view addSubview:navigation];
    
    CGFloat basicMove = 55;

    sosButton = [self buttonWthName:@"      短信开关" andPointY:70];
    
    lowPowerButton = [self buttonWthName:@"     低电报警" andPointY:70 + basicMove];
    
    takeDownWatch = [self buttonWthName:@"      脱落报警" andPointY:70 + basicMove * 2];
    
    
    messageButton = [self buttonWthName:@"      SOS报警" andPointY:70 + basicMove * 3];
    
    sureButton = [self buttonWthName:@"确定" andPointY:0];
    [sureButton setFrame:CGRectMake(6, 70 + basicMove * 5, SCREEN_WIDTH - 12, 50)];
    [sureButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [sureButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentCenter)];
    [sureButton addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
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
    if (sender.isOn) {
        switsState[sender.tag] = @"1";
    }
    if (!sender.isOn) {
        switsState[sender.tag] = @"0";
    }
}


- (void)clickSureButton {
    NSString *userId = accountMessage.userId;
    NSString *wid = accountMessage.wid;
    
    NSLog(@"userid : %@ wid : %@",userId,wid);
    
    NSDictionary *sosDict = @{
                                @"userId":userId,
                                @"wid":wid,
                                @"onoroff":[switsState objectAtIndex:0]
                              };
    [Command commandWithAddress:@"sossms" andParamater:sosDict];
    
    NSDictionary *lowpowerDict = @{
                                   @"userId":userId,
                                   @"wid":wid,
                                   @"lowbat":[switsState objectAtIndex:1]
                                   };
    [Command commandWithAddress:@"lowbat" andParamater:lowpowerDict];
    
    NSDictionary *offDict = @{
                                @"userId":userId,
                                @"wid":wid,
                                @"remove":[switsState objectAtIndex:2]
                              };
    
    
    [Command commandWithAddress:@"remove" andParamater:offDict];

    NSDictionary *smsDict = @{
                                @"userId":userId,
                                @"wid":wid,
                                @"smsonoff":[switsState objectAtIndex:3]
                              };
    
    [Command commandWithAddress:@"smsonoff" andParamater:smsDict];
    
}

@end
