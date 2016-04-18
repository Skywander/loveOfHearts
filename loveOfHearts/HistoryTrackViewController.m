//
//  HistoryTrackViewController.m
//  Runner
//
//  Created by 于恩聪 on 15/7/6.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "HistoryTrackViewController.h"
#import "Mymapview.h"
#import "IQActionSheetPickerView.h"
#import "Networking.h"
#import "Navigation.h"
#import "AccountMessage.h"
#import "JKAlert.h"


@interface HistoryTrackViewController()<IQActionSheetPickerViewDelegate>
{
    IQActionSheetPickerView *picker;
    
    MAMapView *mapView;
    Mymapview *mymapView;
    
    UIButton *dateButton;

    AccountMessage *accountMessage;
}
@end
@implementation HistoryTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    accountMessage = [AccountMessage sharedInstance];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)initUI {
    [self.view setBackgroundColor:DEFAULT_COLOR];
    
    Navigation *navigation = [Navigation new];
    [self.view addSubview:navigation];
    
    //日期
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *dateString = [formatter stringFromDate:date];
    
    dateButton = [[UIButton alloc] initWithFrame:CGRectMake(100,0,SCREEN_WIDTH - 200,navigation.frame.size.height)];
    [dateButton setBackgroundColor:[UIColor clearColor]];
    
    [dateButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [dateButton.titleLabel setTextColor:[UIColor whiteColor]];
    
    [dateButton setTitle:dateString forState:UIControlStateNormal];
    
    [dateButton addTarget:self action:@selector(chooseDate) forControlEvents:UIControlEventTouchUpInside];
    
    [navigation addSubview:dateButton];
    
    [self initDatePicker];
    
    [self initMapview];
}

- (void)initDatePicker {
    picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Date Picker" delegate:self];
    [picker setTag:6];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
}

- (void)initMapview{
    mymapView = [Mymapview sharedInstance];
    
    [mymapView setFrame:CGRectMake(0, 74, SCREEN_WIDTH, SCREEN_HEIGHT - 84)];
    
    mapView = mymapView.mapView;
    
    mymapView.annotationImage = [UIImage imageNamed:@"defaultanimationView"];

    
    [mapView removeOverlays:mapView.overlays];
    [mapView removeAnnotations:mapView.annotations];
    
    [self.view addSubview:mymapView];
    [self.view sendSubviewToBack:mymapView];

}

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate *)date
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    formatter.dateFormat = @"YYYY-MM-dd";
    
    [dateButton setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
    
    [mapView removeOverlays:mapView.overlays];
    [mapView removeAnnotations:mapView.annotations];
    
    NSDictionary *paramater = @{
                                @"userId":accountMessage.userId,
                                @"wid":accountMessage.wid,
                                @"firstResult":@"0",
                                @"maxResult":@"10000",
                                @"dateTime":dateButton.titleLabel.text
                                };
    
    NSLog(@"paramater : %@",paramater);
    
    [Networking getHistoryTrack:paramater block:^(NSDictionary *dict) {
        
        NSLog(@"returnDict : %@",dict);
        
        NSArray *dataArray = [dict objectForKey:@"data"];
        
        if (dataArray.count < 1) {
            [JKAlert showMessage:@"没有历史记录"];
            
            return ;
        }
    
        [mymapView showHistoryTrack:[NSMutableArray arrayWithArray:dataArray]];
        
        
    }];

}

- (void)chooseDate{
    [picker show];
    
}



@end
