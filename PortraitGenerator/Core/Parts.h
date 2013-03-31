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
extern NSString* const PartsKeyDataConfig;
extern NSString* const PartsKeyDataConfigX;
extern NSString* const PartsKeyDataConfigY;
extern NSString* const PartsKeyDataConfigTag;
extern NSString* const PartsKeyDataConfigCouple;
extern NSString* const PartsKeyDataConfigColorChange;
extern NSString* const PartsKeyDataParts;
extern NSString* const PartsKeyDataPartsBaseFilePath;
extern NSString* const PartsKeyDataPartsFrameFilePath;

extern NSString* const PartsCategoryFace;
extern NSString* const PartsCategoryEye;

@interface Parts : NSObject
@property (retain, nonatomic) NSString* path;
+(NSArray*) category;
+(NSDictionary*) dictionary;
+(NSDictionary*) partsForCategory:(NSString*) category;
+(NSDictionary*) configForCategory:(NSString*) category;
@end
