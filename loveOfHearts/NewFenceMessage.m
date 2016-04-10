//
//  NewFenceMessage.m
//  爱之心
//
//  Created by 于恩聪 on 15/9/24.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "NewFenceMessage.h"
#import "Constant.h"
#import "Command.h"
#import "Navigation.h"
#import "AccountMessage.h"
#import "NavigationProtocol.h"
#define BASIC_HEIGHT 36
#define BASIC_SPACE 4
#define BASIC_DISTANCE 40

@interface NewFenceMessage()<NavigationProtocol>
{
    UITextField *fenceNameTextField;
    
    UIButton *inButton;
    UIButton *outButton;
    
    UIButton *selectedButton;
    
    NSString *type;
    NSString *fencename;
}

@end

@implementation NewFenceMessage
@synthesize fencesArray;
-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
}

- (void)initData{
    type = @"0";
}

- (void)initUI {
    [self.view setBackgroundColor:DEFAULT_COLOR];
    Navigation *naviView = [Navigation new];
    [naviView addRightViewWithName:@"确定"];
    [naviView setDelegate:self];
    [self.view addSubview:naviView];
    
    //围栏姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH - 20, BASIC_HEIGHT)];
    [nameLabel setText:@"输入围栏名称"];
    [nameLabel setTextColor:[UIColor blackColor]];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:nameLabel];
    
    fenceNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 70 + BASIC_HEIGHT + BASIC_SPACE, SCREEN_WIDTH - 20,BASIC_HEIGHT)];
    [fenceNameTextField setPlaceholder:@"如学校，家，公园"];
    [fenceNameTextField setTextAlignment:NSTextAlignmentCenter];
    
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(40, 70 + BASIC_DISTANCE * 2 , SCREEN_WIDTH - 80, 1)];
    [lineview setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:lineview];
    
    [self.view addSubview:fenceNameTextField];
    
    //进出警告
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70 + BASIC_DISTANCE * 2, SCREEN_WIDTH - 20, BASIC_HEIGHT)];
    [typeLabel setTextAlignment:NSTextAlignmentCenter];
    [typeLabel setText:@"围栏进出警告"];
    [typeLabel setTextColor:DEFAULT_FONT_COLOR];
    
    [self.view addSubview:typeLabel];
    
    inButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 70 + BASIC_DISTANCE * 3, (SCREEN_WIDTH - 20)  / 2, BASIC_HEIGHT)];
    [inButton setTitle:@"进去警告" forState:(UIControlStateNormal)];
    [inButton setTag:1];
    [inButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [inButton setTitleColor:DEFAULT_PINK forState:UIControlStateSelected];
    [inButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [inButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [inButton setSelected:YES];
    [inButton addTarget:self action:@selector(chooseAlarmType:) forControlEvents:UIControlEventTouchUpInside];
    
    outButton = [[UIButton alloc] initWithFrame:CGRectMake(10 + (SCREEN_WIDTH - 20)  / 2, 70 + BASIC_DISTANCE * 3, (SCREEN_WIDTH - 20)  / 2, BASIC_HEIGHT)];
    [outButton setTitle:@"离开警告" forState:UIControlStateNormal];
    [outButton setTag:2];
    [outButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [outButton setTitleColor:DEFAULT_PINK forState:UIControlStateSelected];
    [outButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [outButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [outButton addTarget:self action:@selector(chooseAlarmType:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:inButton];
    [self.view addSubview:outButton];
    
    UIView *lineview_1 = [[UIView alloc] initWithFrame:CGRectMake(20, 70 + BASIC_DISTANCE * 4, SCREEN_WIDTH- 40, 1)];
    [lineview_1 setBackgroundColor:DEFAULT_COLOR];
    [self.view addSubview:lineview_1];
    
}

- (void)chooseAlarmType:(UIButton *)sender {
    [sender setSelected:YES];
    if (sender.tag == 1) {
        outButton.selected = NO;
    }
    if (sender.tag == 2) {
        inButton.selected = NO;
    }
    type = [NSString stringWithFormat:@"%ld",(long)sender.tag];

}

- (void)clickNavigationRightView{
    AccountMessage *accountMessage = [AccountMessage sharedInstance];
    
    NSDictionary *paramater = @{
                                @"userId":accountMessage.userId,
                                @"wid":accountMessage.wid,
                                @"fenceType":@"1",
                                @"alertType":type,
                                @"area":self.fenceData,
                                @"name":fenceNameTextField.text
                                };
    [Command commandWithAddress:@"fence_addFence" andParamater:paramater block:^(NSInteger _type) {
        if (_type == 100) {
            [self dismissViewControllerAnimated:YES completion:^{
                ;
            }];
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
