//
//  Parts.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/24/13.
//
//

#import "Parts.h"

NSString* const PartsKeyCategory = @"category";
NSString* const PartsKeyData = @"data";
NSString* const PartsKeyDataConfig = @"config";
NSString* const PartsKeyDataConfigX = @"x";
NSString* const PartsKeyDataConfigY = @"y";
NSString* const PartsKeyDataConfigTag = @"tag";
NSString* const PartsKeyDataConfigZindex = @"zindex";
NSString* const PartsKeyDataConfigCouple = @"couple";
NSString* const PartsKeyDataConfigDistance = @"distance";
NSString* const PartsKeyDataConfigAllowScale = @"allow_scale";
NSString* const PartsKeyDataConfigAllowRotate = @"allow_rotate";
NSString* const PartsKeyDataConfigAllowMove = @"allow_move";
NSString* const PartsKeyDataConfigAllowColor = @"allow_color";
NSString* const PartsKeyDataConfigFixed = @"fixed";
NSString* const PartsKeyDataParts = @"parts";
NSString* const PartsKeyDataPartsBaseFilePath = @"base_path";
NSString* const PartsKeyDataPartsFrameFilePath = @"frame_path";

@implementation Parts
+(NSArray*) category {
    return [[Parts dictionary] objectForKey:PartsKeyCategory];
}

+(NSDictionary*) dictionary {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    
    NSError *error=nil;
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
}

+(NSDictionary*) partsForCategory:(NSString*) category {
    return [[[[Parts dictionary] objectForKey:PartsKeyData] objectForKey:category] objectForKey:PartsKeyDataParts];
}

+(NSDictionary*) configForCategory:(NSString*) category {
    return [[[[Parts dictionary] objectForKey:PartsKeyData] objectForKey:category] objectForKey:PartsKeyDataConfig];
}
@end
