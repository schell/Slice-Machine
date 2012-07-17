//
//  MIDIPort.h
//  Slice Machine
//
//  Created by Schell Scivally on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>

/** An enumeration of port types. */
typedef enum {
    MIDIPortType_None,
    MIDIPortType_Input,
    MIDIPortType_Output
} MIDIPortType;

/** MIDIPort is a wrapper around the MIDIEndpointRef struct. 
 
 MIDIPorts are created by MIDIClients, generally.
 */
@interface MIDIPort : NSObject {
    NSString* _name;
    MIDIPortRef _portRef;
    MIDIPortType _type;
}

#pragma mark - Initializing a MIDIPort
/// @name Initializing a MIDIPort

/** Creates a new MIDIPort with the given MIDIEndpointRef and name. */
- (id)initWithMIDIPortRef:(MIDIPortRef)port andType:(MIDIPortType)type andName:(NSString*)name;

#pragma mark - Getting Properties
/// @name Getting Properties

/** The type of the port. */
- (MIDIPortType)type;
/** The name of the port. */
- (NSString*)name;
/** The MIDIPortRef CoreMIDI object. */
- (MIDIPortRef)portRef;

@end
