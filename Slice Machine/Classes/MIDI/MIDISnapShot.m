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
- (MIDIDevice*)deviceWithName:(NSString*)name inArray:(NSArray*)array;
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

#pragma mark - Class Properties

static MIDISnapShot* __default = nil;

+ (MIDISnapShot*)defaultSnapShot {
    if (!__default) {
        __default = [[MIDISnapShot alloc] init];
    }
    return __default;
}

#pragma mark - Getters

- (NSString*)description {
    NSString* description = [super description];
    description = [description stringByAppendingFormat:@"\n sources: %@\n   destinations: %@",[[self sources] description], [[self destinations] description]];
    description = [description stringByReplacingOccurrencesOfString:@"\\n" withString:@"\r"];
    description = [description stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    return description;
}

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
        _destinations = nil;
    }
}

#pragma mark - Getting Specific Devices

- (MIDIDevice*)deviceWithName:(NSString *)name inArray:(NSArray *)array {
    for (MIDIDevice* device in array) {
        if ([[device name] isEqualToString:name]) {
            return device;
        }
    }
    return nil;
}

- (MIDIDevice*)destinationWithName:(NSString *)name {
    return [self deviceWithName:name inArray:[self destinations]];
}

- (MIDIDevice*)sourceWithName:(NSString *)name {
    return [self deviceWithName:name inArray:[self sources]];
}

@end
