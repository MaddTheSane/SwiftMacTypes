//
//  NSRangeAdditions.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 8/22/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Foundation

internal func CFStringToString(cfStr: CFString) -> String {
	return cfStr as NSString as String
}

internal func StringToCFString(string: String) -> CFString {
	return string as NSString as CFString
}

public func ==(rhs: NSRange, lhs: NSRange) -> Bool {
	return (rhs.location == lhs.location && rhs.length == lhs.length)
}

extension NSRange: Equatable, StringLiteralConvertible {
	public init(string: String) {
		self = NSRangeFromString(string)
	}
	
	public var notFound: Bool {
		get {
			return location == NSNotFound
		}
	}
	
	public func locationIsInRange(loc: Int) -> Bool {
		return (!(loc < location) && (loc - location) < length) ? true : false
	}

	public var max: Int {
		get {
			return location + length
		}
	}

	public func rangeByIntersecting(otherRange: NSRange) -> NSRange {
		return NSIntersectionRange(self, otherRange)
	}

	public mutating func intersect(otherRange: NSRange) {
		self = NSIntersectionRange(self, otherRange)
	}

	public var stringValue: String {
		get {
			return NSStringFromRange(self)
		}
	}

	public func rangeByUnion(otherRange: NSRange) -> NSRange {
		return NSUnionRange(self, otherRange)
	}

	public mutating func union(otherRange: NSRange) {
		self = NSUnionRange(self, otherRange)
	}

	public init(stringLiteral value: String) {
		self.init(string: value)
	}

	public init(extendedGraphemeClusterLiteral value: String) {
		let tmpStr = String(extendedGraphemeClusterLiteral: value)
		self.init(string: tmpStr)
	}
	
	public init(unicodeScalarLiteral value: String) {
		let tmpStr = String(unicodeScalarLiteral: value)
		self.init(string: tmpStr)
	}
}

#if os(OSX)
extension NSPoint: StringLiteralConvertible {
	public init(string: String) {
		self = NSPointFromString(string)
	}

	public var stringValue: String {
		get {
			return NSStringFromPoint(self)
		}
	}

	public init(stringLiteral value: String) {
		self.init(string: value)
	}
	
	public init(extendedGraphemeClusterLiteral value: String) {
		let tmpStr = String(extendedGraphemeClusterLiteral: value)
		self.init(string: tmpStr)
	}
	
	public init(unicodeScalarLiteral value: String) {
		let tmpStr = String(unicodeScalarLiteral: value)
		self.init(string: tmpStr)
	}
}

extension NSSize: StringLiteralConvertible {
	public init(string: String) {
		self = NSSizeFromString(string)
	}

	public var stringValue: String {
		get {
			return NSStringFromSize(self)
		}
	}

	public init(stringLiteral value: String) {
		self.init(string: value)
	}
	
	public init(extendedGraphemeClusterLiteral value: String) {
		let tmpStr = String(extendedGraphemeClusterLiteral: value)
		self.init(string: tmpStr)
	}
	
	public init(unicodeScalarLiteral value: String) {
		let tmpStr = String(unicodeScalarLiteral: value)
		self.init(string: tmpStr)
	}
}

extension NSRect: StringLiteralConvertible {
	public func integralRect() -> NSRect {
		return NSIntegralRect(self)
	}

	public func integralRect(#options: NSAlignmentOptions) -> NSRect {
		return NSIntegralRectWithOptions(self, options)
	}

	public init(string: String) {
		self = NSRectFromString(string)
	}

	public var stringValue: String {
		get {
			return NSStringFromRect(self)
		}
	}

	public func mouseIn(location: NSPoint, flipped: Bool = false) -> Bool {
		return NSMouseInRect(location, self, flipped)
	}

	public init(stringLiteral value: String) {
		self.init(string: value)
	}
	
	public init(extendedGraphemeClusterLiteral value: String) {
		let tmpStr = String(extendedGraphemeClusterLiteral: value)
		self.init(string: tmpStr)
	}
	
	public init(unicodeScalarLiteral value: String) {
		let tmpStr = String(unicodeScalarLiteral: value)
		self.init(string: tmpStr)
	}
}
#endif
