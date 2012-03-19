#import "MyContactListener.h"
#import "cocos2d.h"

MyContactListener::MyContactListener() : _contacts() {
}

MyContactListener::~MyContactListener() {
}

void MyContactListener::BeginContact(b2Contact* contact) {
    
  /*  b2Body* bodyA = contact->GetFixtureA()->GetBody();
	b2Body* bodyB = contact->GetFixtureB()->GetBody();
	CCSprite* spriteA = (CCSprite*)bodyA->GetUserData();
	CCSprite* spriteB = (CCSprite*)bodyB->GetUserData();
	
	if (spriteA != NULL && spriteB != NULL)
	{
		spriteA.color = ccMAGENTA;
		spriteB.color = ccMAGENTA;
	}
   
   */
    // We need to copy out the data because the b2Contact passed in
    // is reused.
    MyContact myContact = { contact->GetFixtureA(), contact->GetFixtureB() };
    _contacts.push_back(myContact);
}

void MyContactListener::EndContact(b2Contact* contact)
    {
   /*     b2Body* bodyA = contact->GetFixtureA()->GetBody();
        b2Body* bodyB = contact->GetFixtureB()->GetBody();
        CCSprite* spriteA = (CCSprite*)bodyA->GetUserData();
        CCSprite* spriteB = (CCSprite*)bodyB->GetUserData();
        
        if (spriteA != NULL && spriteB != NULL)
        {
            spriteA.color = ccWHITE;
            spriteB.color = ccWHITE;
        }
    
    */
    MyContact myContact = { contact->GetFixtureA(), contact->GetFixtureB() };
    std::vector<MyContact>::iterator pos;
    pos = std::find(_contacts.begin(), _contacts.end(), myContact);
    if (pos != _contacts.end()) {
        _contacts.erase(pos);
    }
}

void MyContactListener::PreSolve(b2Contact* contact, 
                                 const b2Manifold* oldManifold) {
}

void MyContactListener::PostSolve(b2Contact* contact, 
                                  const b2ContactImpulse* impulse) {
}