//
//  SoundEngineTestAppDelegate.h
//  SoundEngineTest
//
//  Created by Scott Lawrence on 8/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SoundEngineTestViewController;

@interface SoundEngineTestAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet SoundEngineTestViewController *viewController;

@end
