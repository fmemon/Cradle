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

+(id) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	// 'layer' is an autorelease object.
	GameOverScene *layer = [GameOverScene node];
    
	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init] )) {
        CCSprite *sprite2 = [CCSprite spriteWithFile:@"bg.png"];
        sprite2.anchorPoint = CGPointZero;
        [self addChild:sprite2 z:-11];
        
        winner1 = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:32];
        winner1.position = ccp(240.0f, 240.0f);
        winner1.color = ccc3(26, 46, 149);
        [self addChild:winner1];
        
        [self restoreData];

        CCLabelTTF* label2 = [CCLabelTTF labelWithString:@"Tap to Restart"
                                                fontName:@"Marker Felt"
                                                fontSize:35];
		label2.position = ccp(240, 131.67f);        
		[self addChild: label2];
        
        // Enable touches
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	}	
	return self;
}

- (void)showScores {

}


- (void)restoreData {
    
    // Get the stored data before the view loads
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
    if ([defaults integerForKey:@"HS1"]) {
        [winner1 setString:[NSString stringWithFormat:@"HighScore: %i",[defaults integerForKey:@"HS1"]]];
    }
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [[CCDirector sharedDirector] replaceScene:[ComboSeeMe scene]];
    return YES;
}


- (void)dealloc {
	[super dealloc];
}

@end
