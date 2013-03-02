//
//  Figure.h
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/2/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const FigureTypeFace;
extern NSString *const FigureTypeEye;

@interface Figure : NSObject
@property (retain, nonatomic) NSString* path;
@property (assign, nonatomic) CGPoint position;
@property (retain, nonatomic) NSString* type;

-(NSString*) key;
-(NSDictionary*) dictionary;
+(Figure*) figureWithDictionary:(NSDictionary*) dictionary;
@end
