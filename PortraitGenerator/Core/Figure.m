//
//  Figure.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/2/13.
//
//

#import "Figure.h"

int const FigureScaleMax = 8;
int const FigureScaleMin = -8;
int const FigureDistanceMax = 8;
int const FigureDistanceMin = -8;
int const FigureRotateDegree = 45;

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
            [NSNumber numberWithBool:self.isCouple], @"isCouple",
            [NSNumber numberWithInteger:self.distance], @"distance",
            [NSNumber numberWithInteger:self.rotate], @"rotate",
            NSStringFromCGPoint(self.position), @"position",
            [NSNumber numberWithBool:self.isColored], @"isColored",
            [NSNumber numberWithInt:self.red], @"red",
            [NSNumber numberWithInt:self.green], @"green",
            [NSNumber numberWithInt:self.blue], @"blue",
            nil];
}

+(Figure*) figureWithDictionary:(NSDictionary*) dictionary
{
    Figure* figure = [[Figure alloc] init];
    figure.category = [dictionary objectForKey:@"category"];
    figure.base_path = [dictionary objectForKey:@"base_path"];
    figure.frame_path = [dictionary objectForKey:@"frame_path"];
    figure.scale = [[dictionary objectForKey:@"scale"] intValue];
    figure.isCouple = [[dictionary objectForKey:@"isCouple"] boolValue];
    figure.distance = [[dictionary objectForKey:@"distance"] intValue];
    figure.rotate = [[dictionary objectForKey:@"rotate"] intValue];
    figure.position = CGPointFromString([dictionary objectForKey:@"position"]);
    figure.isColored = [[dictionary objectForKey:@"isColored"] boolValue];
    figure.red = [[dictionary objectForKey:@"red"] intValue];
    figure.green = [[dictionary objectForKey:@"green"] intValue];
    figure.blue = [[dictionary objectForKey:@"blue"] intValue];
    
    return figure;
}
@end