//
//  TopLayer.h
//  PortraitGenerator
//
//  Created by Watabe Takuya on 4/27/13.
//
//

#import "cocos2d.h"
#import "GADBannerView.h"

@interface TopLayer : CCLayer
{
    GADBannerView *bannerView_;
}
+(CCScene *) scene;
@end
