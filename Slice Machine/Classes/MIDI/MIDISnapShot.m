//
//  MIDISnapShot.m
//  Slice Machine
//
//  Created by Schell Scivally on 2/19/12.
//  Copyright (c) 2012 Slaughter Balloon Software Company. All rights reserved.
//

#import "MIDISnapShot.h"
#import <CoreMIDI/CoreMIDI.h>
#import "MIDIDevice.h"

@interface MIDISnapShot (Private)
- (NSArray*)enumerateSources;
- (NSArray*)enumerateDestinations;
@end


@implementation MIDISnapShot

- (id)init {
    self = [super init];
    if (self) {
        _sources = nil;
        _destinations = nil;
        [self renew];
    }
    return self;
}

- (void)dealloc {
    [self renew];
    [super dealloc];
}

#pragma mark - Getters

- (NSArray*)sources {
    if (!_sources) {
        _sources = [[self enumerateSources] retain];
    }
    return _sources;
}

- (NSArray*)destinations {
    if (!_destinations) {
        _destinations = [[self enumerateDestinations] retain];
    }
    return _destinations;
}

#pragma mark - Enumerating Devices

- (NSArray*)enumerateSources {
    NSMutableArray* mutableSources = [NSMutableArray array];
    ItemCount midiSources = MIDIGetNumberOfSources();
    for (int i = 0; i<midiSources; i++) {
        MIDIEndpointRef sourceEndpoint = MIDIGetSource(i);
        MIDIEntityRef sourceEntity;
        MIDIDeviceRef sourceDeviceRef;
        OSStatus err = MIDIEndpointGetEntity(sourceEndpoint, &sourceEntity);
        err = MIDIEntityGetDevice(sourceEntity, &sourceDeviceRef);
        CFPropertyListRef sourceProperties;
        err = MIDIObjectGetProperties(sourceDeviceRef, &sourceProperties, YES);
        NSDictionary* deviceInfo = [NSDictionary dictionaryWithDictionary:sourceProperties];
        MIDIDevice* sourceDevice = [[[MIDIDevice alloc] initWithInfoDictionary:deviceInfo] autorelease];
        [mutableSources addObject:sourceDevice];
    }
    return [NSArray arrayWithArray:mutableSources];
}

- (NSArray*)enumerateDestinations {
    NSMutableArray* mutableDestinations = [NSMutableArray array];
    ItemCount midiDesinations = MIDIGetNumberOfDestinations();
    for (int i = 0; i<midiDesinations; i++) {
        MIDIEndpointRef destEndpoint = MIDIGetDestination(i);
        MIDIEntityRef destEntity;
        MIDIDeviceRef destDeviceRef;
        OSStatus err = MIDIEndpointGetEntity(destEndpoint, &destEntity);
        err = MIDIEntityGetDevice(destEntity, &destDeviceRef);
        MIDIDevice* destDevice = [[[MIDIDevice alloc] initWithDevice:destDeviceRef andDestination:destEndpoint] autorelease];
        [mutableDestinations addObject:destDevice];
    }
    return [NSArray arrayWithArray:mutableDestinations];
}

- (void)renew {
    if (_sources) {
        [_sources release];
        _sources = nil;
    }
    if (_destinations) {
        [_destinations release];
        _sources = nil;
    }
}
@end
