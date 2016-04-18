//
//  PasswordViewController.m
//  喔喔农机
//
//  Created by 于恩聪 on 15/12/21.
//  Copyright © 2015年 于恩聪. All rights reserved.
//

#import "PasswordViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "Command.h"
#import "Networking.h"
#define HIGH_COLOR [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1]


@interface PasswordViewController (){
    UITextField *phoneNumber;
    UIButton *sureButton;
    
    UIView *codeView;
    UITextField *code;
    UIButton *codeButton;
    UILabel *passwordLabel;
    
    //验证码
    NSMutableArray* _areaArray;
    NSString *_str;
    NSString *_phoneNumber;
    BOOL codeIsRight;
    //
    
    int timeCount;
    NSTimer *timer;
    NSTimer *codeTimer;
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
    
    code = [UITextField new];
    [code setBackgroundColor:[UIColor whiteColor]];
    [code setKeyboardType:UIKeyboardTypeNumberPad];
    [code.layer setCornerRadius:CORNER_RIDUS];
    
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
    
    sureButton = [UIButton new];
    [sureButton setBackgroundColor:[UIColor whiteColor]];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [sureButton setTitleColor:DEFAULT_COLOR forState:UIControlStateHighlighted];
    
    [sureButton.layer setCornerRadius:CORNER_RIDUS];
    
    [sureButton addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
    [sureButton addTarget:self action:@selector(touchInsideButton:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:sureButton];
    
    passwordLabel = [UILabel new];
    
    [passwordLabel setBackgroundColor:[UIColor whiteColor]];
    
    [passwordLabel setTextAlignment:NSTextAlignmentCenter];
    
    [passwordLabel setFont:[UIFont systemFontOfSize:14.f]];
    
    
    [passwordLabel.layer setCornerRadius:6.f];
    
    [self.view addSubview:passwordLabel];
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
        make.height.equalTo(phoneNumber);
    }];
    
    [code mas_makeConstraints:^(MASConstraintMaker *make) {
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
    }];
}

- (void)clickSureButton{
    [sureButton setBackgroundColor:[UIColor whiteColor]];
    
    [self checkCode];
        
}
- (void)clickCodeButton{
    [codeButton setBackgroundColor:DEFAULT_COLOR];
}
- (void)touchInsideButton:(UIButton *)sender{
    [sender setBackgroundColor:[UIColor whiteColor]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)getCode{
    
    [codeButton setBackgroundColor:[UIColor whiteColor]];
    
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
            BOOL isMatch = [pred evaluateWithObject:phoneNumber.text];
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
        if (phoneNumber.text.length!=11)
        {
            [self alertWithTitle:@"手机号码不正确"];
            return;
        }
    }
    
    NSString* str = [NSString stringWithFormat:@"%@:%@ %@",@"发送验证码到",@"+86",phoneNumber.text];
    _str = [NSString stringWithFormat:@"%@",phoneNumber.text];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:str
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert
                                          ];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString* str2 = [@"+86" stringByReplacingOccurrencesOfString:@"+" withString:@""];
        
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneNumber.text
                                       zone:str2
                           customIdentifier:nil
                                     result:^(NSError *error)
         {
             
             if (!error)
             {
                 NSLog(@"验证码发送成功");
                 _phoneNumber = phoneNumber.text;
                 
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
- (void)touchInside:(UIButton *)sender{
    [sender setBackgroundColor:HIGH_COLOR];
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
        [SMSSDK commitVerificationCode:code.text phoneNumber:phoneNumber.text zone:@"86" result:^(NSError *error) {
            
            if (!error) {
                
                NSLog(@"验证成功");
                codeIsRight = YES;
                
                NSDictionary *dict = @{
                                       @"userId":phoneNumber.text,
                                       };
                
                [Networking getPasswordWithParamater:dict block:^(NSDictionary *dict) {
                    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(phoneNumber);
                        make.right.equalTo(phoneNumber);
                        make.top.equalTo(sureButton).with.offset(CELL_HEIGHT + OFFSET);
                        make.height.equalTo(@(CELL_HEIGHT));
                    }];
                    if (dict == nil) {
                        
                        [passwordLabel setText:[NSString stringWithFormat:@"密码找回失败"]];
                        
                        return ;
                    }
                    
                    if ([[dict objectForKey:@"type"] integerValue] == 100) {
                        [passwordLabel setText:[NSString stringWithFormat:@"密码是:%@",[dict objectForKey:@"data"]]];
                    }else{
                        [passwordLabel setText:[NSString stringWithFormat:@"密码找回失败"]];

                    }
                }];
                
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




@end
