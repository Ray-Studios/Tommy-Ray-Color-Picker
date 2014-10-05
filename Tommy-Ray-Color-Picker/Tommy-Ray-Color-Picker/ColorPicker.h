//
//  ColorPicker.h
//  Board Share
//
//  Created by Rohan Thomare on 1/22/14.
//  Copyright (c) 2014 TommyRayStudios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorDisplay.h"
#import "BrightnessControl.h"
#import "AlphaControl.h"
#import "ColorWheel.h"
#import "ColorPickerDelegate.h"

@protocol ColorPickerDelegate;

@interface ColorPicker : UIView <AlphaReciverDelegate,BrightnessRecieverDelegate,ColorRecieverDelegate,ColorDisplayDelegate>

@property (nonatomic,weak) id<ColorPickerDelegate> delegate;
@property (nonatomic,strong) UIColor* textColor;
@property (nonatomic,strong) UIColor* backgroundColor;
@property BOOL closed;

-(void)setColorValue:(UIColor*)color forSelectedSegment:(NSUInteger)segment;

-(void)close;

-(void)disableAlpha;

-(void)enableAlpha;

-(void)setEditingTypeWithText:(BOOL)text andBackground:(BOOL)background;

+(ColorPicker*)colorPickerWithDelegate:(id<ColorPickerDelegate>)delegate;

@end

@protocol ColorPickerDelegate <NSObject>

-(void)ColorPicker:(ColorPicker*)picker createdNewColor:(UIColor*)color withSegmentControlValue:(NSInteger)selection;

-(void)ColorPickerPressedExitButton:(ColorPicker*)picker;

-(BOOL)ColorPickerShouldHaveTextOption:(ColorPicker*)picker;

-(BOOL)ColorPickerShouldHaveBackgroundOption:(ColorPicker *)picker;

-(BOOL)ColorPickerShouldHaveAlphaControl:(ColorPicker *)picker;

@optional
-(UIColor*)ColorPickerInitalColorForText:(ColorPicker*)picker;

-(UIColor*)ColorPickerInitalColorForBackground:(ColorPicker*)picker;


@end

