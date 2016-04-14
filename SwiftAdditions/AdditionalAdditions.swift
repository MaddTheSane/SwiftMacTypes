//
//  AdditionalAdditions.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 11/2/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Foundation

///Clamps a variable between `minimum` and `maximum`.
///
///If `minimum` is greater than `maximum`, the original value is returned.
public func clamp<X: Comparable>(value: X, minimum: X, maximum: X) -> X {
	if minimum > maximum {
		return value
	}
	return max(min(value, maximum), minimum)
}

/// Best used for tuples of the same type, which Swift converts fixed-sized C arrays into.
/// Will crash if any type in the mirror doesn't match `X`.
///
/// - parameter mirror: The `Mirror` to get the reflected values from.
/// - parameter lastObj: Best used for a fixed-size C array that expects to be NULL-terminated, like a C string. If passed `nil`, no object will be put on the end of the array. Default is `nil`.
///
/// **Deprecated:** Use `arrayFromObject(reflecting:, appendLastObject:)` instead
public func getArrayFromMirror<X>(mirror: Mirror, appendLastObject lastObj: X? = nil) -> [X] {
	var anArray = [X]()
	for val in mirror.children {
		let aChar = val.value as! X
		anArray.append(aChar)
	}
	if let lastObj = lastObj {
		anArray.append(lastObj)
	}
	return anArray
}

public enum ReflectError: ErrorType {
	case UnexpectedType(Any.Type)
}

/// Best used for tuples of the same type, which Swift converts fixed-sized C arrays into.
/// Will throw if any type in the mirror doesn't match `X`.
///
/// - parameter obj: The base object to get the data from.
/// - parameter lastObj: Appends the element at the end of the array.<br>
/// Best used for a fixed-size C array that expects to be NULL-terminated, like a C string.
/// If passed `nil`, no object will be put on the end of the array. Default is `nil`.
/// - returns: an array of `X` objects.
/// - throws: `ReflectError` if any of the types don't match `X`.
public func arrayFromObject<X>(reflecting obj: Any, appendLastObject lastObj: X? = nil) throws -> [X] {
	var anArray = [X]()
	let mirror = Mirror(reflecting: obj)
	for val in mirror.children {
		guard let aChar = val.value as? X else {
			throw ReflectError.UnexpectedType(val.value.dynamicType)
		}
		anArray.append(aChar)
	}
	if let lastObj = lastObj {
		anArray.append(lastObj)
	}
	return anArray
}

/// Runs the closure on the main thread immediately if ran from the main thread,
/// or puts it on the main dispatch queue and waits for it to complete.
///
/// Useful to force a closure to run on the main thread, but you don't know if 
/// you *are* on the main thread.
///
/// This assumes that `NSThread`'s main thread is the same as GCD's main queue.
public func runOnMainThreadSync(block: dispatch_block_t) {
	if NSThread.isMainThread() {
		block()
	} else {
		dispatch_sync(dispatch_get_main_queue(), block)
	}
}

/// Runs the closure on the main thread immediately if ran from the main thread,
/// or queues it on the main Dispatch queue if on another thread.
///
/// This assumes that `NSThread`'s main thread is the same as GCD's main queue.
public func runOnMainThreadAsync(block: dispatch_block_t) {
	if NSThread.isMainThread() {
		block()
	} else {
		dispatch_async(dispatch_get_main_queue(), block)
	}
}

// Code taken from http://stackoverflow.com/a/33957196/1975001
extension Dictionary {
	mutating func unionInPlace(dictionary: Dictionary) {
		dictionary.forEach { self.updateValue($1, forKey: $0) }
	}
	
	func union(dictionary: Dictionary) -> Dictionary {
		var dict1 = dictionary
		dict1.unionInPlace(self)
		return dict1
	}
}

// Code taken from http://stackoverflow.com/a/24052094/1975001
public func +=<K, V> (inout left: Dictionary<K, V>, right: Dictionary<K, V>) {
	for (k, v) in right {
		left.updateValue(v, forKey: k)
	}
}

/// Adds two dictionaries together, returning the result.
/// Any key in both `left` and `right`, the value in `right` is used.
public func + <K,V>(left: Dictionary<K,V>, right: Dictionary<K,V>)
	-> Dictionary<K,V>
{
	var map = Dictionary<K,V>()
	for (k, v) in left {
		map[k] = v
	}
	for (k, v) in right {
		map[k] = v
	}
	return map
}

// MARK: - Array additions

/// Removes objects in an array that are in the specified `NSIndexSet`.
/// Returns objects that were removed.
/// - parameter ixs: the index set containing the indexes of objects that will be removed
/// - returns: any objects that were removed.
public func removeObjects<T>(inout inArray anArray: Array<T>, atIndexes indexes: NSIndexSet) -> [T] {
	return anArray.removeAtIndexes(indexes)
}

/// Removes objects in an array that are in the specified integer set.
/// Returns objects that were removed.
/// - parameter anArray: the array to modify.
/// - parameter indexes: the integer set containing the indexes of objects that will be removed
/// - returns: any objects that were removed.
public func removeObjects<T, B: SequenceType where B.Generator.Element == Int>(inout inArray anArray: Array<T>, atIndexes indexes: B) -> [T] {
	return anArray.removeAtIndexes(indexes)
}

extension Array {
	// Code taken from http://stackoverflow.com/a/26174259/1975001
	// Further adapted to work with Swift 2.2
	/// Removes objects at indexes that are in the specified `NSIndexSet`.
	/// Returns objects that were removed.
	/// - parameter indexes: the index set containing the indexes of objects that will be removed
	/// - returns: any objects that were removed.
	public mutating func removeAtIndexes(indexes: NSIndexSet) -> [Element] {
		var toRet = [Element]()
		for i in indexes.reverse() {
			toRet.append(self.removeAtIndex(i))
		}
		
		return toRet
	}
	
	/// Removes objects at indexes that are in the specified integer sequence.
	/// Returns objects that were removed.
	///
	/// Internally creates an `NSIndexSet` so the items are in order.
	/// - parameter ixs: the integer sequence containing the indexes of objects that will be removed
	/// - returns: any objects that were removed.
	public mutating func removeAtIndexes<B: SequenceType where B.Generator.Element == Int>(ixs: B) -> [Element] {
		let idxSet = NSMutableIndexSet()
		for i in ixs {
			idxSet.addIndex(i)
		}
		return removeAtIndexes(idxSet)
	}
}

extension Array where Element: AnyObject {
	///Returns a sorted array from the current array by using `NSSortDescriptor`s.
	///
	///This *may* be expensive, in both memory and computation!
	@warn_unused_result public func sortUsingDescriptors(descriptors: [NSSortDescriptor]) -> [Element] {
		let sortedArray = (self as NSArray).sortedArrayUsingDescriptors(descriptors)
		
		return sortedArray as! [Element]
	}
	
	///Sorts the current array by using `NSSortDescriptor`s.
	///
	///This *may* be expensive, in both memory and computation!
	public mutating func sortInPlaceUsingDescriptors(descriptors: [NSSortDescriptor]) {
		self = sortUsingDescriptors(descriptors)
	}
}

///Sort a Swift array using an array of `NSSortDescriptor`.
///
///This *may* be expensive, in both memory and computation!
@warn_unused_result public func sortedArray(anArray: [AnyObject], usingDescriptors descriptors: [NSSortDescriptor]) -> [AnyObject] {
	let sortedArray = anArray.sortUsingDescriptors(descriptors)
	
	return sortedArray
}
