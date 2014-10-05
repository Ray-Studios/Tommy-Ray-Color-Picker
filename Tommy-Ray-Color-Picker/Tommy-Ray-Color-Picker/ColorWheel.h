//
//  ColorWheel.h
//  Board Share
//
//  Created by Rohan Thomare on 1/22/14.
//  Copyright (c) 2014 TommyRayStudios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerDelegate.h"

@interface ColorWheel : UIView

@property (nonatomic,weak) id <ColorRecieverDelegate> delegate;

-(void)setSelectorAtPoint:(CGPoint)point;

-(void)setColorAtPointForHue:(CGFloat)hue andSaturation:(CGFloat)saturation;


-(void)getHue:(CGFloat*)hue andGetSaturation:(CGFloat*)saturation;

-(void)close;

@end
