//
//  BabyMangeCellView.h
//  loveOfHearts
//
//  Created by 于恩聪 on 16/4/6.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BabyMangeCellView : UIView

@property (nonatomic,strong) UIImage *portrait;

@property (nonatomic,strong) NSString *wid;

- (UIView *)viewWithWatchImage:(UIImage *)image andY:(float)getY andWatchId:(NSString *)watchId;

@end
