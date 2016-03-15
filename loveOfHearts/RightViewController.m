//
//  RightViewController.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/14.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "RightViewController.h"
#import "RightVieFactory.h"

#define RIGHT_BUTTON_WIDTH 465/2.0

#define RIGHT_BUTTON_HEIGHT 95/2.0

@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view setBackgroundColor:DEFAULT_COLOR];
    
    [self initButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initButton{
    NSArray *buttonNames = [NSArray arrayWithObjects:@"babyManage",@"authority",@"relativeNumber",@"1",@"2",@"fences",@"historyTrack",@"findWatch",@"otherSetting",@"exit", nil];
    
    float y = 64;
    
    for (NSString *buttonName in buttonNames) {
        [self initButtonWithTitle:buttonName andY:y];
        
        y = y + RIGHT_BUTTON_HEIGHT + 1;
    }
}


- (void)initButtonWithTitle:(NSString *)title andY:(float)y{
    UIButton *button = [UIButton new];
    
    [button setFrame:CGRectMake(10, y, RIGHT_BUTTON_WIDTH, RIGHT_BUTTON_HEIGHT)];
    
    [button setBackgroundImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
    
    [self.view addSubview:button];
    
    [button setTag:(int)(y - 64) / (RIGHT_BUTTON_HEIGHT) + 1];
    
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return;
}

- (void)clickButton:(UIButton *)button{
    [self presentViewController:[RightVieFactory factoryWithTag:(int)button.tag] animated:YES completion:^{
        ;
    }];

}

@end
