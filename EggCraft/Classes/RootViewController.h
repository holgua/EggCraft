//
//  RootViewController
//  EggCraft
//
//  Created by Holger Weissboeck on 18.11.11.
//  Copyright 2011 Gamua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RootViewControllerStageSetupCompletionHandler)(SPStage *stage, NSError *error);

@interface RootViewController : UIViewController
{

@private
	CGRect mViewBounds;
	CGSize mStageSize;
	BOOL mSupportHighResolutions;
	float mContentScaleFactor;
	BOOL mMultipleTouchEnabled;
	float mFrameRate;

	UIWindow *mWindow;
	SPView *mSparrowView;

}

@property (nonatomic, readonly) UIWindow *window;
@property (nonatomic, readonly) SPView *sparrowView;

- (id)initWithMultipleTouchEnabled:(BOOL)multipleTouchEnabled frameRate:(float)frameRate;

- (id)initWithViewBounds:(CGRect)viewBounds stageSize:(CGSize)stageSize supportHighResolutions:(BOOL)supportHighResolutions contentScaleFactor:(float)contentScaleFactor multipleTouchEnabled:(BOOL)multipleTouchEnabled frameRate:(float)frameRate;

- (void)setupStageWithCompletionHandler:(RootViewControllerStageSetupCompletionHandler)completionHandler;

@end