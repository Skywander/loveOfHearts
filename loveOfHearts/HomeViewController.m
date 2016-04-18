//
//  ViewController.m
//  爱之心
//
//  Created by 于恩聪 on 16/3/9.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewController+delegate.h"
#import "DB.h"
#import "Command.h"

#define START_X 0
#define START_Y 0
#define TOP_HEIGHT 64

@interface HomeViewController ()
{
    Mymapview *mapView;
    HomeMenuView *menuView;
}

@end

@implementation HomeViewController
@synthesize topView;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view setBackgroundColor:DEFAULT_COLOR];
        
    [self initTopView];
    
    [self initHomeMenuView];
    
    [self initNotification];
    
    [self getBabyMessage];
    
    [AccountMessage sharedInstance].showHomeView = YES;
    
    if ([AccountMessage sharedInstance].wid != NULL) {
        
        [Command commandWithName:@"watch_cr" block:^(NSInteger type) {
            ;
        }];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [AccountMessage sharedInstance].showHomeView = YES;
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [self initMapView];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [AccountMessage sharedInstance].homeAnimationImage = mapView.annotationImage;

    [AccountMessage sharedInstance].showHomeView = NO;
    
    if (mapView.currentLat) {
        
        [[NSUserDefaults standardUserDefaults] setDouble:[mapView.currentLat doubleValue] forKey:@"lat"];
        
        [[NSUserDefaults standardUserDefaults] setDouble:[mapView.currentLng doubleValue] forKey:@"lon"];
   
        [mapView.mapView setShowsUserLocation:NO];
        
    }
}


- (void)initTopView{
    topView = [[HomeTopView alloc] initWithFrame:CGRectMake(START_X, START_Y, SCREEN_WIDTH, TOP_HEIGHT)];
    
    topView.topViewDelegat = self;
    
    [self.view addSubview:topView];
}

- (void)initMapView{
    
    double lat = [[NSUserDefaults standardUserDefaults] doubleForKey:@"lat"];
    
    double lon = [[NSUserDefaults standardUserDefaults] doubleForKey:@"lon"];
    
    mapView = [Mymapview sharedInstance];
        
    [mapView setFrame:CGRectMake(0, TOP_HEIGHT + 20, SCREEN_WIDTH, SCREEN_HEIGHT - TOP_HEIGHT - 20)];
    
    mapView.mydelegate = self;
    
    [mapView.mapView removeOverlays:mapView.mapView.overlays];
    
    [mapView.mapView removeAnnotations:mapView.mapView.annotations];

    
    [self.view addSubview:mapView];
    
    [self.view sendSubviewToBack:mapView];
    
    if([AccountMessage sharedInstance].homeAnimationImage != nil){
        
        mapView.annotationImage = [AccountMessage sharedInstance].homeAnimationImage;
        
    }else{
        
        mapView.annotationImage = [UIImage imageNamed:@"animationView"];
        
    }
    
    [mapView searchPointWithLat:lat andLon:lon];
}

- (void)initHomeMenuView{
    
    menuView = [[HomeMenuView alloc] initWithFrame:CGRectMake(4, 20 + TOP_HEIGHT, 45, SCREEN_HEIGHT - TOP_HEIGHT - 20)];
    
    menuView.homeDelegat = self;
        
    [self.view addSubview:menuView];
}

- (void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage:) name:@"HomeviewUpdateImage" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSignal:) name:@"updateSignal" object:nil];
}

- (void)updateImage:(NSNotification *)sender{
    UIImage *image = (UIImage *)sender.object;
    
    [topView setImage:image];
    
    NSDictionary *paramater = @{
                                @"wid":[AccountMessage sharedInstance].wid
                                };
    

    [Command commandWithAddress:@"user_getBabyInfo" andParamater:paramater dictBlock:^(NSDictionary *dict) {
        if (![dict isEqual:[NSNull null]] && [dict isKindOfClass:[NSDictionary class]]) {
            AccountMessage *accountMessage = [AccountMessage sharedInstance];
            
            [accountMessage setBabyMessage:dict];
            
            [topView updateTimeLabel];
            
        }else{
            [[AccountMessage sharedInstance] initBabyMesssage];
        }
    }];
}

- (void)updateSignal:(NSNotification *)sender{
    
    NSDictionary *dict = (NSDictionary *)sender.object;
    
    NSInteger signal = [[dict objectForKey:@"gsm"] integerValue];
    
    [menuView updateSingalWith:signal];
    
    NSInteger power = [[dict objectForKey:@"power"] integerValue];
    
    [topView setUpdatePower:power];
    
    
    double lat = [[dict objectForKey:@"lat"] doubleValue];
    
    double lng = [[dict objectForKey:@"lng"] doubleValue];
    
    mapView.annotationImage = [UIImage imageNamed:[NSString stringWithFormat:@"animationView_%@",[dict objectForKey:@"way"]]];
    
    [mapView searchPointWithLat:lat andLon:lng];

}

- (void)getBabyMessage{
    
    if ([AccountMessage sharedInstance].wid == NULL) {
        return;
    }
    
    [Networking getWatchMessageWithParamater:[AccountMessage sharedInstance].wid block:^(NSDictionary *dict) {
        if (![dict isEqual:[NSNull null]] && [dict isKindOfClass:[NSDictionary class]]) {
            [[AccountMessage sharedInstance] setWatchInfor:dict];
        }
    }];
}

@end
