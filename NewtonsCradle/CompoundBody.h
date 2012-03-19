//
//  CompoundBody.h
//  CompoundBody
//
//  Created by Saida Memon on 3/8/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

// CompoundBody
@interface CompoundBody : CCLayer
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
}

// returns a CCScene that contains the CompoundBody as the only child
+(CCScene *) scene;
// adds a new sprite at a given coordinate
-(void) addNewSpriteWithCoords:(CGPoint)p;
- (void)moveWheels;


@end
