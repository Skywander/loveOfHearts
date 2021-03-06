//
//  SosphoneSetting.m
//  爱之心
//
//  Created by 于恩聪 on 15/9/9.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "SosphoneSetting.h"
#import "Constant.h"
#import "Command.h"
#import "Navigation.h"
#import "AccountMessage.h"
#import "Networking.h"
#import "JKAlert.h"
@interface SosphoneSetting()
{
    UITextField *textFields[4];
    NSArray *nameArray;
    NSArray *phoneArray;
    NSMutableArray *newPhoneArray;
    
    UIButton *sureButton;
    
    NSString *userAccount;
    NSString *watchID;
    NSArray *sosArray;
    NSString *centerNumber;
    
    AccountMessage *accountMessage;
}
@end
@implementation SosphoneSetting

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    
    Navigation *navigationView = [Navigation new];
    
    [self.view addSubview:navigationView];

    [self.view setBackgroundColor:DEFAULT_COLOR];
    
    [Networking getWatchMessageWithParamater:[AccountMessage sharedInstance].wid block:^(NSDictionary *dict) {
        NSLog(@"watchMessage: %@",dict);
        
        [[AccountMessage sharedInstance] setWatchInfor:dict];
        
        [self initData];
        [self initUI];
        
    }];
}

- (void)initData {
    accountMessage = [AccountMessage sharedInstance];
    
    userAccount = accountMessage.userId;
    
    watchID = accountMessage.wid;
    
    sosArray = [accountMessage.sos componentsSeparatedByString:@","];
    
    centerNumber = accountMessage.centernumber;
    
    nameArray = [NSArray arrayWithObjects:@"1号键电话(SOS1)",@"2号键电话(SOS2)",@"3号键号码(SOS3)",@"中心号码设置", nil];
    
    newPhoneArray = [NSMutableArray new];

}
- (void)initUI {
    [self.view setBackgroundColor:DEFAULT_COLOR];
    CGFloat basicY = 70;
    CGFloat basicMove = 40;
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(6, basicY + i * basicMove, SCREEN_WIDTH / 2 - 6, 36)];
        [label setText:[nameArray objectAtIndex:i]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:15]];
        [label setTextColor:[UIColor blackColor]];
        
        [self.view addSubview:label];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, basicY + basicMove * i, SCREEN_WIDTH / 2 - 6, 36)];
        
        [textField.layer setCornerRadius:6.f];
        
        [textField setBackgroundColor:[UIColor whiteColor]];
        [textField setPlaceholder:@"  请输入号码"];
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
        textFields[i] = textField;
        if (sosArray.count > 0) {
            if (sosArray.count > i && ![[sosArray objectAtIndex:i] isEqualToString:@" "]) {
                [textField setText:[sosArray objectAtIndex:i]];
                }
            if (i == 3 && ![centerNumber isEqualToString:@" "]) {
                [textField setText:centerNumber];
            }

        }        
        [self.view addSubview:textField];
    }
    
    sureButton = [[UIButton alloc] initWithFrame:CGRectMake(6, basicY + 5 * basicMove, SCREEN_WIDTH - 12, 36)];
    [sureButton setBackgroundColor:[UIColor whiteColor]];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureButton setTitleColor:DEFAULT_COLOR forState:UIControlStateHighlighted];
    [sureButton addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
    
    [sureButton.layer setCornerRadius:6.f];
    
    [self.view addSubview:sureButton];
}

- (void)clickSureButton {
    
    if ([AccountMessage sharedInstance].isAdmin != 1) {
        [JKAlert showMessage:@"您不是管理员"];
        
        return;
    }

    
    for (int i = 0; i < 4; i ++) {
        [newPhoneArray addObject:textFields[i].text];
        
        if (textFields[i].text.length > 0 && textFields[i].text.length!=11) {
            
            
            
            NSLog(@"TextField:%@ length: %ld",textFields[i].text,textFields[i].text.length);
            
            [JKAlert showMessage:@"输入号码不正确"];
            
            [textFields[i] becomeFirstResponder];
            newPhoneArray = [NSMutableArray new];
            return;
        }
        
        if (textFields[i].text.length <= 0) {
            [JKAlert showMessage:@"请完善信息"];
            [textFields[i] becomeFirstResponder];
            newPhoneArray = [NSMutableArray new];
            return;

        }
    }
    
    NSString *tempString = [NSString stringWithFormat:@"%@,%@,%@",textFields[0].text,textFields[1].text,textFields[2].text];
    
    NSLog(@"tempString : %@",tempString);
    
    NSDictionary *dict = @{
                            @"userId":userAccount,
                            @"wid":watchID,
                            @"sos":tempString
                           };
    
    [Command commandWithAddress:@"watch_sos" andParamater:dict block:^(NSInteger type) {
        if (type == 100) {
        }
    }];
    accountMessage.sos = tempString;
    
        
        NSDictionary *paramater = @{
                                @"userId":userAccount,
                                @"wid":watchID,
                                @"centerNumber":textFields[3].text
                               };
        
        [Command commandWithAddress:@"watch_center" andParamater:paramater block:^(NSInteger type) {
            if (type == 100) {
            }
        }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
