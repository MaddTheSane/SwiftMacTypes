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
#include <AudioToolbox/ExtendedAudioFile.h>
#include <AudioToolbox/AudioUnitProperties.h>
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
//! Errors found in the audio frameworks of Mac OS X/iOS
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
	SAACoreAudioErrorBadFilePath = kAudio_BadFilePathError,
	SAACoreAudioErrorMIDINotPermitted = kMIDINotPermitted,
	SAACoreAudioErrorMIDIUnknown = kMIDIUnknownError,
	SAACoreAudioErrorExtAudioFileInvalidProperty = kExtAudioFileError_InvalidProperty,
	SAACoreAudioErrorExtAudioFileInvalidPropertySize = kExtAudioFileError_InvalidPropertySize,
	SAACoreAudioErrorExtAudioFileNonPCMClientFormat = kExtAudioFileError_NonPCMClientFormat,
	SAACoreAudioErrorExtAudioFileInvalidOperationOrder = kExtAudioFileError_InvalidOperationOrder,
	SAACoreAudioErrorExtAudioFileInvalidDataFormat = kExtAudioFileError_InvalidDataFormat,
	SAACoreAudioErrorExtAudioFileMaxPacketSizeUnknown = kExtAudioFileError_MaxPacketSizeUnknown,
	SAACoreAudioErrorExtAudioFileAsyncWriteTooLarge = kExtAudioFileError_AsyncWriteTooLarge,
	//! An unspecified error has occurred.
	SAACoreAudioErrorFileUnspecified = kAudioFileUnspecifiedError,
	//! The file type is not supported.
	SAACoreAudioErrorFileUnsupportedFileType = kAudioFileUnsupportedFileTypeError,
	//! The data format is not supported by this file type.
	SAACoreAudioErrorFileUnsupportedDataFormat = kAudioFileUnsupportedDataFormatError,
	//! The property is not supported.
	SAACoreAudioErrorFileUnsupportedProperty = kAudioFileUnsupportedPropertyError,
	//! The size of the property data was not correct.
	SAACoreAudioErrorFileBadPropertySize = kAudioFileBadPropertySizeError,
	//! The operation violated the file permissions. For example, an attempt was made to write to a file opened with the \c kAudioFileReadPermission constant.
	SAACoreAudioErrorFilePermissions = kAudioFilePermissionsError,
	//! The chunks following the audio data chunk are preventing the extension of the audio data chunk. To write more data, you must optimize the file.
	SAACoreAudioErrorFileNotOptomized = kAudioFileNotOptimizedError,
	//! Either the chunk does not exist in the file or it is not supported by the file.
	SAACoreAudioErrorFileInvalidChunk = kAudioFileInvalidChunkError,
	//! The file offset was too large for the file type. The AIFF and WAVE file format types have 32-bit file size limits.
	SAACoreAudioErrorFileDoesNotAllow64BitDataSize = kAudioFileDoesNotAllow64BitDataSizeError,
	//! A packet offset was past the end of the file, or not at the end of the file when a VBR format was written, or a corrupt packet size was read when the packet table was built.
	SAACoreAudioErrorFileInvalidPacketOffset = kAudioFileInvalidPacketOffsetError,
	//! The file is malformed, or otherwise not a valid instance of an audio file of its type.
	SAACoreAudioErrorFileInvalidFile = kAudioFileInvalidFileError,
	//! The operation cannot be performed. For example, setting the \c kAudioFilePropertyAudioDataByteCount constant to increase the size of the audio data in a file is not a supported operation. Write the data instead.
	SAACoreAudioErrorFileOperationNotSupported = kAudioFileOperationNotSupportedError,
	//! An invalid \c MIDIClientRef was passed.
	SAACoreAudioErrorMIDIInvalidClient = kMIDIInvalidClient,
	//! An invalid \c MIDIPortRef was passed.
	SAACoreAudioErrorMIDIInvalidPort = kMIDIInvalidPort,
	//! A source endpoint was passed to a function expecting a destination, or vice versa.
	SAACoreAudioErrorMIDIWrongEndpointType = kMIDIWrongEndpointType,
	//! Attempt to close a non-existant connection.
	SAACoreAudioErrorMIDINoConnection = kMIDINoConnection,
	//! An invalid \c MIDIEndpointRef was passed.
	SAACoreAudioErrorMIDIUnknownEndpoint = kMIDIUnknownEndpoint,
	//! Attempt to query a property not set on the object.
	SAACoreAudioErrorMIDIUnknownProperty = kMIDIUnknownProperty,
	//! Attempt to set a property with a value not of the correct type.
	SAACoreAudioErrorMIDIWrongPropertyType = kMIDIWrongPropertyType,
	//! Internal error; there is no current MIDI setup object.
	SAACoreAudioErrorMIDINoCurrentSetup = kMIDINoCurrentSetup,
	//! Communication with MIDIServer failed.
	SAACoreAudioErrorMIDIMessageSend = kMIDIMessageSendErr,
	//! Unable to start MIDIServer.
	SAACoreAudioErrorMIDIServerStart = kMIDIServerStartErr,
	//! Unable to read the saved state.
	SAACoreAudioErrorMIDISetupFormat = kMIDISetupFormatErr,
	//! A driver is calling a non-I/O function in the server from a thread other than the server's main thread.
	SAACoreAudioErrorMIDIWrongThread = kMIDIWrongThread,
	//! The requested object does not exist.
	SAACoreAudioErrorMIDIObjectNotFound = kMIDIObjectNotFound,
	//! Attempt to set a non-unique \c kMIDIPropertyUniqueID on an object.
	SAACoreAudioErrorMIDINotUnique = kMIDIIDNotUnique,
	//! The number of channels does not match the specified format.
	SAACoreAudioErrorExtAudioFileInvalidChannelMap = kExtAudioFileError_InvalidChannelMap,
	//! An attempt to write, or an offset, is out of bounds.
	SAACoreAudioErrorExtAudioFileInvalidSeek = kExtAudioFileError_InvalidSeek,
	//! An asynchronous write operation could not be completed in time.
	SAACoreAudioErrorExtAudioFileAsyncWriteBufferOverflow = kExtAudioFileError_AsyncWriteBufferOverflow,
	
#if TARGET_OS_IPHONE
	//! Returned from \c AudioConverterFillComplexBuffer if the underlying hardware codec has
	//! become unavailable, probably due to an interruption. In this case, your application
	//! must stop calling <code>AudioConverterFillComplexBuffer</code>. If the converter can resume from an
	//! interruption (see <code>kAudioConverterPropertyCanResumeFromInterruption</code>), you must
	//! wait for an EndInterruption notification from AudioSession, and call AudioSessionSetActive(true)
	//! before resuming.
	SAACoreAudioErrorConverterHardwareInUse = kAudioConverterErr_HardwareInUse,
	//! Returned from \c AudioConverterNew if the new converter would use a hardware codec
	//! which the application does not have permission to use.
	SAACoreAudioErrorConverterNoHardwarePermission = kAudioConverterErr_NoHardwarePermission,
#else
	//! This error indicates that an unexpected number of input channels was encountered during initialization of voice processing audio unit
	SAACoreAudioErrorVoiceIOUnexpectedNumberOfInputChannels = kAUVoiceIOErr_UnexpectedNumberOfInputChannels,
#endif
};

#endif /* SAAError_h */
