//
//  AcornCradle.h
//  RopeJoint
//
//  Created by Saida Memon on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef RopeJoint_AcornCradle_h
#define RopeJoint_AcornCradle_h



#endif
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "VRope.h"

// HelloWorldLayer
@interface AcornCradle : CCLayer
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
	// +++
    
    
	b2Body* anchorBody; //reference to anchor body
	CCSpriteBatchNode* ropeSpriteSheet; //sprite sheet for rope segment
	NSMutableArray* vRopes; //array to hold rope references
	
    
    NSMutableArray *anchors;
	b2Body* bulletBody; //reference to anchor body
	b2Body* anchorBody2; //reference to anchor body
    b2BodyDef anchorBodyDef2;
    
    b2MouseJoint *mouseJoint;
	b2Body* bulletBody2; //reference to anchor body
    b2Body *groundBody;
    
    
    b2Fixture *armFixture;
    b2Body *armBody;
    b2RevoluteJoint *armJoint;
    b2WeldJoint *bulletJoint;
    
    
    b2Body *moving_rec;
    
    
    
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

// adds a new sprite at a given coordinate
-(void) addNewSpriteWithCoords:(CGPoint)p;

@end
