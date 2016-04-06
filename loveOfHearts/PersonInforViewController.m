//
//  PersonInforViewController.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/24.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "PersonInforViewController.h"
#import "Navigation.h"
#import "IQActionSheetPickerView.h"
#import "AccountMessage.h"
#import "Networking.h"
#import "AccountMessage.h"
#import "Command.h"
#import "NavigationProtocol.h"
@interface PersonInforViewController ()<IQActionSheetPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NavigationProtocol>
{
    UIButton *portraitButton;
    UIButton *remarkButton;
    UIButton *codeButton;
    UIButton *birthdayButton;
    UIButton *sexButton;
    UIButton *removeButton;
    
    UITextField *remarkTextField;
    UIButton *birthdaySubButton;
    UIButton *sexSubButton;
    UILabel *channelLabel;
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
}

- (void)initData{
    accountMessage = [AccountMessage sharedInstance];
    
    NSLog(@"%@",accountMessage.babyname);
    
    _name = accountMessage.babyname;


    _birthday = accountMessage.babybir;
    
    shouhuan_id = accountMessage.wid;
    
    head = accountMessage.head;
    
        
    if ([accountMessage.babysex intValue] == 1) {
        _sex = @"女";
    } else{
        _sex = @"男";
    }
    

}



- (void)initUI {
    [self.view setBackgroundColor:DEFAULT_COLOR];
    
    Navigation *navigation = [Navigation new];
    
    [navigation addRightViewWithName:@"保存"];
    
    [navigation setDelegate:self];
    
    [self.view addSubview:navigation];
    
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
    
    [portraitView setImage:accountMessage.image];

    
    [portraitButton addTarget:self action:@selector(getPortraitView) forControlEvents:UIControlEventTouchUpInside];
    
    [portraitButton addSubview:portraitView];
    [self.view addSubview:portraitButton];
    
    remarkButton = [self buttonWithName:@"    昵称" andPointY:basicY];
    
    codeButton = [self buttonWithName:@"    手表ID" andPointY:basicY + basicMove];
    
    birthdayButton = [self buttonWithName:@"    生日" andPointY:basicY + basicMove * 2];
    [birthdaySubButton addTarget:self action:@selector(updateBirthday) forControlEvents:UIControlEventTouchUpInside];
    
    sexButton = [self buttonWithName:@"    性别" andPointY:basicY + basicMove * 3];
    [sexSubButton addTarget:self action:@selector(updateSex:) forControlEvents:UIControlEventTouchUpInside ];
    
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
    
    
    if (y == basicY) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 50)];
        
        [textField setTextAlignment:NSTextAlignmentRight];
        [textField setTextColor:[UIColor grayColor]];
        [textField setOpaque:YES];
        [textField setText:_name];
        
        [button addSubview:textField];
        
        remarkTextField = textField;
    }
    if (y == basicY + basicMove) {
        channelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 50)];
        [channelLabel setText:shouhuan_id];
        
        [channelLabel setTextAlignment:NSTextAlignmentRight];
        [channelLabel setTextColor:[UIColor grayColor]];
        
        [button addSubview:channelLabel];
    }
    
    if (y == basicY + basicMove * 2) {
        birthdaySubButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 50)];
        [birthdaySubButton setTitle:_birthday forState:UIControlStateNormal];
        [birthdaySubButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [birthdaySubButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [button addSubview:birthdaySubButton];
    }
    
    if (y == basicY + basicMove * 3) {
        sexSubButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 50)];
        [sexSubButton setTitle:_sex forState:UIControlStateNormal];
        [sexSubButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [sexSubButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
//        [sexSubButton setTag:[accountMessage.babysex integerValue]];
        
        [button addSubview:sexSubButton];
    }
    [self.view addSubview:button];
    
    return button;
}

- (void)updateSex:(UIButton *)button{
    NSLog(@"updateSex : %ld",button.tag);
    
    if (button.tag == 0) {
        [button setTitle:@"女" forState:UIControlStateNormal];
    }else{
        [button setTitle:@"男" forState:UIControlStateNormal];
    }
    [button setTag:1 - button.tag];
}

- (void)updateBirthday{
    [picker show];
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


- (void)clickNavigationRightView{
    NSDictionary *paramater = @{
                                @"wid":accountMessage.wid,
                                @"head":head,
                                @"babysex":[NSString stringWithFormat:@"%ld",(long)sexSubButton.tag],
                                @"babyage":@"10",
                                @"babybir":birthdaySubButton.titleLabel.text,
                                @"babyname":remarkTextField.text,
                                @"babyheight":@"170",
                                @"babyweight":@"50",
                                @"usim":accountMessage.usim,
                                @"wsim":accountMessage.wsim
                                };
    
    NSLog(@"paramater : %@",paramater);
    
    
    [Networking updateWatchInfoWithDict:paramater block:^(int i) {
        if (i == 100) {
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
    [birthdaySubButton setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(BOOL)shouldAutorotate
{
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
