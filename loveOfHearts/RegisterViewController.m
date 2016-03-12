//
//  RegisterViewController.m
//  喔喔农机
//
//  Created by 于恩聪 on 15/12/21.
//  Copyright © 2015年 于恩聪. All rights reserved.
//

#import "RegisterViewController.h"
#import "Networking.h"
#import <SMS_SDK/SMSSDK.h>

#define LABEL_COLOR [UIColor grayColor]

@interface RegisterViewController (){
    UITextField *username;
    UITextField *password;
    UITextField *passwordAgain;
    UITextField *code;
    
    UIView *codeView;
    UIButton *codeButton;
    UIButton *sureButton;
    
    //验证码
    NSMutableArray* _areaArray;
    NSString *_str;
    NSString *phoneNumber;
    BOOL codeIsRight;
    //
    
    int timeCount;
    NSTimer *timer;
    NSTimer *getMessageTimer;
    NSTimer *codeTimer;
}

@end

@implementation RegisterViewController

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
    
    username = [self textFieldWithImageName:@"username" andPlaceholder:@" 输入手机号码"];
    password = [self textFieldWithImageName:@"userpassword" andPlaceholder:@" 输入密码"];
    password.secureTextEntry = YES;
    passwordAgain = [self textFieldWithImageName:@"userpassword" andPlaceholder:@" 确认密码"];
    passwordAgain.secureTextEntry = YES;
    //验证码
    codeView = [UIView new];
    [codeView setBackgroundColor:BACKGROUND_COLOR];
    [self.view addSubview:codeView];
    
    code = [UITextField new];
    [code setBackgroundColor:[UIColor whiteColor]];
    [code.layer setBorderWidth:0.3f];
    [code.layer setCornerRadius:6.f];
    [code.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [codeView addSubview:code];
    
    codeButton = [UIButton new];
    [codeButton setBackgroundColor:[UIColor whiteColor]];
    [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [codeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [codeButton.layer setCornerRadius:6.f];
    
    [codeButton addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    [codeButton addTarget:self action:@selector(touchInside:) forControlEvents:UIControlEventTouchDown];
    
    [codeView addSubview:codeButton];
    //确定
    sureButton = [UIButton new];
    [sureButton setBackgroundColor:[UIColor whiteColor]];
    [sureButton setTitle:@"注册" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [sureButton setTitleColor:DEFAULT_COLOR forState:UIControlStateHighlighted];
    
    [sureButton.layer setCornerRadius:CORNER_RIDUS];
    
    [sureButton addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
    [sureButton addTarget:self action:@selector(touchInside:) forControlEvents:UIControlEventTouchDown];
    
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
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setLeftBarButtonItem:leftButton];
    
    [self.view addSubview:navigationBar];
    
}

- (UITextField *)textFieldWithImageName:(NSString *)imageName andPlaceholder:(NSString *)placeholder{
    UITextField *textField = [UITextField new];
    [textField setBackgroundColor:[UIColor whiteColor]];
    
    [textField.layer setBorderWidth:0.3f];
    [textField.layer setBorderColor:[UIColor whiteColor].CGColor];
    [textField.layer setCornerRadius:6.f];
    
    [textField setPlaceholder:placeholder];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [imageView setFrame:CGRectMake(0, 0, CELL_HEIGHT, CELL_HEIGHT)];
    
    [textField setLeftView:imageView];
    
    [textField setLeftViewMode:UITextFieldViewModeAlways];
    
    [self.view addSubview:textField];
    
    
    return textField;
}

- (void)makeConstraints{
    [username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.top.equalTo(self.view).with.offset(80);
        make.height.equalTo(@(CELL_HEIGHT));
    }];
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(username);
        make.right.equalTo(username);
        make.top.equalTo(username).with.offset(CELL_HEIGHT + OFFSET);
        make.height.equalTo(@(CELL_HEIGHT));
    }];
    
    [passwordAgain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(username);
        make.right.equalTo(username);
        make.top.equalTo(password).with.offset(CELL_HEIGHT + OFFSET);
        make.height.equalTo(@(CELL_HEIGHT));
    }];
    
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(username);
        make.right.equalTo(username);
        make.top.equalTo(passwordAgain).with.offset(CELL_HEIGHT + OFFSET);
        make.height.equalTo(@(CELL_HEIGHT));
    }];
    [code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeView);
        make.top.equalTo(codeView);
        make.height.equalTo(codeView);
        make.width.equalTo(@(SCREEN_WIDTH / 2 - 15));
    }];
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(codeView);
        make.top.equalTo(codeView);
        make.height.equalTo(codeView);
        make.width.equalTo(@(SCREEN_WIDTH / 2 - 15));
    }];
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(username);
        make.left.equalTo(username);
        make.top.equalTo(codeView).with.offset(CELL_HEIGHT + OFFSET);
        make.height.equalTo(@(CELL_HEIGHT));
    }];
}

//响应

- (void)clickLeftButton{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)clickSureButton{
    [sureButton setBackgroundColor:DEFAULT_COLOR];
    if (password.text.length <= 6) {
        NSLog(@"密码太短");
        return;
    }
    
    if (![password.text isEqualToString:passwordAgain.text]) {
        NSLog(@"两次输入不一致");
        return;
    }
    
    [self checkCode];
    
    codeTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                 target:self
                                               selector:@selector(registerAccount)
                                               userInfo:nil
                                                repeats:NO];
    

}
- (void)registerAccount{
    if (codeIsRight) {
        
        NSLog(@"code is rightn");
        NSDictionary *paramater = @{
                                    @"userId":phoneNumber,
                                    @"userPw":password.text,
                                    };
        [Networking registerwithDict:paramater];
        
        getMessageTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(getReturnMessage) userInfo:nil repeats:NO];
    }else{
        NSLog(@"code is wrong");
    }
}

- (void)getReturnMessage{
    NSLog(@"returen message");
   int returnNumber =  [Networking getRegisterMessage];
    
    if (returnNumber == 1){
        NSLog(@"success");
    }else if(returnNumber == 2){
        NSLog(@"重复注册");
    }else{
        NSLog(@"注册失败");
    }
}

- (void)touchInside:(UIButton *)sender{
    [sender setBackgroundColor:HIGH_COLOR];
}
- (void)getCode{
    
    [codeButton setBackgroundColor:DEFAULT_COLOR];
    
    int compareResult = 0;
    for (int i = 0; i<_areaArray.count; i++)
    {
        NSDictionary* dict1 = [_areaArray objectAtIndex:i];
        NSString* code1 = [dict1 valueForKey:@"zone"];
        
        if ([code1 isEqualToString:@"86"])
        {
            compareResult = 1;
            NSString* rule1 = [dict1 valueForKey:@"rule"];
            NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule1];
            BOOL isMatch = [pred evaluateWithObject:username.text];
            if (!isMatch)
            {
                [self alertWithTitle:@"手机号码不正确"];
                return;
            }
            break;
        }
    }
    
    if (!compareResult)
    {
        if (username.text.length!=11)
        {
            [self alertWithTitle:@"手机号码不正确"];
            return;
        }
    }
    
    NSString* str = [NSString stringWithFormat:@"%@:%@ %@",@"发送验证码到",@"+86",username.text];
    _str = [NSString stringWithFormat:@"%@",username.text];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:str
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert
                                          ];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString* str2 = [@"+86" stringByReplacingOccurrencesOfString:@"+" withString:@""];
        
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:username.text
                                       zone:str2
                           customIdentifier:nil
                                     result:^(NSError *error)
         {
             
             if (!error)
             {
                 NSLog(@"验证码发送成功");
                 phoneNumber = username.text;
                 
                 timeCount = 60;
                 timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                          target:self
                                                        selector:@selector(startTimer)
                                                        userInfo:nil
                                                         repeats:YES
                          ];
             }
             else
             {
                 [self alertWithTitle:@"验证码发送错误"];
             }
             
         }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                         }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];

    

}
- (void)checkCode{
    [self.view endEditing:YES];
    
    codeIsRight = NO;
    
    if(code.text.length != 4)
    {
        [self alertWithTitle:@"验证码错误"];
    }
    else
    {
        [SMSSDK commitVerificationCode:code.text phoneNumber:username.text zone:@"86" result:^(NSError *error) {
            
            if (!error) {
                
                NSLog(@"验证成功");
                codeIsRight = YES;
            }
            else
            {
                NSLog(@"验证失败");
                [self alertWithTitle:@"验证错误"];
            }
        }];
    }
}
- (void)startTimer{
    
    if (timeCount != 1) {
        
        NSString *tempString = [NSString stringWithFormat:@"%ds后重新发送",timeCount];
        
        [codeButton setTitle:tempString forState:UIControlStateNormal];
        
        [codeButton setUserInteractionEnabled:NO];
        
        timeCount --;
        
    } else{
        [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        [codeButton setUserInteractionEnabled:YES];
        
        timeCount = 60;
        
        [timer invalidate];
    }
}


- (void)alertWithTitle:(NSString *)title{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert
                                          ];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                         }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
