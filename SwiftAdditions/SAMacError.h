//
//  SAMacError.h
//  SwiftAdditions
//
//  Created by C.W. Betts on 10/10/18.
//  Copyright © 2018 C.W. Betts. All rights reserved.
//

#ifndef SAMacError_h
#define SAMacError_h

#import <Foundation/NSObjCRuntime.h>
#import <Foundation/NSError.h>
#if TARGET_OS_OSX
#include <CoreServices/CoreServices.h>
#else
#define paramErr -50
#define unimpErr -4
#define fnfErr -43
#define permErr -54
#define tmfoErr -42
#define memFullErr -108
#define fnOpnErr -38
#define eofErr -39
#define posErr -40
#define nsvErr -35
#define fLckdErr -45
#define userCanceledErr -128
#define dirNFErr -120
#endif

#ifndef MTS_ERROR_ENUM
#define __MTS_ERROR_ENUM_GET_MACRO(_0, _1, _2, NAME, ...) NAME
#if ((__cplusplus && __cplusplus >= 201103L && (__has_extension(cxx_strong_enums) || __has_feature(objc_fixed_enum))) || (!__cplusplus && __has_feature(objc_fixed_enum))) && __has_attribute(ns_error_domain)
#define __MTS_NAMED_ERROR_ENUM(_type, _domain, _name)     enum _name : _type _name; enum __attribute__((ns_error_domain(_domain))) _name : _type
#define __MTS_ANON_ERROR_ENUM(_type, _domain)             enum __attribute__((ns_error_domain(_domain))) : _type
#else
#define __MTS_NAMED_ERROR_ENUM(_type, _domain, _name) NS_ENUM(_type, _name)
#define __MTS_ANON_ERROR_ENUM(_type, _domain) NS_ENUM(_type)
#endif

#define MTS_ERROR_ENUM(...) __MTS_ERROR_ENUM_GET_MACRO(__VA_ARGS__, __MTS_NAMED_ERROR_ENUM, __MTS_ANON_ERROR_ENUM)(__VA_ARGS__)
#endif

//! Common Carbon error codes
//!
//! This list is in no way, shape, or form exhaustive! A lot of the other
//! errors make no sense under Mac OS X but were needed for pre-OS X systems.
typedef MTS_ERROR_ENUM(OSStatus, NSOSStatusErrorDomain, SAMacError) {
	/*! error in user parameter list */
	SAMacErrorParameter = paramErr,
	/*! unimplemented core routine */
	SAMacErrorUnimplemented = unimpErr,
	/*! File not found */
	SAMacErrorFileNotFound = fnfErr,
	/*! permissions error (on file open) */
	SAMacErrorFilePermission = permErr,
	/*! too many files open */
	SAMacErrorTooManyFilesOpen = tmfoErr,
	/*! Not enough room in heap zone */
	SAMacErrorMemoryFull = memFullErr,
	/*! File not open */
	SAMacErrorFileNotOpen = fnOpnErr,
	/*! End of file */
	SAMacErrorEndOfFile = eofErr,
	/*! tried to position to before start of file (r/w) */
	SAMacErrorFilePosition = posErr,
	/*! no such volume */
	SAMacErrorNoSuchVolume = nsvErr,
	/*! file is locked */
	SAMacErrorFileLocked = fLckdErr,
	/*! User cancelled action */
	SAMacErrorUserCancelled = userCanceledErr,
	/*! Directory not found */
	SAMacErrorDirectoryNotFound = dirNFErr,
	
#if TARGET_OS_OSX
	SAMacErrorOSASystemError             = -1750,
	SAMacErrorOSAInvalidID               = -1751,
	SAMacErrorOSABadStorageType          = -1752,
	SAMacErrorOSAScriptError             = -1753,
	SAMacErrorOSABadSelector             = -1754,
	SAMacErrorOSASourceNotAvailable      = -1756,
	SAMacErrorOSANoSuchDialect           = -1757,
	SAMacErrorOSADataFormatObsolete      = -1758,
	SAMacErrorOSADataFormatTooNew        = -1759,
	SAMacErrorOSACorruptData             = -1702,
	SAMacErrorOSARecordingIsAlreadyOn    = -1732,
	
	/*! Parameters are from 2 different components */
	SAMacErrorOSAComponentMismatch       = -1761,
	/*! Can't connect to scripting system with that ID */
	SAMacErrorOSACantOpenComponent       = -1762,
	/*! Can't store memory pointers in a saved script */
	SAMacErrorOSACantStorePointers       = -1763
#endif
};

#endif /* SAMacError_h */
