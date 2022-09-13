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
