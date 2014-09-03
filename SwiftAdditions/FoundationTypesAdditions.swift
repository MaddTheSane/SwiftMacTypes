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
	return NSEqualRanges(rhs, lhs)
}

extension NSRange: Equatable, StringLiteralConvertible {
	public init(string: String) {
		self = NSRangeFromString(string)
	}
	
	public var notFound: Bool { get {
		return location == NSNotFound
	}}
	
	public func locationIsInRange(loc: Int) -> Bool {
		return NSLocationInRange(loc, self)
	}

	public var max: Int { get {
		return NSMaxRange(self)
	}}

	public func rangeByIntersecting(otherRange: NSRange) -> NSRange {
		return NSIntersectionRange(self, otherRange)
	}

	public mutating func intersect(otherRange: NSRange) {
		self = NSIntersectionRange(self, otherRange)
	}

	public var stringValue: String? { get {
		return NSStringFromRange(self)
	}}

	public func rangeByUnion(otherRange: NSRange) -> NSRange {
		return NSUnionRange(self, otherRange)
	}

	public mutating func union(otherRange: NSRange) {
		self = NSUnionRange(self, otherRange)
	}

	public static func convertFromStringLiteral(value: String) -> NSRange {
		return NSRange(string: value)
	}

	public static func convertFromExtendedGraphemeClusterLiteral(value: String) -> NSRange {
		let tmpStr = String.convertFromExtendedGraphemeClusterLiteral(value)
		return self.convertFromStringLiteral(tmpStr)
	}
}

extension NSPoint: StringLiteralConvertible {
	public init(string: String) {
		self = NSPointFromString(string)
	}

	var stringValue: String? {get {
		return NSStringFromPoint(self)
	}}

	public static func convertFromStringLiteral(value: String) -> NSPoint {
		return NSPoint(string: value)
	}

	public static func convertFromExtendedGraphemeClusterLiteral(value: String) -> NSPoint {
		let tmpStr = String.convertFromExtendedGraphemeClusterLiteral(value)
		return self.convertFromStringLiteral(tmpStr)
	}
}

extension NSSize: StringLiteralConvertible {
	public init(string: String) {
		self = NSSizeFromString(string)
	}

	var stringValue: String? {get {
		return NSStringFromSize(self)
	}}

	public static func convertFromStringLiteral(value: String) -> NSSize {
		return NSSize(string: value)
	}

	public static func convertFromExtendedGraphemeClusterLiteral(value: String) -> NSSize {
		let tmpStr = String.convertFromExtendedGraphemeClusterLiteral(value)
		return self.convertFromStringLiteral(tmpStr)
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

	var stringValue: String? {get {
		return NSStringFromRect(self)
	}}

	public func mouseIn(location: NSPoint, flipped: Bool = false) -> Bool {
		return NSMouseInRect(location, self, flipped)
	}

	public static func convertFromStringLiteral(value: String) -> NSRect {
		return NSRect(string: value)
	}

	public static func convertFromExtendedGraphemeClusterLiteral(value: String) -> NSRect {
		let tmpStr = String.convertFromExtendedGraphemeClusterLiteral(value)
		return self.convertFromStringLiteral(tmpStr)
	}
}
