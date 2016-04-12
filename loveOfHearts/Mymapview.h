//
//  Mymapview.h
//  爱之心
//
//  Created by 于恩聪 on 15/9/21.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import <MAMapKit/MAMapServices.h>

#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "MapProtocol.h"

@interface Mymapview : UIView<MAAnnotation,AMapSearchDelegate>

@property (strong,nonatomic) MAMapView *mapView;

@property (nonatomic,strong) MAUserLocation *userLocation;

@property (nonatomic,strong) MAPointAnnotation *pointAnimation;

@property (nonatomic,strong) NSString *currentLat;

@property (nonatomic,strong) NSString *currentLng;

@property (nonatomic,strong) UIImage *annotationImage;

@property (weak,nonatomic) id <MapProtocol>mydelegate;

+ (instancetype)sharedInstance;

- (NSString *)searchPointWithLat:(double)lat andLon:(double)lon;


- (void)showHistoryTrack:(NSMutableArray *)pointsArray;

@end
