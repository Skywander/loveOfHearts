//
//  HomeMenuView.h
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/11.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeMenuProtocol.h"


@interface HomeMenuView : UIView

@property id<HomeMenuProtocol> homeDelegat;

- (void)updateSingalWith:(NSInteger)paramater;

@end
