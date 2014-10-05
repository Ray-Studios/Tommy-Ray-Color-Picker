//
//  ColorDisplay.h
//  Board Share
//
//  Created by Rohan Thomare on 1/22/14.
//  Copyright (c) 2014 TommyRayStudios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerDelegate.h"

@interface ColorDisplay : UIView

@property (nonatomic,weak) id <ColorDisplayDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *colorDisplay;

- (void)updateDisplayWithColor: (UIColor*)color;

@end
