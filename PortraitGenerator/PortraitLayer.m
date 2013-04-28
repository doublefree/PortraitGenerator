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
#import "SaveViewController.h"
#import "TopLayer.h"

int const TAG_MENU = 1;
int const TAG_IMAGE_CONTROL = 2;
int const TAG_MAIN_CONTROL = 3;
int const TAG_FRAME = 4;

double const SCALE_PARAM = 0.2;
double const DISTANCE_PARAM = 0.2;
double const PADDING_MENU_ITEM = 2.5f;
double const PADDING_MENU = 10.0f;
double const PADDING_FRAME = 30.0f;

int const ZINDEX_IMAGE_CONTROL = 1010;
int const ZINDEX_FRAME = 1000;

@interface PortraitLayer()
@property (retain, nonatomic) NSMutableArray* nodeList;
@property (retain, nonatomic) CCNode* touchedNode;
@property (retain, nonatomic) NSString* selectedCategory;
@property (retain, nonatomic) FigureSet* figureSet;
@property (retain, nonatomic) CCMenuItem* newMenu;
@property (retain, nonatomic) CCMenuItem* loadMenu;
@property (retain, nonatomic) CCMenuItem* saveMenu;
@property (retain, nonatomic) NSString* loadedName;
@property (retain, nonatomic) PartsListView* selectedPartsListView;
@property (retain, nonatomic) CCLayerColor* background;
@property (retain, nonatomic) CCSprite* frameSprite;
@property (retain, nonatomic) UITableView* partsCategoryView;
@property (retain, nonatomic) NSString* name;
@end

@implementation PortraitLayer
+(CCScene *)scene
{
	CCScene *scene = [CCScene node];
	PortraitLayer *layer = [PortraitLayer node];
	[scene addChild: layer];
	return scene;
}

+(CCScene *)sceneWithName:(NSString*)name
{
    CCScene *scene = [CCScene node];
	PortraitLayer *layer = [PortraitLayer node];
    layer.name = name;
    layer.figureSet = [FigureSet figureSetFromName:name];
    [layer drawPortrait];
	[scene addChild: layer];
	return scene;
}

-(id)init
{
	if( (self=[super init]) ) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        [self registerNotification];
        
        self.background = [CCLayerColor layerWithColor:ccc4(204, 0, 102, 255)];
        [self addChild:self.background z:-1];
        
        self.nodeList = [[[NSMutableArray alloc] init] autorelease];
        self.frameSprite = [CCSprite spriteWithFile:@"portrait_area_rect.png"];
        self.figureSet = [FigureSet figureSetFromName:@""];
        [self drawPortrait];
        
        self.partsCategoryView = [[UITableView alloc] init];
        self.partsCategoryView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        self.partsCategoryView.backgroundColor = [UIColor clearColor];
        self.partsCategoryView.frame = CGRectMake(0, size.height - 45, size.width, 45);
        PartsTableDataDelegate* partsDelegate = [[PartsTableDataDelegate alloc] init];
        self.partsCategoryView.delegate = partsDelegate;
        self.partsCategoryView.dataSource = partsDelegate;
        self.partsCategoryView.bounces = NO;
        self.partsCategoryView.separatorColor = [UIColor clearColor];
        
        [self showControls];
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
    NSDictionary* config = [Parts configForCategory:self.selectedCategory];
    BOOL fixed = [[config objectForKey:PartsKeyDataConfigFixed] boolValue];
    if (fixed) {
        return;
    }
    
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    if (self.touchedNode) {
        CGPoint newPos = ccpAdd(self.touchedNode.position, translation);
        self.touchedNode.position = newPos;
        NSString* category = self.touchedNode.userObject;
        Figure* figure = [self.figureSet figureWithCategory:category];
        figure.position = self.touchedNode.position;
        [self.figureSet add:figure];
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.touchedNode = nil;
}

-(void) selectSpriteForTouch:(CGPoint)touchLoation
{
    CCNode* newNode = nil;
    for (CCNode* node in self.nodeList) {
        NSString* category = node.userObject;
        Figure* figure = [self.figureSet figureWithCategory:category];
        CGRect nodeRect = node.boundingBox;
        if (figure.isCouple) {
            float x = 0;
            float y = 0;
            for (CCSprite* sprite in [node children]) {
                CGRect spriteRect = sprite.boundingBox;
                x = max(x, fabs(spriteRect.origin.x) + spriteRect.size.width/2);
                y = max(y, fabs(spriteRect.origin.y) + spriteRect.size.height/2);
            }
            
            nodeRect.origin.x = nodeRect.origin.x - x;
            nodeRect.size.width = x * 2;
            nodeRect.origin.y = nodeRect.origin.y - y;
            nodeRect.size.height = y * 2;
            
            if (CGRectContainsPoint(nodeRect, touchLoation)) {
                if ([self.selectedCategory isEqualToString:category]) {
                    newNode = node;
                }
            }
        } else {
            for (CCSprite* sprite in [node children]) {
                CGRect spriteRect = sprite.boundingBox;
                spriteRect.origin.x = nodeRect.origin.x - spriteRect.size.width/2;
                spriteRect.origin.y = nodeRect.origin.y - spriteRect.size.height/2;
                if (CGRectContainsPoint(spriteRect, touchLoation)) {
                    if ([self.selectedCategory isEqualToString:category]) {
                        newNode = node;
                    }
                }
            }
        }
    }
    
    if (newNode != self.touchedNode) {
        [self.touchedNode stopAllActions];
        self.touchedNode = newNode;
    }
}

- (void)drawPortrait
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    for (NSString* category in [Parts category]) {
        NSDictionary* config = [Parts configForCategory:category];
        int tag = [[config objectForKey:PartsKeyDataConfigTag] intValue];
        [self removeChildByTag:tag cleanup:YES];
        
        Figure* figure = [self.figureSet figureWithCategory:category];
        
        int rotation = 360 / FigureRotateDegree * figure.rotate;
        float scale = 1 + (SCALE_PARAM * figure.scale);
        
        if (figure) {
            CCNode* node = [CCNode node];
            if (figure.isCouple) {
                CCSprite* leftBase = [CCSprite spriteWithFile:figure.base_path];
                CCSprite* rightBase = [CCSprite spriteWithFile:figure.base_path];
                rightBase.flipX = YES;
                
                if (figure.isColored) {
                    leftBase.color = rightBase.color = ccc3(figure.red, figure.green, figure.blue);
                }
                
                // position
                float defaultDistance = [[config objectForKey:PartsKeyDataConfigDistance] floatValue];
                float distance =  defaultDistance * (1 + figure.distance * DISTANCE_PARAM) * size.width;
                CGPoint leftPoint = CGPointMake(-1 * distance/2, leftBase.contentSize.height/2);
                CGPoint rightPoint = CGPointMake(distance/2, leftBase.contentSize.height/2);
                leftBase.position = leftPoint;
                rightBase.position = rightPoint;
                
                // scale
                leftBase.scaleX = rightBase.scaleX = scale;
                leftBase.scaleY = rightBase.scaleY = scale;
                
                // rotation
                leftBase.rotation = rotation;
                rightBase.rotation = -1 * leftBase.rotation;

                [node addChild:leftBase];
                [node addChild:rightBase];
                
                if (figure.frame_path) {
                    CCSprite* leftFrame = [CCSprite spriteWithFile:figure.frame_path];
                    CCSprite* rightFrame = [CCSprite spriteWithFile:figure.frame_path];
                    rightFrame.flipX = YES;
                    
                    leftFrame.position = leftBase.position;
                    rightFrame.position = rightBase.position;
                    leftFrame.scaleX = rightFrame.scaleX = leftBase.scaleX;
                    leftFrame.scaleY = rightFrame.scaleY = leftBase.scaleY;
                    leftFrame.rotation = leftBase.rotation;
                    rightFrame.rotation = rightBase.rotation;
                    
                    [node addChild:leftFrame];
                    [node addChild:rightFrame];
                }
            } else {
                CCSprite* base = [CCSprite spriteWithFile:figure.base_path];
                
                if (figure.isColored) {
                    base.color = ccc3(figure.red, figure.green, figure.blue);
                }
                
                base.scaleX = scale;
                base.scaleY = scale;
                [node addChild:base z:-1];
                
                if (figure.frame_path) {
                    CCSprite* frame = [CCSprite spriteWithFile:figure.frame_path];
                    frame.scaleX = base.scaleX;
                    frame.scaleY = base.scaleY;
                    [node addChild:frame z:0];
                }
            }
            node.userObject = category;
            node.position = figure.position;
            
            int zindex = [[config objectForKey:PartsKeyDataConfigZindex] intValue];
            
            [self.nodeList addObject:node];
            [self addChild:node z:zindex tag:tag];
        }
    }
}

- (void) partsCategorySelected:(NSNotification*)center{
    NSString* category = [[center userInfo] objectForKey:@"category"];
    if ([category length] != 0) {
        self.selectedCategory = category;
        [self removePartsListView];
        [self showPartsListView:category];
        
        [self removeImageControl];
        [self showImageControl];
    }
}

- (void) partsSelected:(NSNotification*)center{
    NSDictionary* parts = [[center userInfo] objectForKey:@"parts"];
    if (parts) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        NSDictionary* config = [Parts configForCategory:self.selectedCategory];
        
        Figure* figure = [[Figure alloc] init];
        figure.category = self.selectedCategory;
        figure.base_path = [parts objectForKey:PartsKeyDataPartsBaseFilePath];
        figure.frame_path = [parts objectForKey:PartsKeyDataPartsFrameFilePath];
        figure.isCouple = [[config objectForKey:PartsKeyDataConfigCouple] boolValue];
        
        Figure* oldFigure = [self.figureSet figureWithCategory:self.selectedCategory];
        if (oldFigure) {
            figure.position = oldFigure.position;
        } else {
            figure.position = CGPointMake(size.width * [[config objectForKey:PartsKeyDataConfigX] doubleValue], size.height * [[config objectForKey:PartsKeyDataConfigY] doubleValue]);
        }
        
        [self.figureSet add:figure];
        [self drawPortrait];
    }
}

- (void) removePartsListView
{
    if (self.selectedPartsListView) {
        [self.selectedPartsListView removeFromSuperview];
        self.selectedPartsListView = nil;
    }
}

- (void) showPartsListView:(NSString*) category
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    UIViewController* controller;
    controller = [[UIViewController alloc] initWithNibName:@"PartsListView" bundle:nil];
    PartsListView* partsListView  = (PartsListView*)controller.view;
    partsListView.category = category;
    partsListView.frame = CGRectMake(0, size.height - 100, size.width, 50);
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
    [nc addObserver:self selector:@selector(partsCategorySelected:) name:NOTIFICATION_PARTS_CATEGORY_BUTTON_PUSHED object:nil];
    [nc addObserver:self selector:@selector(partsSelected:) name:NOTIFICATION_PARTS_BUTTON_PUSHED object:nil];
}

- (void) showImageControl
{
    // sprite for menu
    CCSprite* normalRotateRight = [CCSprite spriteWithFile:@"btn_rotate_right.png"];
    CCSprite* selectedRotateRight = [CCSprite spriteWithFile:@"btn_rotate_right.png"];
    selectedRotateRight.opacity = 0x7f;
    CCSprite* normalRotateLeft = [CCSprite spriteWithFile:@"btn_rotate_left.png"];
    CCSprite* selectedRotateLeft = [CCSprite spriteWithFile:@"btn_rotate_left.png"];
    selectedRotateLeft.opacity = 0x7f;
    
    CCSprite* normalMoveClose = [CCSprite spriteWithFile:@"btn_move_close.png"];
    CCSprite* selectedMoveClose = [CCSprite spriteWithFile:@"btn_move_close.png"];
    selectedMoveClose.opacity = 0x7f;
    CCSprite* normalMoveApart = [CCSprite spriteWithFile:@"btn_move_apart.png"];
    CCSprite* selectedMoveApart = [CCSprite spriteWithFile:@"btn_move_apart.png"];
    selectedMoveApart.opacity = 0x7f;
    
    CCSprite* normalScaleUp = [CCSprite spriteWithFile:@"btn_scale_up.png"];
    CCSprite* selectedScaleUp = [CCSprite spriteWithFile:@"btn_scale_up.png"];
    selectedScaleUp.opacity = 0x7f;
    CCSprite* normalScaleDown = [CCSprite spriteWithFile:@"btn_scale_down.png"];
    CCSprite* selectedScaleDown = [CCSprite spriteWithFile:@"btn_scale_down.png"];
    selectedScaleDown.opacity = 0x7f;
    
    CCSprite* normalColorChange = [CCSprite spriteWithFile:@"btn_color_change.png"];
    CCSprite* selectedColorChange = [CCSprite spriteWithFile:@"btn_color_change.png"];
    selectedColorChange.opacity = 0x7f;
    
    // menu item
    CCMenuItemSprite *menuRotateRight = [CCMenuItemSprite itemWithNormalSprite:normalRotateRight selectedSprite:selectedRotateRight block:^(id sender) {
        [self rotateRightSeletedFigure];
    }];
    CCMenuItemSprite *menuRotateLeft = [CCMenuItemSprite itemWithNormalSprite:normalRotateLeft selectedSprite:selectedRotateLeft block:^(id sender) {
        [self rotateLeftSeletedFigure];
    }];
    CCMenuItemSprite *menuMoveClose = [CCMenuItemSprite itemWithNormalSprite:normalMoveClose selectedSprite:selectedMoveClose block:^(id sender) {
        [self moveCloseSeletedFigure];
    }];
    CCMenuItemSprite *menuMoveApart = [CCMenuItemSprite itemWithNormalSprite:normalMoveApart selectedSprite:selectedMoveApart block:^(id sender) {
        [self moveApartSeletedFigure];
    }];
    CCMenuItem* menuScaleUp = [CCMenuItemSprite itemWithNormalSprite:normalScaleUp selectedSprite:selectedScaleUp block:^(id sender) {
        [self scaleUpSelectedFigure];
    }];
    CCMenuItem* menuScaleDown = [CCMenuItemSprite itemWithNormalSprite:normalScaleDown selectedSprite:selectedScaleDown block:^(id sender) {
        [self scaleDownSeletedFigure];
    }];
    
    CCMenuItem* menuColorChange = [CCMenuItemSprite itemWithNormalSprite:normalColorChange selectedSprite:selectedColorChange block:^(id sender) {
        [self colorChangeSeletctedFigure];
    }];
    
    // menu
    CCMenu* menuRotate = [CCMenu menuWithItems:menuRotateRight, menuRotateLeft, nil];
    [menuRotate alignItemsVerticallyWithPadding:PADDING_MENU_ITEM];
    CCMenu* menuMove = [CCMenu menuWithItems:menuMoveApart, menuMoveClose, nil];
    [menuMove alignItemsVerticallyWithPadding:PADDING_MENU_ITEM];
    CCMenu* menuScale = [CCMenu menuWithItems:menuScaleUp, menuScaleDown, nil];
    [menuScale alignItemsVerticallyWithPadding:PADDING_MENU_ITEM];
    CCMenu* menuColor = [CCMenu menuWithItems:menuColorChange, nil];
    [menuColor alignItemsVerticallyWithPadding:PADDING_MENU_ITEM];
    
    CCNode* nodeMenu = [CCNode node];
    
    if (self.selectedCategory) {
        int count = 0;
        double width = 0.0f;
        double height = 0.0f;
        NSDictionary* config = [Parts configForCategory:self.selectedCategory];
        
        {
            // calculate scale
            if ([[config objectForKey:PartsKeyDataConfigAllowScale] boolValue]) {
                count++;
                height += menuScaleUp.contentSize.height + menuScaleDown.contentSize.height;
                width = max(width, max(menuScaleUp.contentSize.width, menuScaleDown.contentSize.width));
            }
            if ([[config objectForKey:PartsKeyDataConfigAllowRotate] boolValue]) {
                count++;
                height += menuRotateRight.contentSize.height + menuRotateLeft.contentSize.height;
                width = max(width, max(menuRotateRight.contentSize.width, menuRotateLeft.contentSize.width));
            }
            if ([[config objectForKey:PartsKeyDataConfigAllowMove] boolValue]) {
                count++;
                height += menuMoveApart.contentSize.height + menuMoveClose.contentSize.height;
                width = max(width, max(menuMoveApart.contentSize.width, menuMoveClose.contentSize.width));
            }
            if ([[config objectForKey:PartsKeyDataConfigAllowColor] boolValue]) {
                count++;
                height += menuColorChange.contentSize.height;
                width = max(width, menuColorChange.contentSize.width);
            }
        }
        {
            // actual deployment
            CGSize size = [[CCDirector sharedDirector] winSize];
            height = height + PADDING_MENU * (count - 1);
            double x = size.width - (width/2 + PADDING_MENU_ITEM);
            double hightUsed = 0.0f;
            double yTop = size.height/2 + height/2;
            
            if ([[config objectForKey:PartsKeyDataConfigAllowColor] boolValue]) {
                double partsHeight = menuColorChange.contentSize.height;
                menuColor.position = ccp(x, yTop - hightUsed - partsHeight/2);
                hightUsed += partsHeight + PADDING_MENU;
                
                [nodeMenu addChild:menuColor];
            }
            
            if ([[config objectForKey:PartsKeyDataConfigAllowMove] boolValue]) {
                double partsHeight = menuMoveApart.contentSize.height + menuMoveClose.contentSize.height;
                menuMove.position = ccp(x, yTop - hightUsed - partsHeight/2);
                hightUsed += partsHeight + PADDING_MENU;
                
                [nodeMenu addChild:menuMove];
            }
            
            if ([[config objectForKey:PartsKeyDataConfigAllowRotate] boolValue]) {
                double partsHeight = menuRotateRight.contentSize.height + menuRotateLeft.contentSize.height;
                menuRotate.position = ccp(x, yTop - hightUsed - partsHeight/2);
                hightUsed += partsHeight + PADDING_MENU;
                
                [nodeMenu addChild:menuRotate];
            }

            if ([[config objectForKey:PartsKeyDataConfigAllowScale] boolValue]) {
                double partsHeight = menuScaleUp.contentSize.height + menuScaleDown.contentSize.height;
                menuScale.position = ccp(x, yTop - hightUsed - partsHeight/2);
                hightUsed += partsHeight + PADDING_MENU;
                
                [nodeMenu addChild:menuScale];
            }
        }
    }
    
    [self addChild:nodeMenu z:ZINDEX_IMAGE_CONTROL tag:TAG_IMAGE_CONTROL];
}

- (void)removeImageControl
{
    [self removeChildByTag:TAG_IMAGE_CONTROL cleanup:YES];
}

- (void)showMainControl
{
    CCSprite* normalBack = [CCSprite spriteWithFile:@"btn_back.png"];
    CCSprite* selectedBack = [CCSprite spriteWithFile:@"btn_back.png"];
    selectedBack.opacity = 0x7f;
    CCSprite* normalSave = [CCSprite spriteWithFile:@"btn_save.png"];
    CCSprite* selectedSave = [CCSprite spriteWithFile:@"btn_save.png"];
    selectedSave.opacity = 0x7f;
    
    CCMenuItemSprite *menuBack = [CCMenuItemSprite itemWithNormalSprite:normalBack selectedSprite:selectedBack block:^(id sender) {
        [self removeControls];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TopLayer scene]]];
    }];
    CCMenuItemSprite *menuSave = [CCMenuItemSprite itemWithNormalSprite:normalSave selectedSprite:selectedSave block:^(id sender) {
        [self launchSaveDialog];
    }];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCMenu* menu = [CCMenu menuWithItems:menuBack, menuSave, nil];
    [menu alignItemsHorizontallyWithPadding:20];
    
    float height = menuSave.contentSize.height;
    menu.position = CGPointMake(size.width/2, size.height - height / 3 * 2);
    
    [self addChild:menu];
}

- (void)removeMainControl
{
    [self removeChildByTag:TAG_MAIN_CONTROL cleanup:YES];
}

- (void)colorChangeSeletctedFigure
{
    InfColorPickerController* picker = [InfColorPickerController colorPickerViewController];
    picker.delegate = self;
    
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [app.navController presentModalViewController: picker animated:YES];
}

- (void) colorPickerControllerDidFinish: (InfColorPickerController*) picker
{
    Figure* figure = [self.figureSet figureWithCategory:self.selectedCategory];
    if (figure && figure) {
        UIColor* color = picker.resultColor;
        CGFloat r, g, b, a;
        if (![color getRed:&r green:&g blue:&b alpha:&a]) {
            [color getWhite:&r alpha:&a];
            g = b = r;
        }
        figure.isColored = true;
        figure.red = r * 255;
        figure.green = g * 255;
        figure.blue = b * 255;
        
        [self drawPortrait];
    }
}

- (void)scaleUpSelectedFigure
{
    Figure* figure = [self.figureSet figureWithCategory:self.selectedCategory];
    if (figure && figure) {
        figure.scale = min(figure.scale+1, FigureScaleMax);
        [self.figureSet add:figure];
        [self drawPortrait];
    }
}

- (void)scaleDownSeletedFigure
{
    Figure* figure = [self.figureSet figureWithCategory:self.selectedCategory];
    if (figure && figure) {
        figure.scale = max(figure.scale-1, FigureScaleMin);
        [self.figureSet add:figure];
        [self drawPortrait];
    }
}

- (void)moveApartSeletedFigure
{
    Figure* figure = [self.figureSet figureWithCategory:self.selectedCategory];
    if (figure && figure) {
        figure.distance = min(figure.distance+1, FigureDistanceMax);
        [self.figureSet add:figure];
        [self drawPortrait];
    }
}

- (void)moveCloseSeletedFigure
{
    Figure* figure = [self.figureSet figureWithCategory:self.selectedCategory];
    if (figure && figure) {
        figure.distance = max(figure.distance-1, FigureDistanceMin);
        [self.figureSet add:figure];
        [self drawPortrait];
    }
}

- (void)rotateRightSeletedFigure
{
    Figure* figure = [self.figureSet figureWithCategory:self.selectedCategory];
    if (figure && figure) {
        figure.rotate++;
        [self.figureSet add:figure];
        [self drawPortrait];
    }
}

- (void)rotateLeftSeletedFigure
{
    Figure* figure = [self.figureSet figureWithCategory:self.selectedCategory];
    if (figure && figure) {
        figure.rotate--;
        [self.figureSet add:figure];
        [self drawPortrait];
    }
}

- (void)launchSaveDialog
{
    UIImage* image = [self croppedPortraitImage];
    SaveViewController* saveViewController = [[SaveViewController alloc] initWithNibName:@"SaveViewController" bundle:nil image:image figureSet:self.figureSet name:self.name];
    UIView* view = [[CCDirector sharedDirector] view];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:view cache:YES];
    [view addSubview:saveViewController.view];
    [UIView commitAnimations];
    
}

- (UIImage*)croppedPortraitImage
{
    [self removeControls];
    CGSize size = [[CCDirector sharedDirector] winSize];
    float h = self.frameSprite.contentSize.height;
    float w = self.frameSprite.contentSize.width;
    float x = self.frameSprite.position.x - w/2;
    float y = size.height - (self.frameSprite.position.y + h/2);
    
    CGRect rect;
    if([[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
        rect = CGRectMake(x*2,y*2,w*2,h*2);
    } else {
        rect = CGRectMake(x,y,w,h);
    }
    
    CCRenderTexture* rtx = [CCRenderTexture renderTextureWithWidth:size.width height:size.height];
    [rtx beginWithClear:0 g:0 b:0 a:1.0f];
    [[[CCDirector sharedDirector] runningScene] visit];
    [rtx end];
    
    UIImage* image = [rtx getUIImage];
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *cropped =[UIImage imageWithCGImage:imageRef];
    
    [self showControls];
    
    return cropped;
}

- (void)showPortraitFrame
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    self.frameSprite.position = CGPointMake(size.width/2, size.height/2 + PADDING_FRAME);
    [self addChild:self.frameSprite z:ZINDEX_FRAME tag:TAG_FRAME];
}

- (void)removePortraitFrame
{
    [self removeChildByTag:TAG_FRAME cleanup:YES];
}

- (void)showPartsCategoryView
{
    [[[CCDirector sharedDirector] view] addSubview:self.partsCategoryView];
}

- (void)removePartsCategoryView
{
    [self.partsCategoryView removeFromSuperview];
}

- (void)showControls
{
    [self showImageControl];
    [self showMainControl];
    [self showPortraitFrame];
    [self showPartsCategoryView];
}

- (void)removeControls
{
    [self removeImageControl];
    [self removeMainControl];
    [self removePortraitFrame];
    [self removePartsCategoryView];
    [self removePartsListView];
}

- (void)notifySelectedCategoryChanged
{
    NSDictionary* dictionary = [NSDictionary dictionaryWithObject:self.selectedCategory forKey:@"category"];
    NSNotification* nc = [NSNotification notificationWithName:NOTIFICATION_SELECTED_CATEGORY_CHANGED object:self userInfo:dictionary];
    [[NSNotificationCenter defaultCenter] postNotification:nc];
}

- (void) dealloc
{
	[super dealloc];
}
@end
