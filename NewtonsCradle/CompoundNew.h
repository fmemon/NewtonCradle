//
//  CompoundNew.h
//  CompoundBody
//
//  Created by Saida Memon on 3/8/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "MyContactListener.h"

// CompoundNew
@interface CompoundNew : CCLayer
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    
    b2Body* ground;
    b2BodyDef bd;
    b2BodyDef bodyDef,bodyDef1;
    b2Vec2 initVel; 
    b2PolygonShape shape;
    b2CircleShape circleShape;
    b2FixtureDef fd;
    b2RevoluteJointDef revJointDef;
    b2Vec2 pos;
    
    b2FixtureDef fixtureDef;

    b2PolygonShape boxy;

    NSMutableArray *acorns;
    NSMutableArray *sticks;
    
    b2MouseJoint *mouseJoint;
	b2Body* bulletBody;
    b2Body* bulletBody2; //reference to anchor body

    b2MouseJointDef md;
    
    MyContactListener *contactListener;
    CCSprite *acornSprite;
    b2Body* groundBody;
    
    BOOL muted;
    float spacing;
    float delta;
    
    NSMutableArray *walkAnimFrames;
}

// returns a CCScene that contains the CompoundNew as the only child
+(CCScene *) scene;
// adds a new sprite at a given coordinate
- (void) createEachPendulum2:(float)delta;
- (void)reset;
- (void)turnOnMusic;
- (CCAction*)createBlinkAnim;
- (CCAction*)createLeftHookAnim;
- (CCAction*)createRightHookAnim;
- (CCAction*)createResetAnim;
- (void)SNHit;
- (void)MRHit;
- (void)createMenu;


@end
