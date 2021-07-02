//
//  SAMacError.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 10/10/18.
//  Copyright © 2018 C.W. Betts. All rights reserved.
//

import Foundation

#if SWIFT_PACKAGE

/// Common Carbon error codes
///
/// This list is in no way, shape, or form exhaustive! A lot of the other
/// errors make no sense under Mac OS X but were needed for pre-OS X systems.
public struct SAMacError: _BridgedStoredNSError {
	public let _nsError: NSError

	public init(_nsError: NSError) {
		precondition(_nsError.domain == NSOSStatusErrorDomain)
		self._nsError = _nsError
	}
	
	public static var errorDomain: String { return NSOSStatusErrorDomain }
	
	/// Common Carbon error codes
	///
	/// This list is in no way, shape, or form exhaustive! A lot of the other
	/// errors make no sense under Mac OS X but were needed for pre-OS X systems.
	public enum Code: OSStatus, _ErrorCodeProtocol {
		public typealias _ErrorType = SAMacError
		
		/// error in user parameter list
		case parameter = -50
		
		/// unimplemented core routine
		case unimplemented = -4
		
		/// File not found
		case fileNotFound = -43
		
		/// permissions error (on file open)
		case filePermission = -54
		
		/// too many files open
		case tooManyFilesOpen = -42
		
		/// Not enough room in heap zone
		case memoryFull = -108
		
		/// File not open
		case fileNotOpen = -38
		
		/// End of file
		case endOfFile = -39
		
		/// tried to position to before start of file (r/w)
		case filePosition = -40
		
		/// no such volume
		case noSuchVolume = -35
		
		/// file is locked
		case fileLocked = -45

		/// User cancelled action
		case userCancelled = -128
		
		/// Directory not found
		case directoryNotFound = -120
		
		#if os(OSX)
		case osaSystemError = -1750
		case osaInvalidID = -1751
		case osaBadStorageType = -1752
		case osaScriptError = -1753
		case osaBadSelector = -1754
		case osaSourceNotAvailable = -1755
		case osaNoSuchDialect = -1756
		case osaDataFormatObsolete = -1758
		case osaDataFormatTooNew = -1759
		case osaCorruptData = -1702
		case osaRecordingIsAlreadyOn = -1732
		
		/// Parameters are from 2 different components
		case osaComponentMismatch = -1761

		/// Can't connect to scripting system with that ID
		case osaCantOpenComponent = -1762

		/// Can't store memory pointers in a saved script
		case osaCantStorePointers = -1763
		#endif
	}
	
	/// error in user parameter list
	public static var parameter: SAMacError.Code { return .parameter }
	
	/// unimplemented core routine
	public static var unimplemented: SAMacError.Code { return .unimplemented }
	
	/// File not found
	public static var fileNotFound: SAMacError.Code { return .fileNotFound }
	
	/// permissions error (on file open)
	public static var filePermission: SAMacError.Code { return .filePermission }
	
	/// too many files open
	public static var tooManyFilesOpen: SAMacError.Code { return .tooManyFilesOpen }
	
	/// Not enough room in heap zone
	public static var memoryFull: SAMacError.Code { return .memoryFull }
	
	/// File not open
	public static var fileNotOpen: SAMacError.Code { return .fileNotOpen }
	
	/// End of file
	public static var endOfFile: SAMacError.Code { return .endOfFile }
	
	/// tried to position to before start of file (r/w)
	public static var filePosition: SAMacError.Code { return .filePosition }
	
	/// no such volume
	public static var noSuchVolume: SAMacError.Code { return .noSuchVolume }
	
	/// file is locked
	public static var fileLocked: SAMacError.Code { return .fileLocked }
	
	/// User cancelled action
	public static var userCancelled: SAMacError.Code { return .userCancelled }
	
	/// Directory not found
	public static var directoryNotFound: SAMacError.Code { return .directoryNotFound }
	
	#if os(OSX)
	public static var osaSystemError: SAMacError.Code { return .osaSystemError }

	public static var osaInvalidID: SAMacError.Code { return .osaInvalidID }

	public static var osaBadStorageType: SAMacError.Code { return .osaBadStorageType }

	public static var osaScriptError: SAMacError.Code { return .osaScriptError }

	public static var osaBadSelector: SAMacError.Code { return .osaBadSelector }

	public static var osaSourceNotAvailable: SAMacError.Code { return .osaSourceNotAvailable }

	public static var osaNoSuchDialect: SAMacError.Code { return .osaNoSuchDialect }

	public static var osaDataFormatObsolete: SAMacError.Code { return .osaDataFormatObsolete }

	public static var osaDataFormatTooNew: SAMacError.Code { return .osaDataFormatTooNew }

	public static var osaCorruptData: SAMacError.Code { return .osaCorruptData }

	public static var osaRecordingIsAlreadyOn: SAMacError.Code { return .osaRecordingIsAlreadyOn }

	/// Parameters are from 2 different components
	public static var osaComponentMismatch: SAMacError.Code { return .osaComponentMismatch }

	/// Can't connect to scripting system with that ID
	public static var osaCantOpenComponent: SAMacError.Code { return .osaCantOpenComponent }

	/// Can't store memory pointers in a saved script
	public static var osaCantStorePointers: SAMacError.Code { return .osaCantStorePointers }
	#endif
}
#endif

public extension SAMacError.Code {
	/// is `nil` if value is too big for `OSErr`.
	var toOSErr: OSErr? {
		return OSErr(exactly: rawValue)
	}
	
	init?(osErrValue val: OSErr) {
		self.init(rawValue: OSStatus(val))
	}
}

public extension SAMacError {
	/// This throws the passed-in error as an `NSOSStatusErrorDomain` error.
	///
	/// `SAMacError` is not exhaustive: not every Mac OS 9/Carbon error is used!
	/// Catching `SAMacError` may also catch error values that aren't included in
	/// the `SAMacError.Code` enum.
	///
	/// Deprecated: Call `osStatus(_:userInfo:)`, then throw the created value.
	/// - parameter userInfo: Additional user info dictionary. Optional, default value is a
	/// blank dictionary.
	/// - parameter status: The `OSStatus` to throw as an `NSOSStatusErrorDomain` error.
	@available(swift, introduced: 3.0, deprecated: 5.0, obsoleted: 5.5, message: "Call osStatus(_:userInfo:), then throw the created value.")
	static func throwOSStatus(_ status: OSStatus, userInfo: [String: Any] = [:]) throws {
		throw osStatus(status, userInfo: userInfo)
	}
	
	/// This creates an error based on the `status` and anything passed into the `userInfo` dictionary.
	///
	/// `SAMacError` is not exhaustive: not every Mac OS 9/Carbon error is used!
	/// Catching `SAMacError` may also catch error values that aren't included in
	/// the `SAMacError.Code` enum.
	/// - parameter userInfo: Additional user info dictionary. Optional, default value is a
	/// blank dictionary.
	/// - parameter status: The `OSStatus` to create an error in the `NSOSStatusErrorDomain` error domain.
	/// - returns: An object conforming to the `Error` protocol, either `SAMacError` or `NSError`.
	static func osStatus(_ status: OSStatus, userInfo: [String: Any] = [:]) -> Error {
		if let saCode = SAMacError.Code(rawValue: status) {
			return SAMacError(saCode, userInfo: userInfo)
		}
		return NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: userInfo)
	}

	
	/// This throws the passed-in error as an `NSOSStatusErrorDomain` error.
	///
	/// `SAMacError` is not exhaustive: not every Mac OS 9/Carbon error is used!
	/// Catching `SAMacError` may also catch error values that aren't included in
	/// the `SAMacError.Code` enum.
	///
	/// `OSErr`s are returned by older APIs. These APIs may be deprecated and not available to
	/// Swift.
	///
	/// Deprecated: Call `osErr(_:userInfo:)`, then throw the created value.
	/// - parameter userInfo: Additional user info dictionary. Optional, default value is a
	/// blank dictionary.
	/// - parameter status: The `OSErr` to throw as an `NSOSStatusErrorDomain` error.
	@available(swift, introduced: 3.0, deprecated: 5.0, obsoleted: 5.5, message: "Call osErr(_:userInfo:), then throw the created value.")
	static func throwOSErr(_ status: OSErr, userInfo: [String: Any] = [:]) throws {
		throw osErr(status, userInfo: userInfo)
	}
	
	/// This throws the passed-in error as an `NSOSStatusErrorDomain` error.
	///
	/// `SAMacError` is not exhaustive: not every Mac OS 9/Carbon error is used!
	/// Catching `SAMacError` may also catch error values that aren't included in
	/// the `SAMacError.Code` enum.
	///
	/// `OSErr`s are returned by older APIs. These APIs may be deprecated and not available to
	/// Swift.
	/// - parameter userInfo: Additional user info dictionary. Optional, default value is a
	/// blank dictionary.
	/// - parameter status: The `OSErr` to create an error in the `NSOSStatusErrorDomain` error domain.
	/// - returns: An object conforming to the `Error` protocol, either `SAMacError` or `NSError`.
	static func osErr(_ status: OSErr, userInfo: [String: Any] = [:]) -> Error {
		if let saCode = SAMacError.Code(osErrValue: status) {
			return SAMacError(saCode, userInfo: userInfo)
		}
		return NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: userInfo)
	}

}
