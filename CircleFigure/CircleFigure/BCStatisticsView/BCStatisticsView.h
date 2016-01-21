//
//  BCStatisticsView.h
//  Custom tool
//
//  Created by Billy on 16/1/21.
//  Copyright © 2016年 zzjr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCStatisticsView : UIView

/**
    key: the UIColor object
    value: how much money
    the color shown order based on the added order
 */
@property(nonatomic, strong) NSDictionary *dic_data;

// each color rate , the count of array_rate == [dic_data count]
@property(nonatomic, strong) NSArray *array_rateOfEachColor; //每个颜色所占的比率数组，count数量和dic_data数量一样，如果不指定，每个颜色 会平均占比率

/**
    text description ,including color && font
 */
@property(nonatomic, copy) NSString *str_title;
@property (nonatomic, strong) UIColor *color_title;
@property (nonatomic, strong) UIFont *font_title;

/**
    money description,including color && font
 */
@property(nonatomic, copy) NSString *str_amountShown;
@property (nonatomic, strong) UIColor *color_amountShown;
@property (nonatomic, strong) UIFont *font_amountShown;

// layer line width
@property (nonatomic, assign) CGFloat lineWidth; //default 2.0


@property (nonatomic, assign) BOOL isAnimated; //default value is NO

@property (nonatomic, assign) BOOL isSpace; // default value is NO, if YES,space value is 0.003

/**
 *	@brief	initial methods
 *
 *	@param 	frame 	self frame
 *
 *	@return	instance of self
 */
- (instancetype) initWithFrame:(CGRect)frame detailsData:(NSDictionary *) dicData
;


@end
