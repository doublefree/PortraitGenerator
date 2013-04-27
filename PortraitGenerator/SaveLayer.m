//
//  SaveLayer.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 4/27/13.
//
//

#import "SaveLayer.h"

@interface SaveLayer ()
@property (retain,nonatomic) UIImage* image;
@property (retain,nonatomic) Figure* figure;
@end

@implementation SaveLayer
+(CCScene *) sceneWithImage:(UIImage*)image figure:(Figure*)figure
{
    CCScene *scene = [CCScene node];
	SaveLayer *layer = [SaveLayer node];
    layer.image = image;
    layer.figure = figure;
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init]) ) {
		CGSize size = [[CCDirector sharedDirector] winSize];
	}
	return self;
}

-(void) dealloc
{
	[super dealloc];
}
@end
