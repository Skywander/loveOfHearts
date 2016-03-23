//
//  Navview.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/18.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "Navview.h"

@implementation Navview

- (id)init{
    self = [super init];
    
    if(self){
        [self setFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
        
        [self setBackgroundColor:DEFAULT_PINK];
        
        UIButton *returnButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
        
        [returnButton setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
        
        [returnButton addTarget:self action:@selector(returenLastView) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:returnButton];
        
    }
    return self;
}

- (void)returenLastView{
    UIResponder *responder = [self.superview nextResponder];
    
    UIViewController *viewController = (UIViewController *)responder;
    
    [viewController dismissViewControllerAnimated:YES completion:^{
        ;
    }];
    
}

@end
