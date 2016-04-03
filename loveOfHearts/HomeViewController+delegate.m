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
        [self.mapView showsUserLocation];
        
        [self.mapView setCenterCoordinate:[Mymapview sharedInstance].userLocation.coordinate animated:YES];
        
        }
}

- (void)presentPersonInfoView{
    PersonInforViewController *personInfoView = [PersonInforViewController new];
    
    [self presentViewController:personInfoView animated:YES completion:^{
        ;
    }];
}
@end
