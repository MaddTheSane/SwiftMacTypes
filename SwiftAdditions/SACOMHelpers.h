//
//  SACOMHelpers.h
//  SwiftAdditions
//
//  Created by C.W. Betts on 11/20/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

/*!
 * @header Helper functions to call common COM functions
 */

#import <Foundation/Foundation.h>
#import <CoreFoundation/CFPlugInCOM.h>

extern HRESULT SAQueryInterface(void *thisPointer, REFIID uuid, void *ppv);
extern ULONG SARetain(void *thisPointer);
extern ULONG SARelease(void *thisPointer);

static inline ULONG SAAddRef(void *thisPointer)
{
	return SARetain(thisPointer);
}
