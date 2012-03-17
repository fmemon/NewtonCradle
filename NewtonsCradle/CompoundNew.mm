//
//  CompoundNew.mm
//  CompoundBody
//
//  Created by Saida Memon on 3/8/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "CompoundNew.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32
//#define PTM_RATIO 15
#define CompoundNewNUMBER 2 // Initial CompoundNew number
#define STAIRNUMBER 7   // Number of stairs
// World gravity.
#define WORLDGRAVITY 20.0f

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
        
        // Debug Draw functions
        m_debugDraw = new GLESDebugDraw( PTM_RATIO );
        world->SetDebugDraw(m_debugDraw); 
        uint32 flags = 0;
        flags += b2DebugDraw::e_shapeBit;
        m_debugDraw->SetFlags(flags);  
        
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

        
		//Set up sprite
        anchors = [[NSMutableArray alloc] initWithCapacity:4];
        
        //[self rubeGoldberg2];
        [self rubeGoldberg3];

        [self schedule: @selector(tick:)]; 
    }
    
    return self; 
    
}

- (void)rubeGoldberg3 {

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
    
    //Circles
    //Big Ball
    bodyDef.position.Set(0.468085f, 9.574468f);
    bodyDef.angle = 0.000000f;
    b2Body* circle2 = world->CreateBody(&bodyDef);
    [anchors addObject:[NSValue valueWithPointer:circle2]];

    initVel.Set(0.000000f, 0.000000f);
    circle2->SetLinearVelocity(initVel);
    circle2->SetAngularVelocity(0.000000f);
    circleShape.m_radius = 0.75f;
    fd.shape = &circleShape;
    fd.density = 1.0f;
    fd.friction = 0.300000f;
    fd.restitution = 0.600000f;
    fd.filter.groupIndex = int16(0);
    fd.filter.categoryBits = uint16(65535);
    fd.filter.maskBits = uint16(65535);
    circle2->CreateFixture(&fd);
    
    //[self createEachPendulum:10.0f];
    [self createEachPendulum2:10.0f];
    //[self addNewSpriteWithCoords:CGPointMake(240.0f, 240.0f)];

}

- (void) createEachPendulum2:(float)delta {
    
    float spacing = 1.0f;
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    for (int i=0; i<4; i++) {
        
        //sticks
        bodyDef.position.Set(4.764226f+ (spacing*i), 7.320508f);
        bodyDef.angle = 0.000000f;
        b2Body* polygon1 = world->CreateBody(&bodyDef);
        initVel.Set(0.000000f, 0.000000f);
        polygon1->SetLinearVelocity(initVel);
        polygon1->SetAngularVelocity(0.000000f);
        
        boxy.SetAsBox(0.05f,1.65f);
        fd.shape = &boxy;
        fd.density = 0.015000f;
        fd.friction = 0.300000f;
        fd.restitution = 0.600000f;
        fd.filter.groupIndex = int16(0);
        fd.filter.categoryBits = uint16(65535);
        fd.filter.maskBits = uint16(65535);
        polygon1->CreateFixture(&fd);

        //Circles
        bodyDef.position.Set(polygon1->GetWorldCenter().x, polygon1->GetWorldCenter().y -0.75f -1.65f*0.5f);
        bodyDef.angle = 0.000000f;
        b2Body* circle1 = world->CreateBody(&bodyDef);
        initVel.Set(0.000000f, 0.000000f);
        circle1->SetLinearVelocity(initVel);
        circle1->SetAngularVelocity(0.000000f);
        circleShape.m_radius = 0.5f;
        fd.shape = &circleShape;
        fd.density = 1.0;
        fd.friction = 0.300000f;
        fd.restitution = 0.600000f;
        fd.filter.groupIndex = int16(0);
        fd.filter.categoryBits = uint16(65535);
        fd.filter.maskBits = uint16(65535);
        circle1->CreateFixture(&fd);

        
        //turns
        //Revolute joints
        pos.Set(4.764226f+ (spacing*i), 9.320508f);
        revJointDef.Initialize(polygon1, ground, pos);
        revJointDef.collideConnected = false;
        world->CreateJoint(&revJointDef);
        
        pos.Set(polygon1->GetWorldCenter().x, polygon1->GetWorldCenter().y -0.75f - 1.65f*0.5f);
        revJointDef.Initialize(polygon1, circle1, pos);
        revJointDef.collideConnected = false;
        world->CreateJoint(&revJointDef);
        
    }
    /*
    
    bodyDef.position.Set(4.764226f, 7.320508f);
    bodyDef.angle = 0.000000f;
    b2Body* polygon1 = world->CreateBody(&bodyDef);
    initVel.Set(0.000000f, 0.000000f);
    polygon1->SetLinearVelocity(initVel);
    polygon1->SetAngularVelocity(0.000000f);
    
    boxy.SetAsBox(0.05f,1.65f);
    fd.shape = &boxy;
    fd.density = 0.015000f;
    fd.friction = 0.300000f;
    fd.restitution = 0.600000f;
    fd.filter.groupIndex = int16(0);
    fd.filter.categoryBits = uint16(65535);
    fd.filter.maskBits = uint16(65535);
    polygon1->CreateFixture(&fd);
    
    //Circles
    bodyDef.position.Set(polygon1->GetWorldCenter().x, polygon1->GetWorldCenter().y -0.75f -1.65f*0.5f);
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
    
    
    //Revolute joints
    pos.Set(4.764226f, 9.320508f);
    revJointDef.Initialize(polygon1, ground, pos);
    revJointDef.collideConnected = false;
    world->CreateJoint(&revJointDef);
    
    pos.Set(polygon1->GetWorldCenter().x, polygon1->GetWorldCenter().y -0.75f - 1.65f*0.5f);
    revJointDef.Initialize(polygon1, circle1, pos);
    revJointDef.collideConnected = false;
    world->CreateJoint(&revJointDef);
     */
}


-(void) addNewSpriteWithCoords:(CGPoint)p
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    for (int i=0; i<4; i++) {
        
        p = CGPointMake(120.0f + (40*i), p.y);
        b2BodyDef anchorBodyDef;
        anchorBodyDef.position.Set(p.x/PTM_RATIO,screenSize.height/PTM_RATIO*0.9f); //center body on screen
        world->CreateBody(&anchorBodyDef);
        
        bodyDef.type = b2_dynamicBody;
        
        bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
        b2Body *body = world->CreateBody(&bodyDef);
        //[anchors addObject:[NSValue valueWithPointer:body]];
        
        // Define another box shape for our dynamic body.
        //b2PolygonShape dynamicBox;
        //dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box
        
        b2CircleShape dynamicBox;
        dynamicBox.m_radius = 18.0/PTM_RATIO;
        
        // Define the dynamic body fixture.
        fixtureDef.shape = &dynamicBox;	
        fixtureDef.density = 1.0f;
        fixtureDef.friction = 0.1f;
        fixtureDef.restitution = 1.0f;
        body->CreateFixture(&fixtureDef);


    }
}


- (void) createEachPendulum:(float)delta {
    
    float spacing = 1.5f;
    for (int i = 0; i < 2; i++) {
        //polygon1
        bodyDef.position.Set(4.764226f + i*spacing, 7.320508f);
        bodyDef.angle = 0.000000f;
        b2Body* polygon1 = world->CreateBody(&bodyDef);
        initVel.Set(0.000000f, 0.000000f);
        polygon1->SetLinearVelocity(initVel);
        polygon1->SetAngularVelocity(0.000000f);
        
        boxy.SetAsBox(0.05f,1.65f);
        fd.shape = &boxy;
        fd.density = 0.015000f;
        fd.friction = 0.300000f;
        fd.restitution = 0.600000f;
        fd.filter.groupIndex = int16(0);
        fd.filter.categoryBits = uint16(65535);
        fd.filter.maskBits = uint16(65535);
        polygon1->CreateFixture(&fd);
        
        //Circles
        bodyDef.position.Set(polygon1->GetWorldCenter().x, polygon1->GetWorldCenter().y -0.75f -1.65f*0.5f);
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
        
        
        //Revolute joints
        pos.Set(4.764226f, 9.320508f+i*spacing);
        revJointDef.Initialize(polygon1, ground, pos);
        revJointDef.collideConnected = false;
        world->CreateJoint(&revJointDef);
        
        pos.Set(polygon1->GetWorldCenter().x, polygon1->GetWorldCenter().y -0.75f - 1.65f*0.5f);
        revJointDef.Initialize(polygon1, circle1, pos);
        revJointDef.collideConnected = false;
        world->CreateJoint(&revJointDef);
        
    }


}
/*
- (void)rubeGoldberg2 {
    
    //Polygons
    
    //polygon1
    bodyDef.position.Set(4.764226f, 7.320508f);
    bodyDef.angle = 0.000000f;
    b2Body* polygon1 = world->CreateBody(&bodyDef);
    initVel.Set(0.000000f, 0.000000f);
    polygon1->SetLinearVelocity(initVel);
    polygon1->SetAngularVelocity(0.000000f);
    b2PolygonShape boxy;
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

    //Circles
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

- (void)rubeGoldberg {
    
    //Polygons
    
    //polygon1
    bodyDef.position.Set(4.764226f, 7.320508f);
    bodyDef.angle = 0.000000f;
    b2Body* polygon1 = world->CreateBody(&bodyDef);
    initVel.Set(0.000000f, 0.000000f);
    polygon1->SetLinearVelocity(initVel);
    polygon1->SetAngularVelocity(0.000000f);
    b2PolygonShape boxy;
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


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (mouseJoint != nil) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
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
    
    //[[SimpleAudioEngine sharedEngine] playEffect: @"wood.wav"];
    
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
