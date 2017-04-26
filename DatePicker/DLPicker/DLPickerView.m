//
//  DLPickerView.m
//  DatePicker
//
//  Created by DeliveLee on 2017/3/17.
//  Copyright © 2017年 DeliveLee. All rights reserved.
//

#import "DLPickerView.h"

#define DEFAULT_MAXIMUM_DAY 99999


typedef enum ComponentName{
    ComponentDate,
    ComponentHour,
    ComponentMinute,
    ComponentAPM
} componentName;

@interface DLPickerView (){
    NSDateFormatter *dateFormatterOfDay;
}

@end

@implementation DLPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setDefault{
    dateFormatterOfDay = [[NSDateFormatter alloc]init];
    dateFormatterOfDay.dateFormat=@"EEE MMM d";
    
    _startHour = 8;
    _endHour = 20;
}

-(id)initWithDate:(NSDate *)date
{
    self = [super init];
    
    if (self)
    {
        [self setDefault];
        [self prepare];
        [self setDate:date];
        self.showsSelectionIndicator = YES;
    }
    
    return self;
}

-(id)init
{
    self = [self initWithDate:[NSDate date]];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self setDefault];
        [self prepare];
        if (!_date)
            [self setDate:[NSDate date]];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setDefault];
        [self prepare];
        if (!_date)
            [self setDate:[NSDate date]];
    }
    
    return self;
}

-(void)prepare
{
    self.dataSource = self;
    self.delegate = self;
}

-(id<UIPickerViewDelegate>)delegate
{
    return self;
}

-(void)setDelegate:(id<UIPickerViewDelegate>)delegate
{
    if ([delegate isEqual:self])
        [super setDelegate:delegate];
}

-(id<UIPickerViewDataSource>)dataSource
{
    return self;
}

-(void)setDataSource:(id<UIPickerViewDataSource>)dataSource
{
    if ([dataSource isEqual:self])
        [super setDataSource:dataSource];
}


-(void)setDate:(NSDate *)date
{
    _date = date;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 4;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case ComponentDate:
            return DEFAULT_MAXIMUM_DAY;
            break;
        case ComponentHour:
            return DEFAULT_MAXIMUM_DAY;
            break;
        case ComponentMinute:
            return 2;
            break;
        case ComponentAPM:
            return 2;
        default:
            break;
    }
    
    return 2;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    switch (component) {
        case ComponentDate:
            return 160;
            break;
        case ComponentHour:
            return 40;
            break;
        case ComponentMinute:
            return 50;
            break;
        case ComponentAPM:
            return 50;
        default:
            break;
    }
    return 180;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    switch (component) {
        case ComponentDate:
            break;
        case ComponentHour:{
            int willDisplayHour = [self getWillDisplayHour:(int)row];
            if(willDisplayHour>12){
                [self selectRow:1 inComponent:ComponentAPM animated:YES];
            }else{
                [self selectRow:0 inComponent:ComponentAPM animated:YES];
            }
            break;
        }
        case ComponentMinute:
            break;
        case ComponentAPM:
            default:
            break;
    }
    
    NSDate *selectedDate = [self getNowSelectedDate];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone systemTimeZone];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    if(self.dlPickerDelegate){
        [self.dlPickerDelegate whenSelectedADate_DLPickerViewDelegate:selectedDate];
    }
    
}


-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case ComponentDate:{
            NSDate *willDisplayDate = [_date dateByAddingTimeInterval:24*60*60*row];
            NSString *todayStr = [dateFormatterOfDay stringFromDate:_date];
            NSString *tempStr = [dateFormatterOfDay stringFromDate:willDisplayDate];
            if([todayStr isEqualToString:tempStr]){
                return @"Today";
            }else{
                return tempStr;
            }
            break;
        }
        case ComponentHour:{

            int willDisplayHour = [self getWillDisplayHour:(int)row];
            if(willDisplayHour>12){
                willDisplayHour -= 12;
            }
                
            return [NSString stringWithFormat:@"%d", willDisplayHour];
            break;
        }
        case ComponentMinute:{
            BOOL is30Min = !(row % 2);
            return is30Min?@"00":@"30";
            break;
        }
        case ComponentAPM:{
            BOOL isAM = !(row % 2);
            return isAM?@"AM":@"PM";
        }
        default:
            break;
    }
    
    
    if (component == 0) {
        return [_proTitleList objectAtIndex:row];
    } else {
        return [_proTimeList objectAtIndex:row];
        
    }
}

-(int)getWillDisplayHour:(int)row{
    int hourGap = _endHour - _startHour + 1;
    int willDisplayHour = _startHour + (row % hourGap);
    return willDisplayHour;
}

-(NSDate *)getNowSelectedDate{

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitTimeZone|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:_date];
    [components setHour: 0];
    [components setMinute:0];
    [components setSecond: 0];
    
    
    int dayRow = [self selectedRowInComponent:ComponentDate];
    components.day += dayRow;
    
    int minRow = [self selectedRowInComponent:ComponentMinute];
    components.minute += minRow * 30;
    
    int hourRow = [self selectedRowInComponent:ComponentHour];
    components.hour = (hourRow%12) + _startHour;
    
    NSDate *selectedDate = [calendar dateFromComponents:components];

    return selectedDate;
}

@end
