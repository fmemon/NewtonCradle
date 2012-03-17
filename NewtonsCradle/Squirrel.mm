//
//  Squirrel.mm
//  cute-a-pult
//
//  Created by Gustavo Ambrozio on 23/8/11.
//  Copyright CodeCrop Software 2011. All rights reserved.
//


// Import the interfaces
#import "Squirrel.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32
#define FLOOR_HEIGTH    62.0f

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};

// Squirrel implementation
@implementation Squirrel

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Squirrel *layer = [Squirrel node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		// enable touches
		self.isTouchEnabled = YES;
        
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
		b2BodyDef groundBodyDef, bodyDef;
		groundBodyDef.position.Set(0, 0); // bottom-left corner
		
		// Call the body factory which allocates memory for the ground body
		// from a pool and creates the ground box shape (also from a pool).
		// The body is also added to the world.
		groundBody = world->CreateBody(&groundBodyDef);
		
		// Define the ground box shape.
		b2PolygonShape groundBox;		
		
        CGPoint pos = CGPointMake(screenSize.width/PTM_RATIO/2,screenSize.height/PTM_RATIO*0.9f );
        
        //top anchor
        b2FixtureDef fd;
        b2PolygonShape boxy;

        bodyDef.position.Set(7.764226f, screenSize.height/PTM_RATIO *0.90f);
        // bodyDef.position.Set(7.764226f, 7.320508f);
        bodyDef.type = b2_staticBody;
        bodyDef.angle = 0.000000f;
        b2Body* polygon1 = world->CreateBody(&bodyDef);
        //boxy.SetAsBox(5.65f, 0.25f);
        boxy.SetAsBox(2.65f, 0.25f);
        fd.shape = &boxy;
        fd.density = 0.015000f;
        fd.friction = 0.300000f;
        fd.restitution = 0.600000f;
        polygon1->CreateFixture(&fd);
        
		
        // Create the catapult's arm
        b2BodyDef armBodyDef;
        armBodyDef.type = b2_dynamicBody;
        armBodyDef.linearDamping = 1;
        armBodyDef.angularDamping = 1;
        armBodyDef.position.Set(230.0f/PTM_RATIO,pos.y*0.7f);
        armBody = world->CreateBody(&armBodyDef);
        
        b2PolygonShape armBox;
        b2FixtureDef armBoxDef;
        armBoxDef.shape = &armBox;
        armBoxDef.density = 0.3F;
        armBox.SetAsBox(5.0f/PTM_RATIO, 90.0f/PTM_RATIO);
        armFixture = armBody->CreateFixture(&armBoxDef);

        b2CircleShape circle;
        circle.m_radius = 1.0f;
        armBoxDef.shape = &circle;        
        armBodyDef.position.Set(50/PTM_RATIO, 225/PTM_RATIO);
        armBoxDef.density = 1.0f;
        armFixture = armBody->CreateFixture(&armBoxDef);
        
        // Create a joint to fix the catapult to the floor.
        b2RevoluteJointDef armJointDef;
        armJointDef.Initialize(polygon1, armBody, b2Vec2(233.0f/PTM_RATIO, pos.y));
        armJointDef.enableMotor = true;
        armJointDef.enableLimit = true;
        armJointDef.motorSpeed  = -10;
        armJointDef.lowerAngle  = CC_DEGREES_TO_RADIANS(-75);
        armJointDef.upperAngle  = CC_DEGREES_TO_RADIANS(75);
        armJointDef.maxMotorTorque = 1500;
        
        armJoint = (b2RevoluteJoint*)world->CreateJoint(&armJointDef);
        
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
    
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (mouseJoint != nil) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    if (locationWorld.x < armBody->GetWorldCenter().x + 50.0/PTM_RATIO)
    {
        b2MouseJointDef md;
        md.bodyA = groundBody;
        md.bodyB = armBody;
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
        if (armJoint->GetJointAngle() >= CC_DEGREES_TO_RADIANS(20))
        {
            releasingArm = YES;
        }
        
        world->DestroyJoint(mouseJoint);
        mouseJoint = nil;
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
    
    // Arm is being released.
    if (releasingArm && bulletJoint)
    {
        // Check if the arm reached the end so we can return the limits
        if (armJoint->GetJointAngle() <= CC_DEGREES_TO_RADIANS(10))
        {
            releasingArm = NO;
            
            // Destroy joint so the bullet will be free
            world->DestroyJoint(bulletJoint);
            bulletJoint = nil;
            [self performSelector:@selector(resetBullet) withObject:nil afterDelay:5.0f];
        }
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [bullets release];
    
    [targets release];
    [enemies release];
    
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	
    
	delete m_debugDraw;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
