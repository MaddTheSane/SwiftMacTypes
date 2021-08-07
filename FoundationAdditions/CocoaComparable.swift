//
//  CocoaComparable.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 7/1/16.
//  Copyright © 2016 C.W. Betts. All rights reserved.
//

import Foundation

/// Protocol that can be used to mark Objective-C classes as `Comparable`.
/// Useful if they already have a compare function already.
public protocol CocoaComparable: NSObjectProtocol, Comparable {
	func compare(_ rhs: Self) -> ComparisonResult
}

public extension CocoaComparable {
	static func <(lhs: Self, rhs: Self) -> Bool {
		return lhs.compare(rhs) == .orderedAscending
	}
	
	static func >(lhs: Self, rhs: Self) -> Bool {
		return lhs.compare(rhs) == .orderedDescending
	}
	
	static func <=(lhs: Self, rhs: Self) -> Bool {
		let cmpResult = lhs.compare(rhs)
		return cmpResult == .orderedAscending || cmpResult == .orderedSame
	}
	
	static func >=(lhs: Self, rhs: Self) -> Bool {
		let cmpResult = lhs.compare(rhs)
		return cmpResult == .orderedDescending || cmpResult == .orderedSame
	}
	
	//static public func ==(lhs: Self, rhs: Self) -> Bool {
	//	return lhs.compare(rhs) == .orderedSame
	//}
}

extension NSNumber: CocoaComparable {
}
