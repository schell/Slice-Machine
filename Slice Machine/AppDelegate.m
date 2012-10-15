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
#import "MIDIClient.h"
#import "MIDIOutputPort.h"
#import "MIDIConstants.h"

@implementation AppDelegate

@synthesize window = _window;

#pragma mark - Lifecycle

- (id)init {
    self = [super init];
    if (self) {
        _onButton = nil;
        _offButton = nil;
        _mainView = nil;
    }
    return self;
}

- (void)dealloc {
    [_onButton release];
    [_offButton release];
    [_mainView release];
    [super dealloc];
}

#pragma mark - UIApplication Delegate Methods

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[self window] setContentView:[self mainView]];
}

#pragma mark - Getter Methods

- (SMView*)mainView {
    if (!_mainView) {
        _mainView = [[SMView alloc] initWithFrame:[self frameForMainView]];
        [_mainView addSubview:[self onButton]];
        [_mainView addSubview:[self offButton]];
    }
    return _mainView;
}

- (NSButton*)onButton {
    if (!_onButton) {
        _onButton = [[NSButton alloc] initWithFrame:[self frameForOnButton]];
        [_onButton setTitle:@"On"];
        [_onButton setTarget:self];
        [_onButton setAction:@selector(didHitOnButton:)];
    }
    return _onButton;
}

- (NSButton*)offButton {
    if (!_offButton) {
        _offButton = [[NSButton alloc] initWithFrame:[self frameForOffButton]];
        [_offButton setTitle:@"Off"];
        [_offButton setTarget:self];
        [_offButton setAction:@selector(didHitOffButton:)];
    }
    return _offButton;
}

- (MIDIDevice*)launchPad {
    if (!_launchPad) {
        _launchPad = [[[MIDISnapShot defaultSnapShot] destinationWithName:@"Launchpad"] retain];
    }
    return _launchPad;
}

#pragma mark - Event Handlers

- (void)didHitOnButton:(NSButton*)button {
    MIDIOutputPort* output = [[MIDIClient defaultClient] outputPortWithName:@"output"];
    
    Byte msg[] = {NOTE_ON, 0, 15, NOTE_ON, 8, 15};
    [output sendByteArray:msg ofLength:6 toDestination:[[self launchPad] destinationRef]];
    [[MIDISnapShot defaultSnapShot] renew];
    NSLog(@"%s %s",__FUNCTION__,[[[MIDISnapShot defaultSnapShot] description] UTF8String]);
}

- (void)didHitOffButton:(NSButton*)button {
    MIDIOutputPort* output = [[MIDIClient defaultClient] outputPortWithName:@"output"];
    
    Byte msg[] = {NOTE_OFF, 0, 15,NOTE_OFF,8,15}; 
    [output sendByteArray:msg ofLength:6 toDestination:[[self launchPad] destinationRef]];
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - View Frames

- (NSRect)frameForMainView {
    CGRect frame = CGRectZero;
    frame.size = CGSizeMake(300, 100);
    return frame;
}

- (NSRect)frameForOnButton {
    return CGRectMake(0, 0, 100, 50);
}

- (NSRect)frameForOffButton {
    return CGRectMake(0, 50, 100, 50);
}

@end
