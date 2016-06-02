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
	
	public func locationInRange(_ loc: Int) -> Bool {
		return NSLocationInRange(loc, self)
	}

	/// The maximum value from the range.
	public var max: Int {
		return NSMaxRange(self)
	}

	/// Make a new `NSRange` by intersecting this range and another.
	public func intersect(_ otherRange: NSRange) -> NSRange {
		return NSIntersectionRange(self, otherRange)
	}

	/// Set the current `NSRange` to an intersection of this range and another.
	public mutating func intersectInPlace(_ otherRange: NSRange) {
		self = NSIntersectionRange(self, otherRange)
	}
	
	/// A string representation of the current range.
	public var stringValue: String {
		return NSStringFromRange(self)
	}

	/// Make a new `NSRange` from a union of this range and another.
	public func union(_ otherRange: NSRange) -> NSRange {
		return NSUnionRange(self, otherRange)
	}

	/// Set the current `NSRange` to a union of this range and another.
	public mutating func unionInPlace(_ otherRange: NSRange) {
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
	public init(string: String) {
		#if os(OSX)
			self = NSPointFromString(string)
		#else
			self = CGPointFromString(string)
		#endif
	}

	/// A string representation of the current point.
	public var stringValue: String {
		#if os(OSX)
			return NSStringFromPoint(self)
		#else
			return NSStringFromCGPoint(self)
		#endif
	}
}

extension CGSize {
	public init(string: String) {
		#if os(OSX)
			self = NSSizeFromString(string)
		#else
			self = CGSizeFromString(string)
		#endif
	}

	/// A string representation of the current size.
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
	public mutating func integralInPlace(options: NSAlignmentOptions) {
		self = NSIntegralRectWithOptions(self, options)
	}
	
	public func integral(options: NSAlignmentOptions) -> NSRect {
		return NSIntegralRectWithOptions(self, options)
	}
	#endif

	public init(string: String) {
		#if os(OSX)
			self = NSRectFromString(string)
		#else
			self = CGRectFromString(string)
		#endif
	}

	/// A string representation of the current rect.
	public var stringValue: String {
		#if os(OSX)
			return NSStringFromRect(self)
		#else
			return NSStringFromCGRect(self)
		#endif
	}

	#if os(OSX)
	public func mouseInLocation(location: NSPoint, flipped: Bool = false) -> Bool {
		return NSMouseInRect(location, self, flipped)
	}
	#endif
}

extension NSUUID {
	/// Create a new `NSUUID` from a `CFUUID`.
	@objc(initWithCFUUID:) public convenience init(`CFUUID` cfUUID: CoreFoundation.CFUUID) {
		let tempUIDStr = CFUUIDCreateString(kCFAllocatorDefault, cfUUID) as NSString as String
		
		self.init(uuidString: tempUIDStr)!
	}
	
	/// gets a CoreFoundation UUID from the current UUID.
	public var `CFUUID`: CoreFoundation.CFUUID {
		let tmpStr = self.uuidString
		
		return CFUUIDCreateFromString(kCFAllocatorDefault, tmpStr)
	}
}

extension NSData {
	public convenience init(byteArray: [UInt8]) {
		self.init(bytes: byteArray, length: byteArray.count)
	}
	
	public var arrayOfBytes: [UInt8] {
		let count = length / sizeof(UInt8)
		var bytesArray = [UInt8](repeating: 0, count: count)
		getBytes(&bytesArray, length:count * sizeof(UInt8))
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
extension NSEdgeInsets {
	public static var zero: NSEdgeInsets {
		return NSEdgeInsetsZero
	}
}

	@available(OSX, introduced:10.10)
public func ==(rhs: NSEdgeInsets, lhs: NSEdgeInsets) -> Bool {
	return NSEdgeInsetsEqual(rhs, lhs)
}
#endif

extension NSIndexSet {
	public convenience init<B: Sequence where B.Iterator.Element == Int>(indexes: B) {
		let tmpIdxSet = NSMutableIndexSet()
		for idx in indexes {
			tmpIdxSet.add(idx)
		}
		self.init(indexSet: tmpIdxSet)
	}
}

extension NSUserDefaults {
	@nonobjc public subscript(key: String) -> AnyObject? {
		get {
			return object(forKey: key)
		}
		set {
			set(newValue, forKey: key)
		}
	}
}
