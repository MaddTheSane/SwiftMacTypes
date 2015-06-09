//
//  NSRangeAdditions.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 8/22/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Foundation
#if os(iOS)
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
	public func rangeByIntersecting(otherRange: NSRange) -> NSRange {
		return NSIntersectionRange(self, otherRange)
	}

	/// Set the current `NSRange` to an intersection of this range and another.
	public mutating func intersect(otherRange: NSRange) {
		self = NSIntersectionRange(self, otherRange)
	}
	
	/// A string representation of the current range.
	public var stringValue: String {
		return NSStringFromRange(self)
	}

	/// Make a new `NSRange` from a union of this range and another.
	public func rangeByUnion(otherRange: NSRange) -> NSRange {
		return NSUnionRange(self, otherRange)
	}

	/// Set the current `NSRange` to a union of this range and another.
	public mutating func union(otherRange: NSRange) {
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
		#elseif os(iOS)
			self = CGPointFromString(string)
		#endif
	}

	/// A string representation of the current point.
	public var stringValue: String {
		#if os(OSX)
			return NSStringFromPoint(self)
		#elseif os(iOS)
			return NSStringFromCGPoint(self)
		#endif
	}
}

extension CGSize {
	public init(string: String) {
		#if os(OSX)
			self = NSSizeFromString(string)
		#elseif os(iOS)
			self = CGSizeFromString(string)
		#endif
	}

	/// A string representation of the current size.
	public var stringValue: String {
		#if os(OSX)
			return NSStringFromSize(self)
		#elseif os(iOS)
			return NSStringFromCGSize(self)
		#endif
	}
}

extension CGRect {
	/// Set the current rect to an integral of the current rect.
	public mutating func integral() {
		self = CGRectIntegral(self)
	}

	/// An integral rect of the current rect.
	public var rectFromIntegral: CGRect {
		return CGRectIntegral(self)
	}
	
	#if os(OSX)
	public mutating func integral(options options: NSAlignmentOptions) {
		self = NSIntegralRectWithOptions(self, options)
	}
	
	public func rectFromIntegral(options options: NSAlignmentOptions) -> NSRect {
		return NSIntegralRectWithOptions(self, options)
	}
	#endif

	public init(string: String) {
		#if os(OSX)
			self = NSRectFromString(string)
		#elseif os(iOS)
			self = CGRectFromString(string)
		#endif
	}

	/// A string representation of the current rect.
	public var stringValue: String {
		#if os(OSX)
			return NSStringFromRect(self)
		#elseif os(iOS)
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

		let anotherUUID: [UInt8] = getArrayFromMirror(reflect(tmpuid))
		
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

#if false
extension NSEdgeInsets: Equatable {
	#if false
	@available(OSX, introduced=10.10)
	public static var zero: NSEdgeInsets {
		return NSEdgeInsetsZero
	}
	#endif
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

extension NSAffineTransformStruct {
	private init(_ cgAff: CGAffineTransform) {
		m11 = cgAff.a
		m12 = cgAff.b
		m21 = cgAff.c
		m22 = cgAff.d
		tX = cgAff.tx
		tY = cgAff.ty
	}
}

extension NSAffineTransform {
	convenience init(cgTransform: CGAffineTransform) {
		let preStruct = NSAffineTransformStruct(cgTransform)
		self.init()
		transformStruct = preStruct
	}
}

