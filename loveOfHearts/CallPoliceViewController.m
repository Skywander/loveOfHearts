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
@interface CallPoliceViewController()
{
    UIButton *sosButton;
    UIButton *lowPowerButton;
    UIButton *takeDownWatch;
    UIButton *pedometerButton;
    UIButton *messageButton;
    
    UISwitch *swits[5];
    NSMutableArray *switsState;
    
    UIButton *sureButton;
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
    NSMutableArray *tempArray = [[NSUserDefaults standardUserDefaults ]objectForKey:@"CallPoliceSettingState"];
    if (tempArray) {
        switsState = [NSMutableArray arrayWithArray:tempArray];
    }
    
    if (!switsState) {
        switsState = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",nil];
    }
    
    NSLog(@"switState%@",switsState);
}

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    Navview *navigation = [Navview new];
    [self.view addSubview:navigation];
    
    CGFloat basicMove = 40;

    sosButton = [self buttonWthName:@"      SOS短信报警" andPointY:70];
    
    lowPowerButton = [self buttonWthName:@"     低电短信报警" andPointY:70 + basicMove];
    
    takeDownWatch = [self buttonWthName:@"      取下手表报警" andPointY:70 + basicMove * 2];
    
    pedometerButton = [self buttonWthName:@"      计步功能" andPointY:70  + basicMove * 3];
    
    messageButton = [self buttonWthName:@"      短信" andPointY:70 + basicMove * 4];
    
    sureButton = [self buttonWthName:@"确定" andPointY:0];
    [sureButton setFrame:CGRectMake(6, 70 + basicMove * 6, SCREEN_WIDTH - 12, 36)];
    [sureButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [sureButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentCenter)];
    [sureButton addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
}

- (UIButton *)buttonWthName:(NSString *)name andPointY:(CGFloat)y {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(6, y, SCREEN_WIDTH - 12, 36)];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
    [button setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    [button.layer setCornerRadius:6.f];
    [button.layer setBorderColor:[UIColor grayColor].CGColor];
    [button.layer setBorderWidth:0.3f];
    if (y != 0) {
        UISwitch *swit = [UISwitch new];
        [swit setFrame:CGRectMake(SCREEN_WIDTH - 12 - 60, 3, 10, 40)];
        [swit setOnTintColor:DEFAULT_COLOR];
        [swit addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventTouchUpInside];
        [button addSubview:swit];
        
        int i = (y - 70)/40;
        swits[i] = swit;
        [swit setTag:i];
        
        if ([[switsState objectAtIndex:i] isEqualToString:@"1"]) {
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
    
    [[NSUserDefaults standardUserDefaults] setObject:switsState forKey:@"CallPoliceSettingState"];
    
    
}

@end
