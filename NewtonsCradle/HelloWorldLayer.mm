//
//  HelloWorldLayer.mm
//  NewtonsCradle
//
//  Created by Saida Memon on 3/17/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32
#define DEGTORAD 0.0174532925199432957f

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};


// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
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
        
        
        ground = NULL;
        ground = world->CreateBody(&bd);
        
        
       bodyDef.type=b2_dynamicBody;
    
        
        //Box
        b2BodyDef groundBodyDef;
        b2Body* groundBody = world->CreateBody(&groundBodyDef);
        
        shape.SetAsEdge(b2Vec2(0.000000f, 0.000000f), b2Vec2(15.000000f, 0.000000f)); //bottom wall
        groundBody->CreateFixture(&shape,0);
        shape.SetAsEdge(b2Vec2(15.000000f, 0.000000f), b2Vec2(15.000000f, 10.000000f)); //right wall
        groundBody->CreateFixture(&shape,0);
        shape.SetAsEdge(b2Vec2(15.000000f, 10.000000f), b2Vec2(0.000000f, 10.000000f)); //top wall
        groundBody->CreateFixture(&shape,0);
        shape.SetAsEdge(b2Vec2(0.000000f, 10.000000f), b2Vec2(0.000000f, 0.000000f)); //;left wall
        groundBody->CreateFixture(&shape,0);
	
        b2PolygonShape boxy;

      
        //top anchor
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
    
        
  /* not working
   //stick 1
        bodyDef.position.Set(screenSize.width/PTM_RATIO*0.2f, screenSize.height/PTM_RATIO *0.7f);
        // bodyDef.position.Set(7.764226f, 7.320508f);
        bodyDef.type = b2_dynamicBody;
        bodyDef.angle = 0.000000f;
        b2Body* stick1 = world->CreateBody(&bodyDef);
        boxy.SetAsBox(0.15f, 2.65f);
        fd.shape = &boxy;
        fd.density = 0.015000f;
        fd.friction = 0.300000f;
        fd.restitution = 0.600000f;
        stick1->CreateFixture(&fd);
        
       // Create a joint to fix the catapult to the floor.
        //
        b2RevoluteJoint *armJoint;
        b2RevoluteJointDef armJointDef;
        armJointDef.Initialize(polygon1, stick1, b2Vec2(screenSize.width/PTM_RATIO*0.2f, screenSize.height/PTM_RATIO *0.65f));
        armJointDef.enableMotor = true;
        armJointDef.enableLimit = true;
        armJointDef.motorSpeed  = -10;
        armJointDef.lowerAngle  = CC_DEGREES_TO_RADIANS(20);
        armJointDef.upperAngle  = CC_DEGREES_TO_RADIANS(75);
        armJointDef.maxMotorTorque = 500;
        armJoint = (b2RevoluteJoint*)world->CreateJoint(&armJointDef);
    armJointDef.collideConnected = false;
*/
        
    /*    //another example not working
        b2BodyDef circleBodyDef;
        
		circleBodyDef.position.Set(10,2);
    
		b2Body* circleBody = world->CreateBody(&circleBodyDef);	
        
		//b2CircleShape circleShape;
        
		circleShape.m_radius = 26.0/PTM_RATIO;
        
		b2FixtureDef circleFixtureDef;
		circleFixtureDef.shape = &circleShape;
		circleFixtureDef.density = 100.0f;
		circleFixtureDef.friction = 10.0f;
		circleFixtureDef.restitution = 0.8f;
        circleBody->CreateFixture(&circleFixtureDef);
        
		b2Vec2 anchor1 =  circleBody->GetWorldCenter();
        
        b2BodyDef teeterBodyDef;
        
		teeterBodyDef.type = b2_dynamicBody;	
        anchor1.y= anchor1.y+0.9;
		teeterBodyDef.position.Set(anchor1.x,anchor1.y);
        
        
		b2Body* teeterBody = world->CreateBody(&teeterBodyDef);	
        
		b2PolygonShape teeterShape;
        
		teeterShape.SetAsBox(5.0f,0.20f);
		b2FixtureDef teeterFixtureDef;
		teeterFixtureDef.shape = &teeterShape;
		teeterFixtureDef.density = 10.0f;
		teeterFixtureDef.friction = 10.0f;
		teeterBody->CreateFixture(&teeterFixtureDef);

        b2RevoluteJointDef jointdef1;
		b2Joint *rev1_joint;
        
		jointdef1.Initialize(teeterBody, circleBody, anchor1);
		jointdef1.collideConnected = false;
		jointdef1.lowerAngle = -b2_pi/6.0;
		jointdef1.upperAngle = b2_pi/6.0;
		jointdef1.enableLimit = true;
		jointdef1.maxMotorTorque = 50.0f;
		jointdef1.motorSpeed = 20.0f;
		jointdef1.enableMotor = TRUE;
		rev1_joint = world -> CreateJoint(&jointdef1);
*/
     
   /*
   //another example
        b2BodyDef platformBodyDef;
        float Rotation = 20.0f;
        CGPoint position = CGPointMake(240.0f, 240.0f);
        platformBodyDef.type = b2_dynamicBody;
        platformBodyDef.position.Set(position.x/PTM_RATIO, position.y/PTM_RATIO);
        platformBodyDef.angle = -CC_DEGREES_TO_RADIANS(Rotation);
        b2Body *body = world->CreateBody(&platformBodyDef);
        
        b2PolygonShape platformShape;
        platformShape.SetAsBox(2.5, 0.25);
        
        b2FixtureDef platformShapeDef;
        platformShapeDef.filter.groupIndex = -8;
        platformShapeDef.shape = &platformShape;
        platformShapeDef.density = 1.0f;
        platformShapeDef.friction = 1.0f;
        body->CreateFixture(&platformShapeDef);
        //body->SetAngularVelocity(180);
        
        ////////////////////////////////////////////////
        
        b2BodyDef centerBodyDef;
        centerBodyDef.type = b2_staticBody;
        centerBodyDef.position.Set(position.x/PTM_RATIO, position.y/PTM_RATIO);
        
        b2Body *body2 = world->CreateBody(&centerBodyDef);
        
        b2CircleShape circle;
        circle.m_radius = 0.25;
        
        b2FixtureDef ballShapeDef;
        ballShapeDef.shape = &circle;
        ballShapeDef.density = 1.0f;
        ballShapeDef.restitution = 0.01f;
        ballShapeDef.friction = 1.0f;
        body2->CreateFixture(&ballShapeDef);
        
        ////////////////////////////////////////////////
        
        b2RevoluteJointDef jointBodyDef;
        
        //b2DistanceJointDef jointBodyDef;
        jointBodyDef.bodyA = body;
        jointBodyDef.bodyB = body2;
        jointBodyDef.collideConnected = false;
        jointBodyDef.maxMotorTorque = 120.0f;
        jointBodyDef.enableMotor = TRUE;
        //jointBodyDef.enableLimit = true;
        
        b2Joint *joint = world->CreateJoint(&jointBodyDef);
   */
        
  /*      //another example not working
        
        //body and fixture defs - the common parts
        bodyDef.type = b2_dynamicBody;
        b2FixtureDef fixtureDef;
        fixtureDef.density = 1;
        
        //two shapes
        b2PolygonShape boxShape;
        boxShape.SetAsBox(2,2);
        circleShape.m_radius = 2;     
        
        //make box a little to the left
        bodyDef.position.Set(-3, 10);
        fixtureDef.shape = &boxShape;
        b2Body* m_bodyA = world->CreateBody( &bodyDef );
        m_bodyA->CreateFixture( &fixtureDef );
        
        //and circle a little to the right
        bodyDef.position.Set( 3, 10);
        fixtureDef.shape = &circleShape;
        b2Body* m_bodyB = world->CreateBody( &bodyDef );
        m_bodyB->CreateFixture( &fixtureDef );
        
        
        b2RevoluteJointDef revoluteJointDef;
        revoluteJointDef.bodyA = m_bodyA;
        revoluteJointDef.bodyB = m_bodyB;
        revoluteJointDef.collideConnected = false;
        revoluteJointDef.localAnchorA.Set(2,2);//the top right corner of the box
        revoluteJointDef.localAnchorB.Set(0,0);//center of the circle
        b2RevoluteJoint* m_joint = (b2RevoluteJoint*)world->CreateJoint( &revoluteJointDef );
        
        revoluteJointDef.enableLimit = true;
        revoluteJointDef.lowerAngle = -45 * DEGTORAD;
        revoluteJointDef.upperAngle =  45 * DEGTORAD;
        revoluteJointDef.enableMotor = true;
        revoluteJointDef.maxMotorTorque = 5;
        revoluteJointDef.motorSpeed = 90 * DEGTORAD;//90 degrees per second
        
   
   */
        [self rubeGoldberg];
        
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

- (void)rubeGoldberg {
    b2PolygonShape boxy;
    b2Body* polygon1;
 /*   
    //staticBody1
    bodyDef1.position.Set(1.379107f, 8.495184f);
    bodyDef1.angle = -0.222508f;
    b2Body* staticBody1 = world->CreateBody(&bodyDef1);
    initVel.Set(0.000000f, 0.000000f);
    staticBody1->SetLinearVelocity(initVel);
    staticBody1->SetAngularVelocity(0.000000f);
    boxy.SetAsBox(1.35f, 0.20f);
    fd.shape = &boxy;
    fd.density = 0.015000f;
    fd.friction = 0.300000f;
    fd.restitution = 0.600000f;
    fd.filter.groupIndex = int16(0);
    fd.filter.categoryBits = uint16(65535);
    fd.filter.maskBits = uint16(65535);        
    staticBody1->CreateFixture(&boxy,0);
    
    //polygon1
    bodyDef.position.Set(4.764226f, 7.320508f);
    bodyDef.angle = 0.000000f;
    polygon1 = world->CreateBody(&bodyDef);
    initVel.Set(0.000000f, 0.000000f);
    polygon1->SetLinearVelocity(initVel);
    polygon1->SetAngularVelocity(0.000000f);
    boxy.SetAsBox(1.65f, 0.35f);
    
    fd.shape = &boxy;
    fd.density = 0.015000f;
    fd.friction = 0.300000f;
    fd.restitution = 0.600000f;
    fd.filter.groupIndex = int16(0);
    fd.filter.categoryBits = uint16(65535);
    fd.filter.maskBits = uint16(65535);
    polygon1->CreateFixture(&fd);
    
    //Revolute joints
    
    pos.Set(4.764226f, 7.320508f);
    revJointDef.Initialize(polygon1, ground, pos);
    revJointDef.collideConnected = false;
    world->CreateJoint(&revJointDef);
    
    
    //circle2        
    bodyDef.position.Set(0.468085f, 9.574468f);
    bodyDef.angle = 0.000000f;        
    b2Body* circle1 = world->CreateBody(&bodyDef);
    initVel.Set(0.000000f, 0.000000f);
    circle1->SetLinearVelocity(initVel);
    circle1->SetAngularVelocity(0.000000f);
    circleShape.m_radius = 0.406489f;
    fd.shape = &circleShape;
    fd.density = 0.196374f;
    fd.friction = 0.300000f;
    fd.restitution = 0.600000f;
    fd.filter.groupIndex = int16(0);
    fd.filter.categoryBits = uint16(65535);
    fd.filter.maskBits = uint16(65535);
    circle1->CreateFixture(&fd);
*/
    //Polygons
    
    //polygon1
    bodyDef.position.Set(4.764226f, 7.320508f);
    bodyDef.angle = 0.000000f;
    polygon1 = world->CreateBody(&bodyDef);
    initVel.Set(0.000000f, 0.000000f);
    polygon1->SetLinearVelocity(initVel);
    polygon1->SetAngularVelocity(0.000000f);
    boxy.SetAsBox(1.65f, 0.35f);
    
    fd.shape = &boxy;
    fd.density = 0.015000f;
    fd.friction = 0.300000f;
    fd.restitution = 0.600000f;
    fd.filter.groupIndex = int16(0);
    fd.filter.categoryBits = uint16(65535);
    fd.filter.maskBits = uint16(65535);
    polygon1->CreateFixture(&fd);
    
    boxy.SetAsBox(0.35f,1.65f);
    fd.shape = &boxy;
    fd.density = 0.015000f;
    fd.friction = 0.300000f;
    fd.restitution = 0.600000f;
    fd.filter.groupIndex = int16(0);
    fd.filter.categoryBits = uint16(65535);
    fd.filter.maskBits = uint16(65535);
    polygon1->CreateFixture(&fd);
    
    
    //polygon2
    bodyDef.position.Set(1.779086f, 5.100423f);
    bodyDef.angle = 0.000000f;
    b2Body* polygon2 = world->CreateBody(&bodyDef);
    initVel.Set(0.000000f, 0.000000f);
    polygon2->SetLinearVelocity(initVel);
    polygon2->SetAngularVelocity(0.000000f);
    //b2PolygonShape boxy;
    boxy.SetAsBox(1.65f, 0.35f);
    
    fd.shape = &boxy;
    fd.density = 0.015000f;
    fd.friction = 0.300000f;
    fd.restitution = 0.600000f;
    fd.filter.groupIndex = int16(0);
    fd.filter.categoryBits = uint16(65535);
    fd.filter.maskBits = uint16(65535);
    polygon2->CreateFixture(&fd);
    
    boxy.SetAsBox(0.35f,1.65f);
    fd.shape = &boxy;
    fd.density = 0.015000f;
    fd.friction = 0.300000f;
    fd.restitution = 0.600000f;
    fd.filter.groupIndex = int16(0);
    fd.filter.categoryBits = uint16(65535);
    fd.filter.maskBits = uint16(65535);
    polygon2->CreateFixture(&fd);    
    
    
    //staticBody1
    bodyDef1.position.Set(1.379107f, 8.495184f);
    bodyDef1.angle = -0.222508f;
    b2Body* staticBody1 = world->CreateBody(&bodyDef1);
    initVel.Set(0.000000f, 0.000000f);
    staticBody1->SetLinearVelocity(initVel);
    staticBody1->SetAngularVelocity(0.000000f);
    boxy.SetAsBox(1.35f, 0.20f);
    fd.shape = &boxy;
    fd.density = 0.015000f;
    fd.friction = 0.300000f;
    fd.restitution = 0.600000f;
    fd.filter.groupIndex = int16(0);
    fd.filter.categoryBits = uint16(65535);
    fd.filter.maskBits = uint16(65535);        
    staticBody1->CreateFixture(&boxy,0);
    
    //staticBody2
    
    bodyDef1.position.Set(5.946951f, 2.903825f);
    bodyDef1.angle = -0.025254f;
    b2Body* staticBody2 = world->CreateBody(&bodyDef1);
    initVel.Set(0.000000f, 0.000000f);
    staticBody2->SetLinearVelocity(initVel);
    staticBody2->SetAngularVelocity(0.000000f);
    b2Vec2 staticBody2_vertices[4];
    staticBody2_vertices[0].Set(-3.053178f, -0.361702f);
    staticBody2_vertices[1].Set(3.053178f, -0.361702f);
    staticBody2_vertices[2].Set(3.053178f, 0.361702f);
    staticBody2_vertices[3].Set(-3.053178f, 0.361702f);
    shape.Set(staticBody2_vertices, 4);
    fd.shape = &shape;
    fd.density = 0.015000f;
    fd.friction = 0.300000f;
    fd.restitution = 0.600000f;
    fd.filter.groupIndex = int16(0);
    fd.filter.categoryBits = uint16(65535);
    fd.filter.maskBits = uint16(65535);
    staticBody2->CreateFixture(&shape,0);
    
    //staticBody3
    bodyDef1.position.Set(8.670213f, 1.212766f);
    bodyDef1.angle = -0.507438f;
    b2Body* staticBody3 = world->CreateBody(&bodyDef1);
    initVel.Set(0.000000f, 0.000000f);
    staticBody3->SetLinearVelocity(initVel);
    staticBody3->SetAngularVelocity(0.000000f);
    b2Vec2 staticBody3_vertices[4];
    staticBody3_vertices[0].Set(-1.521277f, -0.382979f);
    staticBody3_vertices[1].Set(1.521277f, -0.382979f);
    staticBody3_vertices[2].Set(1.521277f, 0.382979f);
    staticBody3_vertices[3].Set(-1.521277f, 0.382979f);
    shape.Set(staticBody3_vertices, 4);
    fd.shape = &shape;
    fd.density = 0.015000f;
    fd.friction = 0.300000f;
    fd.restitution = 0.600000f;
    fd.filter.groupIndex = int16(0);
    fd.filter.categoryBits = uint16(65535);
    fd.filter.maskBits = uint16(65535);
    staticBody3->CreateFixture(&shape,0);
    
    //staticBody4
    bodyDef1.position.Set(11.574468f, 2.851064f);
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
    fd.density = 0.015000f;
    fd.friction = 0.300000f;
    fd.restitution = 0.600000f;
    fd.filter.groupIndex = int16(0);
    fd.filter.categoryBits = uint16(65535);
    fd.filter.maskBits = uint16(65535);
    staticBody4->CreateFixture(&shape,0);
    
    //block
    bodyDef.position.Set(11.914894f, 0.882979f);
    bodyDef.angle = 0.000000f;
    
    // bodyDef.userData=blockSprite;
    b2Body* block = world->CreateBody(&bodyDef);
    initVel.Set(0.000000f, 0.000000f);
    block->SetLinearVelocity(initVel);
    block->SetAngularVelocity(0.000000f);
    b2Vec2 block_vertices[4];
    block_vertices[0].Set(-0.851064f, -0.840426f);
    block_vertices[1].Set(0.851064f, -0.840426f);
    block_vertices[2].Set(0.851064f, 0.840426f);
    block_vertices[3].Set(-0.851064f, 0.840426f);
    shape.Set(block_vertices, 4);
    fd.shape = &shape;
    fd.density = 0.015000f;
    fd.friction = 0.300000f;
    fd.restitution = 0.600000f;
    fd.filter.groupIndex = int16(0);
    fd.filter.categoryBits = uint16(65535);
    fd.filter.maskBits = uint16(65535);
    block->CreateFixture(&fd);
    
    //Circles
    
    //circle1
    bodyDef.position.Set(0.468085f, 9.574468f);
    bodyDef.angle = 0.000000f;    
    b2Body* circle1 = world->CreateBody(&bodyDef);
    initVel.Set(0.000000f, 0.000000f);
    circle1->SetLinearVelocity(initVel);
    circle1->SetAngularVelocity(0.000000f);
    circleShape.m_radius = 0.406489f;
    fd.shape = &circleShape;
    fd.density = 0.196374f;
    fd.friction = 0.300000f;
    fd.restitution = 0.600000f;
    fd.filter.groupIndex = int16(0);
    fd.filter.categoryBits = uint16(65535);
    fd.filter.maskBits = uint16(65535);
    circle1->CreateFixture(&fd);
    
    
    //circle2
    bodyDef.position.Set(9.361702f, 4.276596f);
    bodyDef.angle = 0.000000f;
    b2Body* circle2 = world->CreateBody(&bodyDef);
    initVel.Set(0.000000f, 0.000000f);
    circle2->SetLinearVelocity(initVel);
    circle2->SetAngularVelocity(0.000000f);
    circleShape.m_radius = 1.175038f;
    fd.shape = &circleShape;
    fd.density = 0.015000f;
    fd.friction = 0.300000f;
    fd.restitution = 0.600000f;
    fd.filter.groupIndex = int16(0);
    fd.filter.categoryBits = uint16(65535);
    fd.filter.maskBits = uint16(65535);
    circle2->CreateFixture(&fd);
    
    
    //Revolute joints
    
    pos.Set(4.764226f, 7.320508f);
    revJointDef.Initialize(polygon1, ground, pos);
    revJointDef.collideConnected = false;
    world->CreateJoint(&revJointDef);
    pos.Set(1.779086f, 5.100423f);
    revJointDef.Initialize(polygon2, ground, pos);
    revJointDef.collideConnected = false;
    world->CreateJoint(&revJointDef); 

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
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
		//[self addNewSpriteWithCoords: location];
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
