//
//  ViewController.m
//  爱之心
//
//  Created by 于恩聪 on 16/3/9.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "ViewController.h"
#import "Mymapview.h"
#import "HomeMenuView.h"

#define START_X 0
#define START_Y 0
#define TOP_HEIGHT 44

@interface ViewController ()
{
    TopView *topView;
    Mymapview *mapView;
    HomeMenuView *menuView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];

    NSLog(@"%@",identifierForVendor);
    
    
    [self initTopView];
    
    [self initMapView];
    
    [self initHomeMenuView];

}

- (void)initTopView{
    topView = [[TopView alloc] initWithFrame:CGRectMake(START_X, START_Y, SCREEN_WIDTH, TOP_HEIGHT)];
    [self.view addSubview:topView];
    
    [topView setAddress:@"哈工大"];
}

- (void)initMapView{
    mapView = [Mymapview sharedInstance];
    
    [mapView setFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    
    [self.view addSubview:mapView];
}

- (void)initHomeMenuView{
    menuView = [[HomeMenuView alloc] initWithFrame:CGRectMake(10, 74, 40, 280)];
    
    [self.view addSubview:menuView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
