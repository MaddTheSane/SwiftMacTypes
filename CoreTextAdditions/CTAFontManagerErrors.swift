//
//  File.swift
//  
//
//  Created by C.W. Betts on 9/1/21.
//

#if SWIFT_PACKAGE

import Foundation
import CoreText

/// Font registration errors
///
/// Errors that would prevent registration of fonts for a specified font file URL.
public struct CTAFontManagerError: Error, _BridgedStoredNSError {
	/// Retrieves the embedded NSError.
	public let _nsError: NSError

	public init(_nsError: NSError) {
		precondition(_nsError.domain == kCTFontManagerErrorDomain as String)
		self._nsError = _nsError
	}
	
	public static var errorDomain: String {
		return kCTFontManagerErrorDomain as String
	}
	
	/// Font registration errors
	///
	/// Errors that would prevent registration of fonts for a specified font file URL.
	public enum Code : Int, _ErrorCodeProtocol {

		/// Font registration errors
		///
		/// Errors that would prevent registration of fonts for a specified font file URL.
		public typealias _ErrorType = CTAFontManagerError

		
		/// The file does not exist at the specified URL.
		case fileNotFound = 101

		/// Cannot access the file due to insufficient permissions.
		case insufficientPermissions = 102

		/// The file is not a recognized or supported font file format.
		case unrecognizedFormat = 103

		/// The file contains invalid font data that could cause system problems.
		case invalidFontData = 104

		/// The file has already been registered in the specified scope.
		case alreadyRegistered = 105

		/// The operation failed due to a system limitation.
		case exceededResourceLimit = 106

		
		/// The font was not found in an asset catalog.
		case assetNotFound = 107

		/// The file is not registered in the specified scope.
		case notRegistered = 201

		/// The font file is actively in use and cannot be unregistered.
		case inUse = 202

		/// The file is required by the system and cannot be unregistered.
		case systemRequired = 203

		/// The file could not be processed due to an unexpected FontProvider error.
		case registrationFailed = 301

		/// The file could not be processed because the provider does not have a necessary entitlement.
		case missingEntitlement = 302

		/// The font descriptor does not have information to specify a font file.
		case insufficientInfo = 303

		/// The operation was cancelled by the user.
		case cancelledByUser = 304

		/// The file could not be registered because of a duplicated font name.
		case duplicatedName = 305

		/// The file is not in an allowed location. It must be either in the application's
		/// bundle or an on-demand resource.
		case invalidFilePath = 306

		
		/// The specified scope is not supported.
		case unsupportedScope = 307
	}

	/// The file does not exist at the specified URL.
	public static var fileNotFound: CTAFontManagerError.Code {
		return .fileNotFound
	}

	/// Cannot access the file due to insufficient permissions.
	public static var insufficientPermissions: CTAFontManagerError.Code {
		return .insufficientPermissions
	}

	/// The file is not a recognized or supported font file format.
	public static var unrecognizedFormat: CTAFontManagerError.Code {
		return .unrecognizedFormat
	}

	/// The file contains invalid font data that could cause system problems.
	public static var invalidFontData: CTAFontManagerError.Code {
		return .invalidFontData
	}

	/// The file has already been registered in the specified scope.
	public static var alreadyRegistered: CTAFontManagerError.Code {
		return .alreadyRegistered
	}

	/// The operation failed due to a system limitation.
	public static var exceededResourceLimit: CTAFontManagerError.Code {
		return .exceededResourceLimit
	}

	/// The font was not found in an asset catalog.
	public static var assetNotFound: CTAFontManagerError.Code {
		return .assetNotFound
	}

	/// The file is not registered in the specified scope.
	public static var notRegistered: CTAFontManagerError.Code {
		return .notRegistered
	}

	/// The font file is actively in use and cannot be unregistered.
	public static var inUse: CTAFontManagerError.Code {
		return .inUse
	}

	/// The file is required by the system and cannot be unregistered.
	public static var systemRequired: CTAFontManagerError.Code {
		return .systemRequired
	}

	/// The file could not be processed due to an unexpected FontProvider error.
	public static var registrationFailed: CTAFontManagerError.Code {
		return .registrationFailed
	}

	/// The file could not be processed because the provider does not have a necessary entitlement.
	public static var missingEntitlement: CTAFontManagerError.Code {
		return .missingEntitlement
	}

	/// The font descriptor does not have information to specify a font file.
	public static var insufficientInfo: CTAFontManagerError.Code {
		return .insufficientInfo
	}

	/// The operation was cancelled by the user.
	public static var cancelledByUser: CTAFontManagerError.Code {
		return .cancelledByUser
	}

	/// The file could not be registered because of a duplicated font name.
	public static var duplicatedName: CTAFontManagerError.Code {
		return .duplicatedName
	}

	/// The file is not in an allowed location. It must be either in the application's
	/// bundle or an on-demand resource.
	public static var invalidFilePath: CTAFontManagerError.Code {
		return .invalidFilePath
	}

	/// The specified scope is not supported.
	public static var unsupportedScope: CTAFontManagerError.Code {
		return .unsupportedScope
	}
}

#endif
