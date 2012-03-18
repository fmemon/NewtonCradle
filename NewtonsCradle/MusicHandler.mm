#import "MusicHandler.h"

static NSString *BOUNCE_EFFECT = @"wood.mp3";


@interface MusicHandler()
+(void) playEffect:(NSString *)path;
@end


@implementation MusicHandler

+(void) preload{
	SimpleAudioEngine *engine = [SimpleAudioEngine sharedEngine];
	if (engine) {
		[engine preloadEffect:BOUNCE_EFFECT];
	}
}


+(void) playBounce{
	[MusicHandler playEffect:BOUNCE_EFFECT];	
}


+(void) playEffect: (NSString *) path{
	[[SimpleAudioEngine sharedEngine] playEffect:path];
}
@end
