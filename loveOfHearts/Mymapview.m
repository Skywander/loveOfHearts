//
//  Mymapview.m
//  爱之心
//
//  Created by 于恩聪 on 15/9/21.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "Mymapview.h"
#import "Mymapview+mapDelegate.m"
#import <Masonry/Masonry.h>

#define ZOOMINVALUE 0.3

#define ZOOMOUTVALUE 0.3

static Mymapview *mymapview;

@interface Mymapview()
{
    AMapSearchAPI *_searchAPI;
    
    NSString *detailAddress;
    
    MAPointAnnotation *basePoint;
}

@end

@implementation Mymapview
@synthesize mapView;
@synthesize coordinate;
//@synthesize _search;
+ (instancetype) sharedInstance {
    if (mymapview) {
        [mymapview.mapView removeOverlays:mymapview.mapView.overlays];
        [mymapview.mapView removeAnnotations:mymapview.mapView.annotations];
        return mymapview;
    }else {
        mymapview = [[self alloc] init];
    }
    return mymapview;
}

- (instancetype)init{
    self = [super init];
    [MAMapServices sharedServices].apiKey = APIKey;
    [AMapSearchServices sharedServices].apiKey = APIKey;
    _searchAPI = [[AMapSearchAPI alloc] init];
    _searchAPI.delegate = self;

    mapView = [[MAMapView alloc]init];
    mapView.delegate = self;
    mapView.customizeUserLocationAccuracyCircleRepresentation = YES;//允许定义精度圈的样式
    mapView.showsCompass = NO;
    mapView.showsScale = NO;
    mapView.showsUserLocation = YES;
    mapView.frame = CGRectMake(0,0, self.frame.size.width,self.frame.size.height);
    mapView.layer.cornerRadius = 5.f;
    
    mapView.zoomLevel = 15;
    
    mapView.touchPOIEnabled = YES;
    
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

//SEARCH DELEGATE
//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
        NSLog(@"ReGeo: %@", result);
        
        AMapAddressComponent *component = response.regeocode.addressComponent;
        
        NSLog(@"Mapresponse : city : %@ district : %@  neighborhoood : %@ description : %@",component.city,component.district,component.neighborhood,component.province);
        
        detailAddress = [NSString stringWithFormat:@"%@%@-%@%@",component.province,component.city,component.district,component.neighborhood];
        
        if([_mydelegate respondsToSelector:@selector(passValue:)]){
            [_mydelegate passValue:detailAddress];
        }
    }
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    self.userLocation = userLocation;
}

- (NSString *)searchPointWithLat:(double)lat andLon:(double)lon{
    //构造AMapReGeocodeSearchRequest对象
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:lat longitude:lon];
    regeo.radius = 10000;
    regeo.requireExtension = YES;
    
    //发起逆地理编码
    [_searchAPI AMapReGoecodeSearch: regeo];
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.989631, 116.481018);
    pointAnnotation.title = @"方恒国际";
    pointAnnotation.subtitle = @"阜通东大街6号";
    
    [mapView addAnnotation:pointAnnotation];
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.989631, 116.481018)];
    
    return detailAddress;

}

- (void)showHistoryTrack:(NSMutableArray *)pointsArray{
    //空值检测
    if (pointsArray.count <= 0) {
        NSLog(@"track not exist");
        
        return;
    }
    //创建基点为获取记录的第一个点
    basePoint = [[MAPointAnnotation alloc] init];
    
    basePoint.coordinate = CLLocationCoordinate2DMake([[pointsArray objectAtIndex:0] doubleValue], [[pointsArray objectAtIndex:1] doubleValue]);
    
    [mapView addAnnotation:basePoint];
    //对之后的点进行遍历
    for (int i = 2; i < pointsArray.count; i = i + 2) {
        //获取遍历点 到 基点的距离
        MAPointAnnotation *currentPoint = [[MAPointAnnotation alloc] init];
        currentPoint.coordinate = CLLocationCoordinate2DMake([[pointsArray objectAtIndex:i] doubleValue], [[pointsArray objectAtIndex:(i + 1)] doubleValue]);
        
        CLLocationDistance distance = MAMetersBetweenMapPoints(MAMapPointForCoordinate(basePoint.coordinate), MAMapPointForCoordinate(currentPoint.coordinate));
        
        NSLog(@"distance : %f",distance);
        //距离在10-10000保存，将当前点设为基点
        if (distance >= 10 && distance <= 10000) {
            //画点和直线
            CLLocationCoordinate2D commonPolylineCoords[2];
            
            commonPolylineCoords[0] = basePoint.coordinate;
            
            commonPolylineCoords[1] = currentPoint.coordinate;
            
            MAPolyline *polyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:2];
            
            [mapView addAnnotation:currentPoint];
            [mapView addOverlay:polyline];
            
            basePoint = currentPoint;
        }
        
        mapView.centerCoordinate = basePoint.coordinate;
    }
}

@end
