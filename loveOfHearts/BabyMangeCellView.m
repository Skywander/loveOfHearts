//
//  BabyMangeCellView.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/4/6.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "BabyMangeCellView.h"

#define VIEW_HEIGHT 80


@implementation BabyMangeCellView

- (id)init{
    self = [super init];
    
    if (self) {
        //self
        }
    
    return self;
}

- (UIView *)viewWithWatchImage:(UIImage *)image andY:(float)getY andWatchId:(NSString *)watchId{
    UIView *view = [UIView new];
    
    [view setFrame:CGRectMake(10, getY, SCREEN_WIDTH - 20, VIEW_HEIGHT)];
    
    [view setBackgroundColor:[UIColor whiteColor]];
    
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    [imageView setFrame:CGRectMake(20, 20, VIEW_HEIGHT - 40, VIEW_HEIGHT - 40)];
    
    [imageView.layer setBorderWidth:0.3f];
    [imageView.layer setCornerRadius:(VIEW_HEIGHT - 40)/2];
    
    [imageView setClipsToBounds:YES];
    
    [view addSubview:imageView];
    
    UILabel *watchIdLabel = [UILabel new];
    
    [watchIdLabel setFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, VIEW_HEIGHT)];
    
    [watchIdLabel setBackgroundColor:[UIColor clearColor]];
    
    [watchIdLabel setText:watchId];
    
    [watchIdLabel setTextAlignment:NSTextAlignmentCenter];
    
    self.wid = watchId;
    
    [view addSubview:watchIdLabel];
    
    
    [view.layer setCornerRadius:6.f];
    [view.layer setBorderColor:[UIColor grayColor].CGColor];
    [view.layer setBorderWidth:0.3f];
        
    return view;
}

@end
