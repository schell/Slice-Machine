//
//  MIDIClient.m
//  Slice Machine
//
//  Created by Schell Scivally on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MIDIClient.h"

static void midiChange(const MIDINotification* message, void* refCon) {
    MIDIClient* client = (MIDIClient*)refCon;
    switch (message->messageID) {
        case kMIDIMsgObjectAdded:
            [client handleAddObjectNotification:(MIDIObjectAddRemoveNotification*)message];
            break;
        case kMIDIMsgObjectRemoved:
            [client handleRemoveObjectNotification:(MIDIObjectAddRemoveNotification*)message];
            break;
        case kMIDIMsgPropertyChanged:
            [client handlePropertyChangedNotification:(MIDIObjectPropertyChangeNotification*)message];
            break;
        case kMIDIMsgThruConnectionsChanged:
            [client handleThruConnectionChangedNotification:(MIDINotification*)message];
            break;
        case kMIDIMsgSerialPortOwnerChanged:
            [client handleSerialPortOwnerChangedNotification:(MIDINotification*)message];
            break;
        case kMIDIMsgIOError:
            [client handleIOErrorNotification:(MIDINotification*)message];
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

- (void)dealloc {
    [_outputPorts release];
    [super dealloc];
}

#pragma mark - The Default Client

MIDIClient* __default = nil;

+ (MIDIClient*)defaultClient {
    if (!__default) {
        __default = [[MIDIClient alloc] init];
    }
    return __default;
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

- (MIDIOutputPort*)outputPortWithName:(NSString *)name {
    MIDIOutputPort* port = [[self outputPorts] valueForKey:name];
    if (!port) {
        // Create the port...
        MIDIPortRef outPort;
        OSStatus status = MIDIOutputPortCreate([self clientRef], (CFStringRef)name, &outPort);
        if (status) {
            [NSException raise:@"could not create midi output port" format:@"error:%s",GetMacOSStatusErrorString(status)];
        }
        port = [[[MIDIOutputPort alloc] initWithMIDIPortRef:outPort andName:name] autorelease];
        // Update the dictionary of output ports...
        NSMutableDictionary* outputsCopy = [NSMutableDictionary dictionaryWithDictionary:[self outputPorts]];
        [outputsCopy setValue:port forKey:name];
        // Renew the outputs dictionary...
        [_outputPorts release];
        _outputPorts = [[NSDictionary dictionaryWithDictionary:outputsCopy] retain];
    }
    return port;
}

#pragma mark - Handling System Messages

- (void)handleAddObjectNotification:(MIDIObjectAddRemoveNotification*)note {

}

- (void)handleRemoveObjectNotification:(MIDIObjectAddRemoveNotification*)note {}

- (void)handlePropertyChangedNotification:(MIDIObjectPropertyChangeNotification*)note {}

- (void)handleThruConnectionChangedNotification:(MIDINotification*)note {}

- (void)handleSerialPortOwnerChangedNotification:(MIDINotification*)note {}

- (void)handleIOErrorNotification:(MIDINotification*)note {}

@end
