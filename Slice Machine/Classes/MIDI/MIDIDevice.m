//
//  MIDIDevice.m
//  Slice Machine
//
//  Created by Schell Scivally on 2/19/12.
//  Copyright (c) 2012 Slaughter Balloon Software Company. All rights reserved.
//

#import "MIDIDevice.h"

@implementation MIDIDevice

- (id)init {
    self = [super init];
    if (self) {
        _info = nil;
        _deviceRef = 0;
        _destinationRef = 0;
    }
    return self;
}

- (id)initWithInfoDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self) {
        _info = dictionary;
        if (_info) {
            [_info retain];
        }
    }
    return self;
}

- (id)initWithDevice:(MIDIDeviceRef)deviceRef andDestination:(MIDIEndpointRef)destinationRef {
    self = [self init];
    if (self) {
        _deviceRef = deviceRef;
        _destinationRef = destinationRef;
        CFPropertyListRef destProperties;
        OSStatus err = MIDIObjectGetProperties(deviceRef, &destProperties, YES);
        if (err) {
            [NSException raise:@"could not get properties for device" format:@"error:%s",GetMacOSStatusErrorString(err)];
        }
        _info = [[NSDictionary dictionaryWithDictionary:destProperties] retain];
    }
    return self;
}

- (void)dealloc {
    [_info release];
    [super dealloc];
}

#pragma mark - Helper Functions

- (MIDIObjectRef)findObjectWithID:(MIDIUniqueID)uid andType:(MIDIObjectType)type {
    MIDIObjectRef objectRef;
    MIDIObjectType realType;
    OSStatus status = MIDIObjectFindByUniqueID([self uniqueID], &objectRef, &realType);
    if (status) {
        [NSException raise:@"encountered unexpected OSStatus" format:@"error:%s",GetMacOSStatusErrorString(status)];
    }
    
    if (type != realType) {
        [NSException raise:@"returned object was an unexpected type" format:@"expected %i and got %i",type,realType];
    }
    return objectRef;
}

#pragma mark - Getters

- (NSDictionary*)info {
    return _info;
}

- (NSString*)name {
    return [[self info] valueForKey:@"name"];
}

- (NSArray*)entities {
    if ([self info] && [[[self info] allKeys] containsObject:@"entities"]) {
        return [[self info] valueForKey:@"entities"];
    }
    return nil;
}

- (MIDIUniqueID)uniqueID {
    if ([self info] && [[[self info] allKeys] containsObject:@"uniqueID"]) {
        return [[[self info] valueForKey:@"uniqueID"] intValue];
    }
    return 0;
}

- (MIDIUniqueID)destinationID {
    if ([self entities]) {
        NSArray* destinations = [[[self entities] objectAtIndex:0] valueForKey:@"destinations"];
        NSDictionary* first = [destinations objectAtIndex:0];
        return [[first valueForKey:@"uniqueID"] intValue];
    }
    return 0;
}

- (MIDIDeviceRef)deviceRef {
    if (!_deviceRef) {
        _deviceRef = (MIDIDeviceRef)[self findObjectWithID:[self uniqueID] andType:kMIDIObjectType_Device];
    }
    return _deviceRef;
}

- (MIDIEndpointRef)destinationRef {
    if (!_destinationRef) {
        _destinationRef = (MIDIEndpointRef)[self findObjectWithID:[self destinationID] andType:kMIDIObjectType_ExternalDestination];
    }
    return _destinationRef;
}

#pragma mark - Printing

- (NSString*)description {
    return [NSString stringWithFormat:@"%@:\n%@",[super description],[[self info] description]];
}

@end
