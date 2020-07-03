//
//  CoreAudioError.swift
//  SwiftAudioAdditions
//
//  Created by C.W. Betts on 9/28/18.
//  Copyright © 2018 C.W. Betts. All rights reserved.
//

import Foundation
#if SWIFT_PACKAGE

public var SAACoreAudioErrorDomain: String {
	return "com.github.maddthesane.SwiftAudioAdditions.errors"
}

/// Errors found in the audio frameworks of Mac OS X/iOS
public struct SAACoreAudioError: _BridgedStoredNSError {
	public let _nsError: NSError
	
	public static var _nsErrorDomain: String {
		return SAACoreAudioErrorDomain
	}
	public static var errorDomain: String {
		return SAACoreAudioErrorDomain
	}
	
	/// Errors found in the audio frameworks of Mac OS X/iOS
	public enum Code: OSStatus, _ErrorCodeProtocol {
		public typealias _ErrorType = SAACoreAudioError

		case invalidProperty = -10879
		case invalidParameter = -10878
		case invalidElement = -10877
		case noConnection = -10876
		case failedInitialization = -10875
		case tooManyFramesToProcess = -10874
		case invalidFile = -10871
		case unknownFileType = -10870
		case fileNotSpecified = -10869
		case formatNotSupported = -10868
		case uninitialized = -10867
		case invalidScope = -10866
		case propertyNotWritable = -10865
		case cannotDoInCurrentContext = -10863
		case invalidPropertyValue = -10851
		case propertyNotInUse = -10850
		case initialized = -10849
		case invalidOfflineRender = -10848
		case unauthorized = -10847
		case midiOutputBufferFull = -66753
		case componentInstanceTimedOut = -66754
		case componentInstanceInvalidated = -66749
		case renderTimeout = -66745
		case extensionNotFound = -66744
		case invalidParameterValue = -66743
		case badFilePath = 561017960
		/// An unspecified error has occurred.
		case fileUnspecified = 2003334207
		/// The file type is not supported.
		case fileUnsupportedFileType = 1954115647
		/// The data format is not supported by this file type.
		case fileUnsupportedDataFormat = 1718449215
		/// The property is not supported.
		case fileUnsupportedProperty = 1886681407
		/// The size of the property data was not correct.
		case fileBadPropertySize = 561211770
		/// The operation violated the file permissions. For example, an attempt was made to write to a file opened with the `kAudioFileReadPermission` constant.
		case filePermissions = 1886547263
		/// The chunks following the audio data chunk are preventing the extension of the audio data chunk. To write more data, you must optimize the file.
		case fileNotOptomized = 1869640813
		/// Either the chunk does not exist in the file or it is not supported by the file.
		case fileInvalidChunk = 1667787583
		/// The file offset was too large for the file type. The AIFF and WAVE file format types have 32-bit file size limits.
		case fileDoesNotAllow64BitDataSize = 1868981823
		/// A packet offset was past the end of the file, or not at the end of the file when a VBR format was written, or a corrupt packet size was read when the packet table was built.
		case fileInvalidPacketOffset = 1885563711
		/// The file is malformed, or otherwise not a valid instance of an audio file of its type.
		case fileInvalidFile = 1685348671
		/// The operation cannot be performed. For example, setting the `kAudioFilePropertyAudioDataByteCount` constant to increase the size of the audio data in a file is not a supported operation. Write the data instead.
		case fileOperationNotSupported = 1869627199
		/// An invalid `MIDIClientRef` was passed.
		case midiInvalidClient = -10830
		/// An invalid `MIDIPortRef` was passed.
		case midiInvalidPort = -10831
		/// A source endpoint was passed to a function expecting a destination, or vice versa.
		case midiWrongEndpointType = -10832
		/// Attempt to close a non-existant connection.
		case midiNoConnection = -10833
		/// An invalid `MIDIEndpointRef` was passed.
		case midiUnknownEndpoint = -10834
		/// Attempt to query a property not set on the object.
		case midiUnknownProperty = -10835
		/// Attempt to set a property with a value not of the correct type.
		case midiWrongPropertyType = -10836
		/// Internal error; there is no current MIDI setup object.
		case midiNoCurrentSetup = -10837
		/// Communication with MIDIServer failed.
		case midiMessageSend = -10838
		/// Unable to start MIDIServer.
		case midiServerStart = -10839
		/// Unable to read the saved state.
		case midiSetupFormat = -10840
		/// A driver is calling a non-I/O function in the server from a thread other than the server's main thread.
		case midiWrongThread = -10841
		/// The requested object does not exist.
		case midiObjectNotFound = -10842
		/// Attempt to set a non-unique `kMIDIPropertyUniqueID` on an object.
		case midiNotUnique = -10843
		
		case midiNotPermitted = -10844
		case midiUnknown = -10845
		case extAudioFileInvalidProperty = -66561
		case extAudioFileInvalidPropertySize = -66562
		case extAudioFileNonPCMClientFormat = -66563
		
		/// The number of channels does not match the specified format.
		case extAudioFileInvalidChannelMap = -66564
		
		case extAudioFileInvalidOperationOrder = -66565
		case extAudioFileInvalidDataFormat = -66566
		case extAudioFileMaxPacketSizeUnknown = -66567
		
		/// An attempt to write, or an offset, is out of bounds.
		case extAudioFileInvalidSeek = -66568
		
		case extAudioFileAsyncWriteTooLarge = -66569
		
		/// An asynchronous write operation could not be completed in time.
		case extAudioFileAsyncWriteBufferOverflow = -66570
	}
	
	public init(_nsError error: NSError) {
		precondition(error.domain == SAACoreAudioErrorDomain)
		_nsError = error
	}
	
	public static var invalidProperty: SAACoreAudioError.Code { return .invalidProperty }
	public static var invalidParameter: SAACoreAudioError.Code { return .invalidParameter }
	public static var invalidElement: SAACoreAudioError.Code { return .invalidElement }
	public static var noConnection: SAACoreAudioError.Code { return .noConnection }
	public static var failedInitialization: SAACoreAudioError.Code { return .failedInitialization }
	public static var tooManyFramesToProcess: SAACoreAudioError.Code { return .tooManyFramesToProcess }
	public static var invalidFile: SAACoreAudioError.Code { return .invalidFile }
	public static var unknownFileType: SAACoreAudioError.Code { return .unknownFileType }
	public static var fileNotSpecified: SAACoreAudioError.Code { return .fileNotSpecified }
	public static var formatNotSupported: SAACoreAudioError.Code { return .formatNotSupported }
	public static var uninitialized: SAACoreAudioError.Code { return .uninitialized }
	public static var invalidScope: SAACoreAudioError.Code { return .invalidScope }
	public static var propertyNotWritable: SAACoreAudioError.Code { return .propertyNotWritable }
	public static var cannotDoInCurrentContext: SAACoreAudioError.Code { return .cannotDoInCurrentContext }
	public static var invalidPropertyValue: SAACoreAudioError.Code { return .invalidPropertyValue }
	public static var propertyNotInUse: SAACoreAudioError.Code { return .propertyNotInUse }
	public static var initialized: SAACoreAudioError.Code { return .initialized }
	public static var invalidOfflineRender: SAACoreAudioError.Code { return .invalidOfflineRender }
	public static var unauthorized: SAACoreAudioError.Code { return .unauthorized }
	public static var midiOutputBufferFull: SAACoreAudioError.Code { return .midiOutputBufferFull }
	public static var componentInstanceTimedOut: SAACoreAudioError.Code { return .componentInstanceTimedOut }
	public static var componentInstanceInvalidated: SAACoreAudioError.Code { return .componentInstanceInvalidated }
	public static var renderTimeout: SAACoreAudioError.Code { return .renderTimeout }
	public static var extensionNotFound: SAACoreAudioError.Code { return .extensionNotFound }
	public static var invalidParameterValue: SAACoreAudioError.Code { return .invalidParameterValue }
	/// An unspecified error has occurred.
	public static var fileUnspecified: SAACoreAudioError.Code { return .fileUnspecified }
	/// The data format is not supported by this file type.
	public static var fileUnsupportedFileType: SAACoreAudioError.Code { return .fileUnsupportedFileType }
	/// The data format is not supported by this file type.
	public static var fileUnsupportedDataFormat: SAACoreAudioError.Code { return .fileUnsupportedDataFormat }
	/// The property is not supported.
	public static var fileUnsupportedProperty: SAACoreAudioError.Code { return .fileUnsupportedProperty }
	/// The size of the property data was not correct.
	public static var fileBadPropertySize: SAACoreAudioError.Code { return .fileBadPropertySize }
	/// The operation violated the file permissions. For example, an attempt was made to write to a file opened with the `kAudioFileReadPermission` constant.
	public static var filePermissions: SAACoreAudioError.Code { return .filePermissions }
	/// The chunks following the audio data chunk are preventing the extension of the audio data chunk. To write more data, you must optimize the file.
	public static var fileNotOptomized: SAACoreAudioError.Code { return .fileNotOptomized }
	/// Either the chunk does not exist in the file or it is not supported by the file.
	public static var fileInvalidChunk: SAACoreAudioError.Code { return .fileInvalidChunk }
	/// The file offset was too large for the file type. The AIFF and WAVE file format types have 32-bit file size limits.
	public static var fileDoesNotAllow64BitDataSize: SAACoreAudioError.Code { return .fileDoesNotAllow64BitDataSize }
	/// A packet offset was past the end of the file, or not at the end of the file when a VBR format was written, or a corrupt packet size was read when the packet table was built.
	public static var fileInvalidPacketOffset: SAACoreAudioError.Code { return .fileInvalidPacketOffset }
	/// The file is malformed, or otherwise not a valid instance of an audio file of its type.
	public static var fileInvalidFile: SAACoreAudioError.Code { return .fileInvalidFile }
	/// The operation cannot be performed. For example, setting the `kAudioFilePropertyAudioDataByteCount` constant to increase the size of the audio data in a file is not a supported operation. Write the data instead.
	public static var fileOperationNotSupported: SAACoreAudioError.Code { return .fileOperationNotSupported }
	/// An invalid `MIDIClientRef` was passed.
	public static var midiInvalidClient: SAACoreAudioError.Code { return .midiInvalidClient }
	/// An invalid `MIDIPortRef` was passed.
	public static var midiInvalidPort: SAACoreAudioError.Code { return .midiInvalidPort }
	/// A source endpoint was passed to a function expecting a destination, or vice versa.
	public static var midiWrongEndpointType: SAACoreAudioError.Code { return .midiWrongEndpointType }
	/// Attempt to close a non-existant connection.
	public static var midiNoConnection: SAACoreAudioError.Code { return .midiNoConnection }
	/// An invalid `MIDIEndpointRef` was passed.
	public static var midiUnknownEndpoint: SAACoreAudioError.Code { return .midiUnknownEndpoint }
	/// Attempt to query a property not set on the object.
	public static var midiUnknownProperty: SAACoreAudioError.Code { return .midiUnknownProperty }
	/// Attempt to set a property with a value not of the correct type.
	public static var midiWrongPropertyType: SAACoreAudioError.Code { return .midiWrongPropertyType }
	/// Internal error; there is no current MIDI setup object.
	public static var midiNoCurrentSetup: SAACoreAudioError.Code { return .midiNoCurrentSetup }
	/// Communication with MIDIServer failed.
	public static var midiMessageSend: SAACoreAudioError.Code { return .midiMessageSend }
	/// Unable to start MIDIServer.
	public static var midiServerStart: SAACoreAudioError.Code { return .midiServerStart }
	/// Unable to read the saved state.
	public static var midiSetupFormat: SAACoreAudioError.Code { return .midiSetupFormat }
	/// A driver is calling a non-I/O function in the server from a thread other than the server's main thread.
	public static var midiWrongThread: SAACoreAudioError.Code { return .midiWrongThread }
	/// The requested object does not exist.
	public static var midiObjectNotFound: SAACoreAudioError.Code { return .midiObjectNotFound }
	/// Attempt to set a non-unique `kMIDIPropertyUniqueID` on an object.
	public static var midiNotUnique: SAACoreAudioError.Code { return .midiNotUnique }
	
	public static var midiNotPermitted: SAACoreAudioError.Code { return .midiNotPermitted }
	public static var midiUnknown: SAACoreAudioError.Code { return .midiUnknown }
	public static var extAudioFileInvalidProperty: SAACoreAudioError.Code { return .extAudioFileInvalidProperty }
	public static var extAudioFileInvalidPropertySize: SAACoreAudioError.Code { return .extAudioFileInvalidPropertySize }
	public static var extAudioFileNonPCMClientFormat: SAACoreAudioError.Code { return .extAudioFileNonPCMClientFormat }
	
	/// The number of channels does not match the specified format.
	public static var extAudioFileInvalidChannelMap: SAACoreAudioError.Code { return .extAudioFileInvalidChannelMap }
	
	public static var extAudioFileInvalidOperationOrder: SAACoreAudioError.Code { return .extAudioFileInvalidOperationOrder }
	public static var extAudioFileInvalidDataFormat: SAACoreAudioError.Code { return .extAudioFileInvalidDataFormat }
	public static var extAudioFileMaxPacketSizeUnknown: SAACoreAudioError.Code { return .extAudioFileMaxPacketSizeUnknown }
	
	/// An attempt to write, or an offset, is out of bounds.
	public static var extAudioFileInvalidSeek: SAACoreAudioError.Code { return .extAudioFileInvalidSeek }
	
	public static var extAudioFileAsyncWriteTooLarge: SAACoreAudioError.Code { return .extAudioFileAsyncWriteTooLarge }
	
	/// An asynchronous write operation could not be completed in time.
	public static var extAudioFileAsyncWriteBufferOverflow: SAACoreAudioError.Code { return .extAudioFileAsyncWriteBufferOverflow }
}

#endif
