//
//  PortraitLayer.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "PortraitLayer.h"
#import "FigureSet.h"

NSString *const FACE_PATH_DEFAULT = @"face.png";
NSString *const EYE_PATH_DEFAULT = @"eye.png";
NSString *const DEFAULT_NAME = @"default";
int const TAG_PORTRAIT_FACE = 1;
int const TAG_PORTRAIT_EYE = 2;
int const TAG_MENU = 3;

@interface PortraitLayer()
@property (retain, nonatomic) NSMutableArray* spriteList;
@property (retain, nonatomic) CCSprite* selSprite;
@property (retain, nonatomic) FigureSet* figureSet;
@property (retain, nonatomic) Figure* face;
@property (retain, nonatomic) Figure* eye;
@property (retain, nonatomic) CCMenuItem* newMenu;
@property (retain, nonatomic) CCMenuItem* loadMenu;
@property (retain, nonatomic) CCMenuItem* saveMenu;
@end

@implementation PortraitLayer
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	PortraitLayer *layer = [PortraitLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init]) ) {
        self.spriteList = [[[NSMutableArray alloc] init] autorelease];
        self.figureSet = [FigureSet figureSetFromName:DEFAULT_NAME];
        
        [self drawPortrait];
        
        self.newMenu = [CCMenuItemFont itemWithString:@"new" block:^(id sender) {
            self.figureSet = [[FigureSet alloc] init];
            [self drawPortrait];
		}];
        
        self.loadMenu = [CCMenuItemFont itemWithString:@"load" block:^(id sender) {
            self.figureSet = [FigureSet figureSetFromName:DEFAULT_NAME];
            [self drawPortrait];
		}];
        
        self.saveMenu = [CCMenuItemFont itemWithString:@"save" block:^(id sender) {
            [self.figureSet saveWithName:DEFAULT_NAME];
		}];
		
		[self drawMenu];
        
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	}
	return self;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchPoint];
    return TRUE;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    if (self.selSprite) {
        CGPoint newPos = ccpAdd(self.selSprite.position, translation);
        self.selSprite.position = newPos;
        Figure* figure = self.selSprite.userData;
        figure.position = self.selSprite.position;
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.selSprite = nil;
}

-(void) selectSpriteForTouch:(CGPoint)touchLoation
{
    CCSprite* newSprite = nil;
    for (CCSprite* sprite in self.spriteList) {
        if (CGRectContainsPoint(sprite.boundingBox, touchLoation)) {
            newSprite = sprite;
        }
    }
    
    if (newSprite != self.selSprite) {
        [self.selSprite stopAllActions];
        self.selSprite = newSprite;
    }
}

- (void) drawPortrait
{
    [self removeChildByTag:TAG_PORTRAIT_FACE cleanup:YES];
    [self removeChildByTag:TAG_PORTRAIT_EYE cleanup:YES];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    // face
    self.face = [self.figureSet figureWithType:FigureTypeFace];
    if (!self.face) {
        self.face = [[Figure alloc] init];
        self.face.path = FACE_PATH_DEFAULT;
        self.face.position = CGPointMake(size.width/2, size.height/2);
        self.face.type = FigureTypeFace;
        [self.figureSet add:self.face];
    }
    
    CCSprite *faceSprite = [CCSprite spriteWithFile:self.face.path];
    faceSprite.position = self.face.position;
    faceSprite.userData = self.face;
    [self addChild:faceSprite z:0 tag:TAG_PORTRAIT_FACE];
    [self.spriteList addObject:faceSprite];
    
    // eye
    self.eye = [self.figureSet figureWithType:FigureTypeEye];
    if (!self.eye) {
        self.eye = [[Figure alloc] init];
        self.eye.path = EYE_PATH_DEFAULT;
        self.eye.position = CGPointMake(size.width/2, size.height/2);
        self.eye.type = FigureTypeEye;
        [self.figureSet add:self.eye];
    }
    
    CCSprite *eyeSprite = [CCSprite spriteWithFile:self.eye.path];
    eyeSprite.position = self.eye.position;
    eyeSprite.userData = self.eye;
    [self addChild:eyeSprite z:0 tag:TAG_PORTRAIT_EYE];
    [self.spriteList addObject:eyeSprite];
}

- (void) drawMenu
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCMenu *menu = [CCMenu menuWithItems:self.newMenu, self.loadMenu, self.saveMenu, nil];
    [menu alignItemsHorizontallyWithPadding:20];
    [menu setPosition:ccp(size.width/2, self.saveMenu.contentSize.height)];
    [self addChild:menu z:0 tag:TAG_MENU];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[super dealloc];
}
@end
