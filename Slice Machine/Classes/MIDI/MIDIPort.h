//
//  MIDIPort.h
//  Slice Machine
//
//  Created by Schell Scivally on 10/15/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>

/** MIDIPort is a wrapper around the MIDIEndpointRef struct. 
 
 MIDIPorts are created by MIDIClients, generally.
 */
@interface MIDIPort : NSObject {
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

@end
