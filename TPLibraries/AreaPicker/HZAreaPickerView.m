//
//  HZAreaPickerView.m
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import "HZAreaPickerView.h"
#import <QuartzCore/QuartzCore.h>

#define kDuration 0.3

@interface HZAreaPickerView ()
{
    NSArray *provinces, *cities, *areas;
}

@end

@implementation HZAreaPickerView

@synthesize delegate=_delegate;
@synthesize pickerStyle=_pickerStyle;
@synthesize locate=_locate;
@synthesize locatePicker = _locatePicker;
@synthesize cancelBtn = _cancelBtn;
@synthesize completeBtn = _completeBtn;
-(HZLocation *)locate
{
    if (_locate == nil) {
        _locate = [[HZLocation alloc] init];
    }
    
    return _locate;
}
//选择完成
- (IBAction)finishBtnPress:(UIButton *)sender {
    
    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
        [self.delegate pickerDidChaneStatus:self];
    }
    [self cancelPicker];
}

//隐藏
- (IBAction)dissmissBtnPress:(UIButton *)sender {
    
    [self cancelPicker];
}
- (id)initWithStyle:(HZAreaPickerStyle)pickerStyle delegate:(id<HZAreaPickerDelegate>)delegate provinceId:(NSString *)proId cityId:(NSString *)citId districtId:(NSString *)disId
{
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"HZAreaPickerView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
        self.pickerStyle = pickerStyle;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        
        NSArray *proArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"provinceArray.plist" ofType:nil]];
        NSArray *citArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cityArray.plist" ofType:nil]];
        NSArray *disArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"districtArray.plist" ofType:nil]];
        
        NSInteger proIndex = [proArray indexOfObject:proId];
        if (proIndex > 10000) {
            proIndex = 0;
        }
        NSInteger citIndex = [[citArray objectAtIndex:proIndex] indexOfObject:citId];
        if (citIndex > 10000) {
            citIndex = 0;
        }
        NSInteger disIndex = [[[disArray objectAtIndex:proIndex] objectAtIndex:citIndex] indexOfObject:disId];
        if (disIndex > 10000) {
            disIndex = 0;
        }
        
        //加载数据
        
        provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
        cities = [[provinces objectAtIndex:proIndex] objectForKey:@"cities"];
        
        self.locate.state = [[provinces objectAtIndex:proIndex] objectForKey:@"state"];
        self.locate.city = [[cities objectAtIndex:citIndex] objectForKey:@"state"];
        
        self.locate.provinceId = [[provinces objectAtIndex:proIndex] objectForKey:@"id"];
        self.locate.cityId = [[cities objectAtIndex:citIndex] objectForKey:@"id"];
        
        areas = [[cities objectAtIndex:citIndex] objectForKey:@"areas"];
        if (areas.count > 0) {
            self.locate.district = [[areas objectAtIndex:disIndex] objectForKey:@"state"];
            self.locate.areaId = [[areas objectAtIndex:disIndex] objectForKey:@"id"];
        } else{
            self.locate.district = @"";
        }
        
        
        [self.locatePicker selectRow:proIndex inComponent:0 animated:YES];
        [self.locatePicker selectRow:citIndex inComponent:1 animated:YES];
        [self.locatePicker selectRow:disIndex inComponent:2 animated:YES];
        
    }
    
//    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
//        [self.delegate pickerDidChaneStatus:self];
//    }
    
    return self;
    
}



#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [provinces count];
            break;
        case 1:
            return [cities count];
            break;
        case 2:
            return [areas count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [[provinces objectAtIndex:row] objectForKey:@"state"];
            break;
        case 1:
            return [[cities objectAtIndex:row] objectForKey:@"state"];
            break;
        case 2:
            if ([areas count] > 0) {
                return [[areas objectAtIndex:row] objectForKey:@"state"];
                break;
            }
        default:
            return  @"";
            break;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            cities = [[provinces objectAtIndex:row] objectForKey:@"cities"];
            [self.locatePicker selectRow:0 inComponent:1 animated:YES];
            [self.locatePicker reloadComponent:1];
            
            areas = [[cities objectAtIndex:0] objectForKey:@"areas"];
            [self.locatePicker selectRow:0 inComponent:2 animated:YES];
            [self.locatePicker reloadComponent:2];
            
            self.locate.state = [[provinces objectAtIndex:row] objectForKey:@"state"];
            self.locate.city = [[cities objectAtIndex:0] objectForKey:@"state"];
            
            self.locate.provinceId = [[provinces objectAtIndex:row] objectForKey:@"id"];
            self.locate.cityId = [[cities objectAtIndex:0] objectForKey:@"id"];
            
            if ([areas count] > 0) {
                self.locate.district = [[areas objectAtIndex:0] objectForKey:@"state"];
                self.locate.areaId = [[areas objectAtIndex:0] objectForKey:@"id"];
            } else{
                self.locate.district = @"";
            }
            break;
        case 1:
            areas = [[cities objectAtIndex:row] objectForKey:@"areas"];
            [self.locatePicker selectRow:0 inComponent:2 animated:YES];
            [self.locatePicker reloadComponent:2];
            
            self.locate.city = [[cities objectAtIndex:row] objectForKey:@"state"];
            self.locate.cityId = [[cities objectAtIndex:row] objectForKey:@"id"];
            
            if ([areas count] > 0) {
                self.locate.district = [[areas objectAtIndex:0] objectForKey:@"state"];
                self.locate.areaId = [[areas objectAtIndex:0] objectForKey:@"id"];
            } else{
                self.locate.district = @"";
            }
            break;
        case 2:
            if ([areas count] > 0) {
                self.locate.district = [[areas objectAtIndex:row] objectForKey:@"state"];
                self.locate.areaId = [[areas objectAtIndex:row] objectForKey:@"id"];
            } else{
                self.locate.district = @"";
            }
            break;
        default:
            break;
    }
    
//    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
//        [self.delegate pickerDidChaneStatus:self];
//    }
    
}


#pragma mark - animation

- (void)showInView:(UIView *) view
{
    self.frame = CGRectMake(0, view.frame.size.height, ScreenWidth, self.frame.size.height);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, ScreenWidth, self.frame.size.height);
    }];
    
}

- (void)cancelPicker
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, ScreenWidth, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
    
}

@end
