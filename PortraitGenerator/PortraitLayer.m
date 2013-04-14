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

int const TAG_MENU = 1;
int const TAG_IMAGE_CONTROL = 2;

double const SCALE_PARAM = 0.2;
double const PADDING_MENU_ITEM = 2.5f;
double const PADDING_MENU = 10.0f;

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
        
        self.background = [CCLayerColor layerWithColor:ccc4(204, 0, 102, 255)];
        [self addChild:self.background z:-1];
        
        self.nodeList = [[[NSMutableArray alloc] init] autorelease];
        self.figureSet = [FigureSet figureSetFromName:@"hoge"];
        
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
    if (self.touchedNode) {
        CGPoint newPos = ccpAdd(self.touchedNode.position, translation);
        self.touchedNode.position = newPos;
        Figure* figure = self.touchedNode.userData;
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
        Figure* figure = node.userData;
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
                newNode = node;
            }
        } else {
            for (CCSprite* sprite in [node children]) {
                CGRect spriteRect = sprite.boundingBox;
                spriteRect.origin.x = nodeRect.origin.x - spriteRect.size.width/2;
                spriteRect.origin.y = nodeRect.origin.y - spriteRect.size.height/2;
                if (CGRectContainsPoint(spriteRect, touchLoation)) {
                    newNode = node;
                }
            }
        }
    }
    
    if (newNode != self.touchedNode) {
        [self.touchedNode stopAllActions];
        self.touchedNode = newNode;
    }
}

- (void) drawPortrait
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    for (NSString* category in [Parts category]) {
        NSDictionary* config = [Parts configForCategory:category];
        int tag = [[config objectForKey:PartsKeyDataConfigTag] intValue];
        [self removeChildByTag:tag cleanup:YES];
        
        Figure* figure = [self.figureSet figureWithCategory:category];
        
        if (figure) {
            CCNode* node = [CCNode node];
            
            if (figure.isCouple) {
                CCSprite* leftBase = [CCSprite spriteWithFile:figure.base_path];
                CCSprite* rightBase = [CCSprite spriteWithFile:figure.base_path];
                rightBase.flipX = YES;
                
                CCSprite* leftFrame = [CCSprite spriteWithFile:figure.frame_path];
                CCSprite* rightFrame = [CCSprite spriteWithFile:figure.frame_path];
                rightFrame.flipX = YES;
                
                float distance = figure.distance * size.width;
                
                CGPoint leftPoint = CGPointMake(-1 * distance/2, leftBase.contentSize.height/2);
                CGPoint rightPoint = CGPointMake(distance/2, leftFrame.contentSize.height/2);

                leftBase.position = leftFrame.position = leftPoint;
                rightBase.position = rightFrame.position = rightPoint;
                
                leftBase.scaleX = rightBase.scaleX = leftFrame.scaleX = rightFrame.scaleX = 1 + (SCALE_PARAM * figure.scale);
                leftBase.scaleY = rightBase.scaleY = leftFrame.scaleY = rightFrame.scaleY = 1 + (SCALE_PARAM * figure.scale);

                [node addChild:leftBase];
                [node addChild:rightBase];
                [node addChild:leftFrame];
                [node addChild:rightFrame];
            } else {
                CCSprite* base = [CCSprite spriteWithFile:figure.base_path];
                CCSprite* frame = [CCSprite spriteWithFile:figure.frame_path];
                base.scaleX = frame.scaleX = 1 + (SCALE_PARAM * figure.scale);
                base.scaleY = frame.scaleY = 1 + (SCALE_PARAM * figure.scale);
                [node addChild:base z:-1 tag:@"base"];
                [node addChild:frame z:0 tag:@"frame"];
            }
            node.userData = figure;
            node.position = figure.position;
            
            [self.nodeList addObject:node];
            [self addChild:node z:0 tag:tag];
        }
    }
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
        if (figure.isCouple) {
            figure.distance = [[config objectForKey:PartsKeyDataConfigDistance] floatValue];
        }
        
        Figure* oldFigure = [self.figureSet figureWithCategory:self.selectedCategory];
        if (oldFigure) {
            figure.position = oldFigure.position;
        } else {
            figure.position = CGPointMake(size.width * [[config objectForKey:PartsKeyDataConfigX] doubleValue], size.height * [[config objectForKey:PartsKeyDataConfigY] doubleValue]);
        }
        
        [self.figureSet add:figure];
        [self drawPortrait];
        //[self removePartsListView];
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
    [nc addObserver:self selector:@selector(loadEventReceived:) name:NOTIFICATION_LOAD_WITH_NAME object:nil];
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
    }];
    CCMenuItemSprite *menuRotateLeft = [CCMenuItemSprite itemWithNormalSprite:normalRotateLeft selectedSprite:selectedRotateLeft block:^(id sender) {
    }];
    CCMenuItemSprite *menuMoveClose = [CCMenuItemSprite itemWithNormalSprite:normalMoveClose selectedSprite:selectedMoveClose block:^(id sender) {
        //[self saveScreenShot];
    }];
    CCMenuItemSprite *menuMoveApart = [CCMenuItemSprite itemWithNormalSprite:normalMoveApart selectedSprite:selectedMoveApart block:^(id sender) {
        ;
    }];
    CCMenuItem* menuScaleUp = [CCMenuItemSprite itemWithNormalSprite:normalScaleUp selectedSprite:selectedScaleUp block:^(id sender) {
        [self scaleUpSelectedFigure];
    }];
    CCMenuItem* menuScaleDown = [CCMenuItemSprite itemWithNormalSprite:normalScaleDown selectedSprite:selectedScaleDown block:^(id sender) {
        [self scaleDownSeletedFigure];
    }];
    
    CCMenuItem* menuColorChange = [CCMenuItemSprite itemWithNormalSprite:normalColorChange selectedSprite:selectedColorChange block:^(id sender) {
        InfColorPickerController* picker = [InfColorPickerController colorPickerViewController];
        picker.delegate = self;
        
        AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
        [app.navController presentModalViewController: picker animated:YES];
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
    
    [self addChild:nodeMenu z:0 tag:TAG_IMAGE_CONTROL];
}

- (void) removeImageControl
{
    [self removeChildByTag:TAG_IMAGE_CONTROL cleanup:YES];
}

- (void) colorPickerControllerDidFinish: (InfColorPickerController*) picker
{
    UIColor* color = picker.resultColor;
    CGFloat r, g, b, a;
    if (![color getRed:&r green:&g blue:&b alpha:&a]) {
        [color getWhite:&r alpha:&a];
        g = b = r;
    }
    self.background.color = ccc3(r*255, g*255, b*255);
    //CCLayerColor *background = [CCLayerColor layerWithColor:ccc4(r*255, g*255, b*255, a*255)];
    //[self addChild:background];
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if(!error){
        NSLog(@"no error");
    } else {
        NSLog(@"error");
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

- (void)saveScreenShot
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    [self removeImageControl];
    
    CCRenderTexture* rtx = [CCRenderTexture renderTextureWithWidth:size.width height:size.height];
    [rtx beginWithClear:0 g:0 b:0 a:1.0f];
    [[[CCDirector sharedDirector] runningScene] visit];
    [rtx end];
    
    UIImage* image = [rtx getUIImage];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:),NULL);
    
    [self showImageControl];
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
