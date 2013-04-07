//
//  Figure.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/2/13.
//
//

#import "Figure.h"

int const FigureScaleMax = 2;
int const FigureScaleMin = -2;

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
            [NSNumber numberWithInteger:self.scale], @"scale",
            [NSNumber numberWithFloat:self.distance], @"distance",
            NSStringFromCGPoint(self.position), @"position",
            nil];
}

+(Figure*) figureWithDictionary:(NSDictionary*) dictionary
{
    Figure* figure = [[Figure alloc] init];
    figure.category = [dictionary objectForKey:@"category"];
    figure.base_path = [dictionary objectForKey:@"base_path"];
    figure.frame_path = [dictionary objectForKey:@"frame_path"];
    figure.scale = [[dictionary objectForKey:@"scale"] intValue];
    figure.distance = [[dictionary objectForKey:@"distance"] floatValue];
    figure.position = CGPointFromString([dictionary objectForKey:@"position"]);
    
    return figure;
}
@end