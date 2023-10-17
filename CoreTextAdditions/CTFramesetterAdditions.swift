//
//  CTFramesetterAdditions.swift
//  CoreTextAdditions
//
//  Created by C.W. Betts on 5/29/21.
//  Copyright © 2021 C.W. Betts. All rights reserved.
//

import Foundation
import CoreText

public extension CTFramesetter {
	/// Creates a framesetter directly from a typesetter.
	///
	/// Each framesetter uses a typesetter internally to perform
	/// line breaking and other contextual analysis based on the
	/// characters in a string. This function allows use of a
	/// typesetter that was constructed using specific options.
	/// - parameter typesetter: The typesetter to be used by the newly-created framesetter.
	/// - returns: This function will return a reference to a `CTFramesetter` object.
	/// - seealso: CTTypesetterCreateWithAttributedStringAndOptions
	@available(macOS 10.14, iOS 12.0, watchOS 5.0 , tvOS 12.0, *)
	@inlinable static func create(with typesetter: CTTypesetter) -> CTFramesetter {
		return CTFramesetterCreateWithTypesetter(typesetter)
	}
	
	/// Creates an immutable framesetter object from an attributed string.
	///
	/// The resultant framesetter object can be used to create and
	/// fill text frames with the `CTFramesetterCreateFrame` call.
	/// - parameter attrString: The attributed string to construct the framesetter with.
	/// - returns: This function will return a reference to a CTFramesetter object.
	@inlinable static func create(with attrString: CFAttributedString) -> CTFramesetter {
		return CTFramesetterCreateWithAttributedString(attrString)
	}
	
	// MARK: - Frame Creation
	
	/// Creates an immutable frame from a framesetter.
	///
	/// This call will create a frame full of glyphs in the shape of
	/// the path provided by the "path" parameter. The framesetter
	/// will continue to fill the frame until it either runs out of
	/// text or it finds that text no longer fits.
	/// - parameter stringRange: The string range which the new frame will be based on. The
	/// string range is a range over the string that was used to
	/// create the framesetter. If the length portion of the range
	/// is set to *0*, then the framesetter will continue to add lines
	/// until it runs out of text or space.
	/// - parameter path: A CGPath object that specifies the shape which the frame will
	/// take on.
	/// - parameter frameAttributes: Additional attributes that control the frame filling process
	/// can be specified here, or `nil` if there are no such attributes.
	/// See *CTFrame.h* for available attributes.
	/// - returns: This function will return a reference to a new `CTFrame` object.
	@inlinable func frame(withStringRange stringRange: CFRange, path: CGPath, frameAttributes: CFDictionary? = nil) -> CTFrame {
		return CTFramesetterCreateFrame(self, stringRange, path, frameAttributes)
	}
	
	/// Creates an immutable frame from a framesetter.
	///
	/// This call will create a frame full of glyphs in the shape of
	/// the path provided by the "path" parameter. The framesetter
	/// will continue to fill the frame until it either runs out of
	/// text or it finds that text no longer fits.
	/// - parameter stringRange: The string range which the new frame will be based on. The
	/// string range is a range over the string that was used to
	/// create the framesetter. If the length portion of the range
	/// is set to *0*, then the framesetter will continue to add lines
	/// until it runs out of text or space.
	/// - parameter path: A CGPath object that specifies the shape which the frame will
	/// take on.
	/// - parameter attributes: Additional attributes that control the frame filling process
	/// can be specified here.
	/// - returns: This function will return a reference to a new `CTFrame` object.
	func frame(withStringRange stringRange: CFRange, path: CGPath, attributes: [CTFrame.Attributes: Any]) -> CTFrame {
		//sanitize input
		let preAttr = attributes.map { (key: CTFrame.Attributes, value: Any) -> (CFString, Any) in
			switch key {
			case .progression:
				if let value = value as? CTFrameProgression {
					return (key.rawValue, value.rawValue)
				}
			case .pathFillRule:
				if let value = value as? CTFramePathFillRule {
					return (key.rawValue, value.rawValue)
				}
			case .pathWidth:
				break
			case .clippingPaths:
				if let value = value as? [[CTFrame.Attributes.ClippingPathKeys: Any]] {
					let mapped1 = value.map { val2 -> [CFString: Any] in
						let mapped2 = val2.map { (key: CTFrame.Attributes.ClippingPathKeys, value: Any) -> (CFString, Any) in
							switch key {
							case .fillRule:
								if let value = value as? CTFramePathFillRule {
									return (key.rawValue, value.rawValue)
								}
							case .width:
								break
							case .clippingPath:
								break
							}
							return (key.rawValue, value)
						}
						return Dictionary(uniqueKeysWithValues: mapped2)
					}
					return (key.rawValue, mapped1)
				}
			case .pathClippingPath:
				break
			}
			return (key.rawValue, value)
		}
		
		let frameAttributes = Dictionary(uniqueKeysWithValues: preAttr)
		return CTFramesetterCreateFrame(self, stringRange, path, frameAttributes as CFDictionary)
	}
	
	/// Returns the typesetter object being used by the framesetter.
	///
	/// Each framesetter uses a typesetter internally to perform
	/// line breaking and other contextual analysis based on the
	/// characters in a string; this function returns the typesetter
	/// being used by a particular framesetter if the caller would
	/// like to perform other operations on that typesetter.
	@inlinable var typesetter: CTTypesetter {
		return CTFramesetterGetTypesetter(self)
	}
	
	// MARK: - Frame Sizing
	
	/// Determines the frame size needed for a string range.
	///
	/// This function may be used to determine how much space is needed
	/// to display a string, optionally by constraining the space along
	/// either dimension.
	///
	/// - parameter stringRange: The string range to which the frame size will apply. The
	/// string range is a range over the string that was used to
	/// create the framesetter. If the length portion of the range
	/// is set to *0*, then the framesetter will continue to add lines
	/// until it runs out of text or space.
	/// - parameter frameAttributes: Additional attributes that control the frame filling process
	/// can be specified here, or `nil` if there are no such attributes.
	/// - parameter constraints: The width and height to which the frame size will be constrained,
	/// A value of `CGFLOAT_MAX` for either dimension indicates that it
	/// should be treated as unconstrained.
	/// - parameter fitRange: The range of the string that actually fit in the constrained size.
	/// - returns: The actual dimensions for the given string range and constraints.
	@inlinable func suggestFrameSize(_ stringRange: CFRange, frameAttributes: CFDictionary? = nil, constraints: CGSize, fitRange: UnsafeMutablePointer<CFRange>? = nil) -> CGSize {
		return CTFramesetterSuggestFrameSizeWithConstraints(self, stringRange, frameAttributes, constraints, fitRange)
	}
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 9.0, *)
public extension CTFramesetter {
	/// Creates an immutable framesetter object from an attributed string.
	///
	/// The resultant framesetter object can be used to create and
	/// fill text frames with the `CTFramesetterCreateFrame` call.
	/// - parameter attrString: The attributed string to construct the framesetter with. Only use with `CoreTextAttributes`.
	/// - returns: This function will return a reference to a CTFramesetter object.
	static func create(with attrString: AttributedString) throws -> CTFramesetter {
		let nsAttrStr = try NSAttributedString(attrString, including: AttributeScopes.CoreTextAttributes.self)
		return CTFramesetterCreateWithAttributedString(nsAttrStr)
	}
}
