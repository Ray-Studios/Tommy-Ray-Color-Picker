//
//  ColorPicker.m
//  Board Share
//
//  Created by Rohan Thomare on 1/22/14.
//  Copyright (c) 2014 TommyRayStudios. All rights reserved.
//

#import "ColorPicker.h"

@interface ColorPicker()

@property (weak, nonatomic) IBOutlet UISegmentedControl *textBackgroundPicker;

@property (weak, nonatomic) IBOutlet ColorDisplay *colorDisplay;

@property (weak, nonatomic) IBOutlet BrightnessControl *brightness;

@property (weak, nonatomic) IBOutlet AlphaControl *alphaSlider;

@property (weak, nonatomic) IBOutlet ColorWheel *wheel;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property BOOL textEdit;

@property BOOL backgroundEdit;

@property CGFloat textHueValue;
@property CGFloat textSaturationValue;
@property CGFloat textBrightnessValue;
@property CGFloat textAlphaValue;
@property CGPoint textSelectorPoint;

@property CGFloat backgroundHueValue;
@property CGFloat backgroundSaturationValue;
@property CGFloat backgroundBrightnessValue;
@property CGFloat backgroundAlphaValue;
@property CGPoint backgroundSelectorPoint;

@end

@implementation ColorPicker

@synthesize delegate = _delegate;


+(ColorPicker*)colorPickerWithDelegate:(id<ColorPickerDelegate>)delegate{
    id colorPicker = [[[NSBundle mainBundle] loadNibNamed:@"ColorPicker" owner:self options:nil] objectAtIndex:0];
    if([colorPicker isKindOfClass:[ColorPicker class]]){
        [((ColorPicker*)colorPicker) setDelegate:delegate];
        return (ColorPicker*)colorPicker;
    }
    return nil;
}

-(void)setDelegate:(id<ColorPickerDelegate>)delegate
{
    _delegate = delegate;
    if(_delegate)
    {
        [self setEditingTypeWithText:[_delegate ColorPickerShouldHaveTextOption:self] andBackground:[_delegate ColorPickerShouldHaveBackgroundOption:self]];
        
        if(self.textEdit && self.backgroundEdit)
        {
            if([_delegate respondsToSelector:@selector(ColorPickerInitalColorForText:)])
                [self setColorValue:[_delegate ColorPickerInitalColorForText:self] forSelectedSegment:0];
            
            if([_delegate respondsToSelector:@selector(ColorPickerInitalColorForBackground:)])
                [self setColorValue:[_delegate ColorPickerInitalColorForBackground:self] forSelectedSegment:1];
        }
        else if(self.textEdit)
        {
            if([_delegate respondsToSelector:@selector(ColorPickerInitalColorForText:)])
                [self setColorValue:[_delegate ColorPickerInitalColorForText:self] forSelectedSegment:0];
        }
        else if(self.backgroundEdit)
        {
            if([_delegate respondsToSelector:@selector(ColorPickerInitalColorForBackground:)])
                [self setColorValue:[_delegate ColorPickerInitalColorForBackground:self] forSelectedSegment:0];
        }
        
        if([_delegate ColorPickerShouldHaveAlphaControl:self])
            [self enableAlpha];
        else
            [self disableAlpha];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setColorValue:(UIColor*)color forSelectedSegment:(NSUInteger)segment
{
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([color CGColor]);
    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(colorSpace);
    
    if(colorSpaceModel == kCGColorSpaceModelMonochrome)
    {
        CGFloat _white = 0.0f, _alpha = 0.0f;
        [color getWhite:&(_white) alpha:&(_alpha)];
        color = [[UIColor alloc] initWithRed:_white green:_white blue:_white alpha:_alpha];
    }

    if(segment == 0)
    {
        [color getHue:&(_textHueValue) saturation:&(_textSaturationValue) brightness:&(_textBrightnessValue) alpha:&(_textAlphaValue)];
        if(segment == self.textBackgroundPicker.selectedSegmentIndex)
        {
            [self.brightness setBrightnessValue:_textBrightnessValue];
            [self.colorDisplay updateDisplayWithColor:color];
            [self.colorDisplay.colorDisplay setNeedsDisplay];
            [self.alphaSlider setAlphaControlValue:_textAlphaValue];
            //[self.wheel setColorValue:color];
        }
    }
    else
    {
        [color getHue:&(_backgroundHueValue) saturation:&(_backgroundSaturationValue) brightness:&(_backgroundBrightnessValue) alpha:&(_backgroundAlphaValue)];
        if(segment == self.textBackgroundPicker.selectedSegmentIndex)
        {
            [self.brightness setBrightnessValue:_backgroundBrightnessValue];
            [self.colorDisplay updateDisplayWithColor:color];
            [self.colorDisplay.colorDisplay setNeedsDisplay];
            [self.alphaSlider setAlphaControlValue:_backgroundAlphaValue];

            //[self.wheel setColorValue:color];
        }
    }
    [self redrawView];
    
}

-(void)redrawView
{
    UIColor* color = [self chosenColor];
    CGFloat hue, sat, bright, alpha;
    [self getCurrentHue:&hue saturation:&sat brightness:&bright andAlphaValues:&alpha];
    [self.brightness setColor:[UIColor colorWithHue:hue saturation:sat brightness:1.0f alpha:alpha]];
    [self.colorDisplay updateDisplayWithColor:color];
    
}

-(void)updateView
{
    UIColor* color = [self chosenColor];
    [self redrawView];
    [self.delegate ColorPicker:self createdNewColor:color withSegmentControlValue:self.textBackgroundPicker.selectedSegmentIndex];
}

-(void)getCurrentHue:(CGFloat*)hue saturation:(CGFloat*)sat brightness:(CGFloat*)brightness andAlphaValues:(CGFloat*)
alpha
{
    if(self.textBackgroundPicker.selectedSegmentIndex == 0)
    {
        *hue = self.textHueValue;
        *sat = self.textSaturationValue;
        *brightness = self.textBrightnessValue;
        *alpha = self.textAlphaValue;
    }
    else
    {
        *hue = self.backgroundHueValue;
        *sat = self.backgroundSaturationValue;
        *brightness = self.backgroundBrightnessValue;
        *alpha = self.backgroundAlphaValue;
    }
}

-(UIColor*)chosenColor
{
    if(self.textBackgroundPicker.selectedSegmentIndex == 0)
        return [UIColor colorWithHue:self.textHueValue saturation:self.textSaturationValue brightness:self.textBrightnessValue alpha:self.textAlphaValue];
    else
        return [UIColor colorWithHue:self.backgroundHueValue saturation:self.backgroundSaturationValue brightness:self.backgroundBrightnessValue alpha:self.backgroundAlphaValue];
}

-(void)newAlphaValue:(CGFloat)alpha
{
    if(self.textBackgroundPicker.selectedSegmentIndex == 0)
        self.textAlphaValue = alpha;
    else
        self.backgroundAlphaValue = alpha;
    [self updateView];
}

-(void)newBrightnessValue:(CGFloat)brightness
{
    if(self.textBackgroundPicker.selectedSegmentIndex == 0)
        self.textBrightnessValue = brightness;
    else
        self.backgroundBrightnessValue = brightness;
    [self updateView];

}

-(void)newHueValue:(CGFloat)hue andSaturationValue:(CGFloat)saturation atPoint:(CGPoint)point
{
    if(self.textBackgroundPicker.selectedSegmentIndex == 0)
    {
        self.textHueValue = hue;
        self.textSaturationValue = saturation;
        self.textSelectorPoint = point;
    }
    else
    {
        self.backgroundHueValue = hue;
        self.backgroundSaturationValue = saturation;
        self.backgroundSelectorPoint = point;
    }
    [self updateView];
}

-(void)displayPressed
{
    
}

- (IBAction)selectorValueChanged:(UISegmentedControl *)sender
{
    if(sender.selectedSegmentIndex == 0)
    {
        [self.wheel setSelectorAtPoint:self.textSelectorPoint];
        [self.alphaSlider setAlphaControlValue:self.textAlphaValue];
        [self.brightness setBrightnessValue:self.textBrightnessValue];
    }
    else
    {
        [self.wheel setSelectorAtPoint:self.backgroundSelectorPoint];
        [self.alphaSlider setAlphaControlValue:self.backgroundAlphaValue];
        [self.brightness setBrightnessValue:self.backgroundBrightnessValue];
    }
    [self updateView];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    for(UIView* subView in self.subviews)
    {
        if([subView isKindOfClass:[ColorDisplay class]]){
            ((ColorDisplay*)subView).delegate = self;
            [((ColorDisplay*)subView)updateDisplayWithColor:[UIColor grayColor]];
        }
        else if([subView isKindOfClass:[BrightnessControl class]]){
            ((BrightnessControl*)subView).delegate = self;
        }
        else if([subView isKindOfClass:[AlphaControl class]]){
            ((AlphaControl*)subView).delegate = self;
        }
        else if([subView isKindOfClass:[ColorWheel class]]){
            ((ColorWheel*)subView).delegate = self;
        }
    }
    
    //set inital values
    self.textBrightnessValue = 0.0f;
    self.textHueValue = 0.0f;
    self.textSaturationValue = 0.0f;
    self.textAlphaValue = 1.0f;

    self.backgroundBrightnessValue = 1.0f;
    self.backgroundHueValue = 0.0f;
    self.backgroundSaturationValue = 0.0f;
    self.backgroundAlphaValue = 1.0f;
    
    UIToolbar* blurView = [[UIToolbar alloc] initWithFrame:self.backgroundView.bounds];
    [blurView setBarStyle:UIBarStyleBlack];
    [blurView setTranslucent:YES];
    
    [self.backgroundView addSubview:blurView];
    
    //rotate close button by 45 degrees
    CGRect oldRect = self.closeButton.bounds;
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_4);
    self.closeButton.transform = transform;
    
    // Repositions and resizes the view.
    self.closeButton.bounds = oldRect;
    self.closed = NO;
}
- (IBAction)closeButtonPressed:(id)sender {
    [self.delegate ColorPickerPressedExitButton:self];
}

-(void)close{
    if(!self.closed)
    {
        self.closed = YES;
        [self.wheel close];
        [UIView animateWithDuration:.5
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseInOut animations:^{
                                [self setAlpha:0.0];
                            }completion:^(BOOL finished){
                                [self removeFromSuperview];
                            }];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.colorDisplay updateDisplayWithColor:[UIColor blackColor]];
    [self.brightness setBrightnessValue:self.textBrightnessValue];
}


-(void)disableAlpha
{
    [self.alphaSlider setAlphaControlValue:1.0f];
    [self.alphaSlider setAlpha:0.0];
}

-(void)enableAlpha
{
    if(self.textBackgroundPicker.selectedSegmentIndex == 0)
        [self.alphaSlider setAlpha:self.textAlphaValue];
    else
        [self.alphaSlider setAlpha:self.backgroundAlphaValue];
    [self.alphaSlider setAlpha:1.0];
}

-(void)setEditingTypeWithText:(BOOL)text andBackground:(BOOL)background
{
    self.textEdit = text;
    self.backgroundEdit = background;
    if(text && background)
    {
        if(self.textBackgroundPicker.numberOfSegments == 1)
        {
            [self.textBackgroundPicker setTitle:@"Text" forSegmentAtIndex:0];
            [self.textBackgroundPicker insertSegmentWithTitle:@"Background" atIndex:1 animated:NO];
        }
        else
        {
            [self.textBackgroundPicker setTitle:@"Text" forSegmentAtIndex:0];
            [self.textBackgroundPicker setTitle:@"Background" forSegmentAtIndex:1];
        }
    }
    else if(text)
    {
        [self.textBackgroundPicker removeSegmentAtIndex:1 animated:NO];
        [self.textBackgroundPicker setTitle:@"Text" forSegmentAtIndex:0];
    }
    else
    {
        [self.textBackgroundPicker removeSegmentAtIndex:1 animated:NO];
        [self.textBackgroundPicker setTitle:@"Background" forSegmentAtIndex:0];
    }
    [self.textBackgroundPicker setSelectedSegmentIndex:0];
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
