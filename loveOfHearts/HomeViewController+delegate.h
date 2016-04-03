//
//  HomeViewController+delegate.h
//  loveOfHearts
//
//  Created by 于恩聪 on 16/4/3.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "HomeViewController.h"
#import "ChatViewController.h"
#import "PersonInforViewController.h"

#import "MapProtocolDelegate.h"
#import "HomeMenuProtocol.h"
#import "TopviewProltocol.h"

@interface HomeViewController (delegate)<MapProtocolDelegate,HomeMenuProtocol,TopviewProltocol>

- (void)passValue:(NSString *)string;

- (void)passSelectedVaule:(NSInteger)selected;

- (void)presentPersonInfoView;

@end
