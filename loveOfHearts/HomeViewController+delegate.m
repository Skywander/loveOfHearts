//
//  HomeViewController+delegate.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/4/3.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "HomeViewController+delegate.h"

@implementation HomeViewController (delegate)

- (void)passValue:(NSString *)string{
    [self.topView setAddress:string];
}


- (void)passSelectedVaule:(NSInteger)selected{
    if (selected == 2) {
        ChatViewController *chatView = [ChatViewController new];
        
        [self presentViewController:chatView animated:YES completion:^{
            ;
        }];
    }
    if(selected == 4){
        [[Mymapview sharedInstance].mapView showsUserLocation];
        
        [[Mymapview sharedInstance].mapView setCenterCoordinate:[Mymapview sharedInstance].userLocation.coordinate animated:YES];
        
        }
}

- (void)presentPersonInfoView{
    PersonInforViewController *personInfoView = [PersonInforViewController new];
    
    personInfoView.delegate = self;
    
    [self presentViewController:personInfoView animated:YES completion:^{
        ;
    }];
}

- (void)updateImage{
    [self.topView setImage:[AccountMessage sharedInstance].image];
}
@end
