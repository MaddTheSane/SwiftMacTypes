//
//  NSRangeAdditions.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 8/22/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Foundation
#if !os(OSX)
	import UIKit
#endif

public func ==(rhs: NSRange, lhs: NSRange) -> Bool {
	return NSEqualRanges(rhs, lhs)
}

extension NSRange: Equatable {
	/// An `NSRange` with a location of `NSNotFound` and a length of `0`.
	public static let notFound = NSRange(location: NSNotFound, length: 0)
	
	public init(string: String) {
		self = NSRangeFromString(string)
	}
	
	/// Is `true` if `location` is equal to `NSNotFound`.
	public var notFound: Bool {
		return location == NSNotFound
	}
	
	@available(*, unavailable, message:"Use \"contains(_:)\" instead", renamed:"NSRange.contains(_:)")
	public func locationInRange(_ loc: Int) -> Bool {
		return NSLocationInRange(loc, self)
	}
	
	public func contains(_ location: Int) -> Bool {
		return NSLocationInRange(location, self)
	}

	/// The maximum value from the range.
	public var max: Int {
		return NSMaxRange(self)
	}

	/// Make a new `NSRange` by intersecting this range and another.
	public func intersection(_ otherRange: NSRange) -> NSRange {
		return NSIntersectionRange(self, otherRange)
	}

	/// Set the current `NSRange` to an intersection of this range and another.
	public mutating func intersect(_ otherRange: NSRange) {
		self = NSIntersectionRange(self, otherRange)
	}
	
	/// A string representation of the current range.
	/// - returns: A string of the form *“{a, b}”*, where *a* and *b* are
	/// non-negative integers representing `self`.
	public var stringValue: String {
		return NSStringFromRange(self)
	}

	/// Make a new `NSRange` from a union of this range and another.
	public func union(_ otherRange: NSRange) -> NSRange {
		return NSUnionRange(self, otherRange)
	}

	/// Set the current `NSRange` to a union of this range and another.
	public mutating func formUnion(_ otherRange: NSRange) {
		self = NSUnionRange(self, otherRange)
	}
	
	// MARK: - CFRange interop.
	
	/// Initializes an `NSRange` struct from a `CFRange` struct.
	public init(_ range: CoreFoundation.CFRange) {
		location = range.location
		length = range.length
	}
	
	/// Initializes an `NSRange` struct from a `CFRange` struct.
	public init(range: CoreFoundation.CFRange) {
		self.init(range)
	}
	
	/// The current range, represented as a `CFRange`.
	public var `CFRange`: CoreFoundation.CFRange {
		return CoreFoundation.CFRange(location: location, length: length)
	}
}

extension CGPoint {
	/// Creates a point from a text-based representation.
	/// - parameter string: A string of the form *"{x, y}"*.
	///
	/// If `string` is of the form *"{x, y}"*, the `CGPoint` structure
	/// uses *x* and *y* as the `x` and `y` coordinates, in that order.<br>
	/// If `string` only contains a single number, it is used as the `x` coordinate.
	/// If `string` does not contain any numbers, creates an `CGPoint` object whose
	/// `x` and `y` coordinates are both `0`.
	public init(string: String) {
		#if os(OSX)
			self = NSPointFromString(string)
		#else
			self = CGPointFromString(string)
		#endif
	}

	/// A string representation of the current point.
	/// - returns: A string of the form *"{a, b}"*, where *a* and *b* are the `x`
	/// and `y` coordinates of `self`.
	public var stringValue: String {
		#if os(OSX)
			return NSStringFromPoint(self)
		#else
			return NSStringFromCGPoint(self)
		#endif
	}
}

extension CGSize {
	/// Creates a `CGSize` from a text-based representation.
	///
	/// Scans aString for two numbers which are used as the width and height,
	/// in that order, to create a `CGSize` struct. If `string` only contains a
	/// single number, it is used as the width. The `string` argument should be
	/// formatted like the output of `NSStringFromSize(_:)`, `NSStringFromCGSize(_:)`,
	/// or `CGSize.stringValue`, for example, `"{10,20}"`.
	/// If `string` does not contain any numbers, this function returns a `CGSize`
	/// struct whose width and height are both `0`.
	public init(string: String) {
		#if os(OSX)
			self = NSSizeFromString(string)
		#else
			self = CGSizeFromString(string)
		#endif
	}

	/// A string representation of the current size.
	///
	/// - returns: A string of the form *"{a, b}"*, where *a* and *b* are the `width`
	/// and `height`, respectively, of `self`.
	public var stringValue: String {
		#if os(OSX)
			return NSStringFromSize(self)
		#else
			return NSStringFromCGSize(self)
		#endif
	}
}

extension CGRect {
	#if os(OSX)
	/// Adjusts the sides of a rectangle to integral values using the specified options.
	public mutating func integralInPlace(options: AlignmentOptions) {
		self = NSIntegralRectWithOptions(self, options)
	}
	
	/// Adjusts the sides of a rectangle to integral values using the specified options.
	/// - returns: A copy of `self`, modified based on the options. The options are
	/// defined in `NSAlignmentOptions`.
	public func integral(options: AlignmentOptions) -> NSRect {
		return NSIntegralRectWithOptions(self, options)
	}
	#endif

	/// Creates a rectangle from a text-based representation.
	///
	/// Scans `string` for four numbers which are used as the x and y coordinates
	/// and the width and height, in that order, to create a `CGRect` object. If
	/// `string` does not contain four numbers, those numbers that were scanned are used,
	/// and `0` is used for the remaining values. If `string` does not contain any
	/// numbers, this function returns a `CGRect` object with a rectangle whose origin
	/// is `(0, 0)` and width and height are both `0`.
	public init(string: String) {
		#if os(OSX)
			self = NSRectFromString(string)
		#else
			self = CGRectFromString(string)
		#endif
	}

	/// A string representation of the current rect.
	///
	/// - returns: a string of the form *"{{a, b}, {c, d}}"*, where *a*, *b*, *c*, and *d*
	/// are the `x` and `y` coordinates and the `width` and `height`, respectively, of `self`.
	public var stringValue: String {
		#if os(OSX)
			return NSStringFromRect(self)
		#else
			return NSStringFromCGRect(self)
		#endif
	}

	#if os(OSX)
	/// Returns a `Bool` value that indicates whether the point is in the specified rectangle.
	/// - parameter flipped: Specify `true` for flipped if the underlying view uses a
	/// flipped coordinate system. Default is `false`.
	/// - returns: `true` if the hot spot of the cursor lies inside the rectangle, otherwise `false`.
	public func mouseInLocation(location: NSPoint, flipped: Bool = false) -> Bool {
		return NSMouseInRect(location, self, flipped)
	}
	#endif
}

extension NSUUID {
	/// Create a new `NSUUID` from a `CFUUID`.
	@objc(initWithCFUUID:) public convenience init(`CFUUID` cfUUID: CoreFoundation.CFUUID) {
		let tempUIDStr = CFUUIDCreateString(kCFAllocatorDefault, cfUUID)! as String
		
		self.init(uuidString: tempUIDStr)!
	}
	
	/// gets a CoreFoundation UUID from the current UUID.
	public var `CFUUID`: CoreFoundation.CFUUID {
		let tmpStr = self.uuidString
		
		return CFUUIDCreateFromString(kCFAllocatorDefault, tmpStr as NSString)
	}
}

extension UUID {
	/// Create a new `Foundation.UUID` from a `CFUUID`.
	public init(`CFUUID` cfUUID: CoreFoundation.CFUUID) {
		let tempUIDStr = CFUUIDCreateString(kCFAllocatorDefault, cfUUID)! as String
		
		self.init(uuidString: tempUIDStr)!
	}
	
	/// gets a CoreFoundation UUID from the current UUID.
	public var `CFUUID`: CoreFoundation.CFUUID {
		let tmpStr = self.uuidString
		
		return CFUUIDCreateFromString(kCFAllocatorDefault, tmpStr as NSString)
	}
}


extension NSData {
	public convenience init(byteArray: [UInt8]) {
		self.init(bytes: byteArray, length: byteArray.count)
	}
	
	public var arrayOfBytes: [UInt8] {
		let count = length / MemoryLayout<UInt8>.size
		var bytesArray = [UInt8](repeating: 0, count: count)
		getBytes(&bytesArray, length:count * MemoryLayout<UInt8>.size)
		return bytesArray
	}
}

extension NSMutableData {
	public func appendByteArray(byteArray: [UInt8]) {
		append(byteArray, length: byteArray.count)
	}
	
	public func replaceBytesInRange(range: NSRange, withByteArray replacementBytes: [UInt8]) {
		replaceBytes(in: range, withBytes: replacementBytes, length: replacementBytes.count)
	}
}

#if os(OSX)
@available(OSX, introduced:10.10)
extension EdgeInsets {
	public static var zero: EdgeInsets {
		return NSEdgeInsetsZero
	}
}

@available(OSX, introduced:10.10)
public func ==(rhs: EdgeInsets, lhs: EdgeInsets) -> Bool {
	return NSEdgeInsetsEqual(rhs, lhs)
}
#endif

extension NSIndexSet {
	public convenience init<B: Sequence>(indexes: B) where B.Iterator.Element == Int {
		self.init(indexSet: IndexSet(indexes: indexes))
	}
}

extension IndexSet {
	public init<B: Sequence>(indexes: B) where B.Iterator.Element == Int {
		self.init()
		for idx in indexes {
			insert(idx)
		}
	}
}


extension UserDefaults {
	@nonobjc public subscript(key: String) -> Any? {
		get {
			return object(forKey: key)
		}
		set {
			set(newValue, forKey: key)
		}
	}
}

// Code taken from http://stackoverflow.com/a/30404532/1975001
extension String {
	/// Creates a `String` range from the passed in `NSRange`.
	/// - parameter nsRange: An `NSRange` to convert to a `String` range.
	/// - returns: a `String` range, or `nil` if `nsRange` could not be converted.
	///
	/// Make sure you have called `-[NSString rangeOfComposedCharacterSequencesForRange:]`
	/// *before* calling this method, otherwise if the beginning or end of
	/// `nsRange` is in between Unicode code points, this method will return `nil`.
	public func nsRange(from range: Range<String.Index>) -> NSRange {
		let utf16view = self.utf16
		let from = range.lowerBound.samePosition(in: utf16view)
		let to = range.upperBound.samePosition(in: utf16view)
		return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from),
		                   utf16view.distance(from: from, to: to))
	}
	
	public func range(from nsRange: NSRange) -> Range<String.Index>? {
		guard
			let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
			let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
			let from = String.Index(from16, within: self),
			let to = String.Index(to16, within: self)
			else { return nil }
		return from ..< to
	}
}
