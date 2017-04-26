//
//  ViewController.m
//  DatePicker
//
//  Created by DeliveLee on 2017/3/17.
//  Copyright © 2017年 DeliveLee. All rights reserved.
//

#import "ViewController.h"
#import "DLPickerView.h"

@interface ViewController ()<DLPickerViewDelegate>{
    UILabel *lblTime;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    DLPickerView *pickerView = [[DLPickerView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 216)];
    pickerView.dlPickerDelegate = self;
    [self.view addSubview:pickerView];
    
    lblTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 20)];
    lblTime.font = [UIFont systemFontOfSize:17];
    lblTime.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lblTime];
    
}

-(void)whenSelectedADate_DLPickerViewDelegate:(NSDate *)selectedDate{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone systemTimeZone];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";

    lblTime.text = [df stringFromDate:selectedDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
