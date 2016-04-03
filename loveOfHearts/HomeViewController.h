//
//  ViewController.h
//  爱之心
//
//  Created by 于恩聪 on 16/3/9.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopView.h"
#import "AccountMessage.h"
#import "Networking.h"

#import "IIViewDeckController.h"
#import "IISideController.h"

#import "Mymapview.h"
#import "HomeMenuView.h"


@interface HomeViewController : UIViewController

@property (nonatomic,strong) TopView *topView;

@property (nonatomic,strong) MAMapView *mapView;

@end

