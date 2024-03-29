//
//  HelloWorldLayer.h
//  RopeJoint
//
//  Created by Saida Memon on 3/2/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "VRope.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
	// +++
	b2Body* anchorBody; //reference to anchor body
	CCSpriteBatchNode* ropeSpriteSheet; //sprite sheet for rope segment
	NSMutableArray* vRopes; //array to hold rope references
	
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

// adds a new sprite at a given coordinate
-(void) addNewSpriteWithCoords:(CGPoint)p;

@end
