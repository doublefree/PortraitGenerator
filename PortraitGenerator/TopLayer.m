//
//  TopLayer.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 4/27/13.
//
//

#import "TopLayer.h"
#import "PortraitLayer.h"

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
			;
		}];
        
        // banner
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        bannerView_.adUnitID = @"a1517b36c098dbe";
        bannerView_.rootViewController = self;
		
		CCMenu *menu = [CCMenu menuWithItems:itemGenerate, itemGallary, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		[self addChild:menu];
        [self showBanner];
	}
	return self;
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
    [bannerView_ release];
	[super dealloc];
}
@end
