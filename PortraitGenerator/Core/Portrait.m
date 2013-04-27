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
+(void) add:(FigureSet *)figureSet withName:(NSString *)name image:(UIImage*)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    NSDictionary* portrait = [NSDictionary dictionaryWithObjectsAndKeys:
                              name, @"name",
                              imageData, @"image",
                              nil];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* dictionary = [Portrait list];
    if (!dictionary) {
        dictionary = [NSMutableDictionary dictionary];
    }
    [dictionary setObject:portrait forKey:name];
    
    [ud setObject:dictionary forKey:PortraitPrefix];
    [ud synchronize];
    [figureSet saveWithName:name];
}

+(void) removeWithName:(NSString *)name
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* dictionary = [Portrait list];
    if (!dictionary) {
        return;
    }
    [dictionary removeObjectForKey:name];
    
    [ud setObject:dictionary forKey:PortraitPrefix];
    [ud synchronize];
}

+(NSMutableDictionary*) list
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSDictionary* dictionary = [ud dictionaryForKey:PortraitPrefix];
    
    return [dictionary mutableCopy];
}

+(int) count
{
    NSMutableDictionary* dictionary = [Portrait list];
    if (!dictionary) {
        return 0;
    }
    
    return [dictionary count];
}
@end
