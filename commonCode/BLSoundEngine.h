//
//  BLSoundEngine.h
//
//  Created by Scott Lawrence on 6/12/10.
//  Copyright 2010,2011 Umlautllama.com All rights reserved.
//
//
// v1.2 - 2011-Aug-22 - cleanups for public release
// v1.1 - 2011-Aug-19 - Moved sound and song filenames into structs
// v1.0 - 2010-Jun-18 - Initial version


// to use:  #import this header in all necessary files
// add frameworks:
//		AVFoundation.framework		for music
//		AudioToolbox.framework		for sfx
//
//  in your applicationDidFinishLaunching:
//			BLSoundEngine * blse = [[BLSoundEngine alloc]
//				initWithSounds:mySounds
//					Musics:myMusics];
//			// see the example for these structures defined
//
//			[blse preload];
//			when the load completes, a GS_PreloadComplete 
//			notification is broadcasted
//
//  to play a song: (one at a time)
//			[blse playSong:SONG_0];
//
//  to play sfx: (each slot can play simultaneously)
//			[blse playSfx:SFX_0];
//


// Copyright (C) 2011 by Scott Lawrence
// (MIT License)
// 
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject
// to the following conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
// ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
// CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h> // for sound effects
#import <AVFoundation/AVFoundation.h> // for music


// BLSESound
//	structure of sound stuff
//	array of these, terminated with { -1 } is passed in to init
typedef struct BLSESound 
{
    int soundNumber;		   // unique ID used for playback indexing
    NSString * filenameInBundle;   // filename of the audio file

    // internal use stuff
    SystemSoundID sfxID;           // loaded in handle for the sfx
    bool loaded;		   // YES if it's cached
} BLSESound;


// BLSEMusic
//	structure of music stuff
//	array of these, terminated with { -1 } is passed in to init
typedef struct BLSEMusic 
{
    int musicNumber;               // unique ID used for playback indexing
    NSString * filenameInBundle;   // filename of the music file
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

	BLSESound * sounds;
	BLSEMusic * musics;
}

@property (nonatomic, retain) AVAudioPlayer * audioPlayer;
@property (nonatomic, retain) NSURL * songToPlay;

#define kSongNone	(-1)

// for fadeout
#define kFadeTime           (2.0)		/* duration of entire fadeout */
#define kFadeSteps          (10)		/* steps per second of fadeout  */

-(id) initWithSounds:(BLSESound *)snds Musics:(BLSEMusic *)mus;

-(void) preload;

-(void) playSong:(int)sid justPrepare:(BOOL)jp inBackground:(BOOL)ib;
-(void) playSong:(int)sid;

-(void) playSfx:(int)sid;
-(void) fadeAndStopTheSong;
-(void) stopAndClearSong;

-(void) setSfxVolume:(float)vol;
-(void) setMusVolume:(float)vol;

@end
