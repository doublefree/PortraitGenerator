//
//  Parts.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/24/13.
//
//

#import "Parts.h"

NSString* const CategoryFace = @"face";
NSString* const CategoryEye = @"eye";

@implementation Parts
+(NSArray*) category {
    return [NSArray arrayWithObjects:CategoryFace, CategoryEye, nil];
}
+(NSArray*) listWithCategory:(NSString*) category {
    NSDictionary* list = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSArray arrayWithObjects:@"f1",@"f2", @"f3", @"f4", @"f5", @"f6", @"f7", @"f8", @"f9", @"f10", nil], CategoryFace,
                          [NSArray arrayWithObjects:@"e1",@"e2", @"e3", nil], CategoryEye,
                          nil];
    return [list objectForKey:category];
}
@end
