//
//  ColorWheel.m
//  Board Share
//
//  Created by Rohan Thomare on 1/22/14.
//  Copyright (c) 2014 TommyRayStudios. All rights reserved.
//

#import "ColorWheel.h"

@interface ColorWheel()

@property (weak, nonatomic) IBOutlet UIImageView* colorWheel;
@property (weak, nonatomic) IBOutlet UIView* selectorContainer;
@property (weak, nonatomic) IBOutlet UIView* selectorDisplay;

@property CFDataRef pixelData;
@property const UInt8* imgData;

@end


@implementation ColorWheel

@synthesize pixelData = _pixelData;
@synthesize imgData = _imgData;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    //add gesture to tap on color wheel to obtain new hue and saturation
    UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [tapgr setNumberOfTapsRequired:1];
    [self addGestureRecognizer:tapgr];
    
    UIPanGestureRecognizer *pangr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pangr];
    
    //move selector to middle of view
    [self.selectorContainer setCenter:self.center];
    
    self.pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.colorWheel.image.CGImage));
    self.imgData = CFDataGetBytePtr(self.pixelData);
    
}

- (UIColor *)colorAtPoint:(CGPoint)point image:(UIImage *)img getAlpha:(CGFloat*)holder{
    
    CGFloat screenScale = (img.size.height/self.colorWheel.bounds.size.height);
    point.x *= screenScale;
    point.y *= screenScale;
    
    NSInteger x = trunc(point.x);
    NSInteger y = trunc(point.y);
    
    int pixelInfo = ((img.size.width  * y) + x ) * 4;
    
    UInt8 red = self.imgData[pixelInfo];
    UInt8 green = self.imgData[(pixelInfo + 1)];
    UInt8 blue = self.imgData[pixelInfo + 2];
    UInt8 alpha = self.imgData[pixelInfo + 3];
    
    if(holder)
        *holder = (alpha/255.0f);
    
    UIColor* col = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    return col;
    
}

-(void)getHue:(CGFloat *)hue andGetSaturation:(CGFloat *)saturation
{
    UIColor* currentColor = self.selectorDisplay.backgroundColor;
    CGFloat trash = 0;
    CGFloat trash1 = 0;
    [currentColor getHue:hue saturation:saturation brightness:&trash alpha:&trash1];
}

-(void)setSelectorAtPoint:(CGPoint)point
{
    CGFloat alpha = 0;
    UIColor* color = [self colorAtPoint:point image:self.colorWheel.image getAlpha:&alpha];
    if(alpha > 0.0)
    {
        [self.selectorContainer setCenter:point];
        [self.selectorDisplay setBackgroundColor:color];
    }
    else
    {
        [self setSelectorAtPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
    }
}

-(void)setColorAtPointForHue:(CGFloat)hue andSaturation:(CGFloat)saturation;
{
    //center of circle is hue: 1.0 and saturation 0.0
    
    //calculate point on map
    //hue is dependent on angle
    CGFloat maxRadius =self.bounds.size.width/2;
    double angle = hue*(2*M_PI);
    //saturation dependent on radius outward
    CGFloat radius = maxRadius*saturation;
    
    CGFloat xVal = radius * cos(angle);
    CGFloat yVal = radius * sin(angle);
    
    xVal +=maxRadius;
    yVal +=maxRadius;
    
    [self.selectorContainer setCenter:CGPointMake(xVal, yVal)];
}

-(void)pan:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateChanged ||
        recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint center = [recognizer locationInView:recognizer.view];
        
        if(!CGRectContainsPoint(self.colorWheel.bounds,center))
        {
            [recognizer setTranslation:CGPointZero inView:self];
            return;
        }
        CGFloat alpha = 0;
        CGFloat hue = 0;
        CGFloat saturation = 0;
        CGFloat brightness = 0;
        UIColor* color = [self colorAtPoint:center image:self.colorWheel.image getAlpha:&alpha];
        
        
        if(alpha > 0.0)
        {
            [self.selectorContainer setCenter:center];
            [self.selectorDisplay setBackgroundColor:color];
            [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
            [self.delegate newHueValue:hue andSaturationValue:saturation atPoint:center];
        }
        [recognizer setTranslation:CGPointZero inView:self];
        
        
    }
}



-(void)tap:(UITapGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateChanged ||
       recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint tapPoint = [recognizer locationOfTouch:0 inView:self.colorWheel];
        
        CGFloat alpha = 0;
        CGFloat hue = 0;
        CGFloat saturation = 0;
        CGFloat brightness = 0;
        UIColor *newColor =[self colorAtPoint:tapPoint image:self.colorWheel.image getAlpha:&alpha];
        
        if(alpha > 0)
        {
            [self.selectorDisplay setBackgroundColor:newColor];
            [self.selectorContainer setCenter:tapPoint];
            [newColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
            [self.delegate newHueValue:hue andSaturationValue:saturation atPoint:tapPoint];
        }
    }
    
}

-(void)close
{
    if(self.pixelData)
        CFRelease(self.pixelData);
}

-(void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];
}
@end
