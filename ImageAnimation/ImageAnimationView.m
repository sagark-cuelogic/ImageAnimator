//
//  ImageAnimationView.m
//  ImageAnimation
//
//  Created by Sagar Kudale on 04/03/14.
//  Copyright (c) 2014 myCompany. All rights reserved.
//

#import "ImageAnimationView.h"

@implementation ImageAnimationView

@synthesize animationRepeatCount;
@synthesize animationImages;
@synthesize animationFrameDuration;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark -
#pragma mark ==============================
#pragma mark Public methods
#pragma mark ==============================

- (void) LoadAnimationData{
    // Animation data should have already been loaded into memory as a result of
	// setting the animationImages property
    int numFrames = [animationImages count];
	self->animationNumFrames = numFrames;
    
	NSAssert(animationImages, @"animationImages was not defined");
	NSAssert([animationImages count] > 1, @"animationURLs must include at least 2 urls");
	NSAssert(animationFrameDuration, @"animationFrameDuration was not defined");
    
	// Load animationData by reading from animationImages
	NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithCapacity:[animationImages count]];
    
	NSMutableArray *muArray = [NSMutableArray arrayWithCapacity:[animationImages count]];
	for ( NSString* iName in animationImages ) {
		UIImage *dataForKey = [dataDict objectForKey:iName];
        
		if (dataForKey == nil) {
			dataForKey = [UIImage imageNamed:iName];
			NSAssert(dataForKey, @"dataForKey");
			
			[dataDict setObject:dataForKey forKey:iName];
		}
        
		[muArray addObject:dataForKey];
	}
	animationData = [NSArray arrayWithArray:muArray];
    
    [self loadView];
}
- (void) startAnimating{
    animationTimer = [NSTimer timerWithTimeInterval: animationFrameDuration
                                                  target: self
                                                selector: @selector(animationTimerCallback:)
                                                userInfo: NULL
                                                 repeats: TRUE];
    
    [[NSRunLoop currentRunLoop] addTimer: animationTimer forMode: NSDefaultRunLoopMode];
    
	animationStep = 0;
    
	// Send notification to object(s) that regestered interest in a start action
    
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:AnimationDidStartNotification
	 object:self];
}

// Invoke this method to stop the animation, note that this method must not
// invoke other methods and it must cancel any pending callbacks since
// it could be invoked in a low-memory situation or when the object
// is being deallocated. Invoking this method will not generate a
// animation stopped notification, that callback is only invoked when
// the animation reaches the end normally.

- (void) stopAnimating{
    if (![self isAnimating])
		return;
    
	[animationTimer invalidate];
	animationTimer = nil;
    
	animationStep = animationNumFrames - 1;
	[self animationShowFrame: animationStep];
    
	// Send notification to object(s) that regestered interest in a stop action
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:AnimationDidStopNotification
	 object:self];
}
- (BOOL) isAnimating{
    return (animationTimer != nil);
}

// Create an array of file/resource names with the given filename prefix
+ (NSArray*) arrayWithNumberedNames:(NSString*)filenamePrefix
						 rangeStart:(NSInteger)rangeStart
						   rangeEnd:(NSInteger)rangeEnd
					   suffixFormat:(NSString*)suffixFormat{
    
    NSMutableArray *numberedNames = [[NSMutableArray alloc] initWithCapacity:40];
    
	for (int i = rangeStart; i <= rangeEnd; i++) {
		NSString *suffix = [NSString stringWithFormat:suffixFormat, i];
		NSString *filename = [NSString stringWithFormat:@"%@%@", filenamePrefix, suffix];
        
		[numberedNames addObject:filename];
	}
    
	NSArray *newArray = [NSArray arrayWithArray:numberedNames];
	return newArray;
    
}

#pragma mark -
#pragma mark ==============================
#pragma mark Private methods
#pragma mark ==============================

// Implement loadView to create a view hierarchy programmatically, without using a nib.

- (void)loadView {
   
	// Foreground animation images
    if (imageView != nil) {
        [imageView removeFromSuperview];
    }
	UIImageView *myImageView = [[UIImageView alloc] initWithFrame:self.frame];
	imageView = myImageView;
    [self addSubview:imageView];
    
	// Display first frame of image animation
    
	animationStep = 0;
	[self animationShowFrame: animationStep];
	animationStep = animationStep + 1;
}
/*
 Display the given animation frame, in the range [1 to N]
 where N is the largest frame number.
*/
- (void) animationShowFrame: (NSInteger) frame {
	if ((frame >= animationNumFrames) || (frame < 0))
		return;
    
    UIImage *img = [animationData objectAtIndex:frame];
	imageView.image = img;
}


// Invoked at framerate interval to implement the animation

- (void) animationTimerCallback: (NSTimer *)timer {
	if (![self isAnimating])
		return;
    
	NSUInteger frameNow = 0;

    animationStep += 1;
    frameNow = animationStep;
	
    
	// Limit the range of frameNow to [0, SIZE-1]
	if (frameNow >= animationNumFrames) {
		frameNow = animationNumFrames - 1;
	}
    
	[self animationShowFrame: frameNow];
    
	if (animationStep >= animationNumFrames) {
		[self stopAnimating];
        
		// Continue to loop animation until loop counter reaches 0
		if (animationRepeatCount > 0) {
			animationRepeatCount = animationRepeatCount - 1;
			[self startAnimating];
		}
	}
}

@end
