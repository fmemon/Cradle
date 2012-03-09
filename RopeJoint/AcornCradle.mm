//
//  AcornCradle.mm
//  RopeJoint
//
//  Created by Saida Memon on 3/2/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "AcornCradle.h"
#import "InterfaceSounds.h"
#import "SimpleAudioEngine.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32
#define FLOOR_HEIGTH    62.0f
#define FLOOR_HEIGHT    62.0f

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};


// AcornCradle implementation
@implementation AcornCradle

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	AcornCradle *layer = [AcornCradle node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// initialize your instance here
-(id) init
{
	if( (self=[super init])) {
		
		// enable touches
		self.isTouchEnabled = YES;
		
		// enable accelerometer
		self.isAccelerometerEnabled = YES;
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		
		// Define the gravity vector.
		b2Vec2 gravity;
		gravity.Set(0.0f, -10.0f);
		
		// Do we want to let bodies sleep?
		// This will speed up the physics simulation
		bool doSleep = true;
		
		// Construct a world object, which will hold and simulate the rigid bodies.
		world = new b2World(gravity, doSleep);
		world->SetContinuousPhysics(true);	
        
        
        /*
        b2Body *_titleBody; 
        b2BodyDef _titleBodyDef;
        CCSprite *sprite;
        b2Fixture *_titleFixture;
        b2FixtureDef _titleShapeDef;
        b2BodyDef anchorBodyDef;
        b2CircleShape _circle;
        b2RopeJointDef jd;
        anchors = [[NSMutableArray alloc] initWithCapacity:2];
        
        sprite = [CCSprite spriteWithFile:@"acorn.png"];
        [self addChild:sprite z:1];
        
        _titleBodyDef.type = b2_dynamicBody;
        _titleBodyDef.position.Set((160.0f)/PTM_RATIO, 225/PTM_RATIO);
        _titleBodyDef.userData = sprite;
        _titleBody = world->CreateBody(&_titleBodyDef);
        
        _circle.m_radius = 18.0/PTM_RATIO;
        
        
        _titleShapeDef.shape = &_circle;
        _titleShapeDef.density = 1.0f;
        _titleShapeDef.friction = 0.2f;
        _titleShapeDef.restitution = 0.0f;
        _titleFixture = _titleBody->CreateFixture(&_titleShapeDef);
        [anchors addObject:[NSValue valueWithPointer:_titleBody]];
        
        
        // +++ Add anchor body
        anchorBodyDef.position.Set((160.0f)/PTM_RATIO, 400/PTM_RATIO); //center body on screen
        anchorBody = world->CreateBody(&anchorBodyDef);
        // +++ Add rope spritesheet to layer
        ropeSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"rope.png" ];
        [self addChild:ropeSpriteSheet];
        // +++ Init array that will hold references to all our ropes
        vRopes = [[NSMutableArray alloc] init];
        
        // +++ Create box2d joint
        jd.bodyA=anchorBody; //define bodies
        jd.bodyB=_titleBody;
        jd.localAnchorA = b2Vec2(0,0); //define anchors
        jd.localAnchorB = b2Vec2(0,0);
        jd.maxLength= (_titleBody->GetPosition() - anchorBody->GetPosition()).Length(); //define max length of joint = current distance between bodies
        world->CreateJoint(&jd); //create joint
        // +++ Create VRope
        VRope *newRope = [[VRope alloc] init:anchorBody body2:_titleBody spriteSheet:ropeSpriteSheet];
        [vRopes addObject:newRope];
        
        
        CCSprite* sprite1 = [CCSprite spriteWithFile:@"acorn.png"];
        [self addChild:sprite1 z:1];
        
        b2BodyDef _titleBodyDef1;
        _titleBodyDef1.type = b2_dynamicBody;
        _titleBodyDef1.position.Set((160.0f + 50.0f)/PTM_RATIO, 225/PTM_RATIO);
        _titleBodyDef1.userData = sprite1;
        b2Body * _titleBody1 = world->CreateBody(&_titleBodyDef1);
        
        b2CircleShape _circle1;
        _circle.m_radius = 18.0/PTM_RATIO;
        
        b2FixtureDef _titleShapeDef1;
        _titleShapeDef1.shape = &_circle1;
        _titleShapeDef1.density = 1.0f;
        _titleShapeDef1.friction = 0.2f;
        _titleShapeDef1.restitution = 0.0f;
        b2Fixture *_titleFixture1;
        _titleFixture1 = _titleBody->CreateFixture(&_titleShapeDef1);
        [anchors addObject:[NSValue valueWithPointer:_titleBody1]];
        
        
        // +++ Add anchor body
        anchorBodyDef.position.Set((160.0f + 50.0f)/PTM_RATIO, 400/PTM_RATIO); //center body on screen
        anchorBody = world->CreateBody(&anchorBodyDef);
        // +++ Add rope spritesheet to layer
        ropeSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"rope.png" ];
        [self addChild:ropeSpriteSheet];
        // +++ Init array that will hold references to all our ropes
        vRopes = [[NSMutableArray alloc] init];
        
        // +++ Create box2d joint
        b2RopeJointDef jd1;

        jd1.bodyA=anchorBody; //define bodies
        jd1.bodyB=_titleBody1;
        jd1.localAnchorA = b2Vec2(0,0); //define anchors
        jd1.localAnchorB = b2Vec2(0,0);
        jd1.maxLength= (_titleBody1->GetPosition() - anchorBody->GetPosition()).Length(); //define max length of joint = current distance between bodies
        world->CreateJoint(&jd1); //create joint
        // +++ Create VRope
        VRope *newRope1 = [[VRope alloc] init:anchorBody body2:_titleBody1 spriteSheet:ropeSpriteSheet];
        [vRopes addObject:newRope1];
        
        
        
        bulletBody2 = (b2Body*)[[anchors objectAtIndex:0] pointerValue];

        b2Vec2 force = b2Vec2(10, 10);
        bulletBody2->ApplyLinearImpulse(force, _titleBodyDef.position);
        */

		[self addNewSpriteWithCoords: CGPointMake(160.0f, 240.0f)];
		[self addNewSpriteWithCoords: CGPointMake(200.0f, 240.0f)];
		[self addNewSpriteWithCoords: CGPointMake(240.0f, 240.0f)];
		[self addNewSpriteWithCoords: CGPointMake(280.0f, 240.0f)];

        
		[self schedule: @selector(tick:)];
	}
	return self;
}


-(void) addNewSpriteWithCoords:(CGPoint)p
{
	
    CCSprite* sprite = [CCSprite spriteWithFile:@"acorn.png"];
    [self addChild:sprite z:1];
	
	sprite.position = ccp( p.x, p.y);
    // +++ Add anchor body
    b2BodyDef anchorBodyDef;
    anchorBodyDef.position.Set(p.x/PTM_RATIO, (p.y+50.0f)/PTM_RATIO);    anchorBody = world->CreateBody(&anchorBodyDef);
    
    
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = sprite;
	b2Body *body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	body->CreateFixture(&fixtureDef);
	
	// +++ Create box2d joint
	b2RopeJointDef jd;
	jd.bodyA=anchorBody; //define bodies
	jd.bodyB=body;
	jd.localAnchorA = b2Vec2(0,0); //define anchors
	jd.localAnchorB = b2Vec2(0,0);
	jd.maxLength= (body->GetPosition() - anchorBody->GetPosition()).Length(); //define max length of joint = current distance between bodies
	world->CreateJoint(&jd); //create joint
	// +++ Create VRope with two b2bodies and pointer to spritesheet
	VRope *newRope = [[VRope alloc] init:anchorBody body2:body spriteSheet:ropeSpriteSheet];
	[vRopes addObject:newRope];
}


-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	// +++ Update rope sprites
	for(uint i=0;i<[vRopes count];i++) {
		[[vRopes objectAtIndex:i] updateSprites];
	}
	
}


-(void) tick: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
    
	
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}
    
	
	// +++ Update rope physics
	for(uint i=0;i<[vRopes count];i++) {
		[[vRopes objectAtIndex:i] update:dt];
	}
	
}



- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (mouseJoint != nil) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    bulletBody = (b2Body*)[[anchors objectAtIndex:0] pointerValue];
    bulletBody2 = (b2Body*)[[anchors lastObject] pointerValue];
    
    if (locationWorld.x > bulletBody2->GetWorldCenter().x - 50.0/PTM_RATIO)
    {
        b2MouseJointDef md;
        md.bodyA = groundBody;
        md.bodyB = bulletBody2;
        md.target = locationWorld;
        md.maxForce = 2000;
        
        mouseJoint = (b2MouseJoint *)world->CreateJoint(&md);
    }
    else if (locationWorld.x < bulletBody->GetWorldCenter().x + 50.0/PTM_RATIO)
    {
        b2MouseJointDef md;
        md.bodyA = groundBody;
        md.bodyB = bulletBody;
        md.target = locationWorld;
        md.maxForce = 2000;
        
        mouseJoint = (b2MouseJoint *)world->CreateJoint(&md);
    }
    [[SimpleAudioEngine sharedEngine] playEffect: @"wood.wav"];
    
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (mouseJoint == nil) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    mouseJoint->SetTarget(locationWorld);
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (mouseJoint != nil)
    {
        world->DestroyJoint(mouseJoint);
        mouseJoint = nil;
    }
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	
	delete m_debugDraw;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
