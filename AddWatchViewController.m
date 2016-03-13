//
//  addWatchViewController.m
//  爱之心
//
//  Created by 于恩聪 on 15/9/4.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "AddWatchViewController.h"
#import "SYQRCodeViewController.h"
#import "Constant.h"
#import "AddWatchByInput.h"
#import "Alert.h"

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
    
    idButton = [[UIButton alloc] initWithFrame:CGRectMake(6, 74, SCREEN_WIDTH - 12, 36)];
    [idButton setTitle:@"通过ID添加手表" forState:UIControlStateNormal];
    [idButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [idButton setTitleColor:DEFAULT_COLOR forState:UIControlStateHighlighted];
    
    [idButton.layer setBorderColor:[UIColor grayColor].CGColor];
    [idButton.layer setBorderWidth:0.3f];
    [idButton.layer setCornerRadius:6.f];
    
    [idButton addTarget:self action:@selector(addWatchByID) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:idButton];
    
    codeButton = [[UIButton alloc] initWithFrame:CGRectMake(6, 116, SCREEN_WIDTH - 12, 36)];
    [codeButton setTitle:@"扫描二维码添加手表" forState:UIControlStateNormal];
    [codeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [codeButton setTitleColor:DEFAULT_COLOR forState:UIControlStateHighlighted];
    
    [codeButton.layer setCornerRadius:6.f];
    [codeButton .layer setBorderWidth:0.3f];
    [codeButton.layer setBorderColor:[UIColor grayColor].CGColor];
    
    [codeButton addTarget:self action:@selector(addWatchByCode) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:codeButton];
}
- (void)addWatchByID {
    AddWatchByInput *addwatch = [AddWatchByInput new];
    addwatch.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addwatch animated:YES];
}

- (void)addWatchByCode {
    SYQRCodeViewController *qrcodevc = [[SYQRCodeViewController alloc] init];
    qrcodevc.SYQRCodeSuncessBlock = ^(SYQRCodeViewController *aqrvc,NSString *qrString){
        //        self.saomiaoLabel.text = qrString;
                
        AddWatchByInput *addWatch = [AddWatchByInput new];
        addWatch.shouhuan_id = qrString;
        addWatch.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addWatch animated:YES];
    };
    qrcodevc.SYQRCodeFailBlock = ^(SYQRCodeViewController *aqrvc){
        //        self.saomiaoLabel.text = @"fail~";
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
    };
    qrcodevc.SYQRCodeCancleBlock = ^(SYQRCodeViewController *aqrvc){
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
        //        self.saomiaoLabel.text = @"cancle~";
    };
    timer =  [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(resetBar) userInfo:nil repeats:NO];
    [self.navigationController pushViewController:qrcodevc animated:YES];
}

- (void)resetBar {
    self.hidesBottomBarWhenPushed = NO;
}

@end
