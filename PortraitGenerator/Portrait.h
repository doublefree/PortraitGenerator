//
//  Portrait.h
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/2/13.
//
//

#import <Foundation/Foundation.h>
#import "FigureSet.h"

@interface Portrait : NSObject
+(void)add:(FigureSet*)figureSet withName:(NSString*)name;
+(void)removeWithName:(NSString*)name;
+(NSMutableArray*) nameList;
+(int) count;
@end
