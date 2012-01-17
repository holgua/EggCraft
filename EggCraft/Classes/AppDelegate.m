//
//  AppDelegate.m
//  EggCraft
//
//  Created by Holger Weissboeck on 12.01.12.
//  Copyright (c) 2012 Gamua. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "Game.h"

@implementation AppDelegate
{

@private
	RootViewController *mRootViewController;

}

- (void)dealloc
{
	[mRootViewController release];
	[super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	SP_CREATE_POOL(pool);

	//Make use of a root view controller, which became mandatory in iOS5. The completion handler
	//allows us to separate the view controller setup from the game.
	mRootViewController = [[RootViewController alloc] initWithMultipleTouchEnabled:false frameRate:60];
	[mRootViewController setupStageWithCompletionHandler:^(SPStage *stage, NSError *error) {
		//Create the game class, rotate it to landscape mode
		//and add it to the stage.
		Game *game = [[[Game alloc] init] autorelease];
		game.rotation = PI_HALF;
		game.x = stage.width;
		[stage addChild:game];
	}];

	SP_RELEASE_POOL(pool);
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

@end
