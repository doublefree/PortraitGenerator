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
NSString* const PartsKeyDataParts = @"parts";
NSString* const PartsKeyDataPartsFilePath = @"path";

NSString* const CategoryFace = @"face";
NSString* const CategoryEye = @"eye";

@implementation Parts
+(NSArray*) category {
    return [NSArray arrayWithObjects:CategoryFace, CategoryEye, nil];
}
+(NSArray*) listWithCategory:(NSString*) category {
    NSDictionary* list = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSArray arrayWithObjects:@"f1.png",@"f2.png", @"f3.png", @"f4.png", @"f5.png", @"f6.png", @"f7.png", @"f8.png", @"f9.png", @"f10.png", nil], CategoryFace,
                          [NSArray arrayWithObjects:@"e1",@"e2", @"e3", nil], CategoryEye,
                          nil];
    return [list objectForKey:category];
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
@end
