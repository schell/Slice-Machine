//
//  AppDelegate.h
//  Slice Machine
//
//  Created by Schell Scivally on 2/18/12.
//  Copyright (c) 2012 Slaughter Balloon Software Company. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SMView.h"
#import "MIDIDevice.h"

/** The slice machine application delegate. */
@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSButton* _offButton;
    NSButton* _onButton;
    SMView* _mainView;
    MIDIDevice* _launchPad;
}

#pragma mark - Getting Properties
/// @name Getting Properties

/** The main view. */
- (SMView*)mainView;
/** The off button. */
- (NSButton*)offButton;
/** The on button. */
- (NSButton*)onButton;
/** The launchpad midi device. */
- (MIDIDevice*)launchPad;


#pragma mark - Event Handlers
/// @name Event Handlers

/** After the user hits the on button. */
- (void)didHitOnButton:(NSButton*)button;
/** After the user hits the off button. */
- (void)didHitOffButton:(NSButton*)button;

#pragma mark - View Frames
/// @name View Frames

- (NSRect)frameForMainView;
- (NSRect)frameForOffButton;
- (NSRect)frameForOnButton;

@property (assign) IBOutlet NSWindow *window;

@end
