//
//  MIDIOutputPort.h
//  Slice Machine
//
//  Created by Schell Scivally on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>
#import "MIDIPort.h"

/** For sending messages to a MIDI device. */
@interface MIDIOutputPort : MIDIPort

#pragma mark - Sending MIDI Messages
/// @name Sending MIDI Messages

/** Sends one packet to a MIDI destination. */
- (void)sendByteArray:(Byte*)bytes ofLength:(NSUInteger)length toDestination:(MIDIEndpointRef)destination;

@end
