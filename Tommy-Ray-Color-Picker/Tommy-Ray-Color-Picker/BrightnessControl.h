//
//  BrightnessControl.h
//  Board Share
//
//  Created by Rohan Thomare on 1/22/14.
//  Copyright (c) 2014 TommyRayStudios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerDelegate.h"

@interface BrightnessControl : UIView

@property (nonatomic,weak) id <BrightnessRecieverDelegate> delegate;

-(void)setColor:(UIColor *)color;

-(void)setBrightnessValue:(CGFloat)value;

-(CGFloat)brightnessValue;

@end
