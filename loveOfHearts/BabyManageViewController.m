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
#import "ImageUpdate.h"
#import "BabyMangeCellView.h"
#import "DB.h"

#define VIEW_HEIGHT 80

@interface BabyManageViewController ()<NavigationProtocol,ImageUpdate>
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
    
    [self initNavigation];
    
    [self getData];
    
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
        
        [self initView];
    }];
}



- (void)initView{
    
    selectedView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yes"]];
    
    [selectedView setFrame:CGRectMake(SCREEN_WIDTH - 75, (VIEW_HEIGHT - 30) / 2, 30, 30)];
    
    y = 70;
    for (NSDictionary *dict in deviceArray) {
        
        [DB getImageWithWatchId:[dict objectForKey:@"wid"] filename:[dict objectForKey:@"headimg"] block:^(UIImage *image) {
            
            UIView *view = [self viewWithWatchImage:image andY:y andWatchId:[dict objectForKey:@"wid"]];
            
            y = y + VIEW_HEIGHT + 10;
            
            if([[dict objectForKey:@"wid"] isEqualToString:accountMessage.wid]){
                [view addSubview:selectedView];
            }
            
            [self.view addSubview:view];
            
            //            [watchViewArray addObject:view];
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
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 2;
    [view addGestureRecognizer:singleTap];
    
    
    return view;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender

{
    //
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
        
        if (CGRectContainsPoint(view.frame, point)) {
            
            NSString *wid = (NSString *)key;
            
            NSDictionary *paramater = @{
                                        @"wid":wid
                                        };
            
            [Networking getWatchMessageWithParamater:paramater block:^(NSDictionary *dict) {
                
                [accountMessage setWatchInfor:[dict objectForKey:@"data"]];
                
                NSLog(@"%@",accountMessage.wid);
                
            }];
            
            [view addSubview:selectedView];

        }
    }];
    
}



@end
