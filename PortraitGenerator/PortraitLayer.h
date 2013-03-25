//
//  PortraitLayer.h
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "InfColorPickerController.h"

@interface PortraitLayer : CCLayer <InfColorPickerControllerDelegate> {
    
}
+(CCScene *) scene;
@end
