

//
//  Command.m
//  爱之心
//
//  Created by 于恩聪 on 15/9/19.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "Command.h"
#import <AFNetworking/AFNetworking.h>
@implementation Command

+ (void)commandWithName:(NSString *)command andParameter:(NSString *)paramater{
    
    AFHTTPSessionManager *sessionManager;
    
    [sessionManager POST:[NSString stringWithFormat:@"%@",HTTP] parameters:paramater constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
}

+ (void)commandWithAddress:(NSString *)address andParamater:(NSDictionary *)paramater{

    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager new];
    
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    
    [sessionManager POST:[NSString stringWithFormat:@"%@%@",HTTP,address] parameters:paramater constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success : %@",responseObject);
        
        ;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure : %@",error);
    }];
}


@end
