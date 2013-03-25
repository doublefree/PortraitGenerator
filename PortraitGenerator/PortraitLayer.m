//
//  PortraitLayer.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "PortraitLayer.h"
#import "Portrait.h"
#import "FigureSet.h"
#import "LoadViewController.h"
#import "PartsTableDataDelegate.h"
#import "Parts.h"
#import "PartsListView.h"

NSString *const FACE_PATH_DEFAULT = @"face.png";
NSString *const EYE_PATH_DEFAULT = @"eye.png";
NSString *const DEFAULT_NAME = @"default";
int const TAG_PORTRAIT_FACE = 1;
int const TAG_PORTRAIT_EYE = 2;
int const TAG_MENU = 3;
int const TAG_IMAGE_CONTROL = 4;

@interface PortraitLayer()
@property (retain, nonatomic) NSMutableArray* spriteList;
@property (retain, nonatomic) CCSprite* selSprite;
@property (retain, nonatomic) NSString* selectedCategory;
@property (retain, nonatomic) FigureSet* figureSet;
@property (retain, nonatomic) Figure* face;
@property (retain, nonatomic) Figure* eye;
@property (retain, nonatomic) CCMenuItem* newMenu;
@property (retain, nonatomic) CCMenuItem* loadMenu;
@property (retain, nonatomic) CCMenuItem* saveMenu;
@property (retain, nonatomic) NSString* loadedName;
@property (retain, nonatomic) PartsListView* selectedPartsListView;
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
        CGSize size = [[CCDirector sharedDirector] winSize];
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        [self registerNotification];
        
        CCLayerColor *background = [CCLayerColor layerWithColor:ccc4(204, 0, 102, 255)];
        [self addChild:background z:-1];
        
        self.spriteList = [[[NSMutableArray alloc] init] autorelease];
        self.figureSet = [FigureSet figureSetFromName:DEFAULT_NAME];
        
        [self drawPortrait];
        
        /*
        self.newMenu = [CCMenuItemFont itemWithString:@"new" block:^(id sender) {
            self.figureSet = [[FigureSet alloc] init];
            self.loadedName = @"";
            [self drawPortrait];
		}];
        
        self.loadMenu = [CCMenuItemFont itemWithString:NSLocalizedString(@"list", "label for list") block:^(id sender) {
            LoadViewController* loadViewController = [[LoadViewController alloc] initWithNibName:@"LoadViewController" bundle:nil];
            AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
            
            [app.navController presentModalViewController: loadViewController animated:YES];
		}];
        
        self.saveMenu = [CCMenuItemFont itemWithString:NSLocalizedString(@"save", "label for save") block:^(id sender) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"save", "label for save") message:NSLocalizedString(@"save_message", "label for save") delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            UITextField *textField = [alert textFieldAtIndex:0];
            textField.text = self.loadedName;
            [alert show];
		}];
		
		[self drawMenu];
        */
        
        UITableView* partsCategoryView = [[UITableView alloc] init];
        partsCategoryView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        partsCategoryView.backgroundColor = [UIColor clearColor];
        partsCategoryView.frame = CGRectMake(0, size.height - 45, size.width, 45);
        PartsTableDataDelegate* partsDelegate = [[PartsTableDataDelegate alloc] init];
        partsCategoryView.delegate = partsDelegate;
        partsCategoryView.dataSource = partsDelegate;
        partsCategoryView.bounces = NO;
        partsCategoryView.separatorColor = [UIColor clearColor];
        [[[CCDirector sharedDirector] view] addSubview:partsCategoryView];
        
        [self showImageControl];
    }
	return self;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSString* name = [[alertView textFieldAtIndex:0] text];
        [Portrait add:self.figureSet withName:name];
    }
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
    faceSprite.color = ccc3(100, 100, 100);
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

- (void) loadWithName:(NSString*)name
{
    self.figureSet = [FigureSet figureSetFromName:name];
    self.loadedName = name;
    [self drawPortrait];
}

- (void) loadEventReceived:(NSNotification*)center{
    NSString* name = [[center userInfo] objectForKey:@"name"];
    if ([name length] != 0) {
        [self loadWithName:name];
    }
}

- (void) partsCategorySelected:(NSNotification*)center{
    NSString* category = [[center userInfo] objectForKey:@"category"];
    if ([category length] != 0) {
        self.selectedCategory = category;
        [self removePartsListView];
        NSArray* partsList = [Parts listWithCategory:category];
        [self showPartsListView:partsList];
    }
}

- (void) partsSelected:(NSNotification*)center{
    NSString* parts = [[center userInfo] objectForKey:@"parts"];
    if ([parts length] != 0) {
        NSLog(@"parts:%@", parts);
        [self removePartsListView];
    }
}

- (void) removePartsListView
{
    if (self.selectedPartsListView) {
        [self.selectedPartsListView removeFromSuperview];
        self.selectedPartsListView = nil;
    }
}

- (void) showPartsListView:(NSArray*) partsList
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    UIViewController* controller;
    controller = [[UIViewController alloc] initWithNibName:@"PartsListView" bundle:nil];
    PartsListView* partsListView  = (PartsListView*)controller.view;
    partsListView.partsList = partsList;
    partsListView.frame = CGRectMake(0, size.height - 80, size.width, 50);
    partsListView.tableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    partsListView.tableView.frame = CGRectMake(0,0,size.width, 46);
    partsListView.tableView.bounces = NO;
    partsListView.tableView.separatorColor = [UIColor clearColor];
    partsListView.tableView.delegate = partsListView;
    partsListView.tableView.dataSource = partsListView;
    partsListView.tableView.backgroundColor = [UIColor clearColor];
    partsListView.tableView.showsVerticalScrollIndicator = NO;
    
    [[[CCDirector sharedDirector] view] addSubview:partsListView];
    [partsListView.tableView reloadData];
    
    self.selectedPartsListView = partsListView;
}

- (void) registerNotification
{
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(loadEventReceived:) name:NOTIFICATION_LOAD_WITH_NAME object:nil];
    [nc addObserver:self selector:@selector(partsCategorySelected:) name:NOTIFICATION_PARTS_CATEGORY_BUTTON_PUSHED object:nil];
    [nc addObserver:self selector:@selector(partsSelected:) name:NOTIFICATION_PARTS_BUTTON_PUSHED object:nil];
}

- (void) showImageControl
{
    // image control
    CCSprite *normalRotateRight = [CCSprite spriteWithFile:@"btn_rotate_right.png"];
    CCSprite *selectedRotateRight = [CCSprite spriteWithFile:@"btn_rotate_right.png"];
    selectedRotateRight.opacity = 0x7f;
    CCSprite *normalRotateLeft = [CCSprite spriteWithFile:@"btn_rotate_right.png"];
    CCSprite *selectedRotateLeft = [CCSprite spriteWithFile:@"btn_rotate_right.png"];
    selectedRotateLeft.opacity = 0x7f;
    CCSprite *normalMoveClose = [CCSprite spriteWithFile:@"btn_rotate_right.png"];
    CCSprite *selectedMoveClose = [CCSprite spriteWithFile:@"btn_rotate_right.png"];
    selectedMoveClose.opacity = 0x7f;
    CCSprite *normalMoveApart = [CCSprite spriteWithFile:@"btn_rotate_right.png"];
    CCSprite *selectedMoveApart = [CCSprite spriteWithFile:@"btn_rotate_right.png"];
    selectedMoveApart.opacity = 0x7f;
    
    CCMenuItemSprite *menuRotateRight = [CCMenuItemSprite itemWithNormalSprite:normalRotateRight selectedSprite:selectedRotateRight block:^(id sender) {;}];
    CCMenuItemSprite *menuRotateLeft = [CCMenuItemSprite itemWithNormalSprite:normalRotateLeft selectedSprite:selectedRotateLeft block:^(id sender) {;}];
    CCMenuItemSprite *menuMoveClose = [CCMenuItemSprite itemWithNormalSprite:normalMoveClose selectedSprite:selectedMoveClose block:^(id sender) {;}];
    CCMenuItemSprite *menuMoveApart = [CCMenuItemSprite itemWithNormalSprite:normalMoveApart selectedSprite:selectedMoveApart block:^(id sender) {;}];
    CCMenu *menu = [CCMenu menuWithItems:menuRotateRight, menuRotateLeft, menuMoveClose, menuMoveApart, nil];
    [menu alignItemsVerticallyWithPadding:10.0f];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    menu.position = ccp(size.width - normalRotateRight.contentSize.width * 0.7, size.height / 2);
    
    
    [self addChild:menu z:0 tag:TAG_IMAGE_CONTROL];
}

- (void) removeImageControl
{
    [self removeChildByTag:TAG_IMAGE_CONTROL cleanup:YES];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[super dealloc];
}

/*
 - (void) drawMenu
 {
 CGSize size = [[CCDirector sharedDirector] winSize];
 CCMenu *menu = [CCMenu menuWithItems:self.newMenu, self.loadMenu, self.saveMenu, nil];
 [menu alignItemsHorizontallyWithPadding:20];
 [menu setPosition:ccp(size.width/2, self.saveMenu.contentSize.height)];
 [self addChild:menu z:0 tag:TAG_MENU];
 }
 */
@end
