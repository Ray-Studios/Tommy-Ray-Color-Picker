//
//  ViewController.m
//  ColorPicker
//
//  Created by Rohan Thomare on 10/1/14.
//  Copyright (c) 2014 TommyRayStudios. All rights reserved.
//

#import "ColorPicker.h"
//#import "testDisplay.h"
#import "ViewController.h"

@interface ViewController () <ColorPickerDelegate>//, testDisplayProtocol>

@property (weak, nonatomic) IBOutlet UIView *background;
@property (nonatomic, strong) ColorPicker* picker;
@property (nonatomic, weak) IBOutlet UILabel* label;
@property (weak, nonatomic) IBOutlet UIButton *revealButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.picker = [ColorPicker colorPickerWithDelegate:self];
    self.picker.center = self.view.center;
    [self.view addSubview:self.picker];
    
//    testDisplay* display = [[testDisplay alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
//    [display setDelegate:self];
//    [self.view addSubview:display];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*-(UIColor*)initalColorForTestDisplay:(testDisplay *)display{
    return [UIColor redColor];
}*/

-(void)hideColorPicker{
    [UIView animateWithDuration:.3f animations:^{
        self.picker.alpha = 0.0f;
    }];
}

-(void)showColorPicker{
    [UIView animateWithDuration:.3f animations:^{
        self.picker.alpha = 1.0f;
    }];
}

-(void)ColorPicker:(ColorPicker*)picker createdNewColor:(UIColor*)color withSegmentControlValue:(NSInteger)selection{
    if(selection == 0){
        [self.label setTextColor:color];
    }
    else{
        [self.background setBackgroundColor:color];
        CGFloat red = 0.0f, green = 0.0f, blue = 0.0f, alpha = 0.0f;
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        UIColor *oppisite = [[UIColor alloc] initWithRed:(1.0f - red) green:(1.0f - green) blue:(1.0f - blue) alpha:1.0f];
        [self.revealButton setTitleColor:oppisite forState:UIControlStateNormal];
        
    }
}

-(IBAction)revealPickerPressed:(id)sender{
    [self showColorPicker];
}

-(void)ColorPickerPressedExitButton:(ColorPicker*)picker{
    [self hideColorPicker];
}

-(BOOL)ColorPickerShouldHaveTextOption:(ColorPicker*)picker{
    return YES;
}

-(BOOL)ColorPickerShouldHaveBackgroundOption:(ColorPicker *)picker{
    return YES;
}

-(BOOL)ColorPickerShouldHaveAlphaControl:(ColorPicker *)picker{
    return YES;
}

-(UIColor*)ColorPickerInitalColorForText:(ColorPicker*)picker{
    return [UIColor redColor];
}

-(UIColor*)ColorPickerInitalColorForBackground:(ColorPicker*)picker{
    return [UIColor whiteColor];
}

@end
