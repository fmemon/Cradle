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
        
        //edge.Set(b2Vec2(0.000000f, 0.000000f), b2Vec2(15.000000f, 0.000000f)); //bottom wall
        //groundBody->CreateFixture(&edge,0);
        edge.Set(b2Vec2(15.000000f, 0.000000f), b2Vec2(15.000000f, 10.000000f)); //right wall
        groundBody->CreateFixture(&edge,0);
        edge.Set(b2Vec2(15.000000f, 10.000000f), b2Vec2(0.000000f, 10.000000f)); //top wall
        groundBody->CreateFixture(&edge,0);
        edge.Set(b2Vec2(0.000000f, 10.000000f), b2Vec2(0.000000f, 0.000000f)); //;left wall
        groundBody->CreateFixture(&edge,0);
        
        //TODO extend wall on left and right side to be longer than rope so that it does not trap after going down

        
        //Circles
        //circle2
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
        paddleShapeDef.density = 0.915000f;
        paddleShapeDef.friction = 0.0300000f;
        paddleShapeDef.restitution = 0.600000f;
        paddleShapeDef.filter.groupIndex = int16(0);
        paddleShapeDef.filter.categoryBits = uint16(65535);
        paddleShapeDef.filter.maskBits = uint16(65535);
        _paddleFixture = _paddleBody->CreateFixture(&paddleShapeDef);
        
        // Restrict paddle along the x axis
        b2PrismaticJointDef pjointDef;
        b2Vec2 worldAxis(1.0f, 0.0f);
        pjointDef.collideConnected = true;
        pjointDef.Initialize(_paddleBody, ground, 
                             _paddleBody->GetWorldCenter(), worldAxis);
        world->CreateJoint(&pjointDef);
        //paddle code
        
        
        //static body 4
        b2PolygonShape shape;

        //bodyDef1.position.Set(11.574468f, 2.851064f);
        bodyDef1.position.Set(screenSize.width/2/PTM_RATIO, 50/PTM_RATIO);
        bodyDef1.angle = 0.020196f;
        b2Body* staticBody4 = world->CreateBody(&bodyDef1);
        initVel.Set(0.000000f, 0.000000f);
        staticBody4->SetLinearVelocity(initVel);
        staticBody4->SetAngularVelocity(0.000000f);
        b2Vec2 staticBody4_vertices[4];
        staticBody4_vertices[0].Set(-1.723404f, -0.404255f);
        staticBody4_vertices[1].Set(1.723404f, -0.404255f);
        staticBody4_vertices[2].Set(1.723404f, 0.404255f);
        staticBody4_vertices[3].Set(-1.723404f, 0.404255f);
        shape.Set(staticBody4_vertices, 4);
        fd.shape = &shape;
        fd.density = 1.0f;
        fd.friction = 0.0f;
        fd.restitution = 0.25f;        
        fd.filter.groupIndex = int16(0);
        fd.filter.categoryBits = uint16(65535);
        fd.filter.maskBits = uint16(65535);
        staticBody4->CreateFixture(&shape,0);
        
        
         // +++ Add anchor body
         b2BodyDef anchorBodyDef;
         anchorBodyDef.position.Set(screenSize.width/PTM_RATIO/2,screenSize.height/PTM_RATIO*0.7f); //center body on screen
         anchorBody = world->CreateBody(&anchorBodyDef);
         // +++ Add rope spritesheet to layer
         ropeSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"rope.png" ];
         [self addChild:ropeSpriteSheet];
         // +++ Init array that will hold references to all our ropes
         vRopes = [[NSMutableArray alloc] init];
        
        // +++ Create box2d joint
        b2RopeJointDef rjd;
        //rjd.bodyA=anchorBody; //define bodies
        //rjd.bodyA=circle1; //define bodies
        //rjd.bodyA=_paddleBody; //define bodies
        rjd.bodyA=staticBody4; //define bodies
        rjd.bodyB=circle2;
        rjd.localAnchorA = b2Vec2(0,0); //define anchors
        rjd.localAnchorB = b2Vec2(0,0);
        //rjd.maxLength= (circle2->GetPosition() - anchorBody->GetPosition()).Length(); //define max length of joint = current distance between bodies
        //rjd.maxLength= (circle2->GetPosition() - circle1->GetPosition()).Length(); //define max length of joint = current distance between bodies
       // rjd.maxLength= (circle2->GetPosition() - _paddleBody->GetPosition()).Length(); //define max length of joint = current distance between bodies
        //rjd.maxLength= (circle2->GetPosition() - staticBody4->GetPosition()).Length() + 3.77f; //define max length of joint = current distance between bodies
        rjd.maxLength= (circle2->GetPosition() - staticBody4->GetPosition()).Length(); //define max length of joint = current distance between bodies
        CCLOG(@"rjd.maxLength11111111111111111111111 %0.2f",rjd.maxLength);

        world->CreateJoint(&rjd); //create joint
        // +++ Create VRope
        //VRope *newRope = [[VRope alloc] init:anchorBody body2:circle2 spriteSheet:ropeSpriteSheet];
        //VRope *newRope = [[VRope alloc] init:circle1 body2:circle2 spriteSheet:ropeSpriteSheet];
        //VRope *newRope = [[VRope alloc] init:_paddleBody body2:circle2 spriteSheet:ropeSpriteSheet];
        VRope *newRope = [[VRope alloc] init:staticBody4 body2:circle2 spriteSheet:ropeSpriteSheet];
        [vRopes addObject:newRope];
        
        /*
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
        b2PrismaticJointDef pjointDef;
        b2Vec2 worldAxis(1.0f, 0.0f);
        pjointDef.collideConnected = true;
        pjointDef.Initialize(_paddleBody, ground, 
                            _paddleBody->GetWorldCenter(), worldAxis);
        world->CreateJoint(&pjointDef);
        
        
        //connect paddle to bouncing ball
        // +++ Create box2d joint
        jd.bodyA=ground; //define bodies
        jd.bodyB=ballBody;
        jd.localAnchorA = b2Vec2(0,0); //define anchors
        jd.localAnchorB = b2Vec2(0,0);
        jd.maxLength= (ballBody->GetPosition() - ground->GetPosition()).Length(); //max joint = current distance between bodies
        CCLOG(@"jd.maxLengthjd.maxLength %0.2f",jd.maxLength);
        
        world->CreateJoint(&jd); //create joint
        // +++ Create VRope with two b2bodies and pointer to spritesheet
        newRope = [[VRope alloc] init:_paddleBody body2:ballBody spriteSheet:ropeSpriteSheet];
        [vRopes addObject:newRope];
        
        */
        
//        anchors = [[NSMutableArray alloc] initWithCapacity:4];
 //       [self addNewSpriteWithCoords:ccp(120.0f, screenSize.height/2)];
        
        [self schedule: @selector(tick:)]; 
        
    }
    
    return self; 
    
}

/*
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
        
        b2CircleShape dynamicBox;
        dynamicBox.m_radius = 18.0/PTM_RATIO;
        
        // Define the dynamic body fixture.
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicBox;	
        fixtureDef.density = 1.0f;
        fixtureDef.friction = 0.1f;
        fixtureDef.restitution = 1.0f;
        body->CreateFixture(&fixtureDef);
        
        // +++ Create box2d joint
        b2RopeJointDef rjd;
        rjd.bodyA=anchorBody; //define bodies
        rjd.bodyB=body;
        rjd.localAnchorA = b2Vec2(0,0); //define anchors
        rjd.localAnchorB = b2Vec2(0,0);
        rjd.maxLength= (body->GetPosition() - anchorBody->GetPosition()).Length(); //define max length of joint = current distance between bodies
        world->CreateJoint(&rjd); //create joint
        // +++ Create VRope with two b2bodies and pointer to spritesheet
        VRope *newRope = [[VRope alloc] init:anchorBody body2:body spriteSheet:ropeSpriteSheet];
        [vRopes addObject:newRope];
    
    }
}
*/
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
  /*
      //for circle2 and rope that did not work
        b2MouseJointDef md;
        md.bodyA = anchorBody;
        md.bodyB = circle2;
        md.target = locationWorld;
        md.maxForce = 2000;
        
        mouseJoint = (b2MouseJoint *)world->CreateJoint(&md);
   
   */
      
/*    bulletBody = (b2Body*)[[anchors objectAtIndex:0] pointerValue];
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
    
    //[[SimpleAudioEngine sharedEngine] playEffect: @"wood.wav"];
   */ 
    
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
