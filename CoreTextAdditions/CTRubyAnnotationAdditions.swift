//
//  CTRubyAnnotationAdditions.swift
//  CoreTextAdditions
//
//  Created by C.W. Betts on 11/1/17.
//  Copyright © 2017 C.W. Betts. All rights reserved.
//

import Foundation
import CoreText

@available(OSX 10.10, iOS 8.0, watchOS 2.0, tvOS 9.0, *)
public extension CTRubyAnnotation {
	/// These constants specify how to align the ruby annotation and the base text relative to each other when
	/// they don't have the same length.
	typealias Alignment = CTRubyAlignment
	/// These constants specify whether, and on which side, ruby text is allowed to overhang adjacent text if
	/// it is wider than the base text.
	typealias Overhang = CTRubyOverhang
	/// These constants specify the position of the ruby text with respect to the base text.
	typealias Position = CTRubyPosition
	
	/// Creates an immutable ruby annotation object.
	/// - parameter alignment: Specifies how the ruby text and the base text should be aligned relative to each
	/// other.
	/// - parameter overhang: Specifies how the ruby text can overhang adjacent characters.
	/// - parameter sizeFactor: Specifies the size of the annotation text as a percent of the size of the
	/// base text.
	/// - parameter text: An array of `String`s, indexed by `CTRubyPosition`. Supply `nil` for any
	/// unused positions.
	/// - returns: This function will return a reference to a `CTRubyAnnotation` object.
	///
	/// Using this function is the easiest and most efficient way to
	/// create a ruby annotation object.
	static func create(alignment: Alignment, overhang: Overhang, sizeFactor: CGFloat, text: [String?]) -> CTRubyAnnotation {
		let bText = text.map({$0 as NSString?})
		var cText = bText.map { (strVal) -> Unmanaged<CFString>? in
			guard let strObj = strVal else {
				return nil
			}
			return Unmanaged<CFString>.passUnretained(strObj)
		}
		return CTRubyAnnotationCreate(alignment, overhang, sizeFactor, &cText)
	}
	
	/// Creates an immutable ruby annotation object.
	/// - parameter alignment: Specifies how the ruby text and the base text should be aligned relative
	/// to each other.
	/// - parameter overhang: Specifies how the ruby text can overhang adjacent characters.
	/// - parameter sizeFactor: Specifies the size of the annotation text as a percent of the size of
	/// the base text.
	/// - parameter text: A tuple of `String`s, indexed by `CTRubyPosition`. Supply `nil` for
	/// any unused positions.
	/// - returns: This function will return a reference to a `CTRubyAnnotation` object.
	///
	/// Using this function is the easiest and most efficient way to
	/// create a ruby annotation object.
	static func create(alignment: Alignment, overhang: Overhang, sizeFactor: CGFloat, text: (before: String?, after: String?, interCharacter: String?, inline: String?)) -> CTRubyAnnotation {
		let aText = [text.before, text.after, text.interCharacter, text.inline]
		return self.create(alignment: alignment, overhang: overhang, sizeFactor: sizeFactor, text: aText)
	}

	/// Creates an immutable ruby annotation object.
	/// - parameter attributes:
	/// A attribute dictionary to combine with the string specified above. If you don't specify
	/// `kCTFontAttributeName`, the font used by the Ruby annotation will be deduced from the base
	/// text, with a size factor specified by a `CFNumber` value keyed by
	/// `kCTRubyAnnotationSizeFactorAttributeName`.
	/// - parameter alignment: Specifies how the ruby text and the base text should be aligned relative to each
	/// other.
	/// - parameter overhang: Specifies how the ruby text can overhang adjacent characters.
	/// - parameter position: The position of the annotation text.
	/// - parameter string: A string without any formatting, its format will be derived from the attrs
	/// specified above.
	///
	/// Using this function to create a ruby annotation object with more precise
	/// control of the annotation text.
	@available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
	static func create(attributes: [String: Any], alignment: Alignment, overhang: Overhang, position: Position, string: String) -> CTRubyAnnotation {
		return CTRubyAnnotationCreateWithAttributes(alignment, overhang, position, string as NSString, attributes as NSDictionary)
	}

	/// Creates an immutable copy of a ruby annotation object.
	@inlinable func copy() -> CTRubyAnnotation {
		return CTRubyAnnotationCreateCopy(self)
	}
	
	/// the alignment value of the ruby annotation object.
	@inlinable var alignment: Alignment {
		return CTRubyAnnotationGetAlignment(self)
	}
	
	/// The overhang value of a ruby annotation object.
	@inlinable var overhang: Overhang {
		return CTRubyAnnotationGetOverhang(self)
	}
	
	/// The size factor of a ruby annotation object.
	@inlinable var sizeFactor: CGFloat {
		return CTRubyAnnotationGetSizeFactor(self)
	}
	
	/// Get the ruby text for a particular position in a ruby annotation.
	/// - parameter position: The position for which you want to get the ruby text.
	/// - returns: If the `position` is valid, then this
	/// function will return a `String` for the text. Otherwise it will return `nil`.
	func getText(for position: Position) -> String? {
		return CTRubyAnnotationGetTextForPosition(self, position) as String?
	}
}
