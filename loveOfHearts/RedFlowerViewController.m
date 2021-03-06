//
//  RedFlowerViewController.m
//  爱之心
//
//  Created by 于恩聪 on 15/9/4.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "RedFlowerViewController.h"
#import "Constant.h"
#import "Networking.h"
#import "Command.h"
#import "Navigation.h"
#import "AccountMessage.h"

@interface RedFlowerViewController()
{
    UILabel *countLabel;
    
    UIButton *addButton;
    
    UIButton *clearButton;
    
    NSString *flower_count;
    
    NSString *shouhuan_id;
    NSString *user_id;
    
    AccountMessage *accountMessage;
    
}
@end

@implementation RedFlowerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Networking getWatchMessageWithParamater:[AccountMessage sharedInstance].wid block:^(NSDictionary *dict) {
        NSLog(@"watchMessage: %@",dict);
        
        [[AccountMessage sharedInstance] setWatchInfor:dict];
        
        [self initUI];
        
    }];

}


- (void)initUI {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    Navigation *navigation = [Navigation new];
    [self.view addSubview:navigation];
    
    accountMessage = [AccountMessage sharedInstance];
    
    flower_count = accountMessage.flower;
    
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 70, SCREEN_WIDTH - 12, 36)];
    
    [countLabel setTextAlignment:NSTextAlignmentCenter];
    [countLabel setTextColor:DEFAULT_FONT_COLOR];
    
    [countLabel.layer setBorderColor:[UIColor grayColor].CGColor];
    [countLabel.layer setBorderWidth:0.3f];
    [countLabel.layer setCornerRadius:6.f];
    

        [countLabel setText:[NSString stringWithFormat:@"小红花的数量 : %@",accountMessage.flower]];


    
    [self.view addSubview:countLabel];
    
    addButton = [[UIButton alloc] initWithFrame:CGRectMake(6, 112, SCREEN_WIDTH - 12, 36)];
    [addButton setTitle:@"奖励一朵小红花" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [addButton setTitleColor:DEFAULT_FONT_COLOR forState:UIControlStateHighlighted];
    
    [addButton.layer setCornerRadius:6.f];
    [addButton.layer setBorderColor:[UIColor grayColor].CGColor];
    [addButton.layer setBorderWidth:0.3f];
    
    [addButton addTarget:self action:@selector(addRedFlower) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:addButton];
    
    clearButton = [[UIButton alloc] initWithFrame:CGRectMake(6, 154, SCREEN_WIDTH - 12, 36)];
    [clearButton setTitle:@"清空小红花" forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [clearButton setTitleColor:DEFAULT_FONT_COLOR forState:UIControlStateHighlighted];
    
    [clearButton.layer setCornerRadius:6.f];
    [clearButton.layer setBorderWidth:0.3f];
    [clearButton.layer setBorderColor:[UIColor grayColor].CGColor];
    
    [clearButton addTarget:self action:@selector(clearRedFlowers) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:clearButton];
}

- (void)addRedFlower {
    
    if ([AccountMessage sharedInstance].isAdmin != 1) {
        [JKAlert showMessage:@"您不是管理员"];
        
        return;
    }

    int num = 0;
    if (flower_count) {
        num = [flower_count intValue];
        
        if (num == 9) {
            num = -1;
        }
    }
    num++;
    flower_count = [NSString stringWithFormat:@"%d",num];
    
    [countLabel setText:[NSString stringWithFormat:@"小红花的数量 : %@",flower_count]];
    
    [accountMessage setFlower:flower_count];
    
    [self makeSureChange];

}

- (void)clearRedFlowers {
    
    if ([AccountMessage sharedInstance].isAdmin != 1) {
        [JKAlert showMessage:@"您不是管理员"];
        
        return;
    }

    flower_count = [NSString stringWithFormat:@"%d",0];
    
    [countLabel setText:[NSString stringWithFormat:@"小红花的数量 : %d",0]];
    
    [self makeSureChange];

}

- (void)makeSureChange{
    

    NSDictionary *dict = @{
                            @"userId":accountMessage.userId,
                            @"wid":accountMessage.wid,
                            @"flowerNum":flower_count
                           };
    
    [Command commandWithAddress:@"watch_flower" andParamater:dict block:^(NSInteger type) {
        if (type == 100) {
        }
    }];
}
@end
