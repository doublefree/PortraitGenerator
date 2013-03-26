//
//  Parts.h
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/24/13.
//
//

#import <Foundation/Foundation.h>
extern NSString* const PartsKeyCategory;
extern NSString* const PartsKeyData;
extern NSString* const PartsKeyDataParts;
extern NSString* const PartsKeyDataPartsFilePath;

@interface Parts : NSObject
@property (retain, nonatomic) NSString* path;
+(NSArray*) category;
+(NSArray*) listWithCategory:(NSString*) category;
+(NSDictionary*) dictionary;
+(NSDictionary*) partsForCategory:(NSString*) category;
@end
