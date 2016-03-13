//
//  Alert.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/13.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "Alert.h"

@implementation Alert


+ (UIAlertController *)getAlertWithTitle:(NSString *)title{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert
                                          ];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                         }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    
    return alertController;

}
@end
