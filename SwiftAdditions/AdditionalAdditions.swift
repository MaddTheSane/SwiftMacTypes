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
/// **Deprecated:** Use `arrayFromObject(reflecting:, appendLastObject:) throws` instead
@available(*, deprecated, message:"Use 'arrayFromObject(reflecting:, appendLastObject:) throws' instead", renamed: "arrayFromObject(reflecting:appendLastObject:)")
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

public enum ReflectError: Error {
	case UnexpectedType(type: Any.Type, named: String?)
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
			throw ReflectError.UnexpectedType(type: type(of: val.value), named: val.label)
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
public func runOnMainThreadSync(block: () -> Void) {
	if Thread.isMainThread {
		block()
	} else {
		DispatchQueue.main.sync(execute: block)
	}
}

/// Runs the closure on the main thread immediately if ran from the main thread,
/// or queues it on the main Dispatch queue if on another thread.
///
/// This assumes that `NSThread`'s main thread is the same as GCD's main queue.
public func runOnMainThreadAsync(block: @escaping () -> Void) {
	if Thread.isMainThread {
		block()
	} else {
		DispatchQueue.main.async(execute: block)
	}
}

// Code taken from http://stackoverflow.com/a/33957196/1975001
extension Dictionary {
	public mutating func formUnion(_ dictionary: Dictionary) {
		dictionary.forEach { self.updateValue($1, forKey: $0) }
	}
	
	public func union(dictionary: Dictionary) -> Dictionary {
		var dict1 = dictionary
		dict1.formUnion(self)
		return dict1
	}
}

// Code taken from http://stackoverflow.com/a/24052094/1975001
public func +=<K, V> ( left: inout Dictionary<K, V>, right: Dictionary<K, V>) {
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
@available(*, unavailable, message:"Use 'Array.remove(indexes:)' instead", renamed: "Array.remove(indexes:)")
public func removeObjects<T>( inArray anArray: inout Array<T>, atIndexes indexes: NSIndexSet) -> [T] {
	return anArray.remove(indexes: indexes)
}

/// Removes objects in an array that are in the specified integer set.
/// Returns objects that were removed.
/// - parameter anArray: the array to modify.
/// - parameter indexes: the integer set containing the indexes of objects that will be removed
/// - returns: any objects that were removed.
@available(*, unavailable, message:"Use 'Array.remove(indexes:)' instead", renamed: "Array.remove(indexes:)")
public func removeObjects<T, B: Sequence>( inArray anArray: inout Array<T>, atIndexes indexes: B) -> [T] where B.Iterator.Element == Int {
	return anArray.remove(indexes: indexes)
}

extension Array {
	// Code taken from http://stackoverflow.com/a/26174259/1975001
	// Further adapted to work with Swift 2.2
	/// Removes objects at indexes that are in the specified `NSIndexSet`.
	/// Returns objects that were removed.
	/// - parameter indexes: the index set containing the indexes of objects that will be removed
	/// - returns: any objects that were removed.
	public mutating func remove(indexes: NSIndexSet) -> [Element] {
		var toRet = [Element]()
		for i in indexes.reversed() {
			toRet.append(self.remove(at: i))
		}
		
		return toRet
	}
	
	/// Removes objects at indexes that are in the specified integer sequence.
	/// Returns objects that were removed.
	///
	/// Internally creates an `NSIndexSet` so the items are in order.
	/// - parameter ixs: the integer sequence containing the indexes of objects that will be removed
	/// - returns: any objects that were removed.
	public mutating func remove<B: Sequence>(indexes ixs: B) -> [Element] where B.Iterator.Element == Int {
		let idxSet = NSMutableIndexSet()
		for i in ixs {
			idxSet.add(i)
		}
		return remove(indexes: idxSet)
	}
}

extension Array where Element: AnyObject {
	///Returns a sorted array from the current array by using `NSSortDescriptor`s.
	///
	///This *may* be expensive, in both memory and computation!
	public func sorted(using descriptors: [NSSortDescriptor]) -> [Element] {
		let sortedArray = (self as NSArray).sortedArray(using: descriptors)
		
		return sortedArray as! [Element]
	}
	
	///Sorts the current array by using `NSSortDescriptor`s.
	///
	///This *may* be expensive, in both memory and computation!
	public mutating func sort(using descriptors: [NSSortDescriptor]) {
		self = sorted(using: descriptors)
	}
}

///Sort a Swift array using an array of `NSSortDescriptor`.
///
///This *may* be expensive, in both memory and computation!
@available(*, unavailable, message:"Use 'Array.sorted(using:)' instead", renamed: "Array.sorted(using:)")
public func sortedArray(anArray: [AnyObject], usingDescriptors descriptors: [NSSortDescriptor]) -> [AnyObject] {
	let sortedArray = anArray.sorted(using: descriptors)
	
	return sortedArray
}

extension String {
	/// Creates a new `String` with the contents of `self`
	/// up to `len` UTF-8 characters long, truncating incomplete
	/// Swift characters at the end.
	public func substringWithLength(utf8 len: Int) -> String {
		let ourUTF = utf8
		guard ourUTF.count > len else {
			return self
		}
		let pref = ourUTF.prefix(len)
		return String(pref)!
	}

	/// Creates a new `String` with the contents of `self`
	/// up to `len` UTF-16 characters long, truncating incomplete
	/// Swift characters at the end.
	public func substringWithLength(utf16 len: Int) -> String {
		let ourUTF = utf16
		guard ourUTF.count > len else {
			return self
		}
		let pref = ourUTF.prefix(len)
		return String(pref)!
	}
}
