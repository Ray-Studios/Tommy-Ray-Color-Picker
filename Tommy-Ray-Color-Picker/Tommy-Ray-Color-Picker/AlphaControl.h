//
//  AlphaControl.h
//  Board Share
//
//  Created by Rohan Thomare on 1/22/14.
//  Copyright (c) 2014 TommyRayStudios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerDelegate.h"

@interface AlphaControl : UIView

@property (nonatomic,weak) id <AlphaReciverDelegate> delegate;

-(void)setAlphaControlValue:(CGFloat)value;

-(CGFloat)getAlpha;

@end
