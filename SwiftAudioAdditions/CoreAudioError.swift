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
		case fileUnspecified = 2003334207
		case fileUnsupportedFileType = 1954115647
		case fileUnsupportedDataFormat = 1718449215
		case fileUnsupportedProperty = 1886681407
		case fileBadPropertySize = 561211770
		case filePermissions = 1886547263
		case fileNotOptomized = 1869640813
		case fileInvalidChunk = 1667787583
		case fileDoesNotAllow64BitDataSize = 1868981823
		case fileInvalidPacketOffset = 1885563711
		case fileInvalidFile = 1685348671
		case fileOperationNotSupported = 1869627199
		case midiInvalidClient = -10830
		case midiInvalidPort = -10831
		case midiWrongEndpointType = -10832
		case midiNoConnection = -10833
		case midiUnknownEndpoint = -10834
		case midiUnknownProperty = -10835
		case midiWrongPropertyType = -10836
		case midiNoCurrentSetup = -10837
		case midiMessageSend = -10838
		case midiServerStart = -10839
		case midiSetupFormat = -10840
		case midiWrongThread = -10841
		case midiObjectNotFound = -10842
		case midiNotUnique = -10843
		case midiNotPermitted = -10844
		case midiUnknown = -10845
		case extAudioFileInvalidProperty = -66561
		case extAudioFileInvalidPropertySize = -66562
		case extAudioFileNonPCMClientFormat = -66563
		
		/// number of channels doesn't match format
		case extAudioFileInvalidChannelMap = -66564
		
		case extAudioFileInvalidOperationOrder = -66565
		case extAudioFileInvalidDataFormat = -66566
		case extAudioFileMaxPacketSizeUnknown = -66567
		
		/// writing, or offset out of bounds
		case extAudioFileInvalidSeek = -66568
		
		case extAudioFileAsyncWriteTooLarge = -66569
		
		/// an async write could not be completed in time
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
	public static var fileUnspecified: SAACoreAudioError.Code { return .fileUnspecified }
	public static var fileUnsupportedFileType: SAACoreAudioError.Code { return .fileUnsupportedFileType }
	public static var fileUnsupportedDataFormat: SAACoreAudioError.Code { return .fileUnsupportedDataFormat }
	public static var fileUnsupportedProperty: SAACoreAudioError.Code { return .fileUnsupportedProperty }
	public static var fileBadPropertySize: SAACoreAudioError.Code { return .fileBadPropertySize }
	public static var filePermissions: SAACoreAudioError.Code { return .filePermissions }
	public static var fileNotOptomized: SAACoreAudioError.Code { return .fileNotOptomized }
	public static var fileInvalidChunk: SAACoreAudioError.Code { return .fileInvalidChunk }
	public static var fileDoesNotAllow64BitDataSize: SAACoreAudioError.Code { return .fileDoesNotAllow64BitDataSize }
	public static var fileInvalidPacketOffset: SAACoreAudioError.Code { return .fileInvalidPacketOffset }
	public static var fileInvalidFile: SAACoreAudioError.Code { return .fileInvalidFile }
	public static var fileOperationNotSupported: SAACoreAudioError.Code { return .fileOperationNotSupported }
	public static var midiInvalidClient: SAACoreAudioError.Code { return .midiInvalidClient }
	public static var midiInvalidPort: SAACoreAudioError.Code { return .midiInvalidPort }
	public static var midiWrongEndpointType: SAACoreAudioError.Code { return .midiWrongEndpointType }
	public static var midiNoConnection: SAACoreAudioError.Code { return .midiNoConnection }
	public static var midiUnknownEndpoint: SAACoreAudioError.Code { return .midiUnknownEndpoint }
	public static var midiUnknownProperty: SAACoreAudioError.Code { return .midiUnknownProperty }
	public static var midiWrongPropertyType: SAACoreAudioError.Code { return .midiWrongPropertyType }
	public static var midiNoCurrentSetup: SAACoreAudioError.Code { return .midiNoCurrentSetup }
	public static var midiMessageSend: SAACoreAudioError.Code { return .midiMessageSend }
	public static var midiServerStart: SAACoreAudioError.Code { return .midiServerStart }
	public static var midiSetupFormat: SAACoreAudioError.Code { return .midiSetupFormat }
	public static var midiWrongThread: SAACoreAudioError.Code { return .midiWrongThread }
	public static var midiObjectNotFound: SAACoreAudioError.Code { return .midiObjectNotFound }
	public static var midiNotUnique: SAACoreAudioError.Code { return .midiNotUnique }
	public static var midiNotPermitted: SAACoreAudioError.Code { return .midiNotPermitted }
	public static var midiUnknown: SAACoreAudioError.Code { return .midiUnknown }
	public static var extAudioFileInvalidProperty: SAACoreAudioError.Code { return .extAudioFileInvalidProperty }
	public static var extAudioFileInvalidPropertySize: SAACoreAudioError.Code { return .extAudioFileInvalidPropertySize }
	public static var extAudioFileNonPCMClientFormat: SAACoreAudioError.Code { return .extAudioFileNonPCMClientFormat }
	
	/// number of channels doesn't match format
	public static var extAudioFileInvalidChannelMap: SAACoreAudioError.Code { return .extAudioFileInvalidChannelMap }
	
	public static var extAudioFileInvalidOperationOrder: SAACoreAudioError.Code { return .extAudioFileInvalidOperationOrder }
	public static var extAudioFileInvalidDataFormat: SAACoreAudioError.Code { return .extAudioFileInvalidDataFormat }
	public static var extAudioFileMaxPacketSizeUnknown: SAACoreAudioError.Code { return .extAudioFileMaxPacketSizeUnknown }
	
	/// writing, or offset out of bounds
	public static var extAudioFileInvalidSeek: SAACoreAudioError.Code { return .extAudioFileInvalidSeek }
	
	public static var extAudioFileAsyncWriteTooLarge: SAACoreAudioError.Code { return .extAudioFileAsyncWriteTooLarge }
	
	/// an async write could not be completed in time
	public static var extAudioFileAsyncWriteBufferOverflow: SAACoreAudioError.Code { return .extAudioFileAsyncWriteBufferOverflow }
	

}

#endif
