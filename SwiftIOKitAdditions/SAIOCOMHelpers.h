//
//  SAIOCOMHelpers.h
//  SwiftAdditions
//
//  Created by C.W. Betts on 11/20/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <IOKit/IOCFPlugIn.h>

extern IOReturn SAIOProbe(void *thisPointer, CFDictionaryRef propertyTable, io_service_t service, SInt32 *order);
extern IOReturn SAIOStart(void *thisPointer, CFDictionaryRef propertyTable, io_service_t service);
extern IOReturn SAIOStop(void *thisPointer);
