//
//  HomeMenuView.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/11.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "HomeMenuView.h"
#import <Masonry/Masonry.h>


#define BUTTON_BACKCOLOR [UIColor blackColor]
@interface HomeMenuView ()
{
    UIButton *menuButton;
    UIButton *signalButton;
    UIButton *locationButton;
    UIButton *chatButton;
    UIButton *phoneButton;
    UIButton *selfButton;
    UIButton *deviceButton;
}

@end

@implementation HomeMenuView

- (instancetype)init{
    self = [super init];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self initButton];
        
        [self initConstraint];
         
    }
    return self;
}

- (void)initButton{
    menuButton = [UIButton new];
    [menuButton setBackgroundColor:BUTTON_BACKCOLOR];
    
    signalButton = [UIButton new];
    [signalButton setBackgroundColor:BUTTON_BACKCOLOR];
    
    locationButton = [UIButton new];
    [locationButton setBackgroundColor:BUTTON_BACKCOLOR];
    
    chatButton = [UIButton new];
    [chatButton setBackgroundColor:BUTTON_BACKCOLOR];
    
    phoneButton = [UIButton new];
    [phoneButton setBackgroundColor:BUTTON_BACKCOLOR];
    
    selfButton = [UIButton new];
    [selfButton setBackgroundColor:BUTTON_BACKCOLOR];
    
    deviceButton = [UIButton new];
    [deviceButton setBackgroundColor:BUTTON_BACKCOLOR];
    
    
     
    [self addSubview:menuButton];
    [self addSubview:signalButton];
    [self addSubview:locationButton];
    [self addSubview:chatButton];
    [self addSubview:phoneButton];
    [self addSubview:selfButton];
    [self addSubview:deviceButton];
    
    
}

- (void)initConstraint{
    [menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.width.equalTo(self.mas_width);
        make.left.equalTo(self.mas_left);
        make.height.equalTo(self.mas_width);
    }];
    
    
}

@end
