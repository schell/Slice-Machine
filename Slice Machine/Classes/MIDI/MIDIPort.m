//
//  MIDIPort.m
//  Slice Machine
//
//  Created by Schell Scivally on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MIDIPort.h"

@implementation MIDIPort

#pragma mark - Lifecycle

- (id)initWithMIDIPortRef:(MIDIPortRef)port andType:(MIDIPortType)type andName:(NSString *)name {
    self = [self init];
    if (self) {
        _type = type;
        _name = [name retain];
        _portRef = port;
    }
    return self;
}

- (void)dealloc {
    [_name release];
    [super dealloc];
}

#pragma mark - Getters
        
- (MIDIPortType)type {
    return _type;
}

- (NSString*)name {
    return _name;
}

- (MIDIPortRef)portRef {
    return _portRef;
}

@end
