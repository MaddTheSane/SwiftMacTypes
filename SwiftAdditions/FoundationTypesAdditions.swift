//
//  NSRangeAdditions.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 8/22/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Foundation
#if !os(OSX)
	import UIKit
#endif

extension NSRange {
	/// An `NSRange` with a `location` of `NSNotFound` and a `length` of `0`.
	public static let notFound = NSRange(location: NSNotFound, length: 0)
	
	/// Returns a range from a textual representation.
	///
	/// Scans `string` for two integers which are used as the `location` 
	/// and `length` values, in that order, to create an `NSRange` struct. 
	/// If `string` only contains a single integer, it is used as the location 
	/// value. If `string` does not contain any integers, this function returns 
	/// an `NSRange` whose location and length values are both `0`.
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, message: "Use `NSRange(_:)` instead", renamed: "NSRange.init(_:)")
	public init(string: String) {
		self = NSRangeFromString(string)
	}
	
	/// Is `true` if `location` is equal to `NSNotFound`.
	public var notFound: Bool {
		return location == NSNotFound
	}
	
	@available(*, unavailable, message:"Use 'contains(_:)' instead", renamed:"contains(_:)")
	public func locationInRange(_ loc: Int) -> Bool {
		fatalError("Unavailable function called: \(#function)")
	}
	
	/// The maximum value from the range.
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, message: "Use `upperBound` instead", renamed: "upperBound")
	public var max: Int {
		return NSMaxRange(self)
	}

	/// Set the current `NSRange` to an intersection of this range and another.
	/// - parameter otherRange: the other range to intersect with.
	public mutating func intersect(_ otherRange: NSRange) {
		self = NSIntersectionRange(self, otherRange)
	}
	
	/// A string representation of the current range.
	/// Returns a string of the form *“{a, b}”*, where *a* and *b* are
	/// non-negative integers representing `self`.
	public var stringValue: String {
		return NSStringFromRange(self)
	}
	
	// MARK: - CFRange interop.
	
	/// Initializes an `NSRange` struct from a `CFRange` struct.
	/// - parameter range: The `CFRange` to convert from.
	public init(_ range: CoreFoundation.CFRange) {
		self.init(location: range.location, length: range.length)
	}
	
	/// Initializes an `NSRange` struct from a `CFRange` struct.
	/// - parameter range: The `CFRange` to convert from.
	public init(range: CoreFoundation.CFRange) {
		self.init(range)
	}
	
	/// The current range, represented as a `CFRange`.
	public var cfRange: CoreFoundation.CFRange {
		return CoreFoundation.CFRange(location: location, length: length)
	}

	/// The current range, represented as a `CFRange`.
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, message: "Use `cfRange` instead", renamed: "cfRange")
	public var `CFRange`: CoreFoundation.CFRange {
		return CoreFoundation.CFRange(location: location, length: length)
	}
}

extension CGPoint {
	/// Creates a point from a text-based representation.
	/// - parameter string: A string of the form *"{x, y}"*.
	///
	/// If `string` is of the form *"{x, y}"*, the `CGPoint` structure
	/// uses *x* and *y* as the `x` and `y` coordinates, in that order.<br>
	/// If `string` only contains a single number, it is used as the `x` coordinate.
	/// If `string` does not contain any numbers, creates an `CGPoint` object whose
	/// `x` and `y` coordinates are both `0`.
	/// - parameter string: The string to decode the point from.
	public init(string: String) {
		#if os(OSX)
			self = NSPointFromString(string)
		#else
			self = CGPointFromString(string)
		#endif
	}

	/// A string representation of the current point.
	/// 
	/// Returns a string of the form *"{a, b}"*, where *a* and *b* are the `x`
	/// and `y` coordinates of `self`.
	public var stringValue: String {
		#if os(OSX)
			return NSStringFromPoint(self)
		#else
			return NSStringFromCGPoint(self)
		#endif
	}
}

extension CGSize {
	/// Creates a `CGSize` from a text-based representation.
	///
	/// Scans aString for two numbers which are used as the width and height,
	/// in that order, to create a `CGSize` struct. If `string` only contains a
	/// single number, it is used as the width. The `string` argument should be
	/// formatted like the output of `NSStringFromSize(_:)`, `NSStringFromCGSize(_:)`,
	/// or `CGSize.stringValue`, for example, `"{10,20}"`.<br>
	/// If `string` does not contain any numbers, this function returns a `CGSize`
	/// struct whose width and height are both `0`.
	/// - parameter string: The string to decode the size from.
	public init(string: String) {
		#if os(OSX)
			self = NSSizeFromString(string)
		#else
			self = CGSizeFromString(string)
		#endif
	}

	/// A string representation of the current size.
	///
	/// Returns a string of the form *"{a, b}"*, where *a* and *b* are the `width`
	/// and `height`, respectively, of `self`.
	public var stringValue: String {
		#if os(OSX)
			return NSStringFromSize(self)
		#else
			return NSStringFromCGSize(self)
		#endif
	}
}

extension CGRect {
	#if os(OSX)
	/// Adjusts the sides of a rectangle to integral values using the specified options.
	public mutating func formIntegral(options: AlignmentOptions) {
		self = NSIntegralRectWithOptions(self, options)
	}
	
	@available(*, unavailable, message: "Use 'formIntegral(options:)' instead", renamed: "formIntegral(options:)")
	public mutating func integralInPlace(options: AlignmentOptions) {
		fatalError("Unavailable function called: \(#function)")
	}

	
	/// Adjusts the sides of a rectangle to integral values using the specified options.
	/// - returns: A copy of `self`, modified based on the options. The options are
	/// defined in `NSAlignmentOptions`.
	public func integral(options: AlignmentOptions) -> NSRect {
		return NSIntegralRectWithOptions(self, options)
	}
	#endif

	/// Creates a rectangle from a text-based representation.
	///
	/// Scans `string` for four numbers which are used as the x and y coordinates
	/// and the width and height, in that order, to create a `CGRect` object. If
	/// `string` does not contain four numbers, those numbers that were scanned are used,
	/// and `0` is used for the remaining values. If `string` does not contain any
	/// numbers, this function returns a `CGRect` object with a rectangle whose origin
	/// is `(0, 0)` and width and height are both `0`.
	/// - parameter string: The string to decode the rectangle from.
	public init(string: String) {
		#if os(OSX)
			self = NSRectFromString(string)
		#else
			self = CGRectFromString(string)
		#endif
	}

	/// A string representation of the current rect.
	///
	/// Returns a string of the form *"{{a, b}, {c, d}}"*, where *a*, *b*, *c*, and *d*
	/// are the `x` and `y` coordinates and the `width` and `height`, respectively, of `self`.
	public var stringValue: String {
		#if os(OSX)
			return NSStringFromRect(self)
		#else
			return NSStringFromCGRect(self)
		#endif
	}

	#if os(OSX)
	/// Returns a `Bool` value that indicates whether the point is in the specified rectangle.
	/// - parameter location: The point to test for.
	/// - parameter flipped: Specify `true` for flipped if the underlying view uses a
	/// flipped coordinate system.<br>
	/// Default is `false`.
	/// - returns: `true` if the hot spot of the cursor lies inside the rectangle, otherwise `false`.
	public func mouseInLocation(_ location: NSPoint, flipped: Bool = false) -> Bool {
		return NSMouseInRect(location, self, flipped)
	}
	#endif
}

extension NSUUID {
	/// Create a new `NSUUID` from a `CFUUID`.
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, message: "Use `UUID(cfUUID:)` instead")
	@objc(initWithCFUUID:) public convenience init(`CFUUID` cfUUID: CoreFoundation.CFUUID) {
		let tempUIDStr = CFUUIDCreateString(kCFAllocatorDefault, cfUUID)! as String
		
		self.init(uuidString: tempUIDStr)!
	}
	
	/// Get a CoreFoundation UUID from the current UUID.
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, message: "Use `cfUUID` instead", renamed: "cfUUID")
	@objc public var `CFUUID`: CoreFoundation.CFUUID {
		let tmpStr = self.uuidString
		
		return CFUUIDCreateFromString(kCFAllocatorDefault, tmpStr as NSString)
	}
	
	/// Get a CoreFoundation UUID from the current UUID.
	public var cfUUID: CoreFoundation.CFUUID {
		let tmpStr = self.uuidString
		
		return CFUUIDCreateFromString(kCFAllocatorDefault, tmpStr as NSString)
	}
}

extension UUID {
	/// Create a new `Foundation.UUID` from a `CFUUID`.
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, message: "Use `UUID(cfUUID:)` instead", renamed: "UUID.init(cfUUID:)")
	public init(`CFUUID` cfUUID: CoreFoundation.CFUUID) {
		let tempUIDStr = CFUUIDCreateString(kCFAllocatorDefault, cfUUID)! as String
		
		self.init(uuidString: tempUIDStr)!
	}
	
	/// Create a new `Foundation.UUID` from a `CFUUID`.
	public init(cfUUID: CoreFoundation.CFUUID) {
		let tempUIDStr = CFUUIDCreateString(kCFAllocatorDefault, cfUUID)! as String
		
		self.init(uuidString: tempUIDStr)!
	}

	
	/// Get a CoreFoundation UUID from the current UUID.
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, message: "Use `cfUUID` instead", renamed: "cfUUID")
	public var `CFUUID`: CoreFoundation.CFUUID {
		let tmpStr = self.uuidString
		
		return CFUUIDCreateFromString(kCFAllocatorDefault, tmpStr as NSString)
	}
	
	/// Get a CoreFoundation UUID from the current UUID.
	public var cfUUID: CoreFoundation.CFUUID {
		let tmpStr = self.uuidString
		
		return CFUUIDCreateFromString(kCFAllocatorDefault, tmpStr as NSString)
	}
}


extension NSData {
	@available(swift, introduced: 2.0, deprecated: 3.0, message: "Use the `Data` struct instead")
	@nonobjc public convenience init(byteArray: [UInt8]) {
		self.init(bytes: byteArray, length: byteArray.count)
	}
	
	@available(swift, introduced: 2.0, deprecated: 3.0, message: "Use the `Data` struct instead")
	@nonobjc public var arrayOfBytes: [UInt8] {
		let count = length / MemoryLayout<UInt8>.size
		var bytesArray = [UInt8](repeating: 0, count: count)
		getBytes(&bytesArray, length:count * MemoryLayout<UInt8>.size)
		return bytesArray
	}
}

extension NSMutableData {
	@available(*, unavailable, renamed: "append(byteArray:)")
	@nonobjc public func appendByteArray(_ byteArray: [UInt8]) {
		fatalError("Unavailable function called: \(#function)")
	}
	
	@available(swift, introduced: 2.0, deprecated: 3.0, obsoleted: 4.0, renamed: "replaceBytes(in:with:)")
	@nonobjc public func replaceBytesInRange(range: NSRange, withByteArray replacementBytes: [UInt8]) {
		replaceBytes(in: range, with: replacementBytes)
	}
	
	@nonobjc public func append(byteArray: [UInt8]) {
		append(byteArray, length: byteArray.count)
	}
	
	@nonobjc public func replaceBytes(in range: NSRange, with replacementBytes: [UInt8]) {
		replaceBytes(in: range, withBytes: replacementBytes, length: replacementBytes.count)
	}
}

#if os(OSX)
@available(OSX, introduced: 10.10)
extension NSEdgeInsets: Equatable {
	public static var zero: NSEdgeInsets {
		return NSEdgeInsetsZero
	}
}

@available(OSX, introduced: 10.10)
public func ==(rhs: NSEdgeInsets, lhs: NSEdgeInsets) -> Bool {
	return NSEdgeInsetsEqual(rhs, lhs)
}
#endif

extension NSIndexSet {
	/// Creates an index set from a sequence of `Int`s.
	public convenience init<B: Sequence>(indexes: B) where B.Element == Int {
		self.init(indexSet: IndexSet(indexes: indexes))
	}
}

extension IndexSet {
	/// Creates an index set from a sequence of `Int`s.
	public init<B: Sequence>(indexes: B) where B.Element == Int {
		self.init()
		for idx in indexes {
			insert(idx)
		}
	}
}


extension UserDefaults {
	/// - parameter key: the user default key to get/set.
	///
	/// If the user default specified by `key` is not a
	/// `String`, Foundation will convert it to a string 
	/// if the value is a number value. Otherwise `nil` will
	/// be returned.
	@nonobjc public subscript(key: String) -> String? {
		get {
			return string(forKey: key)
		}
		set {
			set(newValue, forKey: key)
		}
	}

	/// Gets and sets a user default value named `key` to/from a `Data` type.
	/// - parameter key: the user default key to get/set.
	///
	/// When getting, if the user default specified by `key` is not a `Data`,
	/// this will return `nil`.
	@nonobjc public subscript(key: String) -> Data? {
		get {
			return data(forKey: key)
		}
		set {
			set(newValue, forKey: key)
		}
	}
	
	/// Gets and sets a user default value named `key` to/from a `Date` type.
	/// - parameter key: the user default key to get/set.
	///
	/// When getting, if the user default specified by `key` is not a `Date`,
	/// this will return `nil`.
	@nonobjc public subscript(key: String) -> Date? {
		get {
			return object(forKey: key) as? Date
		}
		set {
			set(newValue, forKey: key)
		}
	}
	
	/// Gets and sets a user default value named `key` to/from an array type.
	/// - parameter key: the user default key to get/set.
	///
	/// When getting, if the user default specified by `key` is not an `Array`,
	/// this will return `nil`.
	@nonobjc public subscript(key: String) -> [Any]? {
		get {
			return array(forKey: key)
		}
		set {
			set(newValue, forKey: key)
		}
	}

	/// Gets and sets a user default value named `key` to/from an array of `String`s.
	/// - parameter key: the user default key to get/set.
	///
	/// When getting, if any of the objects in the user default array specified by `key`
	/// is not a `String`, this will return `nil`.
	@nonobjc public subscript(key: String) -> [String]? {
		get {
			return stringArray(forKey: key)
		}
		set {
			set(newValue, forKey: key)
		}
	}

	/// Gets and sets the dictionary object associated with the specified key.
	/// - parameter key: the user default key to get/set.
	///
	/// When getting, if any of the objects in the user default array specified by `key`
	/// is not a `Dictionary`, this will return `nil`.
	@nonobjc public subscript(key: String) -> [String: Any]? {
		get {
			return dictionary(forKey: key)
		}
		set {
			set(newValue, forKey: key)
		}
	}
	
	/// Gets and sets a user default value named `key` to/from an `Int` type.
	/// - parameter key: the user default key to get/set.
	///
	/// When getting, if the value is not a `Bool` type, the following will be attempted to convert it to an `Int`:
	/// * If the value is a `Bool`, `0` will be returned if the value is *false*, `1` if *true*.
	/// * If the value is a `String`, it will attempt to convert it to an `Int` value. If unsuccessful, returns `nil`.
	/// * If the value is absent or can't be converted to an `Int`, `nil` will be returned.
	@nonobjc public subscript(key: String) -> Int? {
		get {
			if let obj = object(forKey: key) {
				if let aDoub = obj as? Int {
					return aDoub
				} else if let aStr = obj as? String {
					return Int(aStr)
				} else if let aBool = obj as? Bool {
					return aBool ? 1 : 0
				}
			}
			return nil
		}
		set {
			if let newValue = newValue {
				set(newValue, forKey: key)
			} else {
				removeObject(forKey: key)
			}
		}
	}

	/// Gets and sets a user default value named `key` to/from a `Float` type.
	/// - parameter key: the user default key to get/set.
	///
	/// When getting, if the value is not a `Float` type, the following will be attempted to convert 
	/// it to a `Float`:
	/// * If the value is a `String`, it will attempt to convert it to a `Float` value. If unsuccessful, returns `nil`.
	/// * If the value is an `Int`, the value will be converted to a `Float`.
	/// * If the value is absent or can't be converted to a `Float`, `nil` will be returned.
	@nonobjc public subscript(key: String) -> Float? {
		get {
			if let obj = object(forKey: key) {
				if let aDoub = obj as? Float {
					return aDoub
				} else if let aDoub = obj as? Double {
					return Float(aDoub)
				} else if let aInt = obj as? Int {
					return Float(aInt)
				} else if let aStr = obj as? String {
					return Float(aStr)
				}
			}
			return nil
		}
		set {
			if let newValue = newValue {
				set(newValue, forKey: key)
			} else {
				removeObject(forKey: key)
			}
		}
	}
	
	/// Gets and sets a user default value named `key` to/from a `Double` type.
	/// - parameter key: the user default key to get/set.
	///
	/// When getting, if the value is not a `Double` type, the following will be attempted to convert 
	/// it to a `Double`:
	/// * If the value is a `String`, it will attempt to convert it to a `Double` value. If unsuccessful, returns `nil`.
	/// * If the value is an `Int`, the value will be converted to a `Double`.
	/// * If the value is absent or can't be converted to a `Double`, `nil` will be returned.
	@nonobjc public subscript(key: String) -> Double? {
		get {
			if let obj = object(forKey: key) {
				if let aDoub = obj as? Double {
					return aDoub
				} else if let aInt = obj as? Int {
					return Double(aInt)
				} else if let aStr = obj as? String {
					return Double(aStr)
				}
			}
			return nil
		}
		set {
			if let newValue = newValue {
				set(newValue, forKey: key)
			} else {
				removeObject(forKey: key)
			}
		}
	}

	/// Gets and sets a user default value named `key` to/from a `URL` type. 
	/// - parameter key: the user default key to get/set.
	///
	/// When getting, if the value is not a `URL` type, the following is attempted by the Foundation
	/// framework to convert it to a `URL`:
	/// * If the value is a `String` path, then it will construct a file URL to that path. 
	/// * If the value is an archived URL from `-setURL:forKey:`, or is set via the URL subscript, it will be unarchived.
	/// * If the value is absent or can't be converted to a `URL`, `nil` will be returned.
	@nonobjc public subscript(key: String) -> URL? {
		get {
			return url(forKey: key)
		}
		set {
			set(newValue, forKey: key)
		}
	}
	
	/// Gets and sets a user default value named `key` to/from a `Bool` type.
	/// - parameter key: the user default key to get/set.
	///
	/// When getting, if the value is not a `Bool` type, the following will be attempted to convert it to a `Bool`:
	/// * If the value is an `Int`, `false` will be returned if the value is *0*, `true` otherwise.
	/// * If the value is a `String`, values of *"YES"* or *"1"* will return `true`, and values of *"NO"* or *"0"* will return `false`, anything else will return `nil`. 
	/// * If the value is absent or can't be converted to a `Bool`, `nil` will be returned.
	@nonobjc public subscript(key: String) -> Bool? {
		get {
			if let obj = object(forKey: key) {
				if let aBool = obj as? Bool {
					return aBool
				} else if let aNum = obj as? Int {
					if aNum == 0 {
						return false
					} else {
						return true
					}
				} else if let aStr = obj as? String {
					switch aStr {
					case "0", "NO":
						return false
						
					case "1", "YES":
						return true
						
					default:
						return nil
					}
				}
			}
			return nil
		}
		set {
			if let newValue = newValue {
				set(newValue, forKey: key)
			} else {
				removeObject(forKey: key)
			}
		}
	}
}

// Code taken from http://stackoverflow.com/a/30404532/1975001
extension String {
	/// Creates an `NSRange` from a comparable `String` range.
	/// - parameter range: a Swift `String` range to get an `NSRange` from.
	/// - returns: a converted `NSRange`.
	@available(swift, introduced: 3.0, deprecated: 4.0, obsoleted: 5.0, message: "Use `NSRange(_:in:)` instead")
	public func nsRange(from range: Range<String.Index>) -> NSRange {
		let utf16view = self.utf16
		guard let from = range.lowerBound.samePosition(in: utf16view),
			let to = range.upperBound.samePosition(in: utf16view) else {
				return NSRange(range, in: self)
		}
		return NSRange(location: utf16view.distance(from: utf16view.startIndex, to: from),
		               length: utf16view.distance(from: from, to: to))
	}
	
	/// Creates a `String` range from the passed in `NSRange`.
	/// - parameter nsRange: An `NSRange` to convert to a `String` range.
	/// - returns: a converted `String` range, or `nil` if `nsRange` could not be converted.
	///
	/// Make sure you have called `-[NSString rangeOfComposedCharacterSequencesForRange:]`
	/// *before* calling this method, otherwise if the beginning or end of
	/// `nsRange` is in between Unicode code points or grapheme clusters, this method
	/// will return `nil`.
	@available(swift, introduced: 3.0, deprecated: 4.0, obsoleted: 5.0, message: "Use `Range(_:in:)` instead")
	public func range(from nsRange: NSRange) -> Range<String.Index>? {
		guard
			let preRange = Range(nsRange),
			let from16 = utf16.index(utf16.startIndex, offsetBy: preRange.lowerBound, limitedBy: utf16.endIndex),
			let to16 = utf16.index(utf16.startIndex, offsetBy: preRange.upperBound, limitedBy: utf16.endIndex),
			let from = String.Index(from16, within: self),
			let to = String.Index(to16, within: self)
			else { return nil }
		return from ..< to
	}
}
