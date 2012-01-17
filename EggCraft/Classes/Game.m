//
//  Game
//  EggCraft
//
//  Created by Holger Weissboeck on 12.01.12.
//  Copyright 2011 Gamua. All rights reserved.
//

#import "Game.h"

@implementation Game
{

@private
	SPImage *mBackground;
	SPImage *mBasket;
	NSMutableArray *mEggs;

	float mTotalTime;
	float mCreationTimeOfLastEgg;
	float mEggCreationInterval;
}

- (id)init
{
	if((self = [super init]))
	{
		//loads the background texture and adds it as a child
		mBackground = [[SPImage alloc] initWithContentsOfFile:@"background.png"];
		[self addChild:mBackground];

		//loads the basket, positions in the middle of the ground,
		//adds a touch listener and adds it as a child
		mBasket = [[SPImage alloc] initWithContentsOfFile:@"basket.png"];
		mBasket.pivotX = mBasket.width/2;
		mBasket.pivotY = mBasket.height/2;
		mBasket.x = mBackground.width/2 - mBasket.width/2;
		mBasket.y = mBackground.height - mBasket.height;
		[mBasket addEventListener:@selector(onBasketTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
		[self addChild:mBasket];

		//initializes the management array for the falling eggs
		//as well as some informational floats
		mEggs = [[NSMutableArray alloc] init];
		mTotalTime = 0;
		mCreationTimeOfLastEgg = 0;
		mEggCreationInterval = 1;

		//adds an enter frame listener for the following purposes:
		//* let the eggs fall
		//* check for collisions
		//* create new eggs
		[self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
	}
	return self;
}

- (void)dealloc
{
	//event listeners must be removed in the dealloc phase
	[self removeEventListenersAtObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
	[mBasket removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TOUCH];

	[mBasket release];
	[mEggs release];
	[mBackground release];

	[super dealloc];
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event
{
	float passedTime = (float)event.passedTime;
	float fallingSpeed = 100 + 5*mTotalTime;
	float fallingDistance = fallingSpeed*passedTime;

	for (SPImage *egg in [[mEggs copy] autorelease])
	{
		//move and rotate the egg
		egg.y += fallingDistance;
		egg.rotation += passedTime;

		//check for collisions with the ground and the basket
		BOOL didBreak = egg.y >= mBackground.height - egg.height/2;
		BOOL didGetCaught = [mBasket.bounds intersectsRectangle:egg.bounds];
		if(didBreak)
		{
			//break the egg: replace the egg with a yolk texture
			SPImage *yolk = [SPImage imageWithContentsOfFile:@"yolk.png"];
			yolk.pivotX = yolk.width/2;
			yolk.pivotY = yolk.height/2;
			yolk.x = egg.x;
			yolk.y = egg.y;
			[self addChild:yolk];

			//animate the yolk
			SPTween *tween = [SPTween tweenWithTarget:yolk time:1];
			[tween animateProperty:@"y" targetValue:yolk.y + yolk.height];
			[tween animateProperty:@"height" targetValue:2*yolk.height];
			[tween animateProperty:@"alpha" targetValue:0];
			[self.stage.juggler addObject:tween];

			[self removeChild:egg];
			[mEggs removeObject:egg];
		}
		else if(didGetCaught)
		{
			//remove the egg
			[self removeChild:egg];
			[mEggs removeObject:egg];
		}
	}

	//creates new eggs and
	//positions them right above the visible screen
	//but randomly distributed on the x-axis
	mTotalTime += passedTime;
	if(mTotalTime - mCreationTimeOfLastEgg >= mEggCreationInterval)
	{
		SPImage *egg = [SPImage imageWithContentsOfFile:@"egg.png"];
		egg.pivotX = egg.width/2;
		egg.pivotY = egg.height/2;
		egg.y = -egg.height;
		egg.x = arc4random()%((int)mBackground.width);
		[self addChild:egg];
		[mEggs addObject:egg];
		
		mCreationTimeOfLastEgg = mTotalTime;
	}
}

- (void)onBasketTouched:(SPTouchEvent *)event
{
	SPTouch *touch = [[event.touches allObjects] objectAtIndex:0];
	SPPoint *localTouchPosition = [touch locationInSpace:self];
	mBasket.x = localTouchPosition.x;
}

@end