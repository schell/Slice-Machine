//
//  MIDIDevice.h
//  Slice Machine
//
//  Created by Schell Scivally on 2/19/12.
//  Copyright (c) 2012 Slaughter Balloon Software Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>

/** Represents a MIDI input or output device. */
@interface MIDIDevice : NSObject {
    NSDictionary* _info;
    MIDIDeviceRef _deviceRef;
    MIDIEndpointRef _destinationRef;
}

#pragma mark - Lifecycle
/** Creates a new MIDIDevice with the given info. */
- (id)initWithInfoDictionary:(NSDictionary*)dictionary;
/** Creates a new MIDIDevice with the given MIDIDeviceRef and MIDIDestinationRef. */
- (id)initWithDevice:(MIDIDeviceRef)deviceRef andDestination:(MIDIEndpointRef)destinationRef;

#pragma mark - Getters
/** The device's info dictionary. */
- (NSDictionary*)info;
/** An enumeration of entity info. */
- (NSArray*)entities;
/** The device's unique ID. */
- (MIDIUniqueID)uniqueID;
/** The device's MIDIDeviceRef. */
- (MIDIDeviceRef)deviceRef;
/** The device's first destination. */
- (MIDIEndpointRef)destinationRef;

@end
