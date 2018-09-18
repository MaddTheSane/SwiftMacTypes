//
//  AdditionalAdditions.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 11/2/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Foundation

/// Clamps a variable between `minimum` and `maximum`.
/// - parameter value: The value to clamp.
/// - parameter minimum: The minimum value to clamp `value` to.
/// - parameter maximum: The maximum value to clamp `value` to.
/// - returns: `value` if it is in-between `minimum` and `maximum`,
/// or a value that is no less than `minimum` and no greater than `maximum`.
///
/// If `minimum` is greater than `maximum`, a fatal error occurs.
public func clamp<X: Comparable>(_ value: X, minimum: X, maximum: X) -> X {
	if minimum > maximum {
		fatalError("Minimum (\(minimum)) is greater than maximum (\(maximum))!")
	}
	return max(min(value, maximum), minimum)
}

/// Clamp variables between `minimum` and `maximum`.
/// - parameter values: The values to clamp.
/// - parameter minimum: The minimum value to clamp the elements in `values` to.
/// - parameter maximum: The maximum value to clamp the elements in `values` to.
/// - returns: a new array with the values clamped between `minimum` and `maximum`.
///
/// If `minimum` is greater than `maximum`, a fatal error occurs.
public func clamp<W: Sequence, X: Comparable>(values: W, minimum: X, maximum: X) -> [X] where W.Element == X {
	if minimum > maximum {
		fatalError("Minimum (\(minimum)) is greater than maximum (\(maximum))!")
	}
	return values.map({ (value) -> X in
		return max(min(value, maximum), minimum)
	})
}

@available(swift, introduced: 2, deprecated: 4.0, renamed: "clamp(_:minimum:maximum:)")
public func clamp<X: Comparable>(value: X, minimum: X, maximum: X) -> X {
	return clamp(value, minimum: minimum, maximum: maximum)
}

/// Best used for tuples of the same type, which Swift converts fixed-sized C arrays into.
/// Will crash if any type in the mirror doesn't match `X`.
///
/// - parameter mirror: The `Mirror` to get the reflected values from.
/// - parameter lastObj: Best used for a fixed-size C array that expects to be NULL-terminated, like a C string. If passed `nil`, no object will be put on the end of the array. <br>Default is `nil`.
///
/// **Deprecated:** Use `arrayFromObject(reflecting:, appendLastObject:) throws` instead
@available(*, deprecated, message: "Use 'arrayFromObject(reflecting:, appendLastObject:) throws' instead")
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
/// - parameter block: The block to execute syncronously on the main thread.
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
/// - parameter block: The block to execute asyncronously on the main thread.
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
		if capacity < count + dictionary.count {
			reserveCapacity(count + dictionary.count)
		}
		dictionary.forEach { self.updateValue($1, forKey: $0) }
	}
	
	public func union(_ dictionary: Dictionary) -> Dictionary {
		var dict1 = self
		dict1.formUnion(dictionary)
		return dict1
	}

	// Code taken from http://stackoverflow.com/a/24052094/1975001
	public static func +=(left: inout Dictionary, right: Dictionary) {
		if left.capacity < left.count + right.count {
			left.reserveCapacity(left.count + right.count)
		}
		for (k, v) in right {
			left.updateValue(v, forKey: k)
		}
	}
	
	/// Adds two dictionaries together, returning the result.
	/// For any key in both `left` and `right`, the value in `right` is used.
	public static func +(left: Dictionary, right: Dictionary) -> Dictionary {
		var map = Dictionary<Key, Value>()
		map.reserveCapacity(left.count + right.count)
		for (k, v) in left {
			map[k] = v
		}
		for (k, v) in right {
			map[k] = v
		}
		return map
	}
}

// MARK: - Array additions

extension Array {
	/// Removes objects at indexes that are in the specified `NSIndexSet`.
	/// - parameter indexes: the index set containing the indexes of objects that will be removed
	public mutating func remove(indexes: NSIndexSet) {
		self.remove(indexes: indexes as IndexSet)
	}
	
	// Code taken from https://stackoverflow.com/a/50835467/1975001
	/// Removes objects at indexes that are in the specified `IndexSet`.
	/// - parameter indexes: the index set containing the indexes of objects that will be removed
	public mutating func remove(indexes: IndexSet) {
		guard var i = indexes.first, i < count else {
			return
		}
		var j = index(after: i)
		var k = indexes.integerGreaterThan(i) ?? endIndex
		while j != endIndex {
			if k != j {
				swapAt(i, j)
				formIndex(after: &i)
			} else {
				k = indexes.integerGreaterThan(k) ?? endIndex
			}
			formIndex(after: &j)
		}
		removeSubrange(i...)
	}
	
	/// Removes objects at indexes that are in the specified integer sequence.
	///
	/// Internally creates an `IndexSet` so the items are in order.
	/// - parameter ixs: the integer sequence containing the indexes of objects that will be removed
	public mutating func remove<B: Sequence>(indexes ixs: B) where B.Iterator.Element == Int {
		var idxSet = IndexSet()
		for i in ixs {
			idxSet.insert(i)
		}
		remove(indexes: idxSet)
	}
}

extension Array where Element: AnyObject {
	/// Returns a sorted array from the current array by using `NSSortDescriptor`s.
	/// - parameter descriptors: The `NSSortDescriptor`s to sort the array with.
	/// - returns: This array, sorted by `descriptors`.
	///
	/// This *may* be expensive, in both memory and computation!
	public func sorted(using descriptors: [NSSortDescriptor]) -> [Element] {
		let sortedArray = (self as NSArray).sortedArray(using: descriptors)
		
		return sortedArray as! [Element]
	}
	
	/// Sorts the current array by using `NSSortDescriptor`s.
	/// - parameter descriptors: The `NSSortDescriptor`s to sort the array with.
	///
	/// This *may* be expensive, in both memory and computation!
	public mutating func sort(using descriptors: [NSSortDescriptor]) {
		self = sorted(using: descriptors)
	}
}

// MARK: -

extension String {
	/// Creates a new `String` with the contents of `self`
	/// up to `len` UTF-8 characters long, truncating incomplete
	/// Swift characters at the end.
	public func substringWithLength(utf8 len: Int) -> String {
		let ourUTF = utf8
		guard ourUTF.count > len else {
			return self
		}
		var pref = ourUTF.prefix(len)
		var toRet = String(pref)
		var len2 = len
		while len2 > 0 {
			if let toRet = toRet {
				return toRet
			}
			len2 -= 1
			pref = ourUTF.prefix(len2)
			toRet = String(pref)
		}
		
		return ""
	}

	/// Creates a new `String` with the contents of `self`
	/// up to `len` UTF-16 characters long, truncating incomplete
	/// Swift characters at the end.
	public func substringWithLength(utf16 len: Int) -> String {
		let ourUTF = utf16
		guard ourUTF.count > len else {
			return self
		}
		var pref = ourUTF.prefix(len)
		var toRet = String(pref)
		var len2 = len
		while len2 > 0 {
			if let toRet = toRet {
				return toRet
			}
			len2 -= 1
			pref = ourUTF.prefix(len2)
			toRet = String(pref)
		}
		
		return ""
	}
}

extension UnsafeBufferPointer {
	/// Creates an `UnsafeBufferPointer` over the contiguous `Element` instances beginning 
	/// at `start`, iterating until `sentinelChecker` returns `true`.
	///
	/// This is great for array pointers that have an unknown number of elements but does have
	/// a terminating element, or *sentinel*, that indicates the end of the array.
	/// The sentinal isn't included in the array.
	/// - parameter start: the pointer to start from.
	/// - parameter sentinelChecker: The block that checks if the current `Element`
	/// is the sentinel, or last object in an array. Return `true` if `toCheck`
	/// matches the characteristic of the sentinal.
	/// - parameter toCheck: The current element to check.
	public init(start: UnsafePointer<Element>, sentinel sentinelChecker: (_ toCheck: Element) -> Bool) {
		var toIterate = start
		
		while !sentinelChecker(toIterate.pointee) {
			toIterate = toIterate.advanced(by: 1)
		}
		
		self = UnsafeBufferPointer(start: start, count: start.distance(to: toIterate))
	}
}

extension UnsafeMutableBufferPointer {
	/// Creates an `UnsafeMutableBufferPointer` over the contiguous `Element` instances beginning
	/// at `start`, iterating until `sentinelChecker` returns `true`.
	///
	/// This is great for array pointers that have an unknown number of elements but does have
	/// a terminating element, or *sentinel*, that indicates the end of the array.
	/// The sentinal isn't included in the array.
	/// - parameter start: the pointer to start from.
	/// - parameter sentinelChecker: The block that checks if the current `Element`
	/// is the sentinel, or last object in an array. Return `true` if `toCheck`
	/// matches the characteristic of the sentinal.
	/// - parameter toCheck: The current element to check.
	public init(start: UnsafeMutablePointer<Element>, sentinel sentinelChecker: (_ toCheck: Element) -> Bool) {
		var toIterate = start
		
		while !sentinelChecker(toIterate.pointee) {
			toIterate = toIterate.advanced(by: 1)
		}
		
		self = UnsafeMutableBufferPointer(start: start, count: start.distance(to: toIterate))
	}
}
