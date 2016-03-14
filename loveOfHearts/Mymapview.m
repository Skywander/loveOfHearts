//
//  Mymapview.m
//  爱之心
//
//  Created by 于恩聪 on 15/9/21.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "Mymapview.h"
#import "Constant.h"
#import <Masonry/Masonry.h>

#define ZOOMINVALUE 0.3

#define ZOOMOUTVALUE 0.3

static Mymapview *mymapview;

@implementation Mymapview
@synthesize mapView;
//@synthesize _search;
+ (instancetype) sharedInstance {
    if (mymapview) {
        return mymapview;
    }else {
        mymapview = [[self alloc] init];
    }
    return mymapview;
}

- (instancetype)init{
    self = [super init];
    [MAMapServices sharedServices].apiKey = APIKey;

    mapView = [[MAMapView alloc]init];
    mapView.delegate = self;
    mapView.customizeUserLocationAccuracyCircleRepresentation = YES;//允许定义精度圈的样式
    mapView.showsCompass = NO;
    mapView.showsScale = NO;
    mapView.showsUserLocation = NO;
    mapView.centerCoordinate = CLLocationCoordinate2DMake(38.931694, 116.381060);
    mapView.frame = CGRectMake(0,0, self.frame.size.width,self.frame.size.height);
    mapView.layer.cornerRadius = 5.f;
    
    mapView.zoomLevel = 15;
    
    mapView.touchPOIEnabled = YES;
    
    mapView.userInteractionEnabled = NO;
    
    [self addSubview:mapView];
    
    [self initZoomView];

    
    return self;
}

- (void)initZoomView{
    //放大
    UIButton *zoominButton = [UIButton new];
    [zoominButton setBackgroundImage:[UIImage imageNamed:@"zoomin"] forState:UIControlStateNormal];
    [zoominButton addTarget:self action:@selector(zoomIn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:zoominButton];
    //缩小
    UIButton *zoomoutButton = [UIButton new];
    [zoomoutButton setBackgroundImage:[UIImage imageNamed:@"zoomout"] forState:UIControlStateNormal];
    [zoomoutButton addTarget:self action:@selector(zoomOut) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:zoomoutButton];
    
    [zoominButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-10);
        make.bottom.equalTo(self).with.offset(-10);
        make.width.equalTo(@(31));
        make.height.equalTo(@(43));
    }];
    
    [zoomoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(zoominButton);
        make.left.equalTo(zoominButton);
        make.height.equalTo(zoominButton);
        make.bottom.equalTo(zoominButton).with.offset(-43);
    }];
    
    
}

- (void)zoomIn{
    mapView.zoomLevel = mapView.zoomLevel + ZOOMINVALUE;
}

- (void)zoomOut{
    mapView.zoomLevel = mapView.zoomLevel - ZOOMOUTVALUE;
}
@end
