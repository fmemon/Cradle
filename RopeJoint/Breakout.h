//
//  Breakout.h
//  Breakout
//
//  Created by Saida Memon on 3/3/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "VRope.h"
#import "MyContactListener.h"

// Breakout
@interface Breakout : CCLayer
{
    b2World *_world;
    b2Body *_groundBody;
    b2Fixture *_bottomFixture;
    b2Fixture *_ballFixture;
    
    b2Body *_paddleBody;
    b2Fixture *_paddleFixture;
    
    b2MouseJoint *_mouseJoint;
    
    
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
    MyContactListener *contactListener;
}

// returns a CCScene that contains the Breakout as the only child
+(CCScene *) scene;
//- (void)createRope;
-(void) addNewSpriteWithCoords:(CGPoint)p;

@end
