//
//  SAAError.h
//  SwiftAudioAdditions
//
//  Created by C.W. Betts on 9/23/18.
//  Copyright © 2018 C.W. Betts. All rights reserved.
//

#ifndef SAAError_h
#define SAAError_h

#import <Foundation/NSObjCRuntime.h>
#import <Foundation/NSError.h>
#include <AudioToolbox/AUComponent.h>
#include <AudioToolbox/AudioFile.h>
#include <CoreAudio/CoreAudioTypes.h>
#include <CoreMIDI/MIDIServices.h>

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

extern NSErrorDomain const SAACoreAudioErrorDomain;
typedef MTS_ERROR_ENUM(OSStatus, SAACoreAudioErrorDomain, SAACoreAudioError) {
	SAACoreAudioErrorInvalidProperty = kAudioUnitErr_InvalidProperty,
	SAACoreAudioErrorInvalidParameter = kAudioUnitErr_InvalidParameter,
	SAACoreAudioErrorInvalidElement = kAudioUnitErr_InvalidElement,
	SAACoreAudioErrorNoConnection = kAudioUnitErr_NoConnection,
	SAACoreAudioErrorFailedInitialization = kAudioUnitErr_FailedInitialization,
	SAACoreAudioErrorTooManyFramesToProcess = kAudioUnitErr_TooManyFramesToProcess,
	SAACoreAudioErrorInvalidFile = kAudioUnitErr_InvalidFile,
	SAACoreAudioErrorUnknownFileType = kAudioUnitErr_UnknownFileType,
	SAACoreAudioErrorFileNotSpecified = kAudioUnitErr_FileNotSpecified,
	SAACoreAudioErrorFormatNotSupported = kAudioUnitErr_FormatNotSupported,
	SAACoreAudioErrorUninitialized = kAudioUnitErr_Uninitialized,
	SAACoreAudioErrorInvalidScope = kAudioUnitErr_InvalidScope,
	SAACoreAudioErrorPropertyNotWritable = kAudioUnitErr_PropertyNotWritable,
	SAACoreAudioErrorCannotDoInCurrentContext = kAudioUnitErr_CannotDoInCurrentContext,
	SAACoreAudioErrorInvalidPropertyValue = kAudioUnitErr_InvalidPropertyValue,
	SAACoreAudioErrorPropertyNotInUse = kAudioUnitErr_PropertyNotInUse,
	SAACoreAudioErrorInitialized = kAudioUnitErr_Initialized,
	SAACoreAudioErrorInvalidOfflineRender = kAudioUnitErr_InvalidOfflineRender,
	SAACoreAudioErrorUnauthorized = kAudioUnitErr_Unauthorized,
	SAACoreAudioErrorMIDIOutputBufferFull = kAudioUnitErr_MIDIOutputBufferFull,
	SAACoreAudioErrorComponentInstanceTimedOut = kAudioComponentErr_InstanceTimedOut,
	SAACoreAudioErrorComponentInstanceInvalidated = kAudioComponentErr_InstanceInvalidated,
	SAACoreAudioErrorRenderTimeout = kAudioUnitErr_RenderTimeout,
	SAACoreAudioErrorExtensionNotFound = kAudioUnitErr_ExtensionNotFound,
	SAACoreAudioErrorInvalidParameterValue = kAudioUnitErr_InvalidParameterValue,
	SAACoreAudioErrorUnimplemented = kAudio_UnimplementedError,
	SAACoreAudioErrorFileNotFound = kAudio_FileNotFoundError,
	SAACoreAudioErrorFilePermission = kAudio_FilePermissionError,
	SAACoreAudioErrorTooManyFilesOpen = kAudio_TooManyFilesOpenError,
	SAACoreAudioErrorParameter = kAudio_ParamError,
	SAACoreAudioErrorMemoryFull = kAudio_MemFullError,
	SAACoreAudioErrorFileNotOpen = kAudioFileNotOpenError,
	SAACoreAudioErrorEndOfFile = kAudioFileEndOfFileError,
	SAACoreAudioErrorFilePosition = kAudioFilePositionError,
	SAACoreAudioErrorBadFilePath = kAudio_BadFilePathError,
	SAACoreAudioErrorFileUnspecified = kAudioFileUnspecifiedError,
	SAACoreAudioErrorFileUnsupportedFileType = kAudioFileUnsupportedFileTypeError,
	SAACoreAudioErrorFileUnsupportedDataFormat = kAudioFileUnsupportedDataFormatError,
	SAACoreAudioErrorFileUnsupportedProperty = kAudioFileUnsupportedPropertyError,
	SAACoreAudioErrorFileBadPropertySize = kAudioFileBadPropertySizeError,
	SAACoreAudioErrorFilePermissions = kAudioFilePermissionsError,
	SAACoreAudioErrorFileNotOptomized = kAudioFileNotOptimizedError,
	SAACoreAudioErrorFileInvalidChunk = kAudioFileInvalidChunkError,
	SAACoreAudioErrorFileDoesNotAllow64BitDataSize = kAudioFileDoesNotAllow64BitDataSizeError,
	SAACoreAudioErrorFileInvalidPacketOffset = kAudioFileInvalidPacketOffsetError,
	SAACoreAudioErrorFileInvalidFile = kAudioFileInvalidFileError,
	SAACoreAudioErrorFileOperationNotSupported = kAudioFileOperationNotSupportedError,
	SAACoreAudioErrorMIDIInvalidClient = kMIDIInvalidClient,
	SAACoreAudioErrorMIDIInvalidPort = kMIDIInvalidPort,
	SAACoreAudioErrorMIDIWrongEndpointType = kMIDIWrongEndpointType,
	SAACoreAudioErrorMIDINoConnection = kMIDINoConnection,
	SAACoreAudioErrorMIDIUnknownEndpoint = kMIDIUnknownEndpoint,
	SAACoreAudioErrorMIDIUnknownProperty = kMIDIUnknownProperty,
	SAACoreAudioErrorMIDIWrongPropertyType = kMIDIWrongPropertyType,
	SAACoreAudioErrorMIDINoCurrentSetup = kMIDINoCurrentSetup,
	SAACoreAudioErrorMIDIMessageSend = kMIDIMessageSendErr,
	SAACoreAudioErrorMIDIServerStart = kMIDIServerStartErr,
	SAACoreAudioErrorMIDISetupFormat = kMIDISetupFormatErr,
	SAACoreAudioErrorMIDIWrongThread = kMIDIWrongThread,
	SAACoreAudioErrorMIDIObjectNotFound = kMIDIObjectNotFound,
	SAACoreAudioErrorMIDINotUnique = kMIDIIDNotUnique,
	SAACoreAudioErrorMIDINotPermitted = kMIDINotPermitted,
	SAACoreAudioErrorMIDIUnknown = kMIDIUnknownError,
};

#endif /* SAAError_h */
