//
//  BCStatisticsView.m
//  Custom tool
//
//  Created by Billy on 16/1/21.
//  Copyright © 2016年 zzjr. All rights reserved.
//

#import "BCStatisticsView.h"

@interface BCStatisticsView ()

@property (nonatomic, strong) UILabel *label_title; //label title
@property (nonatomic, strong) UILabel *label_moneyShown; // how many money

@property (nonatomic, strong) NSArray *array_colors; //get the colors array specified by property
@property (nonatomic, strong) NSMutableArray *mutableArray_layers; //how many layer should be created

@property (nonatomic, assign) CGFloat strokeEndValue; //strokeEndValue for eachLayer

@property (nonatomic, strong) UIBezierPath *bgPath;

@property (nonatomic, assign) CGFloat space; // if isSpace, space value

@property (nonatomic, assign) int index_layer; //used in animation to indicate which layer will be used
@end

@implementation BCStatisticsView


- (instancetype)initWithFrame:(CGRect)frame detailsData:(NSDictionary *)dicData {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setDic_data:dicData];
        [self viewConfiguration];
    }
    
    return self;
}

#pragma mark - View default value assignation

- (void) viewConfiguration {
    
    // assigh default values
    [self setLineWidth:2.0];
    [self setColor_title:[UIColor blackColor]];
    [self setColor_amountShown:[UIColor redColor]];
    [self setFont_title:[UIFont systemFontOfSize:14.0]];
    [self setFont_amountShown:[UIFont systemFontOfSize:25.0]];
    
    NSAssert([self.dic_data count] > 0, @"dicData can not be empty");
    
    // step 1: get the colors array and create shaperLayer
    
    self.array_colors = [self.dic_data allKeys];
    
    
    //step 2: create sublayers
    
    CGRect frame_layer = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    for (int i = 0 ; i < [self.array_colors count]; i ++) {
        
        CAShapeLayer *layer_tmp = [self shapeLayerCreationWithFrame:frame_layer lineWidth:self.lineWidth fillColor:[UIColor clearColor] strokeColor:self.array_colors[i]];
        
        [self.layer addSublayer:layer_tmp];
        [self.mutableArray_layers addObject:layer_tmp];
    }
    
    
    //step 3: create labels
    
    self.label_title = [self labelCreationWithFrame:CGRectMake(0, self.bounds.size.height/2 - 30.0, self.bounds.size.width, 30.0) textColor:self.color_title fontName:self.font_title text:nil];
    
    [self addSubview:self.label_title];
    self.label_moneyShown = [self labelCreationWithFrame:CGRectMake(0,self.bounds.size.height/2 + 30.0, self.bounds.size.width, 30.0) textColor:self.color_amountShown fontName:self.font_amountShown text:nil];
    
    [self addSubview:self.label_moneyShown];

}

#pragma mark - layout subviews

- (void)layoutSubviews {
    NSLog(@"layoutSubviews");
    // setpe 4: sepcify the path of each layer && assign new properties value for each layer
    self.bgPath = [UIBezierPath bezierPathWithArcCenter:[self.layer.sublayers firstObject].position
                                                 radius:(self.bounds.size.width - self.lineWidth)/2
                                             startAngle: M_PI/6
                                               endAngle: M_PI * 2 + M_PI/6
                                              clockwise:YES];
    
    // 是否有间隙
    if (self.isSpace) {
        
        self.space = 0.003;
    }else {
        
        self.space = 0.0;
    }
    
    [self configureLayersWithSpace];
    
    // 是否有动画
    if (_isAnimated) {
        
        [self shownFigureWithAnimation];
        
    }else {
        
        [self shownFigureWithoutAnimation];
    }
    
    // text description
    
    if (self.str_title) {
        
        [self.label_title setText:self.str_title];
        
    }
    
    if (self.str_amountShown) {
        
        [self.label_moneyShown setText:self.str_amountShown];
    }
}

#pragma mark - Layers assign value

- (void) configureLayersWithSpace {
    
    for (int i = 0 ; i < [self.mutableArray_layers count]; i ++) {
        
        CAShapeLayer *tmp = [self.mutableArray_layers objectAtIndex:i];
        UIColor *color = [self.array_colors objectAtIndex:i];
        
        [tmp setPath:self.bgPath.CGPath];
        [tmp setLineWidth:_lineWidth];
        [tmp setStrokeColor:color.CGColor];
    }
}

#pragma mark - Draw layer

/**
 
 * if no array_rateOfEachColor specified,
    stockEnd value of each layer is divied into mutliples parts  [based on count of array_colors],for example: if the array_count  = 5, so ,the first layer stockEnd can be specified as 0.2,then each layer add 0.2 default and so on

 * if array_rateOfEachColor, the stockEnd value based on array_rateOfEachColor's value
*/

- (void) shownFigureWithAnimation {
    
    //no array_rateOfEachColor, create it using average value
    if (!self.array_rateOfEachColor) {
        
        CGFloat value = 1.0/self.mutableArray_layers.count;
        
        NSMutableArray *arry = [NSMutableArray array];
        
        for (int i = 0; i < self.mutableArray_layers.count; i++) {

            [arry addObject: [NSString stringWithFormat:@"%.2f",value]];
        }
        
        self.array_rateOfEachColor = [NSArray arrayWithArray:arry];
    }
    
    //start drawing
    [NSTimer scheduledTimerWithTimeInterval:1/60 target:self selector:@selector(animationLayer:) userInfo:nil repeats:YES];
}

- (void)animationLayer:(NSTimer *)timer {
    
    CAShapeLayer *layer = [self.mutableArray_layers objectAtIndex:self.index_layer];
        
    CGFloat endValue = [[self.array_rateOfEachColor objectAtIndex:self.index_layer] floatValue];
    
    layer.strokeStart = self.strokeEndValue;
    
    if (layer.strokeEnd <= endValue + self.strokeEndValue) {
        
        if (self.index_layer == (self.mutableArray_layers.count - 1)) {

            layer.strokeEnd = 1 - self.space;
        }else {

            layer.strokeEnd += 0.001;// 0.001 is compare with 0.003 (self.space)
        }
        
    }else{

        [timer invalidate]; // first layer was finished
        
        self.index_layer++;
        
        if (self.index_layer < self.mutableArray_layers.count) {
            
            self.strokeEndValue += (endValue + self.space);
            //start to draw next layer
            [NSTimer scheduledTimerWithTimeInterval:1/60 target:self selector:@selector(animationLayer:) userInfo:nil repeats:YES];
            
        }else{ //here to forbidden two times call for layoutSubViews to stop to app crash
            
            self.strokeEndValue = 0.0;
            self.index_layer = 0;
        }
    }
}

- (void) shownFigureWithoutAnimation {
    
    CGFloat step = 0.0;
    
    if (self.array_rateOfEachColor) {
        
        CGFloat sumRate = 0.0;
        for (NSString *rate in self.array_rateOfEachColor) {
            
            sumRate +=[rate floatValue];
            
        }
        
        NSAssert(sumRate != 1.0 , @" sum of all elemetns for array array_rateOfEachColor must be 1.0 ");
        
        for (int i = 0 ; i < [self.mutableArray_layers count]; i ++) {
            
            CGFloat step = [[_array_rateOfEachColor objectAtIndex:i] floatValue];
            
            CAShapeLayer *tmp = [self.mutableArray_layers objectAtIndex:i];
            
            [tmp setStrokeStart:self.strokeEndValue];
            
            if (i == (self.mutableArray_layers.count -1)) { //the last layer
                
                self.strokeEndValue = 1.0 - self.space ;
                [tmp setStrokeEnd:self.strokeEndValue];
            }else {
               
                [tmp setStrokeEnd:self.strokeEndValue + step ];
            }
            
            self.strokeEndValue += (step + self.space); // record last strokeEndValue
        }
        
    }else{
        
        step = 1.0 / self.mutableArray_layers.count; //average step
        
        for (int i = 0 ; i < [self.mutableArray_layers count]; i ++) {
            
            CAShapeLayer *tmp = [self.mutableArray_layers objectAtIndex:i];
            
            [tmp setStrokeStart:self.strokeEndValue];
            
            if (i == (self.mutableArray_layers.count -1)) { //the last layer
                
                self.strokeEndValue = 1.0 - self.space ;
                [tmp setStrokeEnd:self.strokeEndValue];
            }else {
                
                [tmp setStrokeEnd:self.strokeEndValue + step ];
            }
            
            self.strokeEndValue += (step + self.space); // record last strokeEndValue
            
        }
    }
    
    self.strokeEndValue  = 0.0;  // different os , the layoutSubViews was called different times,so,this line is resolve this problem so that figure can be shown correctly
}

#pragma mark - Setter methods

- (void)setAnimated:(BOOL)animated {
    
    _isAnimated = animated;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    
    _lineWidth = lineWidth;
}

- (void)setStr_amountShown:(NSString *)str_amountShown {
    
    _str_amountShown = str_amountShown;
}

- (void)setStr_title:(NSString *)str_title {
    
    _str_title = str_title;
}

- (void)setIsSpace:(BOOL)isSpace {
    
    _isSpace = isSpace;
}

- (void)setArray_rateOfEachColor:(NSArray *)array_rateOfEachColor {
    
    _array_rateOfEachColor = array_rateOfEachColor;
}

- (void)setColor_amountShown:(UIColor *)color_amountShown {
    
    _color_amountShown = color_amountShown;
}

- (void)setColor_title:(UIColor *)color_title {
    
    _color_title = color_title;
}

- (void)setFont_amountShown:(UIFont *)font_amountShown {
    
    _font_amountShown = font_amountShown;
}

- (void)setFont_title:(UIFont *)font_title {
    
    _font_title = font_title;
}

- (NSMutableArray *)mutableArray_layers {
    
    if (!_mutableArray_layers) {
        
        _mutableArray_layers = [NSMutableArray array];
    }
    
    return _mutableArray_layers;
}

#pragma mark - Custom methods

- (CAShapeLayer *) shapeLayerCreationWithFrame:(CGRect) frame lineWidth:(CGFloat) width fillColor:(UIColor *) fillColor strokeColor:(UIColor *) strokeColor {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    [shapeLayer setFrame:frame];
    [shapeLayer setStrokeColor:strokeColor.CGColor];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor]; //fill color默认为clear color
    [shapeLayer setLineWidth:width];
    [shapeLayer setStrokeEnd:0.0];
    [shapeLayer setStrokeStart:0.0];
    
    return shapeLayer;
}

- (UILabel *) labelCreationWithFrame:(CGRect ) frame textColor:(UIColor *) color fontName:(UIFont *) font text:(NSString *) text {
    
    UILabel *label_tmp = [[UILabel alloc] init];
    [label_tmp setTextColor:color];
    [label_tmp setFont:font];
    [label_tmp setTextAlignment:NSTextAlignmentCenter];
    [label_tmp setAdjustsFontSizeToFitWidth:YES];
    [label_tmp setFrame:frame];
    
    if (text) {
        
        [label_tmp setText:text];
    }

    return  label_tmp;
}

#pragma mark - Dealloc

- (void)dealloc {
    
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    self.bgPath = nil;
}


@end
