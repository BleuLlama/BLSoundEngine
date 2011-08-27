//
//  SoundEngineTestViewController.m
//  SoundEngineTest
//
//  Created by Scott Lawrence on 8/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SoundEngineTestViewController.h"
#import "BLSoundEngine.h"

#pragma mark - Sound Engine Data Structures

BLSESound sounds[8] = {
    { 0, @"accept.wav" },
    { 1, @"accept2.wav" },
    { 2, @"click_l.wav" },
    { 3, @"click_s.wav" },
    { 4, @"denied.wav" },
    { 5, @"exclmtn.wav" },
    { 6, @"question.wav" },
    { -1 } // must be -1 terminated!
};

BLSEMusic songs[8] = {
    { 0, @"Gremlin.mp3" },  // thanks to Jim Young (U4ia/F8)
    { 1, @"Do You Like Cheese.m4a" }, // thanks to my Mac!
    { -1 } // must be -1 terminated!
};



#pragma mark - Classy stuff

@implementation SoundEngineTestViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSound]; // need to set up the sound engine...
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Our additions...

@synthesize blse;

-(void) preloadComplete
{
	[self.blse setMusVolume:0.8];
	[self.blse setSfxVolume:1.0];
    
	//[self.blse playSong:0];
    
	[self.blse playSfx:0];
	//[self.blse playSfx:2];
}


@synthesize updateTimer;

-(void) timerUpdate
{
    if( !self.blse || !self.blse.audioPlayer.isPlaying)
    {
        [songProgress setAlpha:0.0];
        [songLabel setAlpha:0.0];
        return;
    }
    [songProgress setAlpha:1.0];
    [songLabel setAlpha:1.0];
    
    songProgress.progress = self.blse.audioPlayer.currentTime / self.blse.audioPlayer.duration;
    songLabel.text = [NSString stringWithFormat:@"%0.2f of %0.2f", 
                      self.blse.audioPlayer.currentTime, 
                      self.blse.audioPlayer.duration];
}

-(void) dealloc
{
    [self.updateTimer invalidate];
    self.updateTimer = nil;
    
    [super dealloc];
}


-(void) setupSound
{
    // add our preload complete notification
    // sound subsystem
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(preloadComplete) 
												 name:SE_PreloadComplete
											   object:nil];

    
    // now initialize the engine
	self.blse = [[BLSoundEngine alloc] initWithSounds:sounds Musics:songs];
    
    // preload the sound effects
	[self.blse preload];
    
    // and add our update display timer
    self.updateTimer = [NSTimer timerWithTimeInterval:0.25 
                                               target:self 
                                             selector:@selector(timerUpdate) 
                                             userInfo:nil 
                                              repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.updateTimer 
                                 forMode:NSRunLoopCommonModes];
}


#pragma mark - Some button handler thingies

- (IBAction)pressed1:(id)sender { [self.blse playSong:0]; }
- (IBAction)pressed2:(id)sender { [self.blse playSong:1]; }
- (IBAction)pressedStop:(id)sender { [self.blse fadeAndStopTheSong]; }

- (IBAction)pressed3:(id)sender { [self.blse playSfx:0]; }
- (IBAction)pressed4:(id)sender { [self.blse playSfx:1]; }
- (IBAction)pressed5:(id)sender { [self.blse playSfx:4]; }
- (IBAction)pressed6:(id)sender { [self.blse playSfx:5]; }
- (IBAction)pressed7:(id)sender { [self.blse playSfx:6]; }

@end
