//
//  Parts.h
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/24/13.
//
//

#import <Foundation/Foundation.h>
@interface Parts : NSObject
@property (retain, nonatomic) NSString* path;
+(NSArray*) category;
+(NSArray*) listWithCategory:(NSString*) category;
@end
