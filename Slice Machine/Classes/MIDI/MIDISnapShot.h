//
//  MIDISnapShot.h
//  Slice Machine
//
//  Created by Schell Scivally on 2/19/12.
//  Copyright (c) 2012 Slaughter Balloon Software Company. All rights reserved.
//

#import <Foundation/Foundation.h>

/** An object representing the current state of MIDI affairs. 
 
 A MIDISnapShot is basically a listing of all the sources and
 destinations at a given time. To update the snapshot call renew
 and then call other functions for particular sources or 
 destinations. 
 */
@interface MIDISnapShot : NSObject {
    NSArray* _sources;
    NSArray* _destinations;
}

#pragma mark - Getting Properties
/// @name Getting Properties

/** Enumerates the MIDI sources of the system. 
 
 Returns an array of MIDIDevice instances with info about
 MIDI sources.
 */
- (NSArray*)sources;
/** Enumerates the MIDI destinations of the system. 
 
 Returns an array of MIDIDevice instances with info about
 MIDI destinations.
*/
- (NSArray*)destinations;

#pragma mark - Renewing Device Info
/// @name Renewing Device Info

/** Throws away the cached source and destination infos. */
- (void)renew;

@end
