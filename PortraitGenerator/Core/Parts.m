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
NSString* const PartsKeyDataConfigCouple = @"couple";
NSString* const PartsKeyDataConfigDistance = @"distance";
NSString* const PartsKeyDataConfigColorChange = @"color_change";
NSString* const PartsKeyDataParts = @"parts";
NSString* const PartsKeyDataPartsBaseFilePath = @"base_path";
NSString* const PartsKeyDataPartsFrameFilePath = @"frame_path";

NSString* const PartsCategoryFace = @"face";
NSString* const PartsCategoryEye = @"eye";

@implementation Parts
+(NSArray*) category {
    return [NSArray arrayWithObjects:PartsCategoryFace, PartsCategoryEye, nil];
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
