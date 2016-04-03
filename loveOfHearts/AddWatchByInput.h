//
//  AddWatchByInput.h
//  爱之心
//
//  Created by 于恩聪 on 15/10/7.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationProtocol.h"

@interface AddWatchByInput : UIViewController<NavigationProtocol>

@property (nonatomic,strong)NSArray *relationArray;

@property (nonatomic,strong)UITableView *listView;

@property (nonatomic,strong) UIButton *relationButton;


@end
