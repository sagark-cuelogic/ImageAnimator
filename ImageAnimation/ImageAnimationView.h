//
//  ImageAnimationView.h
//  ImageAnimation
//
//  Created by Sagar Kudale on 04/03/14.
//  Copyright (c) 2014 myCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

// frame rate
#define Animation40FPS (1.0/40)
#define Animation30FPS (1.0/30)
#define Animation25FPS (1.0/25)
#define Animation20FPS (1.0/20)
#define Animation15FPS (1.0/15)
#define Animation10FPS (1.0/10)


// Notification
#define AnimationDidStartNotification @"AnimationDidStartNotification"
#define AnimationDidStopNotification @"AnimationDidStopNotification"


@interface ImageAnimationView : UIView{

@public

    NSArray *animationImages;   // stores animation image/resource names
    NSTimeInterval animationFrameDuration; //
    NSInteger animationRepeatCount; // repeate count for animation
    
@private
	
	UIImageView *imageView;
	NSArray *animationData;
	NSTimer *animationTimer;
    NSInteger animationNumFrames;
	NSInteger currentAnimationFrame;
    NSInteger animationStep;
}

@property(nonatomic,strong)NSArray *animationImages;
@property(nonatomic,assign)NSTimeInterval animationFrameDuration;
@property(nonatomic,assign)NSInteger animationRepeatCount;

- (id)initWithFrame:(CGRect)frame;

/*
 * Loads image data before starting animation
 */
- (void) LoadAnimationData;

// starts image animation
- (void) startAnimating;

// stops image animation
- (void) stopAnimating;

// returns true if animating.
- (BOOL) isAnimating;

/*
 Create an array of file/resource names with the given filename prefix,
 the file names will have an integer appended in the range indicated
 by the rangeStart and rangeEnd arguments. The suffixFormat argument
 is a format string like "%02i.png", it must format an integer value
 into a string that is appended to the file/resource string.

 For example: [createNumberedNames:@"Image" rangeStart:1 rangeEnd:3 rangeFormat:@"%02i.png"]

 returns: {"Image01.png", "Image02.png", "Image03.png"}
 */

+ (NSArray*) arrayWithNumberedNames:(NSString*)filenamePrefix
						 rangeStart:(NSInteger)rangeStart
						   rangeEnd:(NSInteger)rangeEnd
					   suffixFormat:(NSString*)suffixFormat;
@end
