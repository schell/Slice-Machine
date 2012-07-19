//
//  MIDIClient.h
//  Slice Machine
//
//  Created by Schell Scivally on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>
#import "MIDIOutputPort.h"

/** A midi notification handler. */
static void midiChange(const MIDINotification* message, void* refCon);

/** A wrapper for sending and receiving midi messages. */
@interface MIDIClient : NSObject {
    MIDIClientRef _clientRef;
    NSDictionary* _outputPorts;
}

#pragma mark - The Default MIDIClient
/// @name The Default MIDIClient

/** A default MIDIClient for sending/receiving midi packets. */
+ (MIDIClient*)defaultClient;

#pragma mark - Getting CoreMIDI Properties
/// @name Getting CoreMIDI Properties

/** The MIDIClientRef.
 
 Used for sending messages to and from midi ports and to and from the system. */
- (MIDIClientRef)clientRef;
/** A dictionary of output ports, keyed by their names. */
- (NSDictionary*)outputPorts;

#pragma mark - Creating MIDIPorts
/// @name Creating MIDIPorts

/** A named midi output port. 
 
 If the port does not yet exist, one is created. Stores the created port in outputPorts. 
 */
- (MIDIOutputPort*)outputPortWithName:(NSString*)name;

@end
