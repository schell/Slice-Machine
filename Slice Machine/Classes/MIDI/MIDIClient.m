//
//  MIDIClient.m
//  Slice Machine
//
//  Created by Schell Scivally on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MIDIClient.h"

static void midiChange(const MIDINotification* message, void* refCon) {
    switch (message->messageID) {
        case kMIDIMsgSetupChanged:
            break;
        case kMIDIMsgObjectAdded:
            break;
        case kMIDIMsgObjectRemoved:
            break;
        case kMIDIMsgPropertyChanged:
            break;
        case kMIDIMsgThruConnectionsChanged:
            break;
        case kMIDIMsgSerialPortOwnerChanged:
            break;
        case kMIDIMsgIOError:
            break;
        default:
            break;
    }
}

@implementation MIDIClient

#pragma mark - Lifecycle

- (id)init {
    self = [super init];
    if (self) {
        _clientRef = 0;
        _outputPorts = nil;
    }
    return self;
}

#pragma mark - Getting Properties

- (NSDictionary*)outputPorts {
    if (!_outputPorts) {
        _outputPorts = [[NSDictionary dictionary] retain];
    }
    return _outputPorts;
}

#pragma mark - Getting CoreMIDI Properties

- (MIDIClientRef)clientRef {
    if (!_clientRef) {
        OSStatus status = MIDIClientCreate(CFSTR("MIDIClient"), midiChange, self, &_clientRef);
        if (status) {
            [NSException raise:@"could not create midi client" format:@"error:%s",GetMacOSStatusErrorString(status)];
        }
    }
    return _clientRef;
}

#pragma mark - Creating MIDIPorts

- (MIDIPort*)outputPortWithName:(NSString *)name {
    MIDIPort* port = [[self outputPorts] valueForKey:name];
    if (!port) {
        // Create the port...
        MIDIPortRef outPort;
        OSStatus status = MIDIOutputPortCreate([self clientRef], (CFStringRef)name, &outPort);
        if (status) {
            [NSException raise:@"could not create midi output port" format:@"error:%s",GetMacOSStatusErrorString(status)];
        }
        port = [[[MIDIPort alloc] initWithMIDIPortRef:outPort andType:MIDIPortType_Output andName:name] autorelease];
        // Update the dictionary of output ports...
        NSMutableDictionary* outputsCopy = [NSMutableDictionary dictionaryWithDictionary:[self outputPorts]];
        [outputsCopy setValue:port forKey:name];
        // Renew the outputs dictionary...
        [_outputPorts release];
        _outputPorts = [[NSDictionary dictionaryWithDictionary:outputsCopy] retain];
    }
    return port;
}

@end
