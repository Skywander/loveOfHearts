//
//  addWatchViewController.m
//  爱之心
//
//  Created by 于恩聪 on 15/9/4.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "AddWatchViewController.h"
#import "SYQRCodeViewController.h"
#import "AddWatchByInput.h"
#import "Navigation.h"

#import "ScanViewController.h";

@interface AddWatchViewController()
{
    UIButton *idButton;
    UIButton *codeButton;
    
    NSTimer *timer;
}

@end
@implementation AddWatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    Navigation *navigation = [Navigation new];
    
    [self.view addSubview:navigation];
    
    idButton = [[UIButton alloc] initWithFrame:CGRectMake(6, 74, SCREEN_WIDTH - 12, 36)];
    [idButton setTitle:@"通过ID添加手表" forState:UIControlStateNormal];
    [idButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [idButton setTitleColor:DEFAULT_FONT_COLOR forState:UIControlStateHighlighted];
    
    [idButton.layer setBorderColor:[UIColor grayColor].CGColor];
    [idButton.layer setBorderWidth:0.3f];
    [idButton.layer setCornerRadius:6.f];
    
    [idButton addTarget:self action:@selector(addWatchByID) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:idButton];
    
    codeButton = [[UIButton alloc] initWithFrame:CGRectMake(6, 116, SCREEN_WIDTH - 12, 36)];
    [codeButton setTitle:@"扫描二维码添加手表" forState:UIControlStateNormal];
    [codeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [codeButton setTitleColor:DEFAULT_FONT_COLOR forState:UIControlStateHighlighted];
    
    [codeButton.layer setCornerRadius:6.f];
    [codeButton .layer setBorderWidth:0.3f];
    [codeButton.layer setBorderColor:[UIColor grayColor].CGColor];
    
    [codeButton addTarget:self action:@selector(addWatchByCode) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:codeButton];
}
- (void)addWatchByID {
    AddWatchByInput *addwatch = [AddWatchByInput new];

    [self presentViewController:addwatch animated:YES completion:^{
        ;
    }];
}

- (void)addWatchByCode {

    ScanViewController *_scan = [[ScanViewController alloc]init];
    
    [self presentViewController:_scan animated:YES completion:^{
        ;
    }];

    [_scan finishingBlock:^(NSString *string) {
        
        [_scan dismissViewControllerAnimated:YES completion:^{
            ;
        }];
        
        AddWatchByInput *addWatchByInput = [AddWatchByInput new];
        
        addWatchByInput.wid = string;
        
        [self presentViewController:addWatchByInput animated:YES completion:^{
            ;
        }];
    }];
}


@end
