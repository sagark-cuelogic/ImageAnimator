//
//  ViewController.m
//  ImageAnimation
//
//  Created by Sagar Kudale on 04/03/14.
//  Copyright (c) 2014 myCompany. All rights reserved.
//

#import "ViewController.h"
#import "ImageAnimationView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    ImageAnimationView *animatorView = [[ImageAnimationView alloc] initWithFrame:CGRectMake(20, 20, 150, 300)];
    
    NSArray *arrImageNames = [ImageAnimationView arrayWithNumberedNames:@"image" rangeStart:1 rangeEnd:16 suffixFormat:@"%i.png"];
    
    animatorView.animationImages = arrImageNames;
    // set animation speed
    animatorView.animationFrameDuration = Animation15FPS;
    
    // set animation repeat count
    animatorView.animationRepeatCount = 10;
    
    [animatorView LoadAnimationData];
    [self.view addSubview:animatorView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animationDidStartNotification) name:AnimationDidStartNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animationDidStopNotification) name:AnimationDidStopNotification object:nil];
    
    [animatorView startAnimating];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ==============================
#pragma mark Nofifications
#pragma mark ==============================

-(void)animationDidStartNotification{
    
}

-(void)animationDidStopNotification{
    
}

@end
