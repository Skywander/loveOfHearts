//
//  HistoryViewController.h
//  Runner
//
//  Created by 于恩聪 on 15/6/27.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import "Mymapview.h"

@interface HistoryViewController : UIViewController<MAMapViewDelegate>
{
    MAMapPoint points[100];
}

@property (nonatomic,strong) NSString *fencesDataArray;

@property (nonatomic,strong) Mymapview *myMapview;

@end
