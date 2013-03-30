//
//  Figure.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/2/13.
//
//

#import "Figure.h"

@implementation Figure
-(NSString*) key
{
    return self.category;
}

-(NSDictionary*) dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.category, @"category",
            self.base_path, @"base_path",
            self.frame_path, @"frame_path",
            NSStringFromCGPoint(self.position), @"position",
            nil];
}

+(Figure*) figureWithDictionary:(NSDictionary*) dictionary
{
    Figure* figure = [[Figure alloc] init];
    figure.category = [dictionary objectForKey:@"category"];
    figure.base_path = [dictionary objectForKey:@"base_path"];
    figure.frame_path = [dictionary objectForKey:@"frame_path"];
    figure.position = CGPointFromString([dictionary objectForKey:@"position"]);
    
    return figure;
}
@end