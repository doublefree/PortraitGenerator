//
//  AppDelegate.h
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/2/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GADBannerView.h"
#import "Flurry.h"
#import <FacebookSDK/FacebookSDK.h>

extern NSString* const NOTIFICATION_LOAD_BUTTON_PUSHED;
extern NSString* const NOTIFICATION_DELETE_BUTTON_PUSHED;
extern NSString* const NOTIFICATION_LOAD_WITH_NAME;
extern NSString* const NOTIFICATION_PARTS_CATEGORY_BUTTON_PUSHED;
extern NSString* const NOTIFICATION_PARTS_BUTTON_PUSHED;
extern NSString* const NOTIFICATION_SELECTED_CATEGORY_CHANGED;
extern NSString* const NOTIFICATION_DELETE_ALL_CONTROL_VIEW;
extern NSString *const NOTIFICATION_FB_SESSION_CHANGED;

extern int const CATEGORY_CELL_HEIGHT;

extern NSString* const GOOGLE_AD_ID;

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI completion:(void (^)(FBSession* session, FBSessionState state, NSError* error))completion;
- (void)closeSession;
@end
