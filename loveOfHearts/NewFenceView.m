//
//  NewFenceViewController.m
//  爱之心
//
//  Created by 于恩聪 on 15/9/8.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//
#import <MAMapKit/MAMapKit.h>
#import "NewFenceView.h"
#import "Networking.h"
#import "Constant.h"
#import "Mymapview.h"
#import "NewFenceMessage.h"
#import "Navigation.h"
#import "NavigationProtocol.h"

@interface NewFenceView()<MAMapViewDelegate,MAAnnotation,UIAlertViewDelegate,NavigationProtocol>

{
    MAMapView *mapView;
    Mymapview *myMapview;
    
    UIButton *backButton;
    
    CLLocationCoordinate2D touchCoordinate;
    MAPointAnnotation *touchAnnotation;
    CLLocationCoordinate2D touchPoints[10];
    MAPointAnnotation *polygonAnnotation[10];
    MAMapPoint points[10];
    MAPolygon *polygonView;
    int tapcount;//多边形 计数
}
@end

@implementation NewFenceView
@synthesize coordinate;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [mapView removeOverlays:mapView.overlays];
    [mapView removeAnnotations:mapView.annotations];
}

- (void)initUI {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initNaviView];
    [self initMapView];
    [self initButton];
}

- (void)initNaviView{
    Navigation *naviview = [Navigation new];
    [naviview addRightViewWithName:@"下一步"];
    [naviview setDelegate:self];
    [self.view addSubview:naviview];
}

- (void)initMapView {
    myMapview = [Mymapview sharedInstance];
    [myMapview setFrame:CGRectMake(10, 70, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 75)];
    
    mapView = myMapview.mapView;
    
    [self.view addSubview:myMapview];
    [self.view sendSubviewToBack:myMapview];
}

- (void)initButton {
    //返回
    backButton = [UIButton new];
    [backButton setFrame:CGRectMake(SCREEN_WIDTH - 52,74,40,40)];
    
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton.layer setMasksToBounds:YES];
    [backButton setBackgroundImage:[UIImage imageNamed:@"reset.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"reset_press.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
}

//撤销
- (void)clickBackButton {
    NSLog(@"tapCount:%d",tapcount);
    if(tapcount <= 0){
        return ;
    }
    [mapView removeAnnotation:polygonAnnotation[tapcount - 1]];
    [mapView removeOverlay:polygonView];
    
    tapcount--;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];

    UITouch *touch = [[event allTouches]anyObject];
    CGPoint point = [touch locationInView:self.view];

    if (!CGRectContainsPoint(myMapview.frame, point)) {
        return;
    }
    if (1) {
        if (tapcount >= 10) {
            return;
        }
        touchCoordinate = [mapView convertPoint:point toCoordinateFromView:self.view];
        touchPoints[tapcount] = touchCoordinate;
        touchAnnotation = [MAPointAnnotation new];
        touchAnnotation.coordinate = touchCoordinate;
        [mapView addAnnotation:touchAnnotation];
        
        
        MAMapPoint point =  MAMapPointForCoordinate(touchCoordinate);
        
        for (int i = 0;i< tapcount;i ++) {
            double distance = MAMetersBetweenMapPoints(points[i], point);
            
            NSLog(@"%f",distance);
        }
        
        polygonAnnotation[tapcount] = touchAnnotation;
        points[tapcount] = point;
        if (tapcount >= 2) {
            if (polygonView) {
                [mapView removeOverlay:polygonView];
            }
            polygonView = [MAPolygon polygonWithCoordinates:touchPoints count:tapcount + 1];
            
            
            [mapView addOverlay:polygonView];
        }
        tapcount ++;
        NSLog(@"tapcount:%d",tapcount);
    }
}

- (void)clickNavigationRightView{
    NSLog(@"clickMakeSureButton");
    
    NSString *fenceData;
    
    for (int i = 0; i < tapcount; i++) {
        double pointX =  touchPoints[i].latitude;
        double pointY = touchPoints[i].longitude;
        
        NSString *tempStr = [NSString stringWithFormat:@"%f,%f",pointY,pointX];
        if (i == 0) {
            fenceData = [NSString stringWithFormat:@"%@",tempStr];
        }
        
        fenceData = [NSString stringWithFormat:@"%@;%@",fenceData,tempStr];
    }
    NewFenceMessage *fenceMessage = [NewFenceMessage new];
    
    fenceMessage.fenceData = fenceData;
    
    [self presentViewController:fenceMessage animated:YES completion:^{
        ;
    }];
}

@end
