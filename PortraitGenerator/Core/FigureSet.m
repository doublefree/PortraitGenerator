//
//  FigureSet.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/2/13.
//
//

#import "FigureSet.h"

NSString *const FigureSetPrefix = @"com.wiz-r.portrait.figureset";

@interface FigureSet()
@property(retain, nonatomic) NSMutableDictionary* dictionary;
@end

@implementation FigureSet
-(FigureSet*) init {
    if (self=[super init]) {
        self.dictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void) add:(Figure*)figure {
    [self.dictionary setObject:figure forKey:[figure key]];
}

-(Figure*) figureWithCategory:(NSString *)category {
    return [self.dictionary objectForKey:category];
}

-(void) saveWithName:(NSString*)name {
    NSMutableDictionary* dictionaryToBeSaved = [NSMutableDictionary dictionary];
    for (id key in [self.dictionary keyEnumerator]) {
        Figure* figure = (Figure*)[self.dictionary objectForKey:key];
        [dictionaryToBeSaved setObject:[figure dictionary] forKey:[figure key]];
    }
    
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:dictionaryToBeSaved forKey:[FigureSet keyWithName:name]];
    [ud synchronize];
}

-(void) deleteWithName:(NSString*)name {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:[FigureSet keyWithName:name]];
}

+(FigureSet*) figureSetFromName:(NSString*)name {
    FigureSet* figureSet = [[FigureSet alloc] init];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSDictionary* savedDictionary = [ud dictionaryForKey:[FigureSet keyWithName:name]];
    
    for (id key in [savedDictionary keyEnumerator]) {
        Figure* figure = [Figure figureWithDictionary:[savedDictionary objectForKey:key]];
        [figureSet add:figure];
    }
    
    return figureSet;
}

+(NSString*) keyWithName: (NSString*)key {
    return [NSString stringWithFormat:@"%@_%@", FigureSetPrefix, key];
}
@end
