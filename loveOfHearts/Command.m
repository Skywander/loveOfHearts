

//
//  Command.m
//  爱之心
//
//  Created by 于恩聪 on 15/9/19.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "Command.h"
#import <AFNetworking/AFNetworking.h>
#import "AccountMessage.h"
#import "HistoryFenceList.h"
#import "AccountMessage.h"

@implementation Command

+ (void)commandWithName:(NSString *)command block:(getInteger)getInteger{
    
    AccountMessage *accountMessage = [AccountMessage sharedInstance];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager new];
    
    NSDictionary *paramater = @{
                                @"userId":accountMessage.userId,
                                @"wid":accountMessage.wid
                                    };
    
    NSLog(@"%@",paramater);
    
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    
    [sessionManager POST:[NSString stringWithFormat:@"%@%@",HTTP,command] parameters:paramater constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        getInteger([[responseObject objectForKey:@"type"] integerValue]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        getInteger(0);
    }];
}

+ (void)commandWithAddress:(NSString *)address andParamater:(NSDictionary *)paramater block:(getInteger)getInteger{

    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager new];
    
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    
    [sessionManager POST:[NSString stringWithFormat:@"%@%@",HTTP,address] parameters:paramater constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success : %@",responseObject);
        
        getInteger([[responseObject objectForKey:@"type"] integerValue]);
  
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure : %@",error);
        
        getInteger(0);
    }];
}

+ (void)commandWithAddress:(NSString *)address andParamater:(NSDictionary *)paramater dictBlock:(getDict)getDict{
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager new];
    
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    
    NSLog(@"%@",paramater);
    
    [sessionManager POST:[NSString stringWithFormat:@"%@%@",HTTP,address] parameters:paramater constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success : %@",[responseObject objectForKey:@"data"]);
        
        if (![[responseObject objectForKey:@"data"] isEqual:[NSNull null]] && [responseObject objectForKey:@"data"] != nil) {
            getDict([responseObject objectForKey:@"data"]);

        }else{
            getDict(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure : %@",error);
        
        getDict(nil);
    }];
}



@end
