//
//  PasswordViewController.m
//  喔喔农机
//
//  Created by 于恩聪 on 15/12/21.
//  Copyright © 2015年 于恩聪. All rights reserved.
//

#import "PasswordViewController.h"
#import "NewPasswordViewController.h"
#define HIGH_COLOR [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1]
#define DEFAULT_COLOR [UIColor whiteColor]

@interface PasswordViewController (){
    UITextField *phoneNumber;
    UIButton *sureButton;
    
    UIView *codeView;
    UITextField *codeField;
    UIButton *codeButton;
}

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self makeConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initUI{
    [self.view setBackgroundColor:BACKGROUND_COLOR];
    
    [self initNavigation];
    
    phoneNumber = [UITextField new];
    [phoneNumber setBackgroundColor:[UIColor whiteColor]];
    
    [phoneNumber.layer setCornerRadius:6.f];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"username"]];
    [imageView setFrame:CGRectMake(0, 0, CELL_HEIGHT, CELL_HEIGHT)];
    [phoneNumber setLeftView:imageView];
    [phoneNumber setLeftViewMode:UITextFieldViewModeAlways];
    [phoneNumber setPlaceholder:@" 输入手机号码"];
    [phoneNumber setKeyboardType:UIKeyboardTypeNumberPad];
    
    [self.view addSubview:phoneNumber];
    
    codeView = [UIView new];
    [codeView setBackgroundColor:BACKGROUND_COLOR];
    [self.view addSubview:codeView];
    
    codeField = [UITextField new];
    [codeField setBackgroundColor:[UIColor whiteColor]];
    [codeField setKeyboardType:UIKeyboardTypeNumberPad];
    [codeField.layer setCornerRadius:CORNER_RIDUS];
    
    [codeView addSubview:codeField];
    
    codeButton = [UIButton new];
    [codeButton setBackgroundColor:[UIColor whiteColor]];
    [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [codeButton setTitleColor:DEFAULT_COLOR forState:UIControlStateHighlighted];
    [codeButton.layer setCornerRadius:CORNER_RIDUS];
    
    [codeButton addTarget:self action:@selector(clickCodeButton) forControlEvents:UIControlEventTouchUpInside];
    [codeButton addTarget:self action:@selector(touchInsideButton:) forControlEvents:UIControlEventTouchDown];
    
    [codeView addSubview:codeButton];
    
    sureButton = [UIButton new];
    [sureButton setBackgroundColor:[UIColor whiteColor]];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [sureButton setTitleColor:DEFAULT_COLOR forState:UIControlStateHighlighted];
    
    [sureButton.layer setCornerRadius:CORNER_RIDUS];
    
    [sureButton addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
    [sureButton addTarget:self action:@selector(touchInsideButton:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:sureButton];
}

- (void)initNavigation{
    CGFloat statusBarHeight=0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight=20;
        UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        [self.view addSubview:statusView];
        
        [statusView setBackgroundColor:NAVI_COLOR];
    }
    
    //创建一个导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0+statusBarHeight, self.view.frame.size.width, 44)];
    
    [navigationBar setBarTintColor:NAVI_COLOR];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(clickLeftButton)];
    [leftButton setTintColor:NAVI_FONT_COLOR];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [titleLabel setText:@"找回密码"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [navigationItem setTitleView:titleLabel];
    
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setLeftBarButtonItem:leftButton];
    
    [self.view addSubview:navigationBar];
    
}

- (void)makeConstraints{
    [phoneNumber mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view).with.offset(OFFSET);
        make.right.equalTo(self.view).with.offset(-OFFSET);
        make.top.equalTo(self.view).with.offset(80);
        make.height.equalTo(@(CELL_HEIGHT));
    }];
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneNumber);
        make.right.equalTo(phoneNumber);
        make.top.equalTo(phoneNumber).with.offset(CELL_HEIGHT + OFFSET);
    }];
    
    [codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeView);
        make.top.equalTo(codeView);
        make.bottom.equalTo(codeView);
        make.width.equalTo(@((SCREEN_WIDTH - 3*OFFSET)/2));
    }];
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(codeView);
        make.bottom.equalTo(codeView);
        make.top.equalTo(codeView);
        make.width.equalTo(@((SCREEN_WIDTH - 3*OFFSET)/2));
    }];
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneNumber);
        make.right.equalTo(phoneNumber);
        make.top.equalTo(codeView).with.offset(CELL_HEIGHT + OFFSET);
        make.height.equalTo(@(CELL_HEIGHT));
    }];
}

- (void)clickLeftButton{
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

- (void)clickSureButton{
    [sureButton setBackgroundColor:DEFAULT_COLOR];
    
    NewPasswordViewController *newPassword = [NewPasswordViewController new];
    [self presentViewController:newPassword animated:YES completion:nil];
}
- (void)clickCodeButton{
    [codeButton setBackgroundColor:DEFAULT_COLOR];
}
- (void)touchInsideButton:(UIButton *)sender{
    [sender setBackgroundColor:HIGH_COLOR];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
