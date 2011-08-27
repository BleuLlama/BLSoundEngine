//
//  SoundEngineTestViewController.h
//  SoundEngineTest
//
//  Created by Scott Lawrence on 8/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLSoundEngine.h"


@interface SoundEngineTestViewController : UIViewController
{
    BLSoundEngine * blse;
    NSTimer * updateTimer;
    
    IBOutlet UIProgressView * songProgress;
    IBOutlet UILabel * songLabel;
}

@property (nonatomic, retain) BLSoundEngine * blse;
@property (nonatomic, retain) NSTimer * updateTimer;


-(void) setupSound;
-(void) preloadComplete;

- (IBAction)pressed1:(id)sender;
- (IBAction)pressed2:(id)sender;
- (IBAction)pressedStop:(id)sender;

- (IBAction)pressed3:(id)sender;
- (IBAction)pressed4:(id)sender;
- (IBAction)pressed5:(id)sender;
- (IBAction)pressed6:(id)sender;
- (IBAction)pressed7:(id)sender;

@end
