//
//  CTTypesetterAdditions.swift
//  CoreTextAdditions
//
//  Created by C.W. Betts on 9/13/22.
//  Copyright © 2022 C.W. Betts. All rights reserved.
//

import Foundation
import CoreText
import FoundationAdditions

public extension CTTypesetter {
	
	// MARK: Typesetter Creation
	
	/// Creates an immutable typesetter object using an attributed
	/// string and a dictionary of options.
	///
	/// The resultant typesetter can be used to create lines, perform
	/// line breaking, and do other contextual analysis based on the
	/// characters in the string.
	/// - parameter string: The `CFAttributedStringRef` that you want to typeset.
	/// This parameter must be filled in with a valid `CFAttributedString`.
	/// - parameter options: A `CFDictionary` of typesetter options, or `nil` if there are none.
	/// - returns: This class method will return either a reference to a `CTTypesetter`
	/// or `nil` if layout cannot be performed due to an attributed
	/// string that would require unreasonable effort.
	///
	/// - seeAlso: kCTTypesetterOptionAllowUnboundedLayout
	@inlinable static func create(with string: CFAttributedString, options: NSDictionary? = nil) -> CTTypesetter? {
		return CTTypesetterCreateWithAttributedStringAndOptions(string, options)
	}
	
	// MARK: - Typeset Line Breaking
	
	/// Suggests a contextual line break point based on the width
	/// provided.
	///
	/// The line break can be triggered either by a hard break character
	/// in the stream or by filling the specified width with characters.
	///
	/// - parameter startIndex: The starting point for the line break calculations. The break
	/// calculations will include the character starting at `startIndex`.
	/// - parameter width: The requested line break width.
	/// - parameter offset: The line position offset.<br/>
	/// Default is `0.0`
	/// - returns: The value returned is a count of the characters from `startIndex`
	/// that would cause the line break. This value returned can be used
	/// to construct a character range for `CTTypesetterCreateLine`.
	@inlinable func suggestLineBreak(startIndex: CFIndex, width: Double, offset: Double = 0.0) -> CFIndex {
		return CTTypesetterSuggestLineBreakWithOffset(self, startIndex, width, offset)
	}
	
	/// Suggests a cluster line break point based on the width provided.
	///
	/// Suggests a typographic cluster line break point based on the width
	/// provided. This cluster break is similar to a character break,
	/// except that it will not break apart linguistic clusters. No other
	/// contextual analysis will be done. This can be used by the caller
	/// to implement a different line breaking scheme, such as
	/// hyphenation. Note that a typographic cluster break can also be
	/// triggered by a hard break character in the stream.
	///
	/// - parameter startIndex: The starting point for the typographic cluster break
	/// calculations. The break calculations will include the character
	/// starting at `startIndex`.
	/// - parameter width: The requested typographic cluster break width.
	/// - parameter offset: The line position offset.
	/// - returns: The value returned is a count of the characters from `startIndex`
	/// that would cause the cluster break. This value returned can be
	/// used to construct a character range for `CTTypesetterCreateLine`.
	func suggestClusterBreak(startIndex: CFIndex, width: Double, offset: Double = 0.0) -> CFIndex {
		return CTTypesetterSuggestClusterBreakWithOffset(self, startIndex, width, offset)
	}
	
	// MARK: - Typeset Line Creation
	
	/// Creates an immutable line from the typesetter.
	///
	/// The resultant line will consist of glyphs in the correct visual
	/// order, ready to draw.
	/// - parameter range: The string range which the line will be based on. If the `length` portion of
	/// `range` is set to *0*, then the typesetter will continue to add glyphs to the line until it runs out of characters in
	/// the string. The `location` and `length` of the range must be within the bounds of the string, otherwise the call will fail.
	/// - parameter offset: The line position offset.<br/>
	/// Default is `0.0`
	/// - returns: This method will return a reference to a `CTLine`.
	func line(with range: CFRange, offset: Double = 0) -> CTLine {
		return CTTypesetterCreateLineWithOffset(self, range, offset)
	}
	
	// MARK: -
	
	enum Options: RawLosslessStringConvertibleCFString, Hashable, @unchecked Sendable {
		public typealias RawValue = CFString
	 
		/// Allows layout requiring a potentially unbounded amount of work.
		///
		/// Value must be a `CFBooleanRef`. Default is `false` for clients linked on or after macOS 10.14 or iOS 12.
		/// Proper Unicode layout of some text requires unreasonable effort;
		/// unless this option is set to `kCFBooleanTrue` such inputs will
		/// result in `CTTypesetterCreateWithAttributedStringAndOptions`
		/// returning `nil`.
		@available(macOS 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
		case allowUnboundedLayout
		
		/// Specifies the embedding level.
		///
		/// Value must be a CFNumberRef. Default is unset. Normally,
		/// typesetting applies the Unicode Bidirectional Algorithm as
		/// described in UAX #9. If present, this specifies the embedding
		/// level and any directional control characters are ignored.
		case forcedEmbeddingLevel
		
		public init?(rawValue: CFString) {
			if #available(macOS 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *) {
				if rawValue == kCTTypesetterOptionAllowUnboundedLayout {
					self = .allowUnboundedLayout
					return
				}
			}
			switch rawValue {
			case kCTTypesetterOptionForcedEmbeddingLevel:
				self = .forcedEmbeddingLevel
				
			default:
				return nil
			}
		}
		
		public var rawValue: CFString {
			if #available(macOS 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *) {
				if self == .allowUnboundedLayout {
					return kCTTypesetterOptionAllowUnboundedLayout
				}
			}
			switch self {
			case .allowUnboundedLayout:
				fatalError("We shouldn't be getting here!")
				
			case .forcedEmbeddingLevel:
				return kCTTypesetterOptionForcedEmbeddingLevel
			}
		}
	}
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 9.0, *)
public extension CTTypesetter {
	/// Creates an immutable typesetter object using an attributed
	/// string and a dictionary of options.
	///
	/// The resultant typesetter can be used to create lines, perform
	/// line breaking, and do other contextual analysis based on the
	/// characters in the string.
	/// - parameter string: The `AttributedString` that you want to typeset.
	/// This parameter must be scoped  with `CoreTextAttributes`.
	/// - parameter options: A `Dictionary` of typesetter options, or `nil` if there are none.
	/// - returns: This class method will return either a reference to a `CTTypesetter`
	/// or `nil` if layout cannot be performed due to an attributed
	/// string that would require unreasonable effort.
	///
	/// - seeAlso: kCTTypesetterOptionAllowUnboundedLayout
	static func create(with string: AttributedString, options: [Options: Any]? = nil) throws -> CTTypesetter? {
		let preOpt = options?.map({ (key: Options, value: Any) -> (NSString, Any) in
			return (key.rawValue, value)
		})
		var dict: NSDictionary?
		if let preOpt {
			let dict2 = Dictionary(uniqueKeysWithValues: preOpt)
			dict = dict2 as NSDictionary
		} else {
			dict = nil
		}
		let nsAttrStr = try NSAttributedString(string, including: AttributeScopes.CoreTextAttributes.self)
		return self.create(with: nsAttrStr, options:dict)
	}
}
