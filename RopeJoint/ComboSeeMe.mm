//
//  ComboSeeMe.mm
//  CompoundBody
//
//  Created by Saida Memon on 3/8/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "ComboSeeMe.h"

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


// ComboSeeMe implementation
@implementation ComboSeeMe

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ComboSeeMe *layer = [ComboSeeMe node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(id)init

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
        
        //  flags += b2DebugDraw::e_jointBit;
        //  flags += b2DebugDraw::e_aabbBit;
        //  flags += b2DebugDraw::e_pairBit;
        //  flags += b2DebugDraw::e_centerOfMassBit;
        
        m_debugDraw->SetFlags(flags);  
        
        b2Body* ground = NULL;
        b2BodyDef bd;
        ground = world->CreateBody(&bd);
        
        bodyDef.type=b2_dynamicBody;
        b2Vec2 initVel;
        b2EdgeShape edge;      
        b2CircleShape circleShape;
        b2FixtureDef fd;
        b2RevoluteJointDef revJointDef;
        b2DistanceJointDef jointDef;
        b2Vec2 pos;
        
        //Box
        b2BodyDef groundBodyDef;
        b2Body* groundBody = world->CreateBody(&groundBodyDef);
        
        edge.Set(b2Vec2(0.000000f, 0.000000f), b2Vec2(15.000000f, 0.000000f)); //bottom wall
        groundBody->CreateFixture(&edge,0);
        edge.Set(b2Vec2(15.000000f, 0.000000f), b2Vec2(15.000000f, 10.000000f)); //right wall
        groundBody->CreateFixture(&edge,0);
        edge.Set(b2Vec2(15.000000f, 10.000000f), b2Vec2(0.000000f, 10.000000f)); //top wall
        groundBody->CreateFixture(&edge,0);
        edge.Set(b2Vec2(0.000000f, 10.000000f), b2Vec2(0.000000f, 0.000000f)); //;left wall
        groundBody->CreateFixture(&edge,0);
                
        //Circles
        //circle2
        CCSprite *ball = [CCSprite spriteWithFile:@"Ball.png"];
        //[self addChild:ball];
        //bodyDef.userData = ball;
        bodyDef.type = b2_dynamicBody;
        bodyDef.position.Set(0.468085f, 9.574468f);
        bodyDef.angle = 0.000000f;
        circle2 = world->CreateBody(&bodyDef);
        initVel.Set(0.000000f, 0.000000f);
        circle2->SetLinearVelocity(initVel);
        circle2->SetAngularVelocity(0.000000f);
        circleShape.m_radius = 0.406489f;
        fd.shape = &circleShape;
        fd.density = 1.0f;
        fd.friction = 1.0f;
        fd.restitution = 0.9f;
        fd.filter.groupIndex = int16(0);
        fd.filter.categoryBits = uint16(65535);
        fd.filter.maskBits = uint16(65535);
        circle2->CreateFixture(&fd);

        ropeSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"rope.png" ];
		[self addChild:ropeSpriteSheet];
    
        
        //paddle code
        // Create paddle and add it to the layer
        CCSprite *paddle = [CCSprite spriteWithFile:@"Paddle.png"];
        paddle.position = ccp(screenSize.width/2, 50/PTM_RATIO);
        [self addChild:paddle];
        
        // Create paddle body
        b2BodyDef paddleBodyDef;
        paddleBodyDef.userData = paddle;
        paddleBodyDef.type = b2_staticBody;
        paddleBodyDef.position.Set(screenSize.width/2/PTM_RATIO, 50/PTM_RATIO);
        //paddleBodyDef.userData = paddle;
        _paddleBody = world->CreateBody(&paddleBodyDef);
        
        // Create paddle shape
        b2PolygonShape paddleShape;
        paddleShape.SetAsBox(paddle.contentSize.width/PTM_RATIO/2, paddle.contentSize.height/PTM_RATIO/2);
        
        // Create shape definition and add to body
        b2FixtureDef paddleShapeDef;
        paddleShapeDef.shape = &paddleShape;
        paddleShapeDef.density = 0.915000f;
        paddleShapeDef.friction = 0.0300000f;
        paddleShapeDef.restitution = 0.600000f;
        paddleShapeDef.filter.groupIndex = int16(0);
        paddleShapeDef.filter.categoryBits = uint16(65535);
        paddleShapeDef.filter.maskBits = uint16(65535);
        _paddleFixture = _paddleBody->CreateFixture(&paddleShapeDef);
        
         
       //static body 4
        b2PolygonShape shape;
        bodyDef1.type = b2_staticBody;
        bodyDef1.position.Set(screenSize.width/2/PTM_RATIO, 50/PTM_RATIO);
        b2Body* staticBody4 = world->CreateBody(&bodyDef1);
        shape.SetAsBox(paddle.contentSize.width/PTM_RATIO/2, paddle.contentSize.height/PTM_RATIO/2);
        fd.shape = &shape;
        fd.density = 0.915000f;
        fd.friction = 0.0300000f;
        fd.restitution = 0.600000f;        
        fd.filter.groupIndex = int16(0);
        fd.filter.categoryBits = uint16(65535);
        fd.filter.maskBits = uint16(65535);
        staticBody4->CreateFixture(&fd);
        
         // +++ Add rope spritesheet to layer
         ropeSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"rope.png" ];
         [self addChild:ropeSpriteSheet];
        
         // +++ Init array that will hold references to all our ropes
         vRopes = [[NSMutableArray alloc] init];
        
        // +++ Create box2d joint
        b2RopeJointDef rjd;
        rjd.bodyA=staticBody4; //define bodies
        rjd.bodyB=circle2;
        rjd.localAnchorA = b2Vec2(0,0); //define anchors
        rjd.localAnchorB = b2Vec2(0,0);
        rjd.maxLength= (circle2->GetPosition() - staticBody4->GetPosition()).Length(); //define max length of joint = current distance between bodies

        world->CreateJoint(&rjd); //create joint
        VRope *newRope = [[VRope alloc] init:staticBody4 body2:circle2 spriteSheet:ropeSpriteSheet];
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
            
            if (sprite.tag == 1) {
                static int maxSpeed = 10;
                
                b2Vec2 velocity = b->GetLinearVelocity();
                float32 speed = velocity.Length();
                
                if (speed > maxSpeed) {
                    b->SetLinearDamping(0.5);
                } else if (speed < maxSpeed) {
                    b->SetLinearDamping(0.0);
                }
                
            }
            sprite.position = ccp(b->GetPosition().x * PTM_RATIO,
                                  b->GetPosition().y * PTM_RATIO);
            sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
            
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
      
    //for paddle
    if (_paddleFixture->TestPoint(locationWorld)) {
        b2MouseJointDef md;
        md.bodyA = anchorBody;
        md.bodyB = _paddleBody;
        md.target = locationWorld;
        md.collideConnected = true;
        md.maxForce = 1000.0f * _paddleBody->GetMass();
        
        _mouseJoint = (b2MouseJoint *) world->CreateJoint(&md);
        _paddleBody->SetAwake(true);
    }
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
