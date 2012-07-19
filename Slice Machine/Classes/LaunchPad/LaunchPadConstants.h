//
//  LaunchPadConstants.h
//  Slice Machine
//
//  Created by Schell Scivally on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Slice_Machine_LaunchPadConstants_h
#define Slice_Machine_LaunchPadConstants_h

#pragma mark -
#pragma mark Output Messages
#pragma mark -

#pragma mark Double Buffering
/// @name Double Buffering

/** Turns double buffering off. */
#define OMSG_BUFFERING_OFF {0xB0,0x00,0x30}
/** Turns double buffering on and sets buffer1 as displayed and
 buffer0 as updating. 
 */
#define OMSG_BUFFER1_SHOW {0xB0,0x00,0x31}
/** Turns double buffering on and sets buffer0 as displayed and
 buffer1 as updating.
 */
#define OMSG_BUFFER0_SHOW {0xB0,0x00,0x34}

#pragma mark -
#pragma mark Input Messages
#pragma mark -

/** The first part of a launchpad-to-computer message specifying that
 a grid button was pressed. The remaining values are key and velocity.
 */
#define IMSG_CMD_GRIDPRESS 0x90
/** The first part of a launchpad-to-computer message specifying that
 a control button was pressed. The remaining values are key (0x68-0x6F) and data.
 */
#define IMSG_CMD_CTRLPRESS 0x80

#endif
