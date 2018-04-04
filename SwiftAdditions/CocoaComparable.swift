//
//  CocoaComparable.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 7/1/16.
//  Copyright © 2016 C.W. Betts. All rights reserved.
//

import Foundation


public protocol CocoaComparable: NSObjectProtocol, Comparable {
	func compare(_ rhs: Self) -> ComparisonResult
}

extension CocoaComparable {
	static public func <(lhs: Self, rhs: Self) -> Bool {
		return lhs.compare(rhs) == .orderedAscending
	}
	
	static public func >(lhs: Self, rhs: Self) -> Bool {
		return lhs.compare(rhs) == .orderedDescending
	}
	
	//static public func ==(lhs: Self, rhs: Self) -> Bool {
	//	return lhs.compare(rhs) == .orderedSame
	//}
}

extension NSNumber: CocoaComparable {
}
