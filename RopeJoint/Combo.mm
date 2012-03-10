//
//  ComboScene.mm
//  verletRopeTestProject
//
//  Created by patrick on 29/10/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


// Import the interfaces
#import "Combo.h"

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


// Combo implementation
@implementation Combo

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Combo *layer = [Combo node];
	
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
        
		// Define the ground body.
		b2BodyDef groundBodyDef;
		groundBodyDef.position.Set(0, 0); // bottom-left corner
		groundBody = world->CreateBody(&groundBodyDef);
        
		// +++ Add rope spritesheet to layer
		ropeSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"rope.png" ];
		[self addChild:ropeSpriteSheet];
		// +++ Init array that will hold references to all our ropes
		vRopes = [[NSMutableArray alloc] init];
		
		
		//Set up sprite
        anchors = [[NSMutableArray alloc] initWithCapacity:4];
        
       // [self addNewSpriteWithCoords:ccp(120.0f, screenSize.height/2)];
        CGPoint p = CGPointMake(120.0f + (40*0), p.y);
        anchorBodyDef.position.Set(p.x/PTM_RATIO,screenSize.height/PTM_RATIO*0.9f); //center body on screen
        anchorBody = world->CreateBody(&anchorBodyDef);
        
        /*   anchorBody = (b2Body*)[[anchors lastObject] pointerValue];
         b2Vec2 force = b2Vec2(10, 15);
         anchorBody->ApplyLinearImpulse(force, b2Vec2(320.0f, screenSize.height/2));
         */ 
        
        
        // Create edges around the entire screen
        groundBodyDef.position.Set(0,0);
        groundBody = world->CreateBody(&groundBodyDef);
        b2EdgeShape groundBox;      
        b2FixtureDef groundBoxDef;
        groundBoxDef.shape = &groundBox;
        groundBox.Set(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO, 0));
        _bottomFixture = groundBody->CreateFixture(&groundBoxDef);
        groundBox.Set(b2Vec2(0,0), b2Vec2(0, screenSize.height/PTM_RATIO));
        groundBody->CreateFixture(&groundBoxDef);
        groundBox.Set(b2Vec2(0, screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO, 
                                                                  screenSize.height/PTM_RATIO));
        groundBody->CreateFixture(&groundBoxDef);
        groundBox.Set(b2Vec2(screenSize.width/PTM_RATIO, screenSize.height/PTM_RATIO), 
                      b2Vec2(screenSize.width/PTM_RATIO, 0));
        groundBody->CreateFixture(&groundBoxDef);
        
        
        
		// +++ Add rope spritesheet to layer
		ropeSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"rope.png" ];
		[self addChild:ropeSpriteSheet];
        
        // Create sprite and add it to the layer
        CCSprite *ball = [CCSprite spriteWithFile:@"Ball.png" 
                                             rect:CGRectMake(0, 0, 52, 52)];
        ball.position = ccp(100, 100);
        ball.tag = 1;
        [self addChild:ball];
        
        
        // Create ball body 
        b2BodyDef ballBodyDef;
        ballBodyDef.type = b2_dynamicBody;
        ballBodyDef.position.Set(100/PTM_RATIO, 100/PTM_RATIO);
        ballBodyDef.userData = ball;
        ballBody = world->CreateBody(&ballBodyDef);
        
        // Create circle shape
        b2CircleShape circle;
        circle.m_radius = 26.0/PTM_RATIO;
        
        // Create shape definition and add to body
        b2FixtureDef ballShapeDef;
        ballShapeDef.shape = &circle;
        ballShapeDef.density = 1.0f;
        ballShapeDef.friction = 0.f;
        ballShapeDef.restitution = 1.0f;
        _ballFixture = ballBody->CreateFixture(&ballShapeDef);
        
        
        b2Vec2 force = b2Vec2(10, 10);
        ballBody->ApplyLinearImpulse(force, ballBodyDef.position);
        
        // Create paddle and add it to the layer
        CCSprite *paddle = [CCSprite spriteWithFile:@"Paddle.png"];
        paddle.position = ccp(screenSize.width/2, 50);
        [self addChild:paddle];
        
        // Create paddle body
        b2BodyDef paddleBodyDef;
        //paddleBodyDef.type = b2_dynamicBody;
        paddleBodyDef.type = b2_staticBody;
        paddleBodyDef.position.Set(screenSize.width/2/PTM_RATIO, 50/PTM_RATIO);
        paddleBodyDef.userData = paddle;
        _paddleBody = world->CreateBody(&paddleBodyDef);
        
        // Create paddle shape
        b2PolygonShape paddleShape;
        paddleShape.SetAsBox(paddle.contentSize.width/PTM_RATIO/2, 
                             paddle.contentSize.height/PTM_RATIO/2);
        
        // Create shape definition and add to body
        b2FixtureDef paddleShapeDef;
        paddleShapeDef.shape = &paddleShape;
        paddleShapeDef.density = 10.0f;
        paddleShapeDef.friction = 0.4f;
        paddleShapeDef.restitution = 0.1f;
        _paddleFixture = _paddleBody->CreateFixture(&paddleShapeDef);
        
        // Restrict paddle along the x axis
        b2PrismaticJointDef jointDef;
        b2Vec2 worldAxis(1.0f, 0.0f);
        jointDef.collideConnected = true;
        jointDef.Initialize(_paddleBody, groundBody, 
                            _paddleBody->GetWorldCenter(), worldAxis);
        world->CreateJoint(&jointDef);
       
        
        //connect paddle to bouncing ball
        // +++ Create box2d joint
        jd.bodyA=anchorBody; //define bodies
        jd.bodyB=ballBody;
        jd.localAnchorA = b2Vec2(0,0); //define anchors
        jd.localAnchorB = b2Vec2(0,0);
        jd.maxLength= (ballBody->GetPosition() - anchorBody->GetPosition()).Length(); //max joint = current distance between bodies
        CCLOG(@"jd.maxLengthjd.maxLength %0.2f",jd.maxLength);

        world->CreateJoint(&jd); //create joint
        // +++ Create VRope with two b2bodies and pointer to spritesheet
        newRope = [[VRope alloc] init:_paddleBody body2:ballBody spriteSheet:ropeSpriteSheet];
        [vRopes addObject:newRope];
        
        
        [self schedule: @selector(tick:)];
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
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    for (int i=0; i<4; i++) {
        
        p = CGPointMake(120.0f + (40*i), p.y);
        anchorBodyDef.position.Set(p.x/PTM_RATIO,screenSize.height/PTM_RATIO*0.9f); //center body on screen
        anchorBody = world->CreateBody(&anchorBodyDef);
        
        CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
        
        sprite = [CCSprite spriteWithFile:@"acorn.png"];
        [self addChild:sprite];
        sprite.position = ccp( p.x, p.y);
        
        // Define the dynamic body.
        //Set up a 1m squared box in the physics world
        bodyDef.type = b2_dynamicBody;
        
        bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
        bodyDef.userData = sprite;
        body = world->CreateBody(&bodyDef);
        [anchors addObject:[NSValue valueWithPointer:body]];
        
        dynamicBox.m_radius = 18.0/PTM_RATIO;
        
        // Define the dynamic body fixture.
        fixtureDef.shape = &dynamicBox;	
        fixtureDef.density = 1.0f;
        fixtureDef.friction = 0.1f;
        fixtureDef.restitution = 1.0f;
        body->CreateFixture(&fixtureDef);
        
        // +++ Create box2d joint
        jd.bodyA=anchorBody; //define bodies
        jd.bodyB=body;
        jd.localAnchorA = b2Vec2(0,10); //define anchors
        jd.localAnchorB = b2Vec2(0,10);
        jd.maxLength= -2.0f; //define max length of joint = current distance between bodies
        world->CreateJoint(&jd); //create joint
        // +++ Create VRope with two b2bodies and pointer to spritesheet
        newRope = [[VRope alloc] init:anchorBody body2:body spriteSheet:ropeSpriteSheet];
        [vRopes addObject:newRope];
    }
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

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (mouseJoint != nil) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
  /*
    bulletBody = (b2Body*)[[anchors objectAtIndex:0] pointerValue];
    bulletBody2 = (b2Body*)[[anchors lastObject] pointerValue];
  	//CCLOG(@"Body2bulletBody2bulletBody2 %0.2f x %02.f",bulletBody2->GetWorldCenter().x , bulletBody2->GetWorldCenter().y);
  	//CCLOG(@"11111111111111111111111 %0.2f x %02.f",bulletBody->GetWorldCenter().x , bulletBody2->GetWorldCenter().y);
    
   
    if (locationWorld.x > bulletBody2->GetWorldCenter().x - 50.0/PTM_RATIO)
    {
        b2MouseJointDef md;
        md.bodyA = groundBody;
        md.bodyB = bulletBody2;
        md.target = locationWorld;
        md.maxForce = 2000;
        
        mouseJoint = (b2MouseJoint *)world->CreateJoint(&md);
    } else if (locationWorld.x < bulletBody->GetWorldCenter().x + 50.0/PTM_RATIO)
    {
        b2MouseJointDef md;
        md.bodyA = groundBody;
        md.bodyB = bulletBody;
        md.target = locationWorld;
        md.maxForce = 2000;
        
        mouseJoint = (b2MouseJoint *)world->CreateJoint(&md);
    }
    */
    //[[SimpleAudioEngine sharedEngine] playEffect: @"wood.wav"];
 
    /*
    if (_paddleFixture->TestPoint(locationWorld)) {
        b2MouseJointDef md;
        md.bodyA = ballBody;
        md.bodyB = _paddleBody;
        md.target = locationWorld;
        md.collideConnected = true;
        md.maxForce = 1000.0f * _paddleBody->GetMass();
        
        _mouseJoint = (b2MouseJoint *)world->CreateJoint(&md);
        _paddleBody->SetAwake(true);
    }
     */
}

/*
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
 */
-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint == NULL) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    _mouseJoint->SetTarget(locationWorld);
    
}
-(void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint) {
        world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
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
