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
	
	/// Is true if `location` is equal to `NSNotFound`.
	public var notFound: Bool {
		return location == NSNotFound
	}
	
	public func locationInRange(loc: Int) -> Bool {
		return NSLocationInRange(loc, self)
	}

	/// The maximum value from the range.
	public var max: Int {
		return NSMaxRange(self)
	}

	/// Make a new `NSRange` by intersecting this range and another.
	public func intersect(otherRange: NSRange) -> NSRange {
		return NSIntersectionRange(self, otherRange)
	}

	/// Set the current `NSRange` to an intersection of this range and another.
	public mutating func intersectInPlace(otherRange: NSRange) {
		self = NSIntersectionRange(self, otherRange)
	}
	
	/// A string representation of the current range.
	public var stringValue: String {
		return NSStringFromRange(self)
	}

	/// Make a new `NSRange` from a union of this range and another.
	public func union(otherRange: NSRange) -> NSRange {
		return NSUnionRange(self, otherRange)
	}

	/// Set the current `NSRange` to a union of this range and another.
	public mutating func unionInPlace(otherRange: NSRange) {
		self = NSUnionRange(self, otherRange)
	}
	
	// MARK: - CFRange interop.
	
	/// Initializes an `NSRange` struct from a `CFRange` struct.
	public init(_ range: CFRange) {
		location = range.location
		length = range.length
	}
	
	/// Initializes an `NSRange` struct from a `CFRange` struct.
	public init(range: CFRange) {
		self.init(range)
	}
	
	/// The current range, represented as a `CFRange`.
	public var cfRange: CFRange {
		return CFRange(location: location, length: length)
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
	public mutating func integralInPlace(options options: NSAlignmentOptions) {
		self = NSIntegralRectWithOptions(self, options)
	}
	
	public func integral(options options: NSAlignmentOptions) -> NSRect {
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
	@objc(initWithCFUUID:) public convenience init(_ cfUUID: CFUUID) {
		let tmpuid = CFUUIDGetUUIDBytes(cfUUID)

		let anotherUUID: [UInt8] = try! arrayFromObject(reflecting: tmpuid)
		
		self.init(UUIDBytes: anotherUUID)
	}
	
	/// gets a CoreFoundation UUID from the current UUID.
	public var cfUUID: CFUUID {
		let tmpStr = self.UUIDString
		
		return CFUUIDCreateFromString(kCFAllocatorDefault, tmpStr)
	}
}

extension NSData {
	public convenience init(byteArray: [UInt8]) {
		self.init(bytes: byteArray, length: byteArray.count)
	}
	
	public var arrayOfBytes: [UInt8] {
		let count = length / sizeof(UInt8)
		var bytesArray = [UInt8](count: count, repeatedValue: 0)
		getBytes(&bytesArray, length:count * sizeof(UInt8))
		return bytesArray
	}
}

extension NSMutableData {
	public func appendByteArray(byteArray: [UInt8]) {
		appendBytes(byteArray, length: byteArray.count)
	}
	
	public func replaceBytesInRange(range: NSRange, withByteArray replacementBytes: [UInt8]) {
		replaceBytesInRange(range, withBytes: replacementBytes, length: replacementBytes.count)
	}
}

#if os(OSX)
@available(OSX, introduced=10.10)
extension NSEdgeInsets {
	public static var zero: NSEdgeInsets {
		return NSEdgeInsetsZero
	}
}

@available(OSX, introduced=10.10)
public func ==(rhs: NSEdgeInsets, lhs: NSEdgeInsets) -> Bool {
	return NSEdgeInsetsEqual(rhs, lhs)
}
#endif

extension NSUserDefaults {
	public subscript(key: String) -> AnyObject? {
		get {
			return objectForKey(key)
		}
		set {
			setObject(newValue, forKey: key)
		}
	}
}
