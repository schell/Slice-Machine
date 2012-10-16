//
//  MIDIPort.m
//  Slice Machine
//
//  Created by Schell Scivally on 10/15/12.
//
//

#import "MIDIPort.h"

@implementation MIDIPort

#pragma mark - Lifecycle

- (id)initWithMIDIPortRef:(MIDIPortRef)port andName:(NSString *)name {
    self = [self init];
    if (self) {
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

- (NSString*)name {
    return _name;
}

- (MIDIPortRef)portRef {
    return _portRef;
}

@end
