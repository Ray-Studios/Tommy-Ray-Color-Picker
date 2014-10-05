//
//  AlphaControl.m
//  Board Share
//
//  Created by Rohan Thomare on 1/22/14.
//  Copyright (c) 2014 TommyRayStudios. All rights reserved.
//

#import "AlphaControl.h"

@interface AlphaControl()

@property (nonatomic, weak) IBOutlet UILabel* alphaLabel;
@property (nonatomic, weak) IBOutlet UISlider* alphaSlider;
@property (strong, nonatomic) NSNumberFormatter *fmt;

@end

@implementation AlphaControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGFloat)getAlpha
{
    return [self.alphaSlider value];
}

- (void)setAlphaControlValue:(CGFloat)value
{
    [self.alphaSlider setValue:value];
    [self valueChanged:self.alphaSlider];
}

-(IBAction)valueChanged:(UISlider*)sender
{
    [self.delegate newAlphaValue:sender.value];
    NSNumber* numberValue = [[NSNumber alloc] initWithFloat:sender.value];
    [self.alphaLabel setText:[self.fmt stringFromNumber:numberValue]];
}

-(void)awakeFromNib
{
    self.fmt = [[NSNumberFormatter alloc] init];
    [self.fmt setMaximumFractionDigits:2];
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
