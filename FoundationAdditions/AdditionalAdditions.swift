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
@inlinable public func clamp<X: Comparable>(_ value: X, minimum: X, maximum: X) -> X {
	precondition(minimum <= maximum, "Minimum (\(minimum)) is greater than maximum (\(maximum))!")
	return max(min(value, maximum), minimum)
}

/// Clamp variables between `minimum` and `maximum`.
/// - parameter values: The values to clamp.
/// - parameter minimum: The minimum value to clamp the elements in `values` to.
/// - parameter maximum: The maximum value to clamp the elements in `values` to.
/// - returns: a new array with the values clamped between `minimum` and `maximum`.
///
/// If `minimum` is greater than `maximum`, a fatal error occurs.
@inlinable public func clamp<W: Sequence, X: Comparable>(values: W, minimum: X, maximum: X) -> [X] where W.Element == X {
	precondition(minimum <= maximum, "Minimum (\(minimum)) is greater than maximum (\(maximum))!")
	return values.map({ (value) -> X in
		return max(min(value, maximum), minimum)
	})
}

/// Errors encountered when attempting to create an array by reflecting into
/// the data type.
public enum ReflectError: Error {
	/// The type encountered wasn't the expected type.
	case unexpectedType(type: Any.Type, named: String?)
}

/// Creates an array of type `X` by reflecting `obj`.
///
/// Best used for tuples of the same type, which Swift converts fixed-sized C arrays into.
/// Will throw if any type in the mirror doesn't match `X`.
///
/// - parameter obj: The base object to get the data from.
/// - parameter lastObj: Appends the element at the end of the array.<br>
/// Best used for a fixed-size C array that expects to be NULL-terminated, like a C string.
/// If passed `nil`, no object will be put on the end of the array. Default is `nil`.
/// - returns: an array of `X` objects.
/// - throws: `ReflectError` if any of the types don't match `X`.
@inlinable public func arrayFromObject<X>(reflecting obj: Any, appendLastObject lastObj: X? = nil) throws -> [X] {
	var anArray = [X]()
	let mirror = Mirror(reflecting: obj)
	let children = mirror.children
	anArray.reserveCapacity(children.count + 1)
	for val in children {
		guard let aChar = val.value as? X else {
			throw ReflectError.unexpectedType(type: type(of: val.value), named: val.label)
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
public func runOnMainThreadSync(_ block: () -> Void) {
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
public func runOnMainThreadAsync(_ block: @escaping () -> Void) {
	if Thread.isMainThread {
		block()
	} else {
		DispatchQueue.main.async(execute: block)
	}
}

// Code taken from http://stackoverflow.com/a/33957196/1975001
public extension Dictionary {
	@inlinable mutating func formUnion(_ dictionary: Dictionary) {
		if capacity < count + dictionary.count {
			reserveCapacity(count + dictionary.count)
		}
		dictionary.forEach { self.updateValue($1, forKey: $0) }
	}
	
	@inlinable func union(_ dictionary: Dictionary) -> Dictionary {
		var dict1 = self
		dict1.formUnion(dictionary)
		return dict1
	}

	// Code taken from http://stackoverflow.com/a/24052094/1975001
	@inlinable static func +=(left: inout Dictionary, right: Dictionary) {
		if left.capacity < left.count + right.count {
			left.reserveCapacity(left.count + right.count)
		}
		for (k, v) in right {
			left.updateValue(v, forKey: k)
		}
	}
	
	/// Adds two dictionaries together, returning the result.
	/// For any key in both `left` and `right`, the value in `right` is used.
	@inlinable static func +(left: Dictionary, right: Dictionary) -> Dictionary {
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

public extension Array {
	/// Removes objects at indexes that are in the specified `NSIndexSet`.
	/// - parameter indexes: the index set containing the indexes of objects that will be removed
	@inlinable mutating func remove(indexes: NSIndexSet) {
		self.remove(indexes: indexes as IndexSet)
	}
	
	// Code taken from https://stackoverflow.com/a/50835467/1975001
	/// Removes objects at indexes that are in the specified `IndexSet`.
	/// - parameter indexes: the index set containing the indexes of objects that will be removed
	@inlinable mutating func remove(indexes: IndexSet) {
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
	@inlinable mutating func remove<B: Sequence>(indexes ixs: B) where B.Iterator.Element == Int {
		let idxSet = IndexSet(ixs)
		remove(indexes: idxSet)
	}
}

public extension Array where Element: AnyObject {
	/// Returns a sorted array from the current array by using `NSSortDescriptor`s.
	/// - parameter descriptors: The `NSSortDescriptor`s to sort the array with.
	/// - returns: This array, sorted by `descriptors`.
	///
	/// This *may* be expensive, in both memory and computation!
	func sorted(using descriptors: [NSSortDescriptor]) -> [Element] {
		let sortedArray = (self as NSArray).sortedArray(using: descriptors)
		
		return sortedArray as! [Element]
	}
	
	/// Sorts the current array by using `NSSortDescriptor`s.
	/// - parameter descriptors: The `NSSortDescriptor`s to sort the array with.
	///
	/// This *may* be expensive, in both memory and computation!
	mutating func sort(using descriptors: [NSSortDescriptor]) {
		self = sorted(using: descriptors)
	}
}

// MARK: -

public extension String {
	/// Creates a new `String` with the contents of `self`
	/// up to `len` UTF-8 characters long, truncating incomplete
	/// Swift characters at the end.
	func substringWithLength(utf8 len: Int) -> String {
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
	func substringWithLength(utf16 len: Int) -> String {
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

public extension UnsafeBufferPointer {
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
	@inlinable init(start: UnsafePointer<Element>, sentinel sentinelChecker: (_ toCheck: Element) throws -> Bool) rethrows {
		var toIterate = start
		
		while !(try sentinelChecker(toIterate.pointee)) {
			toIterate = toIterate.advanced(by: 1)
		}
		
		self = UnsafeBufferPointer(start: start, count: start.distance(to: toIterate))
	}
	
	/// Creates an `UnsafeBufferPointer` over the contiguous `Element` instances
	/// beginning at `start`, iterating until `sentinelChecker` returns `true` or `maximum`
	/// iterations have happened.
	///
	/// This is great for array pointers that have an unknown number of elements but does have
	/// a terminating element, or *sentinel*, that indicates the end of the array.
	/// The sentinal isn't included in the array.
	/// - parameter start: the pointer to start from.
	/// - parameter maximum: The longest iteration to look out for. Any elements after this
	/// are not included in the buffer.
	/// - parameter sentinelChecker: The block that checks if the current `Element`
	/// is the sentinel, or last object in an array. Return `true` if `toCheck`
	/// matches the characteristic of the sentinal.
	/// - parameter toCheck: The current element to check.
	@inlinable init(start: UnsafePointer<Element>, maximum: Int, sentinel sentinelChecker: (_ toCheck: Element) throws -> Bool) rethrows {
		var toIterate = start
		
		while !(try sentinelChecker(toIterate.pointee)) && start.distance(to: toIterate) > maximum {
			toIterate = toIterate.advanced(by: 1)
		}
		
		self = UnsafeBufferPointer(start: start, count: start.distance(to: toIterate))
	}
}

public extension UnsafeMutableBufferPointer {
	/// Creates an `UnsafeMutableBufferPointer` over the contiguous `Element` instances
	/// beginning at `start`, iterating until `sentinelChecker` returns `true`.
	///
	/// This is great for array pointers that have an unknown number of elements but does have
	/// a terminating element, or *sentinel*, that indicates the end of the array.
	/// The sentinal isn't included in the array.
	/// - parameter start: the pointer to start from.
	/// - parameter sentinelChecker: The block that checks if the current `Element`
	/// is the sentinel, or last object in an array. Return `true` if `toCheck`
	/// matches the characteristic of the sentinal.
	/// - parameter toCheck: The current element to check.
	@inlinable init(start: UnsafeMutablePointer<Element>, sentinel sentinelChecker: (_ toCheck: Element) throws -> Bool) rethrows {
		var toIterate = start
		
		while !(try sentinelChecker(toIterate.pointee)) {
			toIterate = toIterate.advanced(by: 1)
		}
		
		self = UnsafeMutableBufferPointer(start: start, count: start.distance(to: toIterate))
	}
	
	/// Creates an `UnsafeMutableBufferPointer` over the contiguous `Element` instances
	/// beginning at `start`, iterating until `sentinelChecker` returns `true` or `maximum`
	/// iterations have happened.
	///
	/// This is great for array pointers that have an unknown number of elements but does have
	/// a terminating element, or *sentinel*, that indicates the end of the array.
	/// The sentinal isn't included in the array.
	/// - parameter start: the pointer to start from.
	/// - parameter maximum: The longest iteration to look out for. Any elements after this
	/// are not included in the buffer.
	/// - parameter sentinelChecker: The block that checks if the current `Element`
	/// is the sentinel, or last object in an array. Return `true` if `toCheck`
	/// matches the characteristic of the sentinal.
	/// - parameter toCheck: The current element to check.
	@inlinable init(start: UnsafeMutablePointer<Element>, maximum: Int, sentinel sentinelChecker: (_ toCheck: Element) throws -> Bool) rethrows {
		var toIterate = start
		
		while !(try sentinelChecker(toIterate.pointee)) && start.distance(to: toIterate) > maximum {
			toIterate = toIterate.advanced(by: 1)
		}
		
		self = UnsafeMutableBufferPointer(start: start, count: start.distance(to: toIterate))
	}
}
