//
//  BabyManageViewController.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/15.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "BabyManageViewController.h"

@interface BabyManageViewController ()

@end

@implementation BabyManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:DEFAULT_COLOR];
    
    [self initNavigation];
}

- (void)initNavigation{
    UIView *view = [UIView new];
    
    [view setBackgroundColor:DEFAULT_PINK];
    
    [view setFrame:CGRectMake(0, 20, SCREEN_WIDTH, NAVIGATION_HEIGHT)];
    
    //返回按键
    
    UIButton *returnButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, NAVIGATION_HEIGHT, NAVIGATION_HEIGHT)];
    
    [returnButton setBackgroundColor:[UIColor blackColor]];
    
    [returnButton addTarget:self action:@selector(returnLastView) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:returnButton];
    
    //添加
    
    UIButton *expandButton = [UIButton new];
    
    [expandButton setFrame:CGRectMake(SCREEN_WIDTH - NAVIGATION_HEIGHT, 0, NAVIGATION_HEIGHT, NAVIGATION_HEIGHT)];
    
    [expandButton setTitle:@"添加" forState:UIControlStateNormal];
    
    [expandButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [expandButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
     
    [view addSubview:expandButton];
     
    [self.view addSubview:view];
    
}

- (void)returnLastView{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

//- (void)expand{
//    ;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
