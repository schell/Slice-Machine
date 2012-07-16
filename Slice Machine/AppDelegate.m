//
//  AppDelegate.m
//  Slice Machine
//
//  Created by Schell Scivally on 2/18/12.
//  Copyright (c) 2012 Slaughter Balloon Software Company. All rights reserved.
//

#import "AppDelegate.h"
#import "MIDISnapShot.h"
#import "MIDIDevice.h"
#import <CoreMIDI/CoreMIDI.h>

#define MSG_SIZE 3
#define NOTE_ON 0x90
#define NOTE_OFF 0x80

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc {
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    MIDISnapShot* snapshot = [[MIDISnapShot alloc] init];
    MIDIDevice* launchPad = [[snapshot destinations] lastObject];
        
    MIDIClientRef client;
    MIDIPortRef outPort;
    OSStatus status;
    status = MIDIClientCreate(CFSTR("SliceMachine_Client"), NULL, NULL, &client);
    if (status) {
        [NSException raise:@"could not create midi client" format:@"error:%s",GetMacOSStatusErrorString(status)];
    }
    status = MIDIOutputPortCreate(client, CFSTR("SliceMachine_OutputPort"), &outPort);
    if (status) {
        [NSException raise:@"could not create midi output port" format:@"error:%s",GetMacOSStatusErrorString(status)];
    }
    
    MIDITimeStamp timestamp = 0; // Play now...
    Byte buffer[1024];
    MIDIPacketList* packetList = (MIDIPacketList*)buffer;
    MIDIPacket* currentPacket = MIDIPacketListInit(packetList);
    Byte noteon[MSG_SIZE] = {NOTE_ON, 0, 15}; 
    
    currentPacket = MIDIPacketListAdd(packetList, sizeof(buffer), currentPacket, timestamp, MSG_SIZE, noteon);
    // Send it!
    status = MIDISend(outPort, [launchPad destinationRef], packetList);
}

@end
