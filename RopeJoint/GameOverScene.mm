//
//  GameOverScene.m
//  Cocos2DSimpleGame
//
//  Created by Ray Wenderlich on 2/10/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "GameOverScene.h"
#import "ComboSeeMe.h"

@implementation GameOverScene
@synthesize layer = _layer;

- (id)init {

	if ((self = [super init])) {
		self.layer = [GameOverLayer node];
		[self addChild:_layer];
	}
	return self;
}

- (void)dealloc {
	[_layer release];
	_layer = nil;
	[super dealloc];
}

@end

@implementation GameOverLayer
@synthesize label = _label;

-(id) init
{
	if( (self=[super init] )) {
		
		
        CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"Please work" fontName:@"Arial" fontSize:32];
        label2.position = ccp(240.0f, 240.0f);
        [self addChild:label2];
        
		[self runAction:[CCSequence actions:
						 [CCDelayTime actionWithDuration:3],
						 [CCCallFunc actionWithTarget:self selector:@selector(gameOverDone)],
						 nil]];
        
        
		
	}	
	return self;
}

- (void)gameOverDone {

	[[CCDirector sharedDirector] replaceScene:[ComboSeeMe scene]];
	
}

- (void)dealloc {
	[_label release];
	_label = nil;
	[super dealloc];
}

@end
