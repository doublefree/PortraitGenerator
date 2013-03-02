//
//  Figure.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/2/13.
//
//

#import "Figure.h"

NSString *const FigureTypeFace = @"face";
NSString *const FigureTypeEye = @"eye";

@implementation Figure
-(NSString*) key
{
    return self.type;
}

-(NSDictionary*) dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.type, @"type",
            self.path, @"path",
            NSStringFromCGPoint(self.position), @"position",
            nil];
}

+(Figure*) figureWithDictionary:(NSDictionary*) dictionary
{
    Figure* figure = [[Figure alloc] init];
    figure.type = [dictionary objectForKey:@"type"];
    figure.path = [dictionary objectForKey:@"path"];
    figure.position = CGPointFromString([dictionary objectForKey:@"position"]);
    
    return figure;
}
@end