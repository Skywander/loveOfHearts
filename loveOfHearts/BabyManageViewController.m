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
#import "Navigation.h"
#import "AddWatchViewController.h"
#import "PersonInforViewController.h"
#import "NavigationProtocol.h"
#import "DB.h"

#define VIEW_HEIGHT 80

@interface BabyManageViewController ()<NavigationProtocol>
{    
    Networking *netWorking;
    
    AccountMessage *accountMessage;
    
    NSArray *deviceArray;
    
    float y;
    
    UIImageView *selectedView;
    
    NSMutableDictionary *watchViewArray;
}
@end

@implementation BabyManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [self initNavigation];
    
    [self getData];

}

- (void)viewWillDisappear:(BOOL)animated{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
}

- (void)getData{
    watchViewArray = [[NSMutableDictionary alloc] init];
    
    accountMessage = [AccountMessage sharedInstance];
    
    NSString *userId = accountMessage.userId;
    
    NSDictionary *paramater = @{
                                    @"userId":userId
                                    };
    
    [Networking getDevicesMessageWithParamaters:paramater block:^(NSDictionary *dict) {
        deviceArray = [dict objectForKey:@"data"];
        
        NSLog(@"deviceList : %@",dict);
        
        [self initView];
    }];
}



- (void)initView{
    
    selectedView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yes"]];
    
    [selectedView setFrame:CGRectMake(SCREEN_WIDTH - 75, (VIEW_HEIGHT - 30) / 2, 30, 30)];
    
    y = 70;
    for (NSDictionary *dict in deviceArray) {
        
        NSString *fileName;
        
        if ([[dict objectForKey:@"babyhead"] isEqual:[NSNull null]]) {
            fileName = @" ";
        }else{
            fileName = [dict objectForKey:@"babyhead"];
        }
        
        [DB getImageWithWatchId:[dict objectForKey:@"wid"] filename:fileName block:^(UIImage *image) {
            
            UIView *view = [self viewWithWatchImage:image andY:y andWatchId:[dict objectForKey:@"wid"]];
            
            y = y + VIEW_HEIGHT + 10;
            
            if([[dict objectForKey:@"wid"] isEqualToString:accountMessage.wid]){
                [view addSubview:selectedView];
            }
            
            [self.view addSubview:view];
            
            [watchViewArray setObject:view forKey:[NSString stringWithFormat:@"%@",[dict objectForKey:@"wid"]]];

        }];
    }
}

- (UIView *)viewWithWatchImage:(UIImage *)image andY:(float)getY andWatchId:(NSString *)watchId{
    UIView *view = [UIView new];
    
    [view setFrame:CGRectMake(10, getY, SCREEN_WIDTH - 20, VIEW_HEIGHT)];
    
    [view setBackgroundColor:[UIColor whiteColor]];
    
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
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
    
    return view;
}


- (void)initNavigation{
    
    [self.view setBackgroundColor:DEFAULT_COLOR];


    Navigation *navigation = [Navigation new];
    
    [navigation setDelegate:self];
    
    [navigation addRightViewWithName:@"添加"];
    
    [self.view addSubview:navigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)clickNavigationRightView{
    AddWatchViewController *add = [AddWatchViewController new];
    
    [self presentViewController:add animated:YES completion:^{
        ;
    }];
}

- (void)updateImage{
    
    NSLog(@"更新图片");
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self.view];
    
    [watchViewArray enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        UIView *view = (UIView *)obj;
        
        UIImageView *imageView = [UIImageView new];
        
        for (UIView *subView in view.subviews) {
            if ([subView isKindOfClass:[UIImageView class]] && subView != selectedView) {
                imageView = (UIImageView *)subView;
            }
        }
        
        if (CGRectContainsPoint(view.frame, point)) {
            
            NSString *wid = (NSString *)key;
            
            [Networking getWatchMessageWithParamater:wid block:^(NSDictionary *dict) {
                
                accountMessage.wid = wid;
                
                [deviceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *tempDict = (NSDictionary *)obj;
                    
                    if ([[tempDict objectForKey:@"wid"] isEqualToString:wid]) {
                        [AccountMessage sharedInstance].admin = [tempDict objectForKey:@"admin"];
                        
                        [AccountMessage sharedInstance].isAdmin = [[tempDict objectForKey:@"admin"] integerValue];
                    }
                }];
                
                [accountMessage setWatchInfor:dict];
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"HomeviewUpdateImage" object:imageView.image userInfo:nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                [self.navigationController popViewControllerAnimated:YES];

                accountMessage.image = imageView.image;
                
            }];

            [view addSubview:selectedView];

        }
    }];
    
}



@end
