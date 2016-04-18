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
#import "HomeViewController.h"
#import "RightViewController.h"

#import "IIViewDeckController.h"
#import "IISideController.h"

@interface LoginViewController (){
    UIView *backView;
    
    UIImageView *logoView;
    
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
    
    IIViewDeckController* deckController;
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
    }
}

- (void)initUI{
    [self.view setBackgroundColor:BACKGROUND_COLOR];
    
    backView = [UIView new];
    [backView setBackgroundColor:BACKGROUND_COLOR];
    [self.view addSubview:backView];
    
    logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginLogo"]];
    
    userName = [UITextField new];
    password = [UITextField new];

    [userName.layer setCornerRadius:CORNER_RIDUS];
    [userName setKeyboardType:UIKeyboardTypeDefault];
    
    if (userId) {
        [userName setText:userId];
    }else{
        [userName setPlaceholder:@"请输入用户名(手机号码)"];
    }
    
    UIImageView *userLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"username"]];
    [userLeftView setFrame:CGRectMake(0, 0, 50, 50)];
    [userName setLeftView:userLeftView];
    [userName setLeftViewMode:UITextFieldViewModeAlways];
    [userName setBackgroundColor:[UIColor whiteColor]];
    
    [password.layer setCornerRadius:CORNER_RIDUS];
    
    if (userPassword) {
        [password setText:userPassword];
    }else{
        [password setPlaceholder:@"请输入密码"];
    }
    
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
    [self.view addSubview:logoView];
    
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
    
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(100);
        make.right.equalTo(self.view).with.offset(-100);
        make.top.equalTo(self.view).with.offset(70);
        make.height.equalTo(@(SCREEN_WIDTH - 200));
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
    if (userName.text && password.text) {
        
        [Networking loginwithUsername:userName.text and:password.text block:^(NSDictionary *dict) {
            
            if (dict == nil) {
                [JKAlert showMessage:@"登陆失败,请检查网络"];
            }
            
            
            int loginMessage = [[dict objectForKey:@"type"] intValue];
        
            
            if (loginMessage == 100){
                
                [[NSUserDefaults standardUserDefaults] setObject:userName.text forKey:[NSString stringWithFormat:@"userAccount"]];
                
                [[NSUserDefaults standardUserDefaults] setObject:password.text forKey:[NSString stringWithFormat:@"%@.password",userName.text]];
                
                [AccountMessage sharedInstance].userId = userName.text;
                
                RightViewController *rightController = [RightViewController new];
                
                RightViewController *leftController = [RightViewController new];
                
                HomeViewController *centerController = [HomeViewController new];
                
                deckController = [[IIViewDeckController alloc] initWithCenterViewController:[[UINavigationController alloc] initWithRootViewController:centerController]
                                                                         leftViewController:[IISideController autoConstrainedSideControllerWithViewController:
                                                                                             leftController]
                                                                        rightViewController:[IISideController autoConstrainedSideControllerWithViewController:rightController]];
                
                deckController.navigationController.navigationBar.hidden = YES;
                
                deckController.rightSize = SCREEN_WIDTH * 1 / 3.0;
                
                [self presentViewController:deckController animated:YES completion:^{
                    ;
                }];
            }else{
                [JKAlert showMessage:@"用户名或密码错误"];
            }

        }];
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
