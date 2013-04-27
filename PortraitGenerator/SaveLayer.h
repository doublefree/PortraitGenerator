//
//  SaveLayer.h
//  PortraitGenerator
//
//  Created by Watabe Takuya on 4/27/13.
//
//

#import "cocos2d.h"
#import "Figure.h"

@interface SaveLayer : CCLayer
{}
+(CCScene *) sceneWithImage:(UIImage*)image figure:(Figure*)figure;
@end
