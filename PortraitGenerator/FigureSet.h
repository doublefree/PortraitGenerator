//
//  FigureSet.h
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/2/13.
//
//

#import <Foundation/Foundation.h>
#import "Figure.h"

@interface FigureSet : NSObject
-(FigureSet*) init;
-(void) add:(Figure*)figure;
-(void) saveWithName:(NSString*)name;
-(void) deleteWithName:(NSString*)name;
-(Figure*) figureWithType:(NSString*) type;
+(FigureSet*) figureSetFromName:(NSString*)name;
@end
