//
//  BrightnessControl.m
//  Board Share
//
//  Created by Rohan Thomare on 1/22/14.
//  Copyright (c) 2014 TommyRayStudios. All rights reserved.
//

#import "BrightnessControl.h"
#import "BrightnessDisplay.h"

@interface BrightnessControl()

@property (weak, nonatomic) IBOutlet UIButton *selector;
@property (weak, nonatomic) IBOutlet BrightnessDisplay* display;
@property (weak, nonatomic) IBOutlet UIView* colorDisplay;
@property CGFloat maxY;
@property CGFloat minY;
@property CGFloat hue;
@property CGFloat saturation;
@property CGFloat brightness;
@property CGFloat alpha;

@end


@implementation BrightnessControl

@synthesize minY = _minY;
@synthesize maxY = _maxY;
@synthesize hue = _hue;
@synthesize saturation = _saturation;
@synthesize brightness = _brightness;
@synthesize alpha = _alpha;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)setColor:(UIColor *)color
{
    [color getHue:&_hue saturation:&_saturation brightness:&_brightness alpha:&_alpha];
    [self.colorDisplay setBackgroundColor:[[UIColor alloc]initWithHue:_hue saturation:_saturation brightness:1.0f alpha:1.0f]];
}

-(CGFloat)brightnessValue
{
    CGFloat scale = (1.0f/(self.maxY-self.minY));
    CGFloat distance = self.selector.center.y - self.minY;
    return 1.0f - scale*distance;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    //add gesture to move slider
    UIPanGestureRecognizer *pangr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [self.selector addGestureRecognizer:pangr];
    
    UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.display addGestureRecognizer:tapgr];
    
    //move slider to top
    self.minY = self.display.superview.center.y - (self.display.superview.frame.size.height/2);
    self.maxY = self.display.superview.center.y + (self.display.superview.frame.size.height/2);
    
    [self.selector setCenter:CGPointMake(self.selector.center.x, self.minY)];
    
    //[self.delegate newBrightnessValue:[self brightnessValue]];

}

- (void)setBrightnessValue:(CGFloat)value
{
    CGFloat scale = (1.0f/(self.maxY-self.minY));
    CGFloat distance = (1.0f - value)/scale;
    CGPoint selectorCenter = self.selector.center;
    selectorCenter.y = distance+self.minY;
    [self.selector setCenter:selectorCenter];
    
}

- (void)move:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateChanged ||
        recognizer.state == UIGestureRecognizerStateEnded) {
        
        UIView *draggedButton = recognizer.view;
        CGPoint translation = [recognizer translationInView:self];
        
        CGRect newButtonFrame = draggedButton.frame;
        newButtonFrame.origin.y += translation.y;

        CGPoint newButtonCenter = CGPointMake(newButtonFrame.origin.x + (newButtonFrame.size.width/2), newButtonFrame.origin.y + (newButtonFrame.size.height/2));
        if(newButtonCenter.y <= self.minY)
            newButtonCenter.y = self.minY;
        else if(newButtonCenter.y >=  self.maxY)
            newButtonCenter.y = self.maxY;
        
        draggedButton.center = newButtonCenter;
        
        [recognizer setTranslation:CGPointZero inView:self];
        [self.delegate newBrightnessValue:[self brightnessValue]];
    }
}

- (void)tap:(UITapGestureRecognizer*)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateEnded)
    {
        UIView *tappedView = recognizer.view;
        CGPoint tap = [recognizer locationOfTouch:0 inView:tappedView];
        CGPoint tapInSuperView = [recognizer locationOfTouch:0 inView:self];
        
        if(tap.y > (self.maxY - self.minY) || tap.y < 0)
            return;
        
        CGPoint newButtonCenter = self.selector.center;
        //CGFloat yTrans = newButtonCenter.y - tapInSuperView.y;
        newButtonCenter.y =tapInSuperView.y;
        
        [self.selector setCenter:newButtonCenter];
        
        [self.delegate newBrightnessValue:[self brightnessValue]];
    }
}

@end
