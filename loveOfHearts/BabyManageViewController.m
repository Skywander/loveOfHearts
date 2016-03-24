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
#import "Navview.h"
#import "AddWatchViewController.h"
#import "PersonInforViewController.h"

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
    accountMessage = [AccountMessage sharedInstance];
    
    NSString *userId = accountMessage.userId;
    
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
        
        [timer invalidate];
        
        [self initView];
    }
}

- (void)initView{
    float y = 70;
    for (NSDictionary *dict in deviceArray) {
        
        NSDictionary *paramater = @{
                               @"wid":[dict objectForKey:@"wid"],
                               @"fileName":[NSString stringWithFormat:@"%@.png",[dict objectForKey:@"wid"]]
                               };
        
        [netWorking getWatchPortiartWithDict:paramater];
        
        UIView *view = [self viewWithWatchID:[dict objectForKey:@"wid"] andY:y];
        y = y + VIEW_HEIGHT + 10;
        [self.view addSubview:view];
    }
}

- (UIView *)viewWithWatchID:(NSString *)watchId andY:(float)y{
    UIView *view = [UIView new];
    
    [view setFrame:CGRectMake(10, y, SCREEN_WIDTH - 20, VIEW_HEIGHT)];
    
    [view setBackgroundColor:[UIColor whiteColor]];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *imagePath = [NSString stringWithFormat:@"%@%@.png",path,watchId];
    
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    
    NSLog(@" imageView : %@",[UIImage imageWithData:imageData]);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
    
    [imageView setFrame:CGRectMake(20, 20, VIEW_HEIGHT - 40, VIEW_HEIGHT - 40)];
    
    [imageView.layer setBorderWidth:0.3f];
    [imageView.layer setCornerRadius:(VIEW_HEIGHT - 40)/2];
    
    [imageView setClipsToBounds:YES];
    
    [view addSubview:imageView];
    
    UILabel *watchIdLabel = [UILabel new];
    
    [watchIdLabel setFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, VIEW_HEIGHT)];
    
    [watchIdLabel setBackgroundColor:[UIColor clearColor]];
    
    [watchIdLabel setText:watchId];
    
    [watchIdLabel setTextAlignment:NSTextAlignmentCenter];
    
    [view addSubview:watchIdLabel];
    
    
    [view.layer setCornerRadius:6.f];
    [view.layer setBorderColor:[UIColor grayColor].CGColor];
    [view.layer setBorderWidth:0.3f];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [view addGestureRecognizer:singleTap];
    
    return view;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender

{
    
    PersonInforViewController *personInforView = [PersonInforViewController new];
    
    [self presentViewController:personInforView animated:YES completion:^{
        ;
    }];
    
}

- (void)initNavigation{
    
    [self.view setBackgroundColor:DEFAULT_COLOR];
  
    //添加
    
    UIButton *expandButton = [UIButton new];
    
    [expandButton setFrame:CGRectMake(SCREEN_WIDTH - NAVIGATION_HEIGHT, 0, NAVIGATION_HEIGHT, NAVIGATION_HEIGHT)];
    
    [expandButton setTitle:@"添加" forState:UIControlStateNormal];
    
    [expandButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [expandButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    [expandButton addTarget:self action:@selector(expand) forControlEvents:UIControlEventTouchUpInside];


    Navview *navigationView = [Navview new];
    
    [navigationView addSubview:expandButton];
    
    [self.view addSubview:navigationView];
}


- (void)expand{
    AddWatchViewController *add = [AddWatchViewController new];
    
    [self presentViewController:add animated:YES completion:^{
        ;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
