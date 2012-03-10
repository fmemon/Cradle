//
//  ComboSeeMe.h
//  CompoundBody
//
//  Created by Saida Memon on 3/8/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "VRope.h"

// ComboSeeMe
@interface ComboSeeMe : CCLayer
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    
    b2RopeJointDef jd;
    b2Body *body;
    CCSprite *sprite;
    NSMutableArray* vRopes; //array to hold rope references
    b2Body* circle2;
    b2MouseJoint *mouseJoint;
    b2BodyDef bodyDef1;
    b2BodyDef bodyDef;
    CCSpriteBatchNode* ropeSpriteSheet; //sprite sheet for rope segment

//Call it Ball and Chain    
    
    
   //Breakout
    b2Fixture *_bottomFixture;
    b2Fixture *_ballFixture;
    
    b2Body *_paddleBody;
    b2Fixture *_paddleFixture;
    b2Body * ballBody;
    
    b2CircleShape dynamicBox;
    b2FixtureDef fixtureDef;
    b2MouseJoint *_mouseJoint;

 /*   
    
    //NewCradle
    b2Body* anchorBody; //reference to anchor body
	CCSpriteBatchNode* ropeSpriteSheet; //sprite sheet for rope segment
    b2BodyDef anchorBodyDef;
    
    NSMutableArray *anchors;
    
	b2Body* bulletBody;
    b2Body* bulletBody2; //reference to anchor body
    b2Body *groundBody;
    
    
    b2Fixture *armFixture;
    b2Body *armBody;
    b2RevoluteJoint *armJoint;
    b2WeldJoint *bulletJoint;
    b2MouseJoint *_mouseJoint;
*/
    //2 circles
    b2Body* anchorBody; //reference to anchor body

    
}

// returns a CCScene that contains the ComboSeeMe as the only child
+(CCScene *) scene;
//-(void) addNewSpriteWithCoords:(CGPoint)p;


@end
