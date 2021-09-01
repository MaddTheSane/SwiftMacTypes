//
//  Header.h
//  CoreTextAdditions
//
//  Created by C.W. Betts on 7/18/21.
//  Copyright © 2021 C.W. Betts. All rights reserved.
//

#ifndef CTAFontManagerErrors_h
#define CTAFontManagerErrors_h

#include <CoreText/CTFontManagerErrors.h>
#include <Foundation/Foundation.h>

/**
 @enum       CTAFontManagerError
 @abstract   Font registration errors
 @discussion Errors that would prevent registration of fonts for a specified font file URL.
 */
typedef NS_ERROR_ENUM(kCTFontManagerErrorDomain, CTAFontManagerError) {
	//! The file does not exist at the specified URL.
	CTAFontManagerErrorFileNotFound             = kCTFontManagerErrorFileNotFound,
	//! Cannot access the file due to insufficient permissions.
	CTAFontManagerErrorInsufficientPermissions  = kCTFontManagerErrorInsufficientPermissions,
	//! The file is not a recognized or supported font file format.
	CTAFontManagerErrorUnrecognizedFormat       = kCTFontManagerErrorUnrecognizedFormat,
	//! The file contains invalid font data that could cause system problems.
	CTAFontManagerErrorInvalidFontData          = kCTFontManagerErrorInvalidFontData,
	//! The file has already been registered in the specified scope.
	CTAFontManagerErrorAlreadyRegistered        = kCTFontManagerErrorAlreadyRegistered,
	//! The operation failed due to a system limitation.
	CTAFontManagerErrorExceededResourceLimit    = kCTFontManagerErrorExceededResourceLimit,
	
	//! The font was not found in an asset catalog.
	CTAFontManagerErrorAssetNotFound            = kCTFontManagerErrorAssetNotFound,
	//! The file is not registered in the specified scope.
	CTAFontManagerErrorNotRegistered            = kCTFontManagerErrorNotRegistered,
	//! The font file is actively in use and cannot be unregistered.
	CTAFontManagerErrorInUse                    = kCTFontManagerErrorInUse,
	//! The file is required by the system and cannot be unregistered.
	CTAFontManagerErrorSystemRequired           = kCTFontManagerErrorSystemRequired,
	//! The file could not be processed due to an unexpected FontProvider error.
	CTAFontManagerErrorRegistrationFailed       = kCTFontManagerErrorRegistrationFailed,
	//! The file could not be processed because the provider does not have a necessary entitlement.
	CTAFontManagerErrorMissingEntitlement       = kCTFontManagerErrorMissingEntitlement,
	//! The font descriptor does not have information to specify a font file.
	CTAFontManagerErrorInsufficientInfo         = kCTFontManagerErrorInsufficientInfo,
	//! The operation was cancelled by the user.
	CTAFontManagerErrorCancelledByUser          = kCTFontManagerErrorCancelledByUser,
	//! The file could not be registered because of a duplicated font name.
	CTAFontManagerErrorDuplicatedName           = kCTFontManagerErrorDuplicatedName,
	//! The file is not in an allowed location. It must be either in the application's
	//! bundle or an on-demand resource.
	CTAFontManagerErrorInvalidFilePath          = kCTFontManagerErrorInvalidFilePath,
	
	//! The specified scope is not supported.
	CTAFontManagerErrorUnsupportedScope         = kCTFontManagerErrorUnsupportedScope
};

#endif /* CTAFontManagerErrors_h */
