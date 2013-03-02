//
//  Portrait.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/2/13.
//
//

#import "Portrait.h"

NSString *const PortraitPrefix = @"com.wiz-r.portrait.portrait";

@implementation Portrait
+(void) add:(FigureSet *)figureSet withName:(NSString *)name
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray* array = [Portrait nameList];
    if (!array) {
        array = [NSMutableArray array];
    }
    [array addObject:name];
    
    [ud setObject:array forKey:PortraitPrefix];
    [ud synchronize];
    [figureSet saveWithName:name];
}

+(void) removeWithName:(NSString *)name
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray* array = [Portrait nameList];
    if (!array) {
        return;
    }
    [array removeObject:name];
    
    [ud setObject:array forKey:PortraitPrefix];
    [ud synchronize];
}

+(NSMutableArray*) nameList
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSArray* savedArray = [ud arrayForKey:PortraitPrefix];
    
    return [savedArray mutableCopy];
}

+(int) count
{
    NSMutableArray* array = [Portrait nameList];
    if (!array) {
        return 0;
    }
    
    return [array count];
}
@end
