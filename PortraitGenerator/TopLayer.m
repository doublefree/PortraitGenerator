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

@interface TopLayer()
@property (retain,nonatomic) LoadViewController* loadViewController;
@end

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
        
        // logo
        CCSprite* logo = [CCSprite spriteWithFile:@"logo.png"];
        logo.position = CGPointMake(size.width/2, size.height/2 + 70);
        [self addChild:logo z:1];
        
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
            UIView* view = [[CCDirector sharedDirector] view];
			self.loadViewController = [[LoadViewController alloc] initWithNibName:@"LoadViewController" bundle:nil];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.7];
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:view cache:YES];
            
            [view addSubview:self.loadViewController.view];
            [UIView commitAnimations];
		}];
        
        CCMenu *menu = [CCMenu menuWithItems:itemGallary, itemGenerate, nil];
		
		[menu alignItemsHorizontallyWithPadding:7];
		[menu setPosition:ccp(size.width/2, GAD_SIZE_320x50.height + itemGallary.contentSize.height/2 + 30)];
		
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
        //[self.loadViewController dismissModalViewControllerAnimated:YES];
        [self.loadViewController.view removeFromSuperview];
        
        [self removeBanner];
        [self removeChildByTag:TAG_TOP_MENU cleanup:YES]; // workaround for iphone4
        CCScene* scene = [PortraitLayer sceneWithName:name];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene]];
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
