//
//  HomeViewController+delegate.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/4/3.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "HomeViewController+delegate.h"

#import "Command.h"

#import "JKAlert.h"

@implementation HomeViewController (delegate)

- (void)passValue:(NSString *)string{
    
    NSLog(@"passValue : %@， topView:%@",string,self.topView);
    
    [self.topView setAddress:string];
    
}


- (void)passSelectedVaule:(NSInteger)selected{
    if(selected == 4){
        
        NSLog(@"showUserLocation");
        
        [[Mymapview sharedInstance].mapView showsUserLocation];
        
        MAMapView *mapView = [Mymapview sharedInstance].mapView;
        
        if ([mapView showsUserLocation]) {
            [mapView setShowsUserLocation:NO];
        }else{
            [mapView setShowsUserLocation:YES];
            [mapView setCenterCoordinate:mapView.userLocation.coordinate];
        }
    }
    if (selected == 3) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://8008808888"]];
        
        NSLog(@"tele");

    }
    if (selected == 2) {
        
        if ([AccountMessage sharedInstance].wid == NULL) {
            
            [JKAlert showMessage:@"没有绑定手环"];
            
            return;
        }
        
        ChatViewController *chatView = [ChatViewController new];
        
        [self presentViewController:chatView animated:YES completion:^{
            ;
        }];
    }
    if (selected == 1) {
        
        if ([AccountMessage sharedInstance].wid == NULL) {
            
            [JKAlert showMessage:@"没有绑定手环"];
            
            return;
        }
        [Command commandWithName:@"watch_cr" block:^(NSInteger type) {
            if (type == 100) {
                NSLog(@"success");
            }
        }];
    }
}

- (void)presentPersonInfoView{
    
    if ([AccountMessage sharedInstance].wid == NULL) {
        
        [JKAlert showMessage:@"没有绑定手环"];
        
        return;
    }
    
    PersonInforViewController *personInfoView = [PersonInforViewController new];
    
    [self presentViewController:personInfoView animated:YES completion:^{
        ;
    }];
}

- (void)showRightView{
        
    if ([self.viewDeckController isSideClosed:IIViewDeckLeftSide]) {
        [self.viewDeckController toggleRightViewAnimated:YES];
    }else{
        [self.viewDeckController closeRightViewAnimated:YES];
    }
}
@end
