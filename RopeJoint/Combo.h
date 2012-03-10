//
//  ComboScene.h
//  verletRopeTestProject
//
//  Created by patrick on 29/10/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "VRope.h"

// Combo Layer
@interface Combo : CCLayer
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
	// +++
	b2Body* anchorBody; //reference to anchor body
	CCSpriteBatchNode* ropeSpriteSheet; //sprite sheet for rope segment
	NSMutableArray* vRopes; //array to hold rope references
    b2BodyDef anchorBodyDef;
    
    NSMutableArray *anchors;
    
    b2MouseJoint *mouseJoint;
	b2Body* bulletBody;
    b2Body* bulletBody2; //reference to anchor body
    b2Body *groundBody;
    
    
    b2Fixture *armFixture;
    b2Body *armBody;
    b2RevoluteJoint *armJoint;
    b2WeldJoint *bulletJoint;
    b2MouseJoint *_mouseJoint;
    
    //Breakout
    b2Fixture *_bottomFixture;
    b2Fixture *_ballFixture;
    
    b2Body *_paddleBody;
    b2Fixture *_paddleFixture;
    b2Body * ballBody;
    
    b2BodyDef bodyDef;
    b2CircleShape dynamicBox;
    b2FixtureDef fixtureDef;
    b2RopeJointDef jd;
    b2Body *body;
    VRope *newRope;
    CCSprite *sprite;
}

// returns a Scene that contains the Combo as the only child
+(id) scene;

// adds a new sprite at a given coordinate
-(void) addNewSpriteWithCoords:(CGPoint)p;

@end
