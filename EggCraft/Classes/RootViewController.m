//
//  RootViewController
//  EggCraft
//
//  Created by Holger Weissboeck on 18.11.11.
//  Copyright 2011 Gamua. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

@synthesize sparrowView = mSparrowView;
@synthesize window = mWindow;

- (id)initWithViewBounds:(CGRect)viewBounds stageSize:(CGSize)stageSize supportHighResolutions:(BOOL)supportHighResolutions contentScaleFactor:(float)contentScaleFactor multipleTouchEnabled:(BOOL)multipleTouchEnabled frameRate:(float)frameRate
{
	self = [super init];
	if(self)
	{
		mViewBounds = viewBounds;
		mStageSize = stageSize;
		mSupportHighResolutions = supportHighResolutions;
		mContentScaleFactor = contentScaleFactor;
		mMultipleTouchEnabled = multipleTouchEnabled;
		mFrameRate = frameRate;
	}
	return self;
}

- (id)initWithMultipleTouchEnabled:(BOOL)multipleTouchEnabled frameRate:(float)frameRate
{
	CGRect viewBounds = [UIScreen mainScreen].bounds;
	CGSize stageSize = CGSizeMake(viewBounds.size.width, viewBounds.size.height);
	BOOL supportHighResolutions = YES;
	float contentScaleFactor = 1;
	return [self initWithViewBounds:viewBounds stageSize:stageSize supportHighResolutions:supportHighResolutions contentScaleFactor:contentScaleFactor multipleTouchEnabled:multipleTouchEnabled frameRate:frameRate];
}

- (void)dealloc
{
	[mWindow release];
	[mSparrowView release];
	[super dealloc];
}

- (void)setupStageWithCompletionHandler:(RootViewControllerStageSetupCompletionHandler)completionHandler
{
	//init root view
	mWindow = [[UIWindow alloc] initWithFrame:mViewBounds];
	self.view = mWindow;

	//init sparrow view
	mSparrowView = [[SPView alloc] initWithFrame:mViewBounds];
	[mSparrowView setMultipleTouchEnabled:mMultipleTouchEnabled];
	[mSparrowView setFrameRate:mFrameRate];
	[mWindow addSubview:mSparrowView];

	//init stage environment
	[SPStage setSupportHighResolutions:mSupportHighResolutions];
	[SPStage setContentScaleFactor:mContentScaleFactor];

	//create sparrow stage
	SPStage *sparrowStage = [[[SPStage alloc] initWithWidth:mStageSize.width height:mStageSize.height] autorelease];
	[mSparrowView setStage:sparrowStage];

	//let the app hook itself into the stage
	if(completionHandler)
	{
		completionHandler(sparrowStage, nil);
	}

	//gentlemen, start your engines
	mWindow.rootViewController = [[[UIViewController alloc] init] autorelease];
	[mWindow makeKeyAndVisible];
	[mWindow bringSubviewToFront:mSparrowView];
	[mSparrowView start];

	//print some info about the current setup
	NSLog(@"Setup: Window size is width=%d, height=%d.", (int)mWindow.frame.size.width, (int)mWindow.frame.size.height);
	NSLog(@"Setup: Sparrow view size is width=%d, height=%d.", (int)mSparrowView.frame.size.width, (int)mSparrowView.frame.size.height);
	NSLog(@"Setup: Sparrow stage size is width=%d, height=%d.", (int)sparrowStage.width, (int)sparrowStage.height);
	NSLog(@"Setup: Sparrow content scale factor is %d.", (int)mContentScaleFactor);
	NSLog(@"Setup: Sparrow framerate is %d.", (int)mFrameRate);
	NSLog(@"Setup: Sparrow support for high resolutions is set to %@.", mSupportHighResolutions ? @"YES" : @"NO");
	NSLog(@"Setup: Sparrow multitouch enabled is set to %@.", mMultipleTouchEnabled ? @"YES" : @"NO");
}

@end