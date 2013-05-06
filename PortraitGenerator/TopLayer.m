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

const int TAG_TOP_MENU = 100;

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
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        // background
        CCSprite* background = [CCSprite spriteWithFile:@"background.png"];
        background.position = CGPointMake(size.width/2, size.height/2);
        [self addChild:background z:0];
        
        // menu
        CCSprite* spriteGenerate = [CCSprite spriteWithFile:@"makenewface_button.png"];
        CCSprite* spriteGenerateSelected = [CCSprite spriteWithFile:@"makenewface_button.png"];
        spriteGenerateSelected.opacity = 0x7f;
        
        CCMenuItem *itemGenerate = [CCMenuItemImage itemWithNormalSprite:spriteGenerate selectedSprite:spriteGenerateSelected block:^(id sender) {
            [self removeBanner];
			[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[PortraitLayer scene]]];
		}];
        
        CCSprite* spriteGallary = [CCSprite spriteWithFile:@"gallary_button.png"];
        CCSprite* spriteGallarySelected = [CCSprite spriteWithFile:@"gallary_button.png"];
        spriteGallarySelected.opacity = 0x7f;
        
		CCMenuItem* itemGallary = [CCMenuItemImage itemWithNormalSprite:spriteGallary selectedSprite:spriteGallarySelected block:^(id sender) {
			LoadViewController* loadViewController = [[LoadViewController alloc] initWithNibName:@"LoadViewController" bundle:nil];
            AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
            
            [app.navController presentModalViewController: loadViewController animated:YES];
		}];
        
        CCMenu *menu = [CCMenu menuWithItems:itemGenerate, itemGallary, nil];
		
		[menu alignItemsVerticallyWithPadding:30];
		[menu setPosition:ccp(size.width/2, (size.height + GAD_SIZE_320x50.height)/2)];
		
		[self addChild:menu z:10 tag:TAG_TOP_MENU];
        
        // banner
        bannerView_ = [[GADBannerView alloc]
                       initWithFrame:CGRectMake(0.0, size.height - GAD_SIZE_320x50.height, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];

        bannerView_.adUnitID = GOOGLE_AD_ID;
        bannerView_.rootViewController = self;
		
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
        [self removeChildByTag:TAG_TOP_MENU cleanup:YES]; // workaround for iphone4
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
