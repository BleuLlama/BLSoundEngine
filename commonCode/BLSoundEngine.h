//
//  BLSoundEngine.h
//
//  Created by Scott Lawrence on 6/12/10.
//  Copyright 2010,2011 Umlautllama.com All rights reserved.
//

// v1.1 - 2011-Aug-19 - Moved sound and song filenames into structs
// v1.0 - 2010-Jun-18 - Initial version

// to use:  #import this header in all necessary files
// add frameworks:
//		AVFoundation.framework		for music
//		AudioToolbox.framework		for sfx
//
//  in your applicationDidFinishLaunching:
//			[[GruyereSounds sharedGruyereSounds] preload];
//			when the load completes, a GS_PreloadComplete notification is broadcasted
//
//	then to play a song:
//			[[GruyereSounds sharedGruyereSounds] playSong:SONG_0];
//
//  to play a sfx:
//			[[GruyereSounds sharedGruyereSounds] playSfx:SFX_0];
//

// TODO:
//		rewrite it all to use OpenAL eventually
//		http://benbritten.com/2008/11/06/openal-sound-on-the-iphone/


#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h> // for sound effects
#import <AVFoundation/AVFoundation.h> // for music

typedef struct BLSESound {
    int soundNumber;
    NSString * filenameInBundle;
    SystemSoundID sfxID;
    bool loaded;
} BLSESound;

typedef struct BLSEMusic {
    int musicNumber;
    NSString * filenameInBundle;
} BLSEMusic;

// notifications
extern NSString *SE_PreloadComplete;

// class definition
@interface BLSoundEngine : NSObject {
	bool sfx_loaded;
	
	AVAudioPlayer * audioPlayer;
	NSURL * songToPlay;
	int nowPlaying;
	
	float sfxVolume;
	float musVolume;
	
	NSTimer * fadeoutTimer;
	float fadeVolume;	// volume during a fadeout.
}

@property (nonatomic, retain) AVAudioPlayer * audioPlayer;
@property (nonatomic, retain) NSURL * songToPlay;

// keys to use for triggering
#define kSONG_NONE	(-1)
#define kSONG_0		(0)

#define kSFX_accept			(0)
#define kSFX_accept2		(1)
#define kSFX_denied			(2)
#define kSFX_exclamation	(3)
#define kSFX_question		(4)
#define kSFX_clickL         (5)
#define kSFX_clickS         (6)


// for fadeout
#define kFadeTime           (2.0)		/* duration of entire fadeout */
#define kFadeSteps          (10)		/* steps per second of fadeout  */

-(void) preload;

-(void) playSong:(int)sid justPrepare:(BOOL)jp inBackground:(BOOL)ib;
-(void) playSong:(int)sid;

-(void) playSfx:(int)sid;
-(void) fadeAndStopTheSong;
-(void) stopAndClearSong;

-(void) setSfxVolume:(float)vol;
-(void) setMusVolume:(float)vol;

@end
