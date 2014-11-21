//
//  SACOMHelpers.h
//  SwiftAdditions
//
//  Created by C.W. Betts on 11/20/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

/*!
 * @header Helper functions to call common COM functions in Swift
 */

#import <CoreFoundation/CFPlugInCOM.h>
#import <Foundation/Foundation.h>

typedef IUnknownVTbl **IUnknownHandle;

extern HRESULT SAQueryInterface(void *thisPointer, REFIID uuid, void *ppv);
extern ULONG SARetain(void *thisPointer);
extern ULONG SARelease(void *thisPointer);

/// This has the same naming conventions as COM
static inline ULONG SAAddRef(void *thisPointer)
{
	return SARetain(thisPointer);
}
