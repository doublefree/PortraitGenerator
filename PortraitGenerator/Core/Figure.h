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

@interface Figure : NSObject
@property (retain, nonatomic) NSString* base_path;
@property (retain, nonatomic) NSString* frame_path;
@property (assign, nonatomic) CGPoint position;
@property (retain, nonatomic) NSString* category;
@property (assign, nonatomic) int scale;
@property (assign, nonatomic) BOOL isCouple;

-(NSString*) key;
-(NSDictionary*) dictionary;
+(Figure*) figureWithDictionary:(NSDictionary*) dictionary;
@end
