//
//  Figure.h
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/2/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Figure : NSObject
@property (retain, nonatomic) NSString* base_path;
@property (retain, nonatomic) NSString* frame_path;
@property (assign, nonatomic) CGPoint position;
@property (retain, nonatomic) NSString* category;

-(NSString*) key;
-(NSDictionary*) dictionary;
+(Figure*) figureWithDictionary:(NSDictionary*) dictionary;
@end
