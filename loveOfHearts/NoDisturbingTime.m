//
//  NoDisturbingTime.m
//  爱之心
//
//  Created by 于恩聪 on 15/10/4.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "NoDisturbingTime.h"
#import "IQActionSheetPickerView.h"
#import "Command.h"
#import "Networking.h"
#import "Navigation.h"
#import "AccountMessage.h"



@interface NoDisturbingTime()<IQActionSheetPickerViewDelegate>
{
    CGFloat basicX;
    CGFloat basicY;
    CGFloat basicMove;
    
    IQActionSheetPickerView *picker;
    
    NSMutableArray *contentArray;
    UIButton *buttons[8];
    UIButton *selectedButton;
    
    NSString *paramater;
    
    NSString *nodisturbTime;
    
    NSMutableArray *timeArray;
    
    AccountMessage *accountMessage;
    int timeCount;
}

@end
@implementation NoDisturbingTime

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [Networking getWatchMessageWithParamater:[AccountMessage sharedInstance].wid block:^(NSDictionary *dict) {
        NSLog(@"watchMessage: %@",dict);
        
        [[AccountMessage sharedInstance] setWatchInfor:dict];
        
        [self initData];
        [self initUI];
        
    }];
}

- (void)initData{
    basicMove = 50;
    
    basicY = 70;
    
    contentArray = [NSMutableArray arrayWithObjects:@"时间段一",@"时间段二",@"时间段三",@"时间段四",nil];
    
    picker = [[IQActionSheetPickerView alloc] initWithTitle:@"选择时间" delegate:self];
    [picker setTag:8];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleTimePicker];
    
    accountMessage = [AccountMessage sharedInstance];
    
    NSString *silenceTime = accountMessage.silencetime;
    
    NSLog(@"silence : %@",silenceTime);
    
    if (![silenceTime isEqualToString:@" "] && silenceTime != NULL) {
        NSArray *silenceArray = [silenceTime componentsSeparatedByString:@","];
        
        timeArray = [NSMutableArray new];
        
        for (NSString *silence in silenceArray) {
            NSArray *singleArray = [silence componentsSeparatedByString:@"-"];
            
            [timeArray addObjectsFromArray:singleArray];
        }
    }else{
        timeArray = [NSMutableArray arrayWithObjects:@"00:00",@"00:00",@"00:00",@"00:00",@"00:00",@"00:00",@"00:00",@"00:00",@"00:00",@"00:00",nil];
    }
}

- (void)initUI{
    [self.view setBackgroundColor:DEFAULT_COLOR];
    
    Navigation *navigation = [Navigation new];
    [self.view addSubview:navigation];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 70, SCREEN_WIDTH, 40)];
    
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [titleLabel setText:@"温馨提示:宝贝正在学习，请勿打扰"];
    
    [titleLabel setTextColor:DEFAULT_FONT_COLOR];
    
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    [self.view addSubview:titleLabel];
    
    timeCount = 0;

    [self initViewWithPointY:basicY + basicMove andTag:0];
    
    [self initViewWithPointY:basicY + basicMove * 2 andTag:1];
    
    [self initViewWithPointY:basicY + basicMove * 3 andTag:2];
    
    [self initViewWithPointY:basicY + basicMove * 4 andTag:3];
    
    UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(6, basicMove * 5 + basicY, SCREEN_WIDTH - 12, 40)];
    
    [sureButton setBackgroundColor:[UIColor whiteColor]];
    
    [sureButton.layer setBorderColor:[UIColor grayColor].CGColor];
    [sureButton.layer setBorderWidth:0.3f];
    [sureButton.layer setCornerRadius:6.f];
    
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:DEFAULT_FONT_COLOR forState:UIControlStateNormal];
    [sureButton setTitleColor:DEFAULT_COLOR forState:UIControlStateHighlighted];
    [sureButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:sureButton];
    
    [sureButton addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];

}

- (void)initViewWithPointY:(CGFloat)y andTag:(NSInteger)tag{
    //第一个
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(6, y, SCREEN_WIDTH - 12, 40)];
    
    [view setUserInteractionEnabled:YES];
    
    [view setBackgroundColor:[UIColor whiteColor]];
    
    [view.layer setBorderColor:[UIColor grayColor].CGColor];
    
    [view.layer setBorderWidth:0.3f];

    [view.layer setCornerRadius:6.f];
    
    [view setClipsToBounds:YES];
    
    //时间段
    UILabel *firstlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3 - 4, 40)];
    
    [firstlabel setTextColor:DEFAULT_FONT_COLOR];
    
    [firstlabel setText:[contentArray objectAtIndex:(y - basicY) / basicMove - 1]];
    
    [firstlabel setTextAlignment:NSTextAlignmentCenter];
    
    [view addSubview:firstlabel];
    
    //第一个button
    
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3 - 4,0 ,( SCREEN_WIDTH / 3 - 4 ) * 2, 40)];
    [secondLabel setUserInteractionEnabled:YES];
    [secondLabel setText:@":"];
    
    [secondLabel setTextColor:DEFAULT_FONT_COLOR];
    
    [secondLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    UIButton *firstButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH / 3 - 6, 40)];
    
    [firstButton setTitle:[timeArray objectAtIndex:timeCount++] forState:UIControlStateNormal];
    
    [firstButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [firstButton setTitleColor:DEFAULT_FONT_COLOR forState:UIControlStateNormal];
    
    [firstButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    buttons[(int)((y - basicY)/basicMove*2 - 2)] = firstButton;
    
    [secondLabel addSubview:firstButton];
    
    //第二个buttton
    
    UIButton *secondButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3 - 2,0, SCREEN_WIDTH / 3 - 4, 40)];
    
    [secondButton setTitleColor:DEFAULT_FONT_COLOR forState:UIControlStateNormal];
    
    [secondButton setTitle:[timeArray objectAtIndex:timeCount++] forState:UIControlStateNormal];
    
    [secondButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [secondButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    buttons[(int)((y - basicY)/basicMove*2 - 1)] = secondButton;
    
    [secondLabel addSubview:secondButton];
    
    [view addSubview:secondLabel];
    
    [self.view addSubview:view];
}

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    formatter.dateFormat = @"HH:mm";
    [selectedButton setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
    [selectedButton setTitleColor:SELECTED_FONT_COLOR forState:UIControlStateNormal];

}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(BOOL)shouldAutorotate
{
    return YES;
}


- (void)clickButton:(UIButton *)sender{
    NSLog(@"clickTimeButton");
    
    selectedButton = sender;
    
    [picker show];
}

- (void)clickSureButton{
    paramater = [NSString new];
    for (int i = 1; i < 5; i ++) {
        NSString *firstTitle = buttons[i*2 - 2].titleLabel.text;
        
        NSString *secondTitle = buttons[i*2 - 1].titleLabel.text;
        
        NSLog(@"firstTitle : %@",firstTitle);
        
        NSLog(@"secondTitle : %@",secondTitle);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSDate *startTime = [dateFormatter dateFromString:firstTitle];
        
        NSDate *endTime = [dateFormatter dateFromString:secondTitle];
        
        if ([endTime compare:startTime] == NSOrderedAscending) {
            return;
        };
        
        paramater = [NSString stringWithFormat:@"%@,%@-%@",paramater,firstTitle,secondTitle];

    }
    NSRange range = {1,paramater.length - 1};
    
    paramater = [paramater substringWithRange:range];
    
    NSLog(@"paramater : %@",paramater);
    
    NSDictionary *paramaters = @{
                                 @"userId":accountMessage.userId,
                                 @"wid":accountMessage.wid,
                                 @"silence":paramater
                                };
    [Command commandWithAddress:@"watch_silence" andParamater:paramaters block:^(NSInteger type) {
        if (type == 100) {
            ;
        }
    }];
    
    accountMessage.tempsilencetime = paramater;
}

@end
