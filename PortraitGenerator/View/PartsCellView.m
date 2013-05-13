//
//  PartsCellView.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/24/13.
//
//

#import "AppDelegate.h"
#import "PartsCellView.h"
#import "Parts.h"
#import "cocos2d.h"

@interface PartsCellView()
@property (retain, nonatomic) IBOutlet UIButton *button;
@property (retain, nonatomic) NSDictionary* parts;
@end

@implementation PartsCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (IBAction)buttonPushed:(id)sender {
    NSDictionary* dictionary = [NSDictionary dictionaryWithObject:self.parts forKey:@"parts"];
    NSNotification* nc = [NSNotification notificationWithName:NOTIFICATION_PARTS_BUTTON_PUSHED object:self userInfo:dictionary];
    [[NSNotificationCenter defaultCenter] postNotification:nc];
}

- (void)setData:(NSDictionary*)parts {
    self.parts = parts;
    [self.button setTitle:@"" forState:UIControlStateNormal];
    
    CCNode* node = [CCNode node];
    
    NSString* basePath = [parts objectForKey:PartsKeyDataPartsBaseFilePath];
    CCSprite* sprite = [CCSprite spriteWithFile:basePath];
    sprite.anchorPoint  = CGPointZero;
    
    NSString* category = [parts objectForKey:@"category"];
    if ([category length] > 0) {
        NSDictionary* config = [Parts configForCategory:category];
        BOOL isColored = [[config objectForKey:PartsKeyDataConfigColored] boolValue];
        if (isColored) {
            float red = [[config objectForKey:PartsKeyDataConfigColorRed] floatValue];
            float green = [[config objectForKey:PartsKeyDataConfigColorGreen] floatValue];
            float blue = [[config objectForKey:PartsKeyDataConfigColorBlue] floatValue];
            sprite.color = ccc3(red, green, blue);
        }
    }
    
    [node addChild:sprite];
    
    NSString* framePath = [parts objectForKey:PartsKeyDataPartsFrameFilePath];
    if ([framePath length] > 0) {
        CCSprite* frameSprite = [CCSprite spriteWithFile:framePath];
        frameSprite.anchorPoint  = CGPointZero;
        [node addChild:frameSprite];
    }
    
    int tx = sprite.contentSize.width;
    int ty = sprite.contentSize.height;
    
    CCRenderTexture *renderer = [CCRenderTexture renderTextureWithWidth:tx height:ty];
    
    [renderer begin];
    [node visit];
    [renderer end];
    
    UIImage* image = [renderer getUIImage];
    
    [self.button setImage:image forState:UIControlStateNormal];
    self.button.imageView.contentMode = UIViewContentModeScaleAspectFit;

}

- (void)dealloc {
    [_button release];
    [super dealloc];
}
@end
