//
//  CocoaComparable.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 7/1/16.
//  Copyright © 2016 C.W. Betts. All rights reserved.
//

import Foundation


public protocol CocoaComparable: NSObjectProtocol, Comparable {
	func compare(rhs: Self) -> NSComparisonResult
}


public func <<A: CocoaComparable>(lhs:A, rhs: A) -> Bool {
	return lhs.compare(rhs) == .OrderedAscending
}

public func ><A: CocoaComparable>(lhs: A, rhs: A) -> Bool {
	return lhs.compare(rhs) == .OrderedDescending
}

public func ==< A: CocoaComparable>(lhs:A, rhs: A) -> Bool {
	return lhs.compare(rhs) == .OrderedSame
}


extension NSNumber: CocoaComparable {}
extension NSIndexPath: CocoaComparable {}
