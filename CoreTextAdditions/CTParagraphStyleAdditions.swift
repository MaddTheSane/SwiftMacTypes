//
//  CTParagraphStyleAdditions.swift
//  CoreTextAdditions
//
//  Created by C.W. Betts on 2/27/20.
//  Copyright © 2020 C.W. Betts. All rights reserved.
//

import Foundation
import CoreText

public extension CTParagraphStyle {
	/// These constants specify text alignment.
	typealias Alignment = CTTextAlignment
	
	/// These constants specify what happens when a line is too long for its frame.
	typealias LineBreakMode = CTLineBreakMode
	
	/// These constants specify the writing direction.
	typealias WritingDirection = CTWritingDirection
	
    /// These constants are used to query and modify the CTParagraphStyle
    /// object.
	///
	/// Each specifier has a type and a default value associated with it.
	/// The type must always be observed when setting or fetching the
	/// value from the `CTParagraphStyle` object. In addition, some
	/// specifiers affect the behavior of both the framesetter and
	/// the typesetter, and others only affect the behavior of the
	/// framesetter; this is also noted below.
	typealias Specifier = CTParagraphStyleSpecifier
	
	/// This structure is used to alter the paragraph style.
	typealias Setting = CTParagraphStyleSetting
	
	/// Creates an immutable paragraph style.
	/// - parameter settings: The settings that you wish to pre-load the paragraph style
	/// with. If you wish to specify the default set of settings,
	/// then this parameter may be set to `nil`.
	/// - returns: If the paragraph style creation was successful, this function
	/// will return a valid reference to an immutable `CTParagraphStyle`
	/// object. Otherwise, this function will return `nil`.
	///
	/// Using this function is the easiest and most efficient way to
	/// create a paragraph style. Paragraph styles should be kept
	/// immutable for totally lock-free operation.
	///
	/// If an invalid paragraph style setting specifier is passed into
	/// the "settings" parameter, nothing bad will happen but just don't
	/// expect to be able to query for this value. This is to allow
	/// backwards compatibility with style setting specifiers that may
	/// be introduced in future versions.
	class func create(settings: [Setting]?) -> CTParagraphStyle {
		return CTParagraphStyleCreate(settings, settings?.count ?? 0)
	}
	
	/// Creates an immutable copy of the paragraph style.
	/// - returns: If the "paragraphStyle" reference is valid, then this
	/// function will return valid reference to an immutable
	/// CTParagraphStyle object that is a copy of the one passed into
	/// "paragraphStyle".
	@inlinable func copy() -> CTParagraphStyle {
		return CTParagraphStyleCreateCopy(self)
	}
	
	/// Obtains the current value for a single setting specifier.
	/// - parameter specifier: The setting specifier that you want to get the value for.
	/// - parameter valueBufferSize: The size of the buffer pointed to by the
	/// "valueBuffer" parameter. This value must be at least as large as the size the
	/// required by the `Specifier` value set in the "spec" parameter.
	/// - parameter valueBuffer: The buffer where the requested setting value will be
	/// written upon successful completion. The buffer's size needs to be at least as
	/// large as the value passed into "valueBufferSize".
	/// - returns: This function will return "true" if the `valueBuffer` had been
	/// successfully filled. Otherwise, this function will return `false`,
	/// indicating that one or more of the parameters is not valid.
	///
	/// This function will return the current value of the specifier
	/// whether or not the user had actually set it. If the user has
	/// not set it, this function will return the default value.
	///
	/// If an invalid paragraph style setting specifier is passed into
	/// the "spec" parameter, nothing bad will happen and the buffer
	/// value will simply be zeroed out. This is to allow backwards
	/// compatibility with style setting specifier that may be introduced
	/// in future versions.
	@inlinable func value(for specifier: Specifier, bufferSize valueBufferSize: Int, buffer valueBuffer: UnsafeMutableRawPointer) -> Bool {
		return CTParagraphStyleGetValueForSpecifier(self, specifier, valueBufferSize, valueBuffer)
	}
}
