//
//  AppDelegate.m
//  Slice Machine
//
//  Created by Schell Scivally on 2/18/12.
//  Copyright (c) 2012 Slaughter Balloon Software Company. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreMIDI/CoreMIDI.h>
#import "MIDISnapShot.h"
#import "MIDIDevice.h"
#import "MIDIClient.h"
#import "MIDIOutputPort.h"
#import "MIDIConstants.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc {
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    MIDISnapShot* snapshot = [[MIDISnapShot alloc] init];
    MIDIDevice* launchPad = [[snapshot destinations] lastObject];
    MIDIOutputPort* output = [[MIDIClient defaultClient] outputPortWithName:@"output"];
    
    Byte msg[] = {NOTE_ON, 0, 15}; 
    [output sendByteArray:msg ofLength:3 toDestination:[launchPad destinationRef]];
}

@end
