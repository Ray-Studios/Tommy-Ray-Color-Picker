//
//  ColorPickerDelegate.h
//  Board Share
//
//  Created by Rohan Thomare on 1/22/14.
//  Copyright (c) 2014 TommyRayStudios. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol AlphaReciverDelegate <NSObject>

-(void)newAlphaValue:(CGFloat)alpha;

@end

@protocol BrightnessRecieverDelegate <NSObject>

-(void)newBrightnessValue:(CGFloat)brightness;

@end

@protocol ColorRecieverDelegate <NSObject>

-(void)newHueValue:(CGFloat)hue andSaturationValue:(CGFloat)saturation atPoint:(CGPoint)point;

@end

@protocol ColorDisplayDelegate <NSObject>

-(void)displayPressed;

@end

