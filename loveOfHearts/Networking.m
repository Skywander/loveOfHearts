//
//  Networking.m
//  喔喔农机
//
//  Created by 于恩聪 on 15/12/22.
//  Copyright © 2015年 于恩聪. All rights reserved.
//

#import "Networking.h"
#import "PasswordViewController.h"

@implementation Networking

bool isSuccess;

bool over;

NSString *returnStr;

AFHTTPSessionManager *manager;

+ (BOOL)registerwithDict:(id)dict{
    if (!manager) {
        manager = [AFHTTPSessionManager new];

    }
    
    [manager POST:[NSString stringWithFormat:@"%@%@",HTTP,@"user/"]
       parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
           //
       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSLog(@"register success");
           isSuccess = YES;
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           isSuccess = NO;
           NSLog(@"register failure");
       }];
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",HTTP,@"user/"]);
    
    return isSuccess;
}

+ (BOOL)loginwithUsername:(NSString *)username and:(NSString *)password andUIViewController:(UIViewController *)viewController{
    NSLog(@"%@",password);
    isSuccess = NO;
    over = NO;
    if (!manager) {
        manager = [AFHTTPSessionManager new];
    }
    [manager GET:[NSString stringWithFormat:@"%@%@%@",HTTP,@"user/",username]
      parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSDictionary *responseDict = (NSDictionary *)responseObject;
          
          NSNumber *code = [responseDict objectForKey:@"code"];
          
          if ([code intValue] == 100) {
              NSArray *dataStr = [responseDict objectForKey:@"data"];
              
              NSDictionary *dataDict = [dataStr objectAtIndex:0];
              
              NSString *getPassword = [dataDict objectForKey:@"password"];
              
              NSLog(@"%@",getPassword);
              
              if ([getPassword isEqualToString:password]) {
                  
                  isSuccess = YES;
                  PasswordViewController *password = [PasswordViewController new];
                  [viewController presentViewController:password animated:YES completion:^{
                      //
                  }];
                  
              }else{
                  isSuccess = NO;
              }
          }else{
              isSuccess = NO;
          }
          over = YES;
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"login failure");
          isSuccess = NO;
          over = NO;
      }];

    return isSuccess;
}

@end
