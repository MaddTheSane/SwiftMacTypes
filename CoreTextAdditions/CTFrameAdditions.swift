//
//  CTFrameAdditions.swift
//  CoreTextAdditions
//
//  Created by C.W. Betts on 11/3/17.
//  Copyright © 2017 C.W. Betts. All rights reserved.
//

import Foundation
import CoreText
import FoundationAdditions

public extension CTFrame {
	/// These constants specify frame progression types.
	///
	/// The lines of text within a frame may be stacked for either
	/// horizontal or vertical text. Values are enumerated for each
	/// stacking type supported by `CTFrame`. Frames created with a
	/// progression type specifying vertical text will rotate lines
	/// 90 degrees counterclockwise when drawing.
	typealias Progression = CTFrameProgression
	
	/// These constants specify fill rule used by the frame.
	///
	/// When a path intersects with itself, the client should specify which rule to use for deciding the
	/// area of the path.
	typealias PathFillRule = CTFramePathFillRule
	
	enum Attributes: RawRepresentable, @unchecked Sendable, Codable, RawLosslessStringConvertibleCFString, Equatable {
		public typealias RawValue = CFString
		
		public init?(rawValue: CFString) {
			switch rawValue {
			case kCTFrameProgressionAttributeName:
				self = .progression
				
			case kCTFramePathFillRuleAttributeName:
				self = .pathFillRule
				
			case kCTFramePathWidthAttributeName:
				self = .pathWidth

			case kCTFrameClippingPathsAttributeName:
				self = .clippingPaths
				
			case kCTFramePathClippingPathAttributeName:
				self = .pathClippingPath
				
			default:
				return nil
			}
		}
		
		public var rawValue: CFString {
			switch self {
			case .progression:
				return kCTFrameProgressionAttributeName
			case .pathFillRule:
				return kCTFramePathFillRuleAttributeName
			case .pathWidth:
				return kCTFramePathWidthAttributeName
			case .clippingPaths:
				return kCTFrameClippingPathsAttributeName
			case .pathClippingPath:
				return kCTFramePathClippingPathAttributeName
			}
		}
		
		/// Specifies progression for a frame.
		///
		/// Value must be a `CTFrame.Progression` or a `CFNumberRef` containing a `CTFrame.Progression`.
		/// Default is `.topToBottom`. This value determines
		/// the line stacking behavior for a frame and does not affect the
		/// appearance of the glyphs within that frame.
		case progression
		
		/// Specifies fill rule for a frame if this attribute is used at top level of `frameAttributes` dictionary.
		///
		/// Value must be a `CTFrame.PathFillRule` or a `CFNumber` containing `CTFrame.PathFillRule.evenOdd` or `CTFrame.PathFillRule.windingNumber`.<br/>
		/// Default is `CTFrame.PathFillRule.evenOdd`.
		case pathFillRule
		
		/// Specifies frame width if this attribute is used at top level of `frameAttributes` dictionary.
		///
		/// Value must be a `CFNumberRef` specifying frame width.<br/>
		/// Default is zero.
		case pathWidth
		
		/// Specifies array of paths to clip frame.
		///
		/// Value must be a `CFArray` containing `CFDictionary`s or `CGPath`s.  (`CGPath` is allowed on 10.8 or later.)
		/// Each dictionary should have a `kCTFramePathClippingPathAttributeName` key-value pair, and can have a `kCTFramePathFillRuleAttributeName` key-value pair
		/// and `kCTFramePathFillRuleAttributeName` key-value pair as optional parameters.  In case of CGPathRef, default fill rule (`CTFrame.PathFillRule.evenOdd`) and width (`0.0`) are used.
		case clippingPaths

		/// Specifies clipping path.  This attribute is valid in a dictionary contained in an array specified by kCTFrameClippingPathsAttributeName.
		/// On 10.8 or later, This attribute is also valid in frameAttributes dictionary passed to `CTFramesetterCreateFrame`.
		///
		/// Value must be a `CGPath` specifying a clipping path.
		case pathClippingPath
		
		public enum ClippingPathKeys: RawRepresentable, @unchecked Sendable, Codable, RawLosslessStringConvertibleCFString, Equatable {
			public typealias RawValue = CFString
			
			public init?(rawValue: CFString) {
				switch rawValue {
				case kCTFramePathFillRuleAttributeName:
					self = .fillRule
					
				case kCTFramePathWidthAttributeName:
					self = .width

				case kCTFramePathClippingPathAttributeName:
					self = .clippingPath
					
				default:
					return nil
				}
			}
			
			public var rawValue: CFString {
				switch self {
				case .fillRule:
					return kCTFramePathFillRuleAttributeName
				case .width:
					return kCTFramePathWidthAttributeName
				case .clippingPath:
					return kCTFramePathClippingPathAttributeName
				}
			}
			
			/// Specifies fill rule for a clipping path.
			///
			/// Value must be a `CTFrame.PathFillRule` or a `CFNumber` containing `CTFrame.PathFillRule.evenOdd` or `CTFrame.PathFillRule.windingNumber`.<br/>
			/// Default is `CTFrame.PathFillRule.evenOdd`.
			case fillRule
			
			/// Specifies clipping path width.
			///
			/// Value must be a `CFNumberRef` specifying frame width.<br/>
			/// Default is zero.
			case width
			
			/// Specifies clipping path.
			///
			/// Value must be a `CGPath` specifying a clipping path.
			case clippingPath
		}
	}
	
	/// Returns the range of characters that were originally requested
	/// to fill the frame.
	///
	/// This getter will return a `CFRange` containing the backing
	/// store range of characters that were originally requested
	/// to fill the frame. If the function call is not successful,
	/// then an empty range will be returned.
	@inlinable var stringRange: CFRange {
		return CTFrameGetStringRange(self)
	}
	
	/// A `CFRange` structure containing the backing store range of characters that fit into the
	/// frame, or if the function call is not successful or no characters fit in the frame, an empty range.
	///
	/// This can be used to chain frames, as it returns the range of
	/// characters that can be seen in the frame. The next frame would
	/// start where this frame ends.
	@inlinable var visibleStringRange: CFRange {
		return CTFrameGetVisibleStringRange(self)
	}
	
	/// Returns the frame attributes used to create the frame, or, if the frame was created without any frame
	/// attributes, `nil`.
	///
	/// You can create a frame with an attributes dictionary to control various aspects of the framing process.
	/// These attributes are different from the ones used to create an attributed string.
	var frameAttributes: [Attributes: Any]? {
		guard let preAttr = CTFrameGetFrameAttributes(self) as? [NSString: Any] else {
			return nil
		}
		let postAttr = preAttr.compactMap { (key: NSString, value: Any) -> (Attributes, Any)? in
			guard let key2 = Attributes(rawValue: key) else {
				return nil
			}
			switch key2 {
			case .progression:
				if let val2 = value as? NSNumber,
				   let val3 = Progression(rawValue: val2.uint32Value) {
					return (key2, val3)
				}
			case .pathFillRule:
				if let val2 = value as? NSNumber,
				   let val3 = PathFillRule(rawValue: val2.uint32Value) {
					return (key2, val3)
				}
			case .clippingPaths:
				if let val2 = value as? [NSString: Any] {
					let val3 = val2.compactMap { (key: NSString, value: Any) -> (Attributes.ClippingPathKeys, Any)? in
						guard let key4 = Attributes.ClippingPathKeys(rawValue: key) else {
							return nil
						}
						if key4 == .fillRule,
						   let val4 = value as? NSNumber,
						   let val5 = PathFillRule(rawValue: val4.uint32Value) {
							return (key4, val5)
						}
						return (key4, value)
					}
					return (key2, Dictionary(uniqueKeysWithValues: val3))
				}
			default:
				return (key2, value)
			}
			return nil
		}
		return Dictionary(uniqueKeysWithValues: postAttr)
	}
	
	/// The path used to create the frame.
	@inlinable var path: CGPath {
		return CTFrameGetPath(self)
	}
	
	/// An array of lines stored in the frame.
	var lines: [CTLine] {
		return CTFrameGetLines(self) as! [CTLine]
	}
	
	/// Copies a range of line origins for a frame.
	/// - parameter range: The range of line origins you wish to copy.
	/// If the length of the range is set to `0`, then the copy operation will continue
	/// from the range's start index to the last line origin.
	///
	/// This function will copy a range of `CGPoint` structures. Each
	/// `CGPoint` is the origin of the corresponding line in the array of
	/// lines returned by `CTFrame.lines`, relative to the origin of the
	/// frame's path. The maximum number of line origins returned by
	/// this function is the count of the array of lines.
	func lineOrigins(in range: CFRange) -> [CGPoint] {
		let actualCount: Int
		if range.length == 0 {
			actualCount = lines.count
		} else {
			actualCount = range.length
		}
		var origins = [CGPoint](repeating: CGPoint(), count: actualCount)
		CTFrameGetLineOrigins(self, range, &origins)
		return origins
	}
	
	/// Copies a range of line origins for a frame.
	/// - parameter range: The range of line origins you wish to copy.
	/// If the length of the range is set to `0`, then the copy operation will continue
	/// from the range's start index to the last line origin.
	///
	/// This function will copy a range of `CGPoint` structures. Each
	/// CGPoint is the origin of the corresponding line in the array of
	/// lines returned by `CTFrame.lines`, relative to the origin of the
	/// frame's path. The maximum number of line origins returned by
	/// this function is the count of the array of lines.
	func lineOrigins(in range: NSRange) -> [CGPoint] {
		return lineOrigins(in: range.cfRange)
	}
	
	/// Draws an entire frame to a context.
	/// - parameter context: The context to draw the frame to.
	///
	/// This function will draw an entire frame to the context. Note
	/// that this call may leave the context in any state and does not
	/// flush it after the draw operation.
	@inlinable func draw(in context: CGContext) {
		CTFrameDraw(self, context)
	}
}
