//
//  TopView.h
//  爱之心
//
//  Created by 于恩聪 on 16/3/9.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopviewProltocol.h"


@interface HomeTopView : UIView

@property (nonatomic,strong) UIButton *expandButton;

@property (nonatomic,weak) id<TopviewProltocol> topViewDelegat;

- (void)setAddress:(NSString *)address;

- (void)setImage:(UIImage *)image;

- (void)setUpdatePower:(NSInteger)paramater;

- (void)updateTimeLabel;

@end
