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
#import "Alert.h"
#import "AccountMessage.h"

@interface Networking()
{
    NSArray *devicelist;
    NSArray *userslist;
}

@end

@implementation Networking

int loginMessage;

//1成功 2 重复 3 失败
int registerMessage;

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

+ (void)loginwithUsername:(NSString *)username and:(NSString *)password{
    loginMessage = 0;
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
        
        NSLog(@"user : %@,password : %@",username,password);
        
        NSLog(@"responseObject::%@",responseObject);
        
        if (returnType == 100) {
            
            loginMessage = 1;
            //生成userinfor 的对象
            
            NSLog(@"reponseObject : %@",responseObject);
            
            NSDictionary *rlist = [[[responseObject objectForKey:@"data"] objectForKey:@"rlist"] objectAtIndex:0];
            
            NSDictionary *wlist = [[[responseObject objectForKey:@"data"] objectForKey:@"wlist"] objectAtIndex:0];
                        
            AccountMessage *accountMessage = [AccountMessage sharedInstance];
            
            [accountMessage setUserInfor:rlist];
            
            [accountMessage setWatchInfor:wlist];
            
        }else{
            
            loginMessage = 2;
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        loginMessage = 2;
    }];
}
+ (void)addWatchWithParamaters:(NSDictionary *)paramaters{
    NSLog(@"%@",paramaters);
    
    if (!manager) {
        manager = [AFHTTPSessionManager new];
    }
    [manager POST:[NSString stringWithFormat:@"%@bind",HTTP] parameters:paramaters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)getDevicesMessageWithParamaters:(NSDictionary *)paramater{
    if (!manager) {
        manager = [AFHTTPSessionManager new];
    }
    devicelist = [NSArray new];
    [manager POST:[NSString stringWithFormat:@"%@devicelist",HTTP] parameters:paramater constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        devicelist = [responseObject objectForKey:@"data"];
        
        NSLog(@"networking : %@",devicelist);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)getUsersMessageWithParamaters:(NSDictionary *)paramater{
    
    if (!manager) {
        manager = [AFHTTPSessionManager new];
    }
    userslist = [NSArray new];
    [manager POST:[NSString stringWithFormat:@"%@powerlist",HTTP] parameters:paramater constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        userslist = [responseObject objectForKey:@"data"];
        
        NSLog(@"networking : %@",devicelist);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)getWatchPortiartWithDict:(NSDictionary *)dict{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
    
    manager.responseSerializer = [AFImageResponseSerializer new];
    
    [manager POST:[NSString stringWithFormat:@"%@downloadheadimg",HTTP] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        
        NSString *imagePath = [NSString stringWithFormat:@"%@%@.png",documentPath,[dict objectForKey:@"wid"]];
        
        NSData *imageData = UIImagePNGRepresentation(responseObject);
        
        [imageData writeToFile:imagePath atomically:NO];
        
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"watchImageError : %@",error);
    }];
    

}

- (void)getHistoryMessageWithParamater:(NSDictionary *)dict{
    
}

- (NSArray *)getUsersArray{
    return userslist;
}
     
     

+ (int)getLoginMessage{
    return  loginMessage;
}

+ (int)getRegisterMessage{
    return registerMessage;
}

- (NSArray *)getDeviceMessage{
    return devicelist;
}


@end
