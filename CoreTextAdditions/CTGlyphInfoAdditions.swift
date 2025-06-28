//
//  CTGlyphInfoAdditions.swift
//  CoreTextAdditions
//
//  Created by C.W. Betts on 9/12/22.
//  Copyright © 2022 C.W. Betts. All rights reserved.
//

import Foundation
import CoreText

public extension CTGlyphInfo {
	
	// MARK: Glyph Info Creation
	
	/// Creates an immutable glyph info object with a glyph name.
	///
	/// This function creates an immutable glyph info object for a glyph name such as copyright using a specified font.
	///
	/// - parameter name: The name of the glyph.
	/// - parameter font: The font to be associated with the returned `CTGlyphInfo` object.
	/// - parameter base: The part of the string the returned object is intended to override.
	/// - Returns: A valid reference to an immutable `CTGlyphInfo` object if glyph info creation was successful; otherwise, `nil`.
	@inlinable static func create(glyphName name: String, font: CTFont, baseString base: String) -> CTGlyphInfo? {
		return CTGlyphInfoCreateWithGlyphName(name as NSString, font, base as NSString)
	}
	
	/// Creates an immutable glyph info object.
	///
	/// This function creates an immutable glyph info object for a glyph
	/// index and a specified font.
	/// - parameter glyph: The glyph identifier.
	/// - parameter font: The font to be associated with the returned `CTGlyphInfo` object.
	/// - parameter baseString: The part of the string the returned object is intended to override.
	/// - Returns: This function will return a reference to a `CTGlyphInfo` object.
	@inlinable static func create(glyph: CGGlyph, font: CTFont, baseString: String) -> CTGlyphInfo? {
		return CTGlyphInfoCreateWithGlyph(glyph, font, baseString as NSString)
	}
	
	/// Creates an immutable glyph info object.
	///
	/// This function creates an immutable glyph info object for a
	/// character identifier and a character collection.
	/// - parameter cid: A character identifier.
	/// - parameter collection: A character collection identifier.
	/// - parameter baseString: The part of the string the returned object is intended to override.
	/// - Returns:  This function will return a reference to a `CTGlyphInfo` object.
	@inlinable static func create(characterIdentifier cid: CGFontIndex, collection: CTCharacterCollection, baseString: String) -> CTGlyphInfo? {
		return CTGlyphInfoCreateWithCharacterIdentifier(cid, collection, baseString as NSString)
	}
	
	// MARK: Glyph Info Access
	
	/// The glyph name, if the glyph info object was created with a name; otherwise, `nil`.
	var glyphName: String? {
		return CTGlyphInfoGetGlyphName(self) as String?
	}
	
	/// A `CGGlyph` value, if the glyph info object was created with a font; otherwise, *0*.
	@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
	@inlinable var glyph: CGGlyph {
		return CTGlyphInfoGetGlyph(self)
	}
	
	/// The character identifier.
	@inlinable var characterIdentifier: CGFontIndex {
		return CTGlyphInfoGetCharacterIdentifier(self)
	}
	
	/// The character collection for a glyph info object.
	///
	/// If the glyph info object was created with a glyph name or a glyph index, its character collection is `.identityMapping`.
	@inlinable var characterCollection: CTCharacterCollection {
		return CTGlyphInfoGetCharacterCollection(self)
	}
}
