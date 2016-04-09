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
    [manager POST:[NSString stringWithFormat:@"%@register",HTTP]
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
    
    [manager POST:[NSString stringWithFormat:@"%@login",HTTP] parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        getDict(responseObject);
        
        int returnType = [[responseObject objectForKey:@"type"] intValue];
        
        
        if (returnType == 100) {
            
            NSDictionary *rlist = [[[responseObject objectForKey:@"data"] objectForKey:@"rlist"] objectAtIndex:0];
            
            NSDictionary *wlist = [[[responseObject objectForKey:@"data"] objectForKey:@"wlist"] objectAtIndex:0];
                        
            AccountMessage *accountMessage = [AccountMessage sharedInstance];
            
            [accountMessage setUserInfor:rlist];
            
            [accountMessage setWatchInfor:wlist];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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

+ (void)getDevicesMessageWithParamaters:(NSDictionary *)paramater block:(getDict)getDict{
    if (!manager) {
        manager = [AFHTTPSessionManager new];
    }
    [manager POST:[NSString stringWithFormat:@"%@devicelist",HTTP] parameters:paramater constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
    [manager POST:[NSString stringWithFormat:@"%@powerlist",HTTP] parameters:paramater constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
    
    [manager POST:[NSString stringWithFormat:@"%@downloadheadimg",HTTP] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
        
    [manager POST:[NSString stringWithFormat:@"%@gethistorylocation",HTTP] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        getDict(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}

+ (void)uploadPortraitWithDict:(NSDictionary *)dict andImageData:(NSData *)imageData imageName:(NSString *)imageName block:(getInt)getInt{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    
    [manager POST:[NSString stringWithFormat:@"%@uploadheadimg",HTTP] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"headimg" fileName:imageName mimeType:@"image/png"];
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
    
    [manager POST:[NSString stringWithFormat:@"%@updatebabyinfo",HTTP] parameters:paramaater constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
    
    [manager POST:[NSString stringWithFormat:@"%@recorde",HTTP] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:voiceData name:@"record" fileName:voiceName mimeType:@"image/png"];
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
    
    [manager POST:[NSString stringWithFormat:@"%@downloadrecordes",HTTP] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
    
    [manager POST:[NSString stringWithFormat:@"%@getallrecordes",HTTP] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
}

+ (void)getWatchMessageWithParamater:(NSDictionary *)paramater block:(getDict)getDict{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
    
    [manager POST:[NSString stringWithFormat:@"%@getsinglewatchinfo",HTTP] parameters:paramater constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        getDict(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
}

+ (void)deleteWatchWithDict:(NSDictionary *)paramater block:(getDict)getDict{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
    
    [manager POST:[NSString stringWithFormat:@"%@deleterelation",HTTP] parameters:paramater constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        getDict(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        getDict(nil);
    }];
}

@end
