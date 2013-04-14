//
//  Figure.h
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/2/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern int const FigureScaleMax;
extern int const FigureScaleMin;
extern int const FigureDistanceMax;
extern int const FigureDistanceMin;
extern int const FigureRotateDegree;

@interface Figure : NSObject
@property (retain, nonatomic) NSString* base_path;
@property (retain, nonatomic) NSString* frame_path;
@property (assign, nonatomic) CGPoint position;
@property (retain, nonatomic) NSString* category;
@property (assign, nonatomic) int scale;
@property (assign, nonatomic) BOOL isCouple;
@property (assign, nonatomic) int distance;
@property (assign, nonatomic) int rotate;
@property (assign, nonatomic) BOOL isColored;
@property (assign, nonatomic) int red;
@property (assign, nonatomic) int green;
@property (assign, nonatomic) int blue;

-(NSString*) key;
-(NSDictionary*) dictionary;
+(Figure*) figureWithDictionary:(NSDictionary*) dictionary;
@end
