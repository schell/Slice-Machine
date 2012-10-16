//
//  MIDIPort.m
//  Slice Machine
//
//  Created by Schell Scivally on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MIDIOutputPort.h"
#import "MIDIConstants.h"

@implementation MIDIOutputPort

#pragma mark - Sending MIDI Messages

- (void)sendByteArray:(Byte *)bytes ofLength:(NSUInteger)length toDestination:(MIDIEndpointRef)destination {
    MIDITimeStamp timestamp = 0; // Play now...
    Byte buffer[1024];
    MIDIPacketList* packetList = (MIDIPacketList*)buffer;
    MIDIPacket* currentPacket = MIDIPacketListInit(packetList);
    
    currentPacket = MIDIPacketListAdd(packetList, sizeof(buffer), currentPacket, timestamp, length, bytes);
    // Send it!
    OSStatus status = MIDISend([self portRef], destination, packetList);
    if (status) {
        [NSException raise:@"could not send midi packets" format:@"%s",GetMacOSStatusErrorString(status)];
    }
}

@end
