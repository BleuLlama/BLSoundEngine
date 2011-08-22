//
//  BLSoundEngine.m
//
//  Created by Scott Lawrence on 6/12/10.
//  Copyright 2010,2011 UmlautLlama.com All rights reserved.
//

// v1.1 - 2011-Aug-19 - Moved sound and song filenames into structs
// v1.0 - 2010-Jun-18 - Initial version


#import "BLSoundEngine.h"

NSString *SE_PreloadComplete = @"SoundEngine Preload Complete";


BLSESound sounds[8] = {
    { kSFX_accept, @"accept.wav" },
    { kSFX_accept2, @"accept2.wav" },
    { kSFX_denied, @"denied.wav" },
    { kSFX_exclamation, @"exclmtn.wav" },
    { kSFX_question, @"question.wav" },
    { kSFX_clickL, @"click_l.wav" },
    { kSFX_clickS, @"click_s.wav" },
    { -1 }
};

BLSEMusic songs[8] = {
    { kSONG_0, @"01 Don't Listen To Me (Instrumental).m4a" },
    { -1 }
};

@implementation BLSoundEngine

@synthesize audioPlayer;
@synthesize songToPlay;

-(id) init
{
	self = [super init];
	if( self ) {
		nowPlaying = kSONG_NONE;
		musVolume = 1.0;
		sfxVolume = 1.0;
	}
	return self;
}

- (void)dealloc
{
	[audioPlayer release];
	[super dealloc];
}


- (NSURL *) nsurlFor:(NSString *)fn
{
	NSString * thePath = [[NSBundle mainBundle] pathForResource:fn ofType:@""];
	NSURL * theURL = [NSURL fileURLWithPath:thePath];
	return theURL;
}

- (CFURLRef) cfurlFor:(NSString *)fn
{
	CFURLRef x = (CFURLRef) [self nsurlFor:fn];
	return x;
}


-(void)preloadComplete
{
	[[NSNotificationCenter defaultCenter] postNotificationName:SE_PreloadComplete object:nil];
}


-(void)backgroundPreload
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    for( int x=0 ; sounds[x].soundNumber >= 0 ; x++ )
    {
        if( sounds[x].loaded == NO ) {
            AudioServicesCreateSystemSoundID( [self cfurlFor:sounds[x].filenameInBundle], &sounds[x].sfxID);
            sounds[x].loaded = YES;
        }
    }
	
	// preload/prepare the AVAudioPlayer too
//	[self playSong:SONG_0 justPrepare:YES inBackground:NO];

	sfx_loaded = YES;
	[self performSelectorOnMainThread:@selector(preloadComplete) withObject:nil waitUntilDone:NO];
	[pool release];
}


-(void)preload
{
	sfx_loaded = NO;
	// load data at startup

	// and spawn the background load
	[self performSelectorInBackground:@selector( backgroundPreload ) withObject:nil];
}

-(void) loadAndPrepareTheSong
{
	if( !self.songToPlay ) return;
	
	NSError *error;
	self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.songToPlay error:&error];
	self.audioPlayer.numberOfLoops = -1;	// play forever
	self.audioPlayer.volume = musVolume;
	
	if (self.audioPlayer == nil)
		NSLog( @"Music load error: %@", [error description]);
	else
		[self.audioPlayer prepareToPlay];
}

-(void) loadAndPlayTheSong
{
	NSError *error;
	
	if( !self.songToPlay ) return;

	[self loadAndPrepareTheSong];
	
	if (self.audioPlayer == nil)
		NSLog( @"Music load error: %@", [error description]);
	else
		[self.audioPlayer play];	
}



- (void) fadeTimerTicked:(id)sender
{
	if( fadeVolume <= 0 ) {
		[self.audioPlayer stop];
		[fadeoutTimer invalidate];
		fadeoutTimer = nil;
	}
	fadeVolume -= musVolume/(kFadeTime * kFadeSteps);
	[self.audioPlayer setVolume:fadeVolume];
}

-(void) fadeAndStopTheSong
{
	fadeoutTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/kFadeSteps
													target:self 
												  selector:@selector(fadeTimerTicked:) 
												  userInfo:nil
												   repeats:YES];
	fadeVolume = musVolume;
	[fadeoutTimer fire];	// force an immediate one
}

-(NSString *)songFilenameFromIndex:(int)sid
{
    for( int x=0 ; songs[x].musicNumber >= 0 ; x++ ) {
        if( songs[x].musicNumber == sid ) {
            return songs[x].filenameInBundle;
        }
    }
    
    NSLog( @"Error: Song %d not found.", sid );
    return nil;
}

-(void)stopAndClearSong
{
	if( self.audioPlayer != nil &&  [self.audioPlayer isPlaying] )
	{
		[self.audioPlayer stop];
	}	
}

-(void) playSong:(int)sid justPrepare:(BOOL)jp inBackground:(BOOL)ib
{
	if( sid == nowPlaying ) {
		[self.audioPlayer play];	// don't restart an already-playing song
		return;
	}
	
	NSString *sfn = [self songFilenameFromIndex:sid];	
	if( sfn == nil ) return;
	
	self.songToPlay = [self nsurlFor:sfn];
	[self stopAndClearSong];
	
	nowPlaying = sid;
	
	if( ib ) {
		if( jp ) {
			[self performSelectorInBackground:@selector( loadAndPrepareTheSong ) withObject:nil];
		} else {
			[self performSelectorInBackground:@selector( loadAndPlayTheSong ) withObject:nil];
		}
	} else {
		if( jp ) {
			[self loadAndPrepareTheSong];
		} else {
			[self loadAndPlayTheSong];
		}
		
	}
}

-(void) playSong:(int)sid
{
	[self playSong:sid justPrepare:NO inBackground:YES];
}


-(void)playSfx:(int)sid
{
	if( !sfx_loaded ) return; /* beh! */
    
    for( int x=0 ; sounds[x].soundNumber >= 0 ; x++ )
    {
        if( sounds[x].soundNumber == sid ) {
            AudioServicesPlaySystemSound( sounds[x].sfxID );
        }
    }
}

-(void)setMusVolume:(float)vol
{
	musVolume = vol;
	[self.audioPlayer setVolume:vol];
}

-(void)setSfxVolume:(float)vol
{
	sfxVolume = vol;
	// TODO: add further adjustment
}

@end