//
//  Networking.m
//  喔喔农机
//
//  Created by 于恩聪 on 15/12/22.
//  Copyright © 2015年 于恩聪. All rights reserved.
//

#import "Networking.h"
#import "PasswordViewController.h"
#import "AccountMessage.h"

@implementation Networking

int loginMessage;

//1成功 2 重复 3 失败

AFHTTPSessionManager *manager;


+ (void)registerwithDict:(id)dict block:(getDict)getDict{
    if (!manager) {
        manager = [AFHTTPSessionManager new];
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    
    [manager POST:[NSString stringWithFormat:@"%@user_register",HTTP]
       parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
           ;
       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           getDict(responseObject);
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSLog(@"register failure as %@",error);
       }];
    
}

+ (void)loginwithUsername:(NSString *)username and:(NSString *)password block:(getDict)getDict{
    loginMessage = 0;
    if (!manager) {
        manager = [AFHTTPSessionManager new];
    }
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:username,@"userId",password,@"userPw",nil];
    
    [manager POST:[NSString stringWithFormat:@"%@user_login",HTTP] parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        getDict(responseObject);
        
        int returnType = [[responseObject objectForKey:@"type"] intValue];
        
        
        if (returnType == 100) {
            
            if (![[responseObject objectForKey:@"data"] isEqual:[NSNull null]]) {
                NSDictionary *rlist = [responseObject objectForKey:@"data"];
                
                AccountMessage *accountMessage = [AccountMessage sharedInstance];
                
                [accountMessage setUserInfor:rlist];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@",error);
    }];
}
+ (void)addWatchWithParamaters:(NSDictionary *)paramaters block:(getDict)getDict{
    NSLog(@"%@",paramaters);
    
    if (!manager) {
        manager = [AFHTTPSessionManager new];
    }
    [manager POST:[NSString stringWithFormat:@"%@user_addUser",HTTP] parameters:paramaters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        getDict(responseObject);
        
        NSLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        getDict(nil);
        NSLog(@"%@",error);
    }];
}

+ (void)getDevicesMessageWithParamaters:(NSDictionary *)paramater block:(getDict)getDict{
    if (!manager) {
        manager = [AFHTTPSessionManager new];
    }
    [manager POST:[NSString stringWithFormat:@"%@user_devicesList",HTTP] parameters:paramater constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject : %@",responseObject);
        

        getDict(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

+ (void)getUsersMessageWithParamaters:(NSDictionary *)paramater block:(getDict)getDict{
    
    if (!manager) {
        manager = [AFHTTPSessionManager new];
    }
    [manager POST:[NSString stringWithFormat:@"%@user_authorityList",HTTP] parameters:paramater constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        getDict(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

+ (void)getWatchPortiartWithDict:(NSDictionary *)dict blockcompletion:(getImage)getImage{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
    
    manager.responseSerializer = [AFImageResponseSerializer new];
    
    [manager POST:[NSString stringWithFormat:@"%@file_downLoadHead",HTTP] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSData *imageData = UIImagePNGRepresentation(responseObject);
        
        UIImage *image = [UIImage imageWithData:imageData];
        
        getImage(image);
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            getImage(nil);
        }];
    
}

+ (void)getHistoryTrack:(NSDictionary *)dict block:(getDict)getDict{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
        
    [manager POST:[NSString stringWithFormat:@"%@w_getHistoryPath",HTTP] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        getDict(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        getDict(nil);
        NSLog(@"%@",error);
    }];

}

+ (void)uploadPortraitWithDict:(NSDictionary *)dict andImageData:(NSData *)imageData imageName:(NSString *)imageName block:(getInt)getInt{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    
    [manager POST:[NSString stringWithFormat:@"%@file_upLoadHead",HTTP] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:imageName mimeType:@"image/png"];
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject : %@",responseObject);
        
        getInt([[responseObject objectForKey:@"type"] intValue]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

+ (void)updateWatchInfoWithDict:(NSDictionary *)paramaater block:(getInt)getInt{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
    
    [manager POST:[NSString stringWithFormat:@"%@user_updateBabyInfo",HTTP] parameters:paramaater constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject objectForKey:@"type"];
                
        getInt([number intValue]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
}

+ (void)uploadVoiceWithDict:(NSDictionary *)dict andVoiceData:(NSData *)voiceData voiceName:(NSString *)voiceName{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    
    [manager POST:[NSString stringWithFormat:@"%@file_upLoadRecorde",HTTP] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:voiceData name:@"file" fileName:voiceName mimeType:@"image/png"];
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"voice responseObject : %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"voice error %@",error);
    }];
}

+ (void)downloadVoiceWithDict:(NSDictionary *)dict block:(getData)getData{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:[NSString stringWithFormat:@"%@file_downLoadRecorde",HTTP] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        getData(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"ERROR : %@",error);
    }];
}

+ (void)getallrecordesWithDict:(NSDictionary *)dict block:(getDict)getDict{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
    
    [manager POST:[NSString stringWithFormat:@"%@w_getRecordeList",HTTP] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        getDict(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
}

+ (void)uploalDataWithAddress:(NSString *)address dict:(NSDictionary *)paramater block:(getInt)getInt{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",HTTP,address] parameters:paramater constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject : %@",responseObject);
        getInt([[responseObject objectForKey:@"type"] intValue]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"erroe : %@",error);
    }];
}

+ (void)getWatchMessageWithParamater:(NSString *)wid block:(getDict)getDict{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
    
    NSDictionary *paramater = @{
                                @"wid":wid
                                };
    
    [manager POST:[NSString stringWithFormat:@"%@w_getWatchInfo",HTTP] parameters:paramater constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){
            getDict([responseObject objectForKey:@"data"]);
        }else{
            getDict(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        getDict(nil);
    }];
}

+ (void)deleteWatchWithDict:(NSDictionary *)paramater block:(getDict)getDict{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];    
    [manager POST:[NSString stringWithFormat:@"%@user_deletedUser",HTTP] parameters:paramater constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        getDict(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error : %@",error);
        getDict(nil);
    }];
}

+ (void)getPasswordWithParamater:(NSDictionary *)paramater block:(getDict)getDict{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
    
    [manager POST:[NSString stringWithFormat:@"%@user_getFogetPasswd",HTTP] parameters:paramater constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject : %@",responseObject);
        getDict(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        getDict(nil);
    }];
}


@end
