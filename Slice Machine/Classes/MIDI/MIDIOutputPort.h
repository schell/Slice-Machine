//
//  MIDIOutputPort.h
//  Slice Machine
//
//  Created by Schell Scivally on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>

/** MIDIPort is a wrapper around the MIDIEndpointRef struct. 
 
 MIDIPorts are created by MIDIClients, generally.
 */
@interface MIDIOutputPort : NSObject {
    NSString* _name;
    MIDIPortRef _portRef;
}

#pragma mark - Initializing a MIDIPort
/// @name Initializing a MIDIPort

/** Creates a new MIDIPort with the given MIDIEndpointRef and name. */
- (id)initWithMIDIPortRef:(MIDIPortRef)port andName:(NSString*)name;

#pragma mark - Getting Properties
/// @name Getting Properties

/** The name of the port. */
- (NSString*)name;
/** The MIDIPortRef CoreMIDI object. */
- (MIDIPortRef)portRef;

#pragma mark - Sending MIDI Messages
/// @name Sending MIDI Messages

/** Sends one packet to a MIDI destination. */
- (void)sendByteArray:(Byte*)bytes ofLength:(NSUInteger)length toDestination:(MIDIEndpointRef)destination;

@end
