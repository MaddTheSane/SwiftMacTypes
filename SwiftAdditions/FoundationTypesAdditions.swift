//
//  NSRangeAdditions.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 8/22/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Foundation

public func ==(rhs: NSRange, lhs: NSRange) -> Bool {
	return (rhs.location == lhs.location && rhs.length == lhs.length)
}

extension NSRange: Equatable {
	public init(string: String) {
		self = NSRangeFromString(string)
	}
	
	public var notFound: Bool {
		return location == NSNotFound
	}
	
	public func locationIsInRange(loc: Int) -> Bool {
		return (!(loc < location) && (loc - location) < length) ? true : false
	}

	public var max: Int {
		return location + length
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

#if os(OSX)
extension NSPoint {
	public init(string: String) {
		self = NSPointFromString(string)
	}

	public var stringValue: String {
		return NSStringFromPoint(self)
	}
}

extension NSSize {
	public init(string: String) {
		self = NSSizeFromString(string)
	}

	public var stringValue: String {
		return NSStringFromSize(self)
	}
}

extension NSRect {
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
		return NSStringFromRect(self)
	}

	public func mouseIn(location: NSPoint, flipped: Bool = false) -> Bool {
		return NSMouseInRect(location, self, flipped)
	}
}
#endif
