//
//  PersonInforViewController.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/24.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "PersonInforViewController.h"
#import "Navview.h"
#import "IQActionSheetPickerView.h"
#import "AccountMessage.h"
#import "Networking.h"
#import "AccountMessage.h"
#import "Command.h"
@interface PersonInforViewController ()<IQActionSheetPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIButton *portraitButton;
    UIButton *remarkButton;
    UIButton *codeButton;
    UIButton *birthdayButton;
    UIButton *sexButton;
    UIButton *removeButton;
    
    UITextField *remarkLabel;
    UITextField *birthdayLabel;
    UITextField *sexLabel;
    UITextField *channelLabel;
    UIImageView *portraitView;
    
    CGFloat basicMove;
    CGFloat basicY;
    NSTimer *timer;
    
    UIImagePickerController *imagePicker;
    
    //信息
    NSString *_birthday;
    NSString *_name;
    NSString *_sex;
    NSString *sex;
    NSString *_clock;
    
    NSString *shouhuan_id;
    
    IQActionSheetPickerView *picker;
    AccountMessage *accountMessage;
    
    NSString *head;
    UIImage *portraitImage;
    
}
@end

@implementation PersonInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData{
    accountMessage = [AccountMessage sharedInstance];
    
    _name = accountMessage.babyname;
    
    _birthday = accountMessage.babybir;
    
    shouhuan_id = accountMessage.wid;
    
    if ([accountMessage.babysex intValue] == 1) {
        _sex = @"女";
    } else{
        _sex = @"男";
    }
}



- (void)initUI {
    [self.view setBackgroundColor:DEFAULT_COLOR];
    
    UIButton *expandButton = [UIButton new];
    
    [expandButton setFrame:CGRectMake(SCREEN_WIDTH - NAVIGATION_HEIGHT, 0, NAVIGATION_HEIGHT, NAVIGATION_HEIGHT)];
    
    [expandButton setTitle:@"保存" forState:UIControlStateNormal];
    
    [expandButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [expandButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    [expandButton addTarget:self action:@selector(expand) forControlEvents:UIControlEventTouchUpInside];
    
    Navview *navigation = [Navview new];
    
    [self.view addSubview:navigation];
    
    [navigation addSubview:expandButton];
    
    basicMove = 55;
    basicY = 144;
    
    portraitButton = [[UIButton alloc] initWithFrame:CGRectMake(6, 70, SCREEN_WIDTH - 12, 70)];
    
    [portraitButton setBackgroundColor:[UIColor whiteColor]];
    
    [portraitButton.layer setBorderColor:[UIColor grayColor].CGColor];
    [portraitButton.layer setBorderWidth:0.3f];
    [portraitButton.layer setCornerRadius:6.f];
    
    [portraitButton setTitle:@"     头像" forState:UIControlStateNormal];
    [portraitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [portraitButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    
    
    
    portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 82, 10, 50, 50)];
    [portraitView.layer setCornerRadius:25.f];
    [portraitView.layer setBorderWidth:0.3f];
    [portraitView setClipsToBounds:YES];
    
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    
//    NSString *imagePath = [NSString stringWithFormat:@"%@%@.png",path,[AccountMessage sharedInstance].head];
//    
//    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    
    
    [portraitView setImage:accountMessage.image];

    
    [portraitButton addTarget:self action:@selector(getPortraitView) forControlEvents:UIControlEventTouchUpInside];
    
    [portraitButton addSubview:portraitView];
    [self.view addSubview:portraitButton];
    
    remarkButton = [self buttonWithName:@"    昵称" andPointY:basicY];
    
    codeButton = [self buttonWithName:@"    手表ID" andPointY:basicY + basicMove];
    
    birthdayButton = [self buttonWithName:@"    生日" andPointY:basicY + basicMove * 2];
    
    sexButton = [self buttonWithName:@"    性别" andPointY:basicY + basicMove * 3];
    
    //日期选择
    picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Date Picker" delegate:self];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    
    
}

- (UIButton *)buttonWithName:(NSString *)name andPointY:(CGFloat)y {
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(6, y, SCREEN_WIDTH - 12, 50)];
    [button setBackgroundColor:[UIColor whiteColor]];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:name forState:UIControlStateNormal];
    [button setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    
    [button.layer setBorderColor:[UIColor grayColor].CGColor];
    [button.layer setBorderWidth:0.3f];
    [button.layer setCornerRadius:6.f];
    
    [button setTag:(y - basicY) / basicMove];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 50)];
    [textField setTextAlignment:NSTextAlignmentRight];
    [textField setTextColor:[UIColor grayColor]];
    [textField setOpaque:YES];
    
    if (y == basicY) {
        remarkLabel = textField;
        [remarkLabel setText:_name];
        [button addSubview:remarkLabel];
    }
    if (y == basicY + basicMove) {
        channelLabel = textField;
        [channelLabel setText:shouhuan_id];
        [button addSubview:channelLabel];
    }
    
    if (y == basicY + basicMove * 2) {
        birthdayLabel = textField;
        [birthdayLabel setText:_birthday];
        [button addSubview:birthdayLabel];
    }
    
    if (y == basicY + basicMove * 3) {
        sexLabel = textField;
        [sexLabel setText:_sex];
        [button addSubview:sexLabel];
    }
    [self.view addSubview:button];
    
    return button;
}
- (void)getPortraitView {
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        
    }
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}


- (void)expand{
    NSDictionary *paramater = @{
                                @"wid":accountMessage.wid,
                                @"head":head,
                                @"babysex":@"0",
                                @"babyage":@"10",
                                @"babybir":birthdayLabel.text,
                                @"babyname":remarkLabel.text,
                                @"babyheight":@"170",
                                @"babyweight":@"50",
                                @"usim":accountMessage.usim,
                                @"wsim":accountMessage.wsim
                                };
    
    NSLog(@"paramater : %@",paramater);
    
    [Networking updateWatchInfoWithDict:paramater block:^(int i) {
        if (i == 100) {
            NSLog(@"success");
            accountMessage.image = portraitImage;
        }
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    //    NSLog(@"%@",info);
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    [portraitView setImage:image];
    UIImage *addPic = image;
    
    CGSize imagesize = addPic.size;
    
    imagesize.height = 100;
    
    imagesize.width = 100;
    
    UIImage *imageNew = [self imageWithImage:addPic scaledToSize:imagesize];
    
    portraitImage = imageNew;
    
    NSData *imageData = UIImagePNGRepresentation(imageNew);
    
    [portraitView setImage:imageNew];
    
    NSDate *date = [NSDate new];
    
    NSDateFormatter  *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYYMMddHHddss";
    
    NSString *dateString =  [formatter stringFromDate:date];
    
    head = [NSString stringWithFormat:@"%@%@.png",accountMessage.wid,dateString];
    
    NSDictionary *dict = @{
                            @"userId":[AccountMessage sharedInstance].userId,
                            @"wid":[AccountMessage sharedInstance].wid,
                           };
    
    [Networking uploadPortraitWithDict:dict andImageData:imageData imageName:head];
    //此处上传图片
}
//图片压缩
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


//日期回调

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate *)date
{
    NSLog(@"picker.date : %@",date);
    NSDateFormatter  *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    [birthdayLabel setText:[formatter stringFromDate:date]];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

@end
