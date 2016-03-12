//
//  Networking.m
//  喔喔农机
//
//  Created by 于恩聪 on 15/12/22.
//  Copyright © 2015年 于恩聪. All rights reserved.
//

#import "Networking.h"
#import "PasswordViewController.h"
#import "JSONKit.h"
@implementation Networking

bool loginMessage;

//1 success 2 重复 3 失败
int registerMessage;

NSString *returnStr;

AFHTTPSessionManager *manager;

+ (void)registerwithDict:(id)dict{
    if (!manager) {
        manager = [AFHTTPSessionManager new];
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    [manager POST:[NSString stringWithFormat:@"%@register",HTTP]
       parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
           ;
       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSString *responseMessage = [responseObject objectForKey:@"msg"];
           
           if ([responseMessage isEqualToString:@"success"]) {
               registerMessage = 1;
           }else if ([responseMessage isEqualToString:@"already exist"]) {
               registerMessage = 2;
           } else{
               registerMessage = 3;
           }
           
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSLog(@"register failure as %@",error);
           registerMessage = 3;
       }];
    
}

+ (int)getRegisterMessage{
    return registerMessage;
}

+ (void)loginwithUsername:(NSString *)username and:(NSString *)password{
    if (!manager) {
        manager = [AFHTTPSessionManager new];
    }
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:username,@"userId",password,@"userPw",nil];
    
    [manager POST:[NSString stringWithFormat:@"%@login",HTTP] parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        int returnType = [[responseObject objectForKey:@"type"] intValue];
        
        if (returnType == 100) {
            NSLog(@"return is 100,login success");
            loginMessage = true;
        }else{
            loginMessage = false;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        loginMessage = false;
    }];
}

+ (BOOL)getLoginMessage{
    return  loginMessage;
}

@end
