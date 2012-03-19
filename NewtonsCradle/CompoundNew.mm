//
//  CompoundNew.mm
//  CompoundBody
//
//  Created by Saida Memon on 3/8/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "CompoundNew.h"
#import "SimpleAudioEngine.h"
#import "MusicHandler.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

/** Convert the given position into the box2d world. */
static inline float ptm(float d)
{
    return d / PTM_RATIO;
}

/** Convert the given position into the cocos2d world. */
static inline float mtp(float d)
{
    return d * PTM_RATIO;
}

static inline float radDiff( float a, float b )
{
    return atan2( sin(a-b), cos(a-b) );
}

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};


// CompoundNew implementation
@implementation CompoundNew

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CompoundNew *layer = [CompoundNew node];
	
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
        
        muted = FALSE;
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height); 
        
        // Define the gravity vector.
        b2Vec2 gravity;
        gravity.Set(0.0f, -10.0f); 
        
        // This will speed up the physics simulation
        bool doSleep = true; 
        
        // Construct a world object, which will hold and simulate the rigid bodies.
        world = new b2World(gravity, doSleep); 
        world->SetContinuousPhysics(true); 
        
       /* // Debug Draw functions
        m_debugDraw = new GLESDebugDraw( PTM_RATIO );
        world->SetDebugDraw(m_debugDraw); 
        uint32 flags = 0;
        flags += b2DebugDraw::e_shapeBit;
        m_debugDraw->SetFlags(flags);  
        */
        ground = world->CreateBody(&bd);
        
        //Box
        b2BodyDef groundBodyDef;
        groundBody = world->CreateBody(&groundBodyDef);
        
        shape.SetAsEdge(b2Vec2(0.000000f, 0.000000f), b2Vec2(15.000000f, 0.000000f)); //bottom wall
        groundBody->CreateFixture(&shape,0);
        shape.SetAsEdge(b2Vec2(15.000000f, 0.000000f), b2Vec2(15.000000f, 10.000000f)); //right wall
        groundBody->CreateFixture(&shape,0);
        shape.SetAsEdge(b2Vec2(15.000000f, 10.000000f), b2Vec2(0.000000f, 10.000000f)); //top wall
        groundBody->CreateFixture(&shape,0);
        shape.SetAsEdge(b2Vec2(0.000000f, 10.000000f), b2Vec2(0.000000f, 0.000000f)); //;left wall
        groundBody->CreateFixture(&shape,0);
        
		//Set up sprite
        acorns = [[NSMutableArray alloc] initWithCapacity:4];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"newtscradle.plist"];
        CCSpriteBatchNode*  spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"newtscradle.png"];
        [self addChild:spriteSheet];
        
        // Preload effect
        [MusicHandler preload];
        
        // Create contact listener
        contactListener = new MyContactListener();
        world->SetContactListener(contactListener);
        
        [self createMenu];
        
        [self createEachPendulum2:10.0f];
        
        [self schedule: @selector(tick:)]; 
    }
    
    return self; 
}


- (void) createEachPendulum2:(float)delta {
        
    spacing = 1.63f;
    //spacing = 1.83f;
    
    //top anchor
    CCSprite *woodSprite = [CCSprite spriteWithFile:@"wood.png"];
    woodSprite.position = ccp(480.0f/2, 50/PTM_RATIO);
    [self addChild:woodSprite z:1 tag:11];
    bodyDef.userData = woodSprite;
    bodyDef.type = b2_staticBody;
    bodyDef.position.Set(7.5f, 360/PTM_RATIO *0.83f);
    bodyDef.type = b2_staticBody;
    bodyDef.angle = 0.000000f;
    b2Body* anchor = world->CreateBody(&bodyDef);
    boxy.SetAsBox(4.65f, 0.25f);
    fd.shape = &boxy;
    fd.density = 0.015000f;
    fd.friction = 0.300000f;
    fd.restitution = 0.600000f;
    anchor->CreateFixture(&fd);
    
    for (int i=0; i<4; i++) {
        
        //sticks
        CCSprite *sticksSprite = [CCSprite spriteWithFile:@"stick4.png"];
        sticksSprite.position = ccp(480.0f/2, 50/PTM_RATIO);
        [self addChild:sticksSprite z:-11 tag:11];
        bodyDef.userData = sticksSprite;
        bodyDef.type=b2_dynamicBody;
        bodyDef.position.Set(4.7f+ (spacing*i), 6.5f);
        bodyDef.angle = 0.000000f;
        b2Body* stick = world->CreateBody(&bodyDef);
        initVel.Set(0.000000f, 0.000000f);
        stick->SetLinearVelocity(initVel);
        stick->SetAngularVelocity(0.000000f);
        boxy.SetAsBox(0.05f,2.85f);
        fd.shape = &boxy;
        fd.density = 1.0f;
        fd.friction = 0.0f;
        stick->CreateFixture(&fd);
        
        // acorns
        bodyDef1.type = b2_dynamicBody;
        bodyDef1.position.Set(stick->GetWorldCenter().x, stick->GetWorldCenter().y -2.85f);
        
        //acorns
        acornSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"candidateA%i.png", i+1]];
        acornSprite.position = ccp(480.0f/2, 50/PTM_RATIO);
        [self addChild:acornSprite z:1 tag:11];

        bodyDef1.userData = acornSprite;
        b2Body *acorn = world->CreateBody(&bodyDef1);
        //Slows the rotation down
        //bodyDef1.linearDamping = 0.01f; //really slows everything down
        bodyDef1.angularDamping = 0.01f;
        [acorns addObject:[NSValue valueWithPointer:acorn]];
        b2CircleShape dynamicBox;
        dynamicBox.m_radius = 25.71/PTM_RATIO;
        fixtureDef.shape = &dynamicBox;	
        fixtureDef.friction = 1.0f;
        fixtureDef.density = 10.0f;
        fixtureDef.restitution = 1.0f;
        //acorn->SetAngularVelocity(5.000000f); //makes heads spin initially

        acorn->CreateFixture(&fixtureDef);
        
        //Revolute joints
        pos.Set(4.764226f+ (spacing*i), 9.3f);
        revJointDef.Initialize(stick, anchor, pos);
        revJointDef.collideConnected = false;
        world->CreateJoint(&revJointDef);
        
        pos.Set(acorn->GetWorldCenter().x, acorn->GetWorldCenter().y);
        revJointDef.Initialize(stick, acorn, pos);
        revJointDef.collideConnected = false;
        revJointDef.motorSpeed = 0.0f;
        revJointDef.enableMotor = false;
        revJointDef.maxMotorTorque = 5.0f;
        world->CreateJoint(&revJointDef);
    }
}

- (void)createMenu {
    CCSprite *sprite2 = [CCSprite spriteWithFile:@"bg.png"];
    sprite2.anchorPoint = CGPointZero;
    [self addChild:sprite2 z:-11];
    
    CCMenuItemSprite* restartItem = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"reset.png"]
                                                            selectedSprite:[CCSprite spriteWithFile:@"resetS.png"]
                                                            disabledSprite:[CCSprite spriteWithFile:@"resetS.png"]
                                                                    target:self
                                                                  selector:@selector(reset)];		    
        
    CCMenuItemSprite *playItem = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"newPauseON.png"]
                                                         selectedSprite:[CCSprite spriteWithFile:@"newPauseONSelect.png"]];
    
    CCMenuItemSprite *pauseItem = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"newPauseOFF.png"]
                                                          selectedSprite:[CCSprite spriteWithFile:@"newPauseOFFSelect.png"]];
    CCMenuItemToggle *pause;
    if (!muted)  {
        pause = [CCMenuItemToggle itemWithTarget:self selector:@selector(turnOnMusic)items:playItem, pauseItem, nil];
    }
    else {
        pause = [CCMenuItemToggle itemWithTarget:self selector:@selector(turnOnMusic)items:pauseItem, playItem, nil];
    }
    
    //Create Menu with the items created before
    CCMenu *menu = [CCMenu menuWithItems:pause,restartItem, nil];
    [self addChild:menu z:11];
    [menu alignItemsHorizontally];
    [menu setPosition:ccp(90.0f, 35.0f)];
}

- (void)reset {
    for (int i=0; i<4; i++) {
        bulletBody = (b2Body*)[[acorns objectAtIndex:i] pointerValue];
        bulletBody->SetTransform(b2Vec2(4.7f+ (spacing*i), 4.0f), 0.0f);
        bulletBody->SetLinearVelocity(b2Vec2(0.0f, 0.0f));
        bulletBody->SetAngularVelocity(0.0f);
    }
}

- (void)turnOnMusic {
    if ([[SimpleAudioEngine sharedEngine] mute]) {
        // This will unmute the sound
        muted = FALSE;
    }
    else {
        //This will mute the sound
        muted = TRUE;
    }
    [[SimpleAudioEngine sharedEngine] setMute:muted];
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
    
    // Loop through all of the box2d bodies that are currently colliding, that we have
    // gathered with our custom contact listener...
    std::vector<MyContact>::iterator pos2;
    for(pos2 = contactListener->_contacts.begin(); pos2 != contactListener->_contacts.end(); ++pos2) {
        MyContact contact = *pos2;
        
        // Get the box2d bodies for each object
        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();
        if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
            CCSprite *spriteA = (CCSprite *) bodyA->GetUserData();
            CCSprite *spriteB = (CCSprite *) bodyB->GetUserData();
            
            //spriteA.color = ccMAGENTA;
            //spriteB.color = ccMAGENTA;
            
            if (spriteA.tag == 11 && spriteB.tag == 11) {
                if (abs(bodyA->GetLinearVelocity().x) > 1 || abs(bodyB->GetLinearVelocity().x) > 1) {
                    //bodyA->ApplyAngularImpulse( 15.0f );
                    //bodyB->ApplyAngularImpulse( 15.0f );  
                    
                /*    angimp = bodyA->GetInertia() * radDiff( 5.0f, bodyA->GetAngle() );
                    bodyA->ApplyAngularImpulse( angimp );
                    angimp = bodyB->GetInertia() * radDiff( 5.0f, bodyB->GetAngle() );
                    bodyB->ApplyAngularImpulse( angimp );
                 */
                [MusicHandler playBounce];
                }
            } 
        }  
        
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (mouseJoint != nil) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    bulletBody = (b2Body*)[[acorns objectAtIndex:0] pointerValue];
    bulletBody2 = (b2Body*)[[acorns lastObject] pointerValue];
    
    
    if (locationWorld.x > bulletBody2->GetWorldCenter().x - 50.0/PTM_RATIO)
    {
        md.bodyA = ground;
        md.bodyB = bulletBody2;
        md.target = locationWorld;
        md.maxForce = 2000;
        
        mouseJoint = (b2MouseJoint *)world->CreateJoint(&md);
    } else if (locationWorld.x < bulletBody->GetWorldCenter().x + 50.0/PTM_RATIO)
    {
        md.bodyA = ground;
        md.bodyB = bulletBody;
        md.target = locationWorld;
        md.maxForce = 2000;
        
        mouseJoint = (b2MouseJoint *)world->CreateJoint(&md);
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
    
    world->DestroyJoint(mouseJoint);
    
    mouseJoint = NULL;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
