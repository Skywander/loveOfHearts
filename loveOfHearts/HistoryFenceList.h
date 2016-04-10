//
//  HistoryFenceList.h
//  Runner
//
//  Created by 于恩聪 on 15/7/9.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryFenceList : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *fencenameList;

@property (nonatomic,strong) UITableView *table;

@end
