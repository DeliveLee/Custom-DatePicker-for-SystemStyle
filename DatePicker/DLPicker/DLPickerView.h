//
//  DLPickerView.h
//  DatePicker
//
//  Created by DeliveLee on 2017/3/17.
//  Copyright © 2017年 DeliveLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DLPickerViewDelegate <NSObject>

-(void)whenSelectedADate_DLPickerViewDelegate:(NSDate *)selectedDate;

@end

@interface DLPickerView : UIPickerView<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *proTimeList;
@property (nonatomic, strong) NSArray *proTitleList;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) int startHour;
@property (nonatomic, assign) int endHour;

@property (nonatomic, weak) id<DLPickerViewDelegate> dlPickerDelegate;

@end
