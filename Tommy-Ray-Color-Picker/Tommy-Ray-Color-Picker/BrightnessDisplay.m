//
//  BrightnessDisplay.m
//  Board Share
//
//  Created by Rohan Thomare on 1/22/14.
//  Copyright (c) 2014 TommyRayStudios. All rights reserved.
//

#import "BrightnessDisplay.h"

@implementation BrightnessDisplay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    [self drawForColor:[UIColor redColor] forRect:rect andContext:context];
    UIGraphicsPopContext();
}

-(void)drawForColor:(UIColor*)color forRect:(CGRect)rect andContext:(CGContextRef)context
{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat scale = (1.0/height);
    //draw pixels
    for (int y = 0; y < height; y++)
    {
        CGFloat newAlpha = (CGFloat)(y)*scale;
        const CGFloat value[4] = {0.0f, 0.0f, 0.0f, newAlpha};
        for (int x = 0; x < width; x++)
        {
            CGContextSetFillColor(context, value);
            CGContextFillRect(context, CGRectMake(x, y, 1.0f, 1.0f));
        }
    }

}

@end
