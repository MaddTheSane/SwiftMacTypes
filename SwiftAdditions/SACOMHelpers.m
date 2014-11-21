//
//  SACOMHelpers.m
//  SwiftAdditions
//
//  Created by C.W. Betts on 11/20/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

#import "SACOMHelpers.h"

HRESULT SAQueryInterface(void *thisPointer, REFIID uuid, void *ppv)
{
	IUnknownVTbl **interface = thisPointer;
	
	return (*interface)->QueryInterface(interface, uuid, ppv);
}

ULONG SARetain(void *thisPointer)
{
	IUnknownVTbl **interface = thisPointer;
	
	return (*interface)->AddRef(interface);

}

ULONG SARelease(void *thisPointer)
{
	IUnknownVTbl **interface = thisPointer;
	
	return (*interface)->Release(interface);

}

