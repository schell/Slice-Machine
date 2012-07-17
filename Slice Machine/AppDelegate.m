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
#import "MIDIClient.h"
#import "MIDIPort.h"
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
    MIDIClient* client = [[MIDIClient alloc] init];
    MIDIPort* output = [client outputPortWithName:@"output"];
    
    MIDITimeStamp timestamp = 0; // Play now...
    Byte buffer[1024];
    MIDIPacketList* packetList = (MIDIPacketList*)buffer;
    MIDIPacket* currentPacket = MIDIPacketListInit(packetList);
    Byte noteon[MSG_SIZE] = {NOTE_ON, 0, 15}; 
    
    currentPacket = MIDIPacketListAdd(packetList, sizeof(buffer), currentPacket, timestamp, MSG_SIZE, noteon);
    // Send it!
    OSStatus status = MIDISend([output portRef], [launchPad destinationRef], packetList);
    if (status) {
        [NSException raise:@"could not send midi packets" format:@"%s",GetMacOSStatusErrorString(status)];
    }
}

@end
