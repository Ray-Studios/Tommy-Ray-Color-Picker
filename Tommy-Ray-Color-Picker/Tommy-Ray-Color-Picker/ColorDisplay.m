//
//  ColorDisplay.m
//  Board Share
//
//  Created by Rohan Thomare on 1/22/14.
//  Copyright (c) 2014 TommyRayStudios. All rights reserved.
//

#import "ColorDisplay.h"

@interface ColorDisplay()

@property (weak, nonatomic) IBOutlet UIImageView *colorWheel;


@end

@implementation ColorDisplay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)updateDisplayWithColor: (UIColor*)color
{
    [self.colorDisplay setBackgroundColor:color];
    [self.colorDisplay setNeedsDisplay];
}

-(void)awakeFromNib{
    [super awakeFromNib];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
