//
//  SAIOCOMHelpers.m
//  SwiftAdditions
//
//  Created by C.W. Betts on 11/20/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

#import "SAIOCOMHelpers.h"

IOReturn SAIOProbe(void *thisPointer, CFDictionaryRef propertyTable, io_service_t service, SInt32 *order)
{
	IOCFPlugInInterface **unwrapped = thisPointer;
	
	return (*unwrapped)->Probe(thisPointer, propertyTable, service, order);
}

IOReturn SAIOStart(void *thisPointer, CFDictionaryRef propertyTable, io_service_t service)
{
	IOCFPlugInInterface **unwrapped = thisPointer;

	return (*unwrapped)->Start(thisPointer, propertyTable, service);
}

IOReturn SAIOStop(void *thisPointer)
{
	IOCFPlugInInterface **unwrapped = thisPointer;

	return (*unwrapped)->Stop(thisPointer);
}

