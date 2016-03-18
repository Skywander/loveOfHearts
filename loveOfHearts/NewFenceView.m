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
#import "Fence.h"
#import "Mymapview.h"
#import "NewFenceMessage.h"
#import "Alert.h"
#import "Navview.h"

@interface NewFenceView()<MAMapViewDelegate,MAAnnotation,UIAlertViewDelegate>

{
    MAMapView *mapView;
    Mymapview *myMapview;
    
    UIButton *backButton;
    UIButton *makeSureButton;

    BOOL _drawCircle;
    
    BOOL _drawPolygon;
    BOOL _resetArea;
    
    CLLocationCoordinate2D touchCoordinate;
    MAPointAnnotation *touchAnnotation;
    CLLocationCoordinate2D touchPoints[10];
    MAPointAnnotation *polygonAnnotation[10];
    MAMapPoint points[10];
    MAPolygon *polygonView;
    MACircle *pointCircle;
    int tapcount;//多边形 计数
    
    NSMutableArray *fenceNameListArray;
    //slider
    NSArray *_sliders;
    
    //围栏信息
    NSString *circleRadius;
    CGFloat _radius;
    //
    NSString *user_id;
    NSString *shouhuan_id;
}
@end

@implementation NewFenceView
@synthesize coordinate;
@synthesize fencesArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)initUI {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initNaviView];
    [self initMapView];
    [self initButton];
}

- (void)initNaviView{
    Navview *naviview = [Navview new];
    [self.view addSubview:naviview];
}

- (void)initMapView {
    myMapview = [Mymapview sharedInstance];
    [myMapview setFrame:CGRectMake(10, 102, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 150)];
    
    mapView = myMapview.mapView;
    mapView.delegate = self;
    
    [mapView removeAnnotations:mapView.annotations];
    [mapView removeOverlays:mapView.overlays];
    
    [self.view addSubview:myMapview];
    [self.view sendSubviewToBack:myMapview];
}

- (void)initButton {
    //返回
    backButton = [UIButton new];
    [backButton setFrame:CGRectMake(12,74,40,40)];
    
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton.layer setMasksToBounds:YES];
    [backButton setBackgroundImage:[UIImage imageNamed:@"reset.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"reset_press.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    //确定
    makeSureButton = [UIButton new];
    [makeSureButton setFrame:CGRectMake(10, SCREEN_HEIGHT-40, SCREEN_WIDTH - 20, 35)];
    [makeSureButton setTitle:@"划定该区域" forState:UIControlStateNormal];
    [makeSureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [makeSureButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [makeSureButton setBackgroundColor:[UIColor whiteColor]];
    [makeSureButton.layer setBorderWidth:0.2];
    [makeSureButton.layer setBorderColor:[UIColor grayColor].CGColor];
    [makeSureButton.layer setCornerRadius:5.0];
    makeSureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [makeSureButton addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:makeSureButton];
    
}

//画annotation的回调函数
- (MAAnnotationView *)mapView:(MAMapView *)_mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[_mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.pinColor = MAPinAnnotationColorGreen;
        annotationView.canShowCallout = YES;//信息封装在maplocation
        annotationView.animatesDrop = YES;//动画显示
        
        annotationView.image = [UIImage imageNamed:@"animationView"];
        
        [annotationView setFrame:CGRectMake(0, 0, 10, 10)];
        [annotationView setClipsToBounds:YES];
        
        return annotationView;
    }
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        static NSString *userLocationStyleReuseIndentifier = @"userLocationStyleReuseIndentifier";
        MAAnnotationView *annotationView = [_mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:userLocationStyleReuseIndentifier];
        }
        return annotationView;
    }
    return nil;
}

//画多边形的回调函数
- (MAOverlayView *)mapView:(MAMapView *)_mapView viewForOverlay:(id <MAOverlay>)overlay
{
    //自定义精度圈
    if (overlay == _mapView.userLocationAccuracyCircle) {
        MACircleView *accuracyCircleView = [[MACircleView alloc]initWithCircle:overlay];
        accuracyCircleView.lineWidth = 2.f;
        accuracyCircleView.strokeColor = [UIColor lightGrayColor];
        accuracyCircleView.fillColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0];
        return accuracyCircleView;
    }
    //画圆的回调函数
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleView *circleView = [[MACircleView alloc] initWithCircle:overlay];
        
        circleView.lineWidth = 5.f;
        circleView.strokeColor = DEFAULT_COLOR;
        circleView.fillColor = [UIColor colorWithRed:252/255.0 green:92/255.0 blue:64/255.0 alpha:0.5];
        circleView.lineJoinType = kMALineJoinRound;
        circleView.lineDash = YES;
        
        return circleView;
    }
    //画折线的回调函数
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 5.f;
        polylineView.strokeColor = DEFAULT_COLOR;
        polylineView.lineJoinType = kMALineJoinRound;//连接类型
        polylineView.lineCapType = kMALineCapRound;//端点类型
        
        return polylineView;
    }
    //多边形的回调函数
    if ([overlay isKindOfClass:[MAPolygon class]])
    {
        MAPolygonView *_polygonView = [[MAPolygonView alloc] initWithPolygon:overlay];
        
        _polygonView.lineWidth = 2.f;
        _polygonView.strokeColor = DEFAULT_COLOR;
        _polygonView.fillColor = [UIColor whiteColor];
        _polygonView.lineJoinType = kMALineJoinMiter;//连接类型
        
        return _polygonView;
    }
    
    
    return nil;
}


- (void)clickSureButton {
    NSLog(@"clickMakeSureButton");
}

//撤销
- (void)clickBackButton {
    NSLog(@"tapCount:%d",tapcount);
    if(tapcount <= 0){
        return ;
    }
    [mapView removeAnnotation:polygonAnnotation[tapcount - 1]];
    [mapView removeOverlay:polygonView];
    
    if (tapcount - 1 >= 3) {
        polygonView = [MAPolygon polygonWithCoordinates:touchPoints count:tapcount - 1];
        [mapView addOverlay:polygonView];
    }
    tapcount--;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];

    UITouch *touch = [[event allTouches]anyObject];
    CGPoint point = [touch locationInView:self.view];
    NSLog(@"tapcount : %d",tapcount);
    if (_drawCircle) {
        NSLog(@"_drawCircle");
        if (touchAnnotation && pointCircle) {
            [mapView removeAnnotation:touchAnnotation];
            [mapView removeOverlay:pointCircle];
        }
        touchCoordinate = [mapView convertPoint:point toCoordinateFromView:self.view];
        touchAnnotation = [MAPointAnnotation new];
        touchAnnotation.coordinate = touchCoordinate;
        
        [mapView addAnnotation:touchAnnotation];
        
        if (!_radius) {
            _radius = 0;
        }
        
        
        pointCircle = [MACircle circleWithCenterCoordinate:touchCoordinate radius:_radius];
        [mapView addOverlay:pointCircle];

    }
    
    if (_drawPolygon) {
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

@end
