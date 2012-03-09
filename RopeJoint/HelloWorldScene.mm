//
//  HelloWorldScene.mm
//  verletRopeTestProject
//
//  Created by patrick on 29/10/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


// Import the interfaces
#import "HelloWorldScene.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};


// HelloWorld implementation
@implementation HelloWorld

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
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
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
		
		// Define the gravity vector.
		b2Vec2 gravity;
		gravity.Set(0.0f, -10.0f);
		
		// Do we want to let bodies sleep?
		// This will speed up the physics simulation
		bool doSleep = true;
		
		// Construct a world object, which will hold and simulate the rigid bodies.
		world = new b2World(gravity, doSleep);
		
		world->SetContinuousPhysics(true);
		
		// Debug Draw functions
		m_debugDraw = new GLESDebugDraw( PTM_RATIO );
		world->SetDebugDraw(m_debugDraw);
		
		uint32 flags = 0;
		flags += b2DebugDraw::e_shapeBit;
//		flags += b2DebugDraw::e_jointBit;
//		flags += b2DebugDraw::e_aabbBit;
//		flags += b2DebugDraw::e_pairBit;
//		flags += b2DebugDraw::e_centerOfMassBit;
		m_debugDraw->SetFlags(flags);		
		
		
		// Define the ground body.
		b2BodyDef groundBodyDef;
		groundBodyDef.position.Set(0, 0); // bottom-left corner
		

		// +++ Add anchor body
		b2BodyDef anchorBodyDef;
		anchorBodyDef.position.Set(screenSize.width/PTM_RATIO/2,screenSize.height/PTM_RATIO*0.7f); //center body on screen
		anchorBody = world->CreateBody(&anchorBodyDef);
		// +++ Add rope spritesheet to layer
		ropeSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"rope.png" ];
		[self addChild:ropeSpriteSheet];
		// +++ Init array that will hold references to all our ropes
		vRopes = [[NSMutableArray alloc] init];
		
		
		//Set up sprite
		
		CCSpriteBatchNode *batch = [CCSpriteBatchNode batchNodeWithFile:@"blocks.png" capacity:150];
		[self addChild:batch z:0 tag:kTagBatchNode];
		
		[self addNewSpriteWithCoords:ccp(screenSize.width/2, screenSize.height/2)];
		
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tap screen" fontName:@"Marker Felt" fontSize:32];
		[self addChild:label z:0];
		[label setColor:ccc3(0,0,255)];
		label.position = ccp( screenSize.width/2, screenSize.height-50);
		
		[self schedule: @selector(tick:)];
        
        
        b2BodyDef _titleBodyDef;
        
        _titleBodyDef.type = b2_dynamicBody;
        _titleBodyDef.position.Set(250/PTM_RATIO, 225/PTM_RATIO);
        _titleBodyDef.userData = label;
        b2Body *_titleBody = world->CreateBody(&_titleBodyDef);
        
        b2CircleShape _circle;
        _circle.m_radius = 18.0/PTM_RATIO;
        
        b2Fixture *_titleFixture;
        b2FixtureDef _titleShapeDef;
        _titleShapeDef.shape = &_circle;
        _titleShapeDef.density = 1.0f;
        _titleShapeDef.friction = 0.2f;
        _titleShapeDef.restitution = 0.0f;
        _titleFixture = _titleBody->CreateFixture(&_titleShapeDef);
        
        // +++ Add anchor body
        //b2BodyDef anchorBodyDef;
        anchorBodyDef.position.Set(160/PTM_RATIO, 400/PTM_RATIO); //center body on screen
        anchorBody = world->CreateBody(&anchorBodyDef);
        // +++ Add rope spritesheet to layer
        ropeSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"rope.png" ];
        [self addChild:ropeSpriteSheet];
        // +++ Init array that will hold references to all our ropes
        vRopes = [[NSMutableArray alloc] init];
        
        // +++ Create box2d joint
        b2RopeJointDef jd;
        jd.bodyA=anchorBody; //define bodies
        jd.bodyB=_titleBody;
        jd.localAnchorA = b2Vec2(0,0); //define anchors
        jd.localAnchorB = b2Vec2(0,0);
        jd.maxLength= (_titleBody->GetPosition() - anchorBody->GetPosition()).Length(); //define max length of joint = current distance between bodies
        world->CreateJoint(&jd); //create joint
        // +++ Create VRope
        VRope *newRope = [[VRope alloc] init:anchorBody body2:_titleBody spriteSheet:ropeSpriteSheet];
        [vRopes addObject:newRope];

	}
	return self;
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

-(void) addNewSpriteWithCoords:(CGPoint)p
{
	CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
	CCSpriteBatchNode *batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];
	
	//We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is
	//just randomly picking one of the images
	int idx = (CCRANDOM_0_1() > .5 ? 0:1);
	int idy = (CCRANDOM_0_1() > .5 ? 0:1);
	CCSprite *sprite = [CCSprite spriteWithBatchNode:batch rect:CGRectMake(32 * idx,32 * idy,32,32)];
	[batch addChild:sprite];
	
	sprite.position = ccp( p.x, p.y);
	
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

-(void)removeRopes {
	for(uint i=0;i<[vRopes count];i++) {
		[[vRopes objectAtIndex:i] removeSprites];
		[[vRopes objectAtIndex:i] release];
	}
	[vRopes removeAllObjects];
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

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
		[self addNewSpriteWithCoords: location];
	}
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
	//#define kFilterFactor 0.05f
#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	// accelerometer values are in "Portrait" mode. Change them to Landscape left
	// multiply the gravity by 10
	b2Vec2 gravity( -accelY * 10, accelX * 10);
	
	world->SetGravity( gravity );
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
