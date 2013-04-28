//
//  TopLayer.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 4/27/13.
//
//

#import "TopLayer.h"
#import "PortraitLayer.h"
#import "LoadViewController.h"

@implementation TopLayer
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	TopLayer *layer = [TopLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init]) ) {
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Portrait Generator" fontName:@"Marker Felt" fontSize:36];
		CGSize size = [[CCDirector sharedDirector] winSize];
		label.position =  ccp( size.width /2 , size.height/3 * 2 );
		[self addChild: label];
        
		[CCMenuItemFont setFontSize:28];
		
		CCMenuItem *itemGenerate = [CCMenuItemFont itemWithString:@"Make New!!" block:^(id sender) {
            [self removeBanner];
			[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[PortraitLayer scene]]];
		}];
		CCMenuItem *itemGallary = [CCMenuItemFont itemWithString:@"Gallary" block:^(id sender) {
			LoadViewController* loadViewController = [[LoadViewController alloc] initWithNibName:@"LoadViewController" bundle:nil];
            AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
            
            [app.navController presentModalViewController: loadViewController animated:YES];
		}];
        
        // banner
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        bannerView_.adUnitID = GOOGLE_AD_ID;
        bannerView_.rootViewController = self;
		
		CCMenu *menu = [CCMenu menuWithItems:itemGenerate, itemGallary, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp(size.width/2, size.height/2 - 50)];
		
		[self addChild:menu];
        [self showBanner];
        
        // notification
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(loadEventReceived:) name:NOTIFICATION_LOAD_WITH_NAME object:nil];
	}
	return self;
}

- (void) loadEventReceived:(NSNotification*)center{
    NSString* name = [[center userInfo] objectForKey:@"name"];
    if ([name length] != 0) {
        [self removeBanner];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[PortraitLayer sceneWithName:name]]];
    }
}

-(void) showBanner
{
    [[[CCDirector sharedDirector] view] addSubview:bannerView_];
    [bannerView_ loadRequest:[GADRequest request]];
}

-(void) removeBanner
{
    [bannerView_ removeFromSuperview];
}
-(void) dealloc
{
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    [bannerView_ release];
	[super dealloc];
}
@end
