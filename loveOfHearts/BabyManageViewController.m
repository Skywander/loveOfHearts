//
//  BabyManageViewController.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/15.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "BabyManageViewController.h"
#import "AccountMessage.h"
#import "Networking.h"

#define VIEW_HEIGHT 80

@interface BabyManageViewController ()
{
    NSTimer *timer;
    
    Networking *netWorking;
    
    AccountMessage *accountMessage;
    
    NSArray *deviceArray;
}
@end

@implementation BabyManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self getData];
    
}

- (void)getData{    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userAccount"];
    
    NSDictionary *paramater = @{
                                    @"userId":userId
                                    };
    
    netWorking = [Networking new];
    
    [netWorking getDevicesMessageWithParamaters:paramater];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getDeviceMessage) userInfo:nil repeats:YES];
}

- (void)getDeviceMessage{
    if ([netWorking getDeviceMessage].count > 0) {
        deviceArray = [netWorking getDeviceMessage];
        
        NSLog(@"deviceArray : %@",deviceArray);
        
        [timer invalidate];
        
        [self initView];
    }
}

- (void)initView{
    float y = 70;
    for (NSDictionary *dict in deviceArray) {
        UIView *view = [self viewWithWatchID:[dict objectForKey:@"wid"] andY:y];
        y = y + VIEW_HEIGHT + 10;
        [self.view addSubview:view];
    }
}

- (UIView *)viewWithWatchID:(NSString *)watchId andY:(float)y{
    UIView *view = [UIView new];
    
    [view setFrame:CGRectMake(10, y, SCREEN_WIDTH - 20, VIEW_HEIGHT)];
    
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIView *subView = [UIView new];
    
    subView.backgroundColor = [UIColor blackColor];
    
    [subView setFrame:CGRectMake(0, 0, VIEW_HEIGHT, VIEW_HEIGHT)];
    
    [view addSubview: subView];
    
    UILabel *watchIdLabel = [UILabel new];
    
    [watchIdLabel setFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, VIEW_HEIGHT)];
    
    [watchIdLabel setBackgroundColor:[UIColor clearColor]];
    
    [watchIdLabel setText:watchId];
    
    [watchIdLabel setTextAlignment:NSTextAlignmentCenter];
    
    [view addSubview:watchIdLabel];
    
    
    [view.layer setCornerRadius:6.f];
    [view.layer setBorderColor:[UIColor grayColor].CGColor];
    [view.layer setBorderWidth:0.3f];
    
    return view;
}

- (void)initNavigation{
    [self.view setBackgroundColor:DEFAULT_COLOR];
    
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
