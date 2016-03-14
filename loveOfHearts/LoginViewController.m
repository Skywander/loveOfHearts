//
//  ViewController.m
//  喔喔农机
//
//  Created by 于恩聪 on 15/12/17.
//  Copyright © 2015年 于恩聪. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "PasswordViewController.h"
#import "Networking.h"
#import "Alert.h"

@interface LoginViewController (){
    UIView *backView;
    
    UIView *logoView;
    
    UITextField *userName;
    UITextField *password;
    
    UIButton *registerButton;
    UIButton *findPasswordButton;
    UIButton *sureButton;
    
    //
    NSTimer *returnMessageInterval;
    
    //userId userPassword
    NSString *userId;
    NSString *userPassword;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initData{
    NSString *tempID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userAccount"];
    
    NSString *tempPassword = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@.password",tempID]];
    
    
    if (tempID && tempPassword) {
        userId = tempID;
        userPassword = tempPassword;
    }else{
        userPassword = @"  输入密码";
        userId = @"  输入手机号码";
    }
    
}

- (void)initUI{
    [self.view setBackgroundColor:BACKGROUND_COLOR];
    
    backView = [UIView new];
    [backView setBackgroundColor:BACKGROUND_COLOR];
    [self.view addSubview:backView];
    
    userName = [UITextField new];
    password = [UITextField new];

    [userName.layer setCornerRadius:CORNER_RIDUS];
    [userName setKeyboardType:UIKeyboardTypeDefault];
//    [userName setPlaceholder:userId];
    [userName setText:userId];
    
    UIImageView *userLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"username"]];
    [userLeftView setFrame:CGRectMake(0, 0, 50, 50)];
    [userName setLeftView:userLeftView];
    [userName setLeftViewMode:UITextFieldViewModeAlways];
    [userName setBackgroundColor:[UIColor whiteColor]];
    
    [password.layer setCornerRadius:CORNER_RIDUS];
//    [password setPlaceholder:userPassword];
    [password setText:userPassword];
    [password setSecureTextEntry:YES];
    [password setKeyboardType:UIKeyboardTypeDefault];
    [password setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *passwordLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userpassword"]];
    [passwordLeftView setFrame:CGRectMake(0, 0, 50, 50)];
    [password setLeftView:passwordLeftView];
    [password setLeftViewMode:UITextFieldViewModeAlways];
    
    
    sureButton = [UIButton new];
    [sureButton setBackgroundColor:[UIColor whiteColor]];
    [sureButton setTitle:@"登录" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [sureButton setTitleColor:DEFAULT_COLOR forState:UIControlStateHighlighted];
    
    [sureButton.layer setCornerRadius:CORNER_RIDUS];
    
    [sureButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [sureButton addTarget:self action:@selector(touchInsideButton:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:sureButton];
    
    [backView addSubview:userName];
    [backView addSubview:password];
    [backView addSubview:sureButton];
    
    registerButton = [UIButton new];
    findPasswordButton = [UIButton new];
    
    [registerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [registerButton setTitle:@"注册账号" forState:UIControlStateNormal];
    [registerButton.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [registerButton addTarget:self action:@selector(register) forControlEvents:UIControlEventTouchUpInside];

    [findPasswordButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [findPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [findPasswordButton.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [findPasswordButton addTarget:self action:@selector(findPassword) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:registerButton];
    [self.view addSubview:findPasswordButton];
    
    [self makeConstraints];
}
//旋转支持
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    [self updateConstraints];
}



//布局
- (void)makeConstraints{
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 190));
    }];
    
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).with.offset(10);
        make.right.equalTo(backView).with.offset(-10);
        make.top.equalTo(backView).with.offset(10);
        make.height.equalTo(@50);
    }];
    
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(userName);
        make.left.equalTo(userName);
        make.top.equalTo(backView).with.offset(70);
        make.height.equalTo(userName);
    }];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(userName);
        make.left.equalTo(userName);
        make.bottom.equalTo(backView).with.offset(-10);
        make.height.equalTo(@50);
    }];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(SCREEN_WIDTH / 2 - 100);
        make.bottom.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
    }];
    [findPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset( - SCREEN_WIDTH / 2 + 100);
        make.bottom.equalTo(registerButton);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
    }];

}

- (void)updateConstraints{
    [backView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 190));
        
    }];
    
    [registerButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(SCREEN_WIDTH / 2 - 100);
        make.bottom.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
    }];
    
    [findPasswordButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset( - SCREEN_WIDTH / 2 + 100);
        make.bottom.equalTo(registerButton);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
    }];
}



//响应
- (void)login{
    [sureButton setBackgroundColor:DEFAULT_COLOR];
    
    if (userName.text && password.text) {
        [Networking loginwithUsername:userName.text and:password.text];
    }
    
    returnMessageInterval = [NSTimer scheduledTimerWithTimeInterval:3 target:self
                                                                    selector:@selector(getLoginMessage)
                                                                    userInfo:nil
                                                                     repeats:NO
                                      ];
}

- (void)getLoginMessage{
    
    if ([Networking getLoginMessage]) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"ViewController"];
        
        [[NSUserDefaults standardUserDefaults] setObject:userName.text forKey:[NSString stringWithFormat:@"userAccount"]];
        
        [[NSUserDefaults standardUserDefaults] setObject:password.text forKey:[NSString stringWithFormat:@"%@.password",userName.text]];
        
        
        [self showViewController:myView sender:nil];
    }else{
        NSLog(@"login false");
    }
}

- (void)touchInsideButton:(UIButton *)sender{
    [sender setBackgroundColor:HIGH_COLOR];
}

- (void)register{
    RegisterViewController *registerView = [RegisterViewController new];
    [self showViewController:registerView sender:self];
}

- (void)findPassword{
    PasswordViewController *passwordView = [PasswordViewController new];
    [self showViewController:passwordView sender:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
