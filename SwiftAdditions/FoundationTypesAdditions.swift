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
	public init(string: String) {
		self = NSRangeFromString(string)
	}
	
	/// is true if the location is equal to NSNotFound
	public var notFound: Bool {
		return location == NSNotFound
	}
	
	public func locationIsInRange(loc: Int) -> Bool {
		return NSLocationInRange(loc, self)
	}

	/// The maximum range of an NSRange
	public var max: Int {
		return NSMaxRange(self)
	}

	public func rangeByIntersecting(otherRange: NSRange) -> NSRange {
		return NSIntersectionRange(self, otherRange)
	}

	public mutating func intersect(otherRange: NSRange) {
		self = NSIntersectionRange(self, otherRange)
	}

	public var stringValue: String {
		return NSStringFromRange(self)
	}

	public func rangeByUnion(otherRange: NSRange) -> NSRange {
		return NSUnionRange(self, otherRange)
	}

	public mutating func union(otherRange: NSRange) {
		self = NSUnionRange(self, otherRange)
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

	public var stringValue: String {
		#if os(OSX)
			return NSStringFromSize(self)
		#elseif os(iOS)
			return NSStringFromCGSize(self)
		#endif
	}
}

extension CGRect {
	public mutating func integral() {
		self = CGRectIntegral(self)
	}

	public var rectFromIntegral: CGRect {
		return CGRectIntegral(self)
	}
	
	#if os(OSX)
	public mutating func integral(#options: NSAlignmentOptions) {
		self = NSIntegralRectWithOptions(self, options)
	}
	
	public func rectFromIntegral(#options: NSAlignmentOptions) -> NSRect {
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
	public convenience init(_ cfUUID: CFUUID) {
		let tmpuid = CFUUIDGetUUIDBytes(cfUUID)
		var aUUID: uuid_t = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)

		//TODO: make this look better
		aUUID.0 = tmpuid.byte0
		aUUID.1 = tmpuid.byte1
		aUUID.2 = tmpuid.byte2
		aUUID.3 = tmpuid.byte3
		aUUID.4 = tmpuid.byte4
		aUUID.5 = tmpuid.byte5
		aUUID.6 = tmpuid.byte6
		aUUID.7 = tmpuid.byte7
		aUUID.8 = tmpuid.byte8
		aUUID.9 = tmpuid.byte9
		aUUID.10 = tmpuid.byte10
		aUUID.11 = tmpuid.byte11
		aUUID.12 = tmpuid.byte12
		aUUID.13 = tmpuid.byte13
		aUUID.14 = tmpuid.byte14
		aUUID.15 = tmpuid.byte15

		let anotherUUID: [UInt8] = GetArrayFromMirror(reflect(aUUID))!
		
		self.init(UUIDBytes: anotherUUID)
	}
	
	/// gets a CoreFoundation UUID from the current UUID
	public var cfUUID: CFUUID {
		let tmpStr = self.UUIDString
		
		return CFUUIDCreateFromString(kCFAllocatorDefault, tmpStr)
	}
}

#if os(OSX)
extension NSEdgeInsets: Equatable {
	#if false
	@availability(OSX, introduced=10.10)
	public static var zero: NSEdgeInsets {
		return NSEdgeInsetsZero
	}
	#endif
}

@availability(OSX, introduced=10.10)
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
