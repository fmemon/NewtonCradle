//
//  HelloWorldLayer.h
//  NewtonsCradle
//
//  Created by Saida Memon on 3/17/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    
    float angle;
    b2Body * rotating_body;
    
    b2Body* ground;
    b2BodyDef bd;
    b2BodyDef bodyDef,bodyDef1;
    b2Vec2 initVel;
    b2PolygonShape shape;
    b2CircleShape circleShape;
    b2FixtureDef fd;
    b2RevoluteJointDef revJointDef;
    b2DistanceJointDef jointDef;
    b2Vec2 pos;

}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
// adds a new sprite at a given coordinate
- (void)rubeGoldberg;

@end
