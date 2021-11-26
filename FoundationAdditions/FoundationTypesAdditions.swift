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

public extension NSRange {
	/// An `NSRange` with a `location` of `NSNotFound` and a `length` of `0`.
	@inlinable static var notFound: NSRange {
		return NSRange(location: NSNotFound, length: 0)
	}
	
	/// Is `true` if `location` is equal to `NSNotFound`.
	@inlinable var notFound: Bool {
		return location == NSNotFound
	}
	
	/// Set the current `NSRange` to an intersection of this range and another.
	/// - parameter otherRange: the other range to intersect with.
	@inlinable mutating func intersect(_ otherRange: NSRange) {
		self = NSIntersectionRange(self, otherRange)
	}
	
	/// A string representation of the current range.
	/// Returns a string of the form *“{a, b}”*, where *a* and *b* are
	/// non-negative integers representing `self`.
	@inlinable var stringValue: String {
		return NSStringFromRange(self)
	}
	
	// MARK: - CFRange interop.
	
	/// Initializes an `NSRange` struct from a `CFRange` struct.
	/// - parameter range: The `CFRange` to convert from.
	@inlinable init(_ range: CoreFoundation.CFRange) {
		self.init(location: range.location, length: range.length)
	}
	
	/// Initializes an `NSRange` struct from a `CFRange` struct.
	/// - parameter range: The `CFRange` to convert from.
	@inlinable init(range: CoreFoundation.CFRange) {
		self.init(range)
	}
	
	/// The current range, represented as a `CFRange`.
	@inlinable var cfRange: CoreFoundation.CFRange {
		return CFRange(location: location, length: length)
	}
	// MARK: -
}

public extension CGPoint {
	/// Creates a point from a text-based representation.
	/// - parameter string: A string of the form *"{x, y}"*.
	///
	/// If `string` is of the form *"{x, y}"*, the `CGPoint` structure
	/// uses *x* and *y* as the `x` and `y` coordinates, in that order.<br>
	/// If `string` only contains a single number, it is used as the `x` coordinate.
	/// If `string` does not contain any numbers, creates an `CGPoint` object whose
	/// `x` and `y` coordinates are both `0`.
	/// - parameter string: The string to decode the point from.
	@inlinable init(string: String) {
		#if os(OSX)
			self = NSPointFromString(string)
		#else
			self = NSCoder.cgPoint(for: string)
		#endif
	}

	/// A string representation of the current point.
	/// 
	/// Returns a string of the form *"{a, b}"*, where *a* and *b* are the `x`
	/// and `y` coordinates of `self`.
	@inlinable var stringValue: String {
		#if os(OSX)
			return NSStringFromPoint(self)
		#else
			return NSCoder.string(for: self)
		#endif
	}
}

public extension CGSize {
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
	@inlinable init(string: String) {
		#if os(OSX)
			self = NSSizeFromString(string)
		#else
			self = NSCoder.cgSize(for: string)
		#endif
	}

	/// A string representation of the current size.
	///
	/// Returns a string of the form *"{a, b}"*, where *a* and *b* are the `width`
	/// and `height`, respectively, of `self`.
	@inlinable var stringValue: String {
		#if os(OSX)
			return NSStringFromSize(self)
		#else
			return NSCoder.string(for: self)
		#endif
	}
}

public extension CGRect {
	#if os(OSX)
	/// Adjusts the sides of a rectangle to integral values using the specified options.
	@inlinable mutating func formIntegral(options: AlignmentOptions) {
		self = NSIntegralRectWithOptions(self, options)
	}
	
	/// Adjusts the sides of a rectangle to integral values using the specified options.
	/// - returns: A copy of `self`, modified based on the options. The options are
	/// defined in `AlignmentOptions`.
	@inlinable func integral(options: AlignmentOptions) -> CGRect {
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
	@inlinable init(string: String) {
		#if os(OSX)
			self = NSRectFromString(string)
		#else
			self = NSCoder.cgRect(for: string)
		#endif
	}

	/// A string representation of the current rect.
	///
	/// Returns a string of the form *"{{a, b}, {c, d}}"*, where *a*, *b*, *c*, and *d*
	/// are the `x` and `y` coordinates and the `width` and `height`, respectively, of `self`.
	@inlinable var stringValue: String {
		#if os(OSX)
			return NSStringFromRect(self)
		#else
			return NSCoder.string(for: self)
		#endif
	}

	#if os(OSX)
	/// Returns a `Bool` value that indicates whether the point is in the specified rectangle.
	/// - parameter location: The point to test for.
	/// - parameter flipped: Specify `true` for flipped if the underlying view uses a
	/// flipped coordinate system.<br>
	/// Default is `false`.
	/// - returns: `true` if the hot spot of the cursor lies inside the rectangle, otherwise `false`.
	@available(swift, introduced: 2.0, deprecated: 5.0, obsoleted: 6.0, renamed: "mouse(inLocation:flipped:)")
	func mouseInLocation(_ location: NSPoint, flipped: Bool = false) -> Bool {
		return NSMouseInRect(location, self, flipped)
	}
	
	/// Returns a `Bool` value that indicates whether the point is in the specified rectangle.
	/// - parameter location: The point to test for.
	/// - parameter flipped: Specify `true` for flipped if the underlying view uses a
	/// flipped coordinate system.<br>
	/// Default is `false`.
	/// - returns: `true` if the hot spot of the cursor lies inside the rectangle, otherwise `false`.
	@inlinable func mouse(inLocation location: NSPoint, flipped: Bool = false) -> Bool {
		return NSMouseInRect(location, self, flipped)
	}
	#endif
}

public extension NSUUID {
	/// Create a new `NSUUID` from a CoreFoundation `CFUUID`.
	@objc(initWithCFUUID:) convenience init(cfUUID: CFUUID) {
		let tmp = CFUUIDGetUUIDBytes(cfUUID)
		let tmp2 = [tmp.byte0, tmp.byte1, tmp.byte2, tmp.byte3, tmp.byte4, tmp.byte5, tmp.byte6, tmp.byte7, tmp.byte8, tmp.byte9, tmp.byte10, tmp.byte11, tmp.byte12, tmp.byte13, tmp.byte14, tmp.byte15]

		self.init(uuidBytes: tmp2)
	}
	
	/// Get a CoreFoundation UUID from the current UUID.
	///
	/// Make sure you `CFRetain` the returned `CFUUIDRef` if you use this getter in Objective-C and you want to keep
	/// the value past the current scope.
	@objc(CFUUID) var cfUUID: CFUUID {
		return (self as UUID).cfUUID
	}
}

public extension UUID {
	/// Create a new `Foundation.UUID` from a CoreFoundation `CFUUID`.
	init(cfUUID: CFUUID) {
		let tmp = CFUUIDGetUUIDBytes(cfUUID)
		let tmp2 = uuid_t(tmp.byte0, tmp.byte1, tmp.byte2, tmp.byte3, tmp.byte4, tmp.byte5, tmp.byte6, tmp.byte7, tmp.byte8, tmp.byte9, tmp.byte10, tmp.byte11, tmp.byte12, tmp.byte13, tmp.byte14, tmp.byte15)
		
		self.init(uuid: tmp2)
	}
	
	/// Get a CoreFoundation UUID from the current UUID.
	var cfUUID: CFUUID {
		let tmp = self.uuid
		let tmp2 = CFUUIDBytes(byte0: tmp.0, byte1: tmp.1, byte2: tmp.2, byte3: tmp.3, byte4: tmp.4, byte5: tmp.5, byte6: tmp.6, byte7: tmp.7, byte8: tmp.8, byte9: tmp.9, byte10: tmp.10, byte11: tmp.11, byte12: tmp.12, byte13: tmp.13, byte14: tmp.14, byte15: tmp.15)
		
		return CFUUIDCreateFromUUIDBytes(kCFAllocatorDefault, tmp2)
	}
}

public extension NSMutableData {
	/// Appends to the receiver the bytes from a given array.
	/// - parameter byteArray: The array of bytes to add.
	@nonobjc func append(byteArray: [UInt8]) {
		append(byteArray, length: byteArray.count)
	}
	
	/// Replaces with a given set of bytes a given range within the contents of the receiver.
	/// - parameter range: The range within the receiver's contents to replace with bytes. The range must not exceed the bounds of the receiver.
	/// - parameter replacementBytes: The array of bytes to be replaced with.
	@nonobjc func replaceBytes(in range: NSRange, with replacementBytes: [UInt8]) {
		replaceBytes(in: range, withBytes: replacementBytes, length: replacementBytes.count)
	}

	/// Replaces with a given set of bytes a given range within the contents of the receiver.
	/// - parameter range: The range within the receiver's contents to replace with bytes. The range must not exceed the bounds of the receiver.
	/// - parameter replacementBytes: The pointer of bytes and length to be replaced with.
	@nonobjc func replaceBytes(in range: NSRange, with replacementBytes: UnsafeRawBufferPointer) {
		replaceBytes(in: range, withBytes: replacementBytes.baseAddress, length: replacementBytes.count)
	}
}

#if os(OSX)
@available(OSX, introduced: 10.10)
extension NSEdgeInsets: Equatable {
	@inlinable public static var zero: NSEdgeInsets {
		return NSEdgeInsetsZero
	}
	
	@inlinable public static func ==(rhs: NSEdgeInsets, lhs: NSEdgeInsets) -> Bool {
		return NSEdgeInsetsEqual(rhs, lhs)
	}
}
#endif

public extension NSIndexSet {
	/// Creates an index set from a sequence of `Int`s.
	convenience init<B: Sequence>(indexes: B) where B.Element == Int {
		self.init(indexSet: IndexSet(indexes))
	}
}

public extension IndexSet {
	/// Creates an index set from a sequence of `Int`s.
	@available(swift, introduced: 2.0, deprecated: 5.0, obsoleted: 6.0, renamed: "init(_:)")
	@inlinable init<B: Sequence>(indexes: B) where B.Element == Int {
		self.init(indexes)
	}
}


public extension UserDefaults {
	/// Gets and sets a user default value named `key` to/from a `String` type.
	/// - parameter key: the user default key to get/set.
	///
	/// When getting, if the user default specified by `key` is not a
	/// `String`, Foundation will convert it to a string 
	/// if the value is a number value. Otherwise `nil` will
	/// be returned.
	@nonobjc @inlinable subscript(key: String) -> String? {
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
	/// When getting, if the user default specified by `key` is not a `Data`
	/// or is not present, this will return `nil`.
	@nonobjc @inlinable subscript(key: String) -> Data? {
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
	/// When getting, if the user default specified by `key` is not a `Date`
	/// or is not present, this will return `nil`.
	@nonobjc @inlinable subscript(key: String) -> Date? {
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
	/// When getting, if the user default specified by `key` is not an `Array`
	/// or is not present, this will return `nil`.
	@nonobjc @inlinable subscript(key: String) -> [Any]? {
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
	/// is not a `String` or is not present, this will return `nil`.
	@nonobjc @inlinable subscript(key: String) -> [String]? {
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
	/// When getting, if the user default specified by `key` is not a `Dictionary`
	/// or is not present, this will return `nil`.
	@nonobjc @inlinable subscript(key: String) -> [String: Any]? {
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
	/// When getting, if the value is not an `Int` type, the following will be attempted to convert it to an `Int`:
	/// * If the value is a `Bool`, `0` will be returned if the value is *false*, `1` if *true*.
	/// * If the value is a `String`, it will attempt to convert it to an `Int` value. If unsuccessful, returns `nil`.
	/// * If the value is absent or can't be converted to an `Int`, `nil` will be returned.
	@nonobjc subscript(key: String) -> Int? {
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
	@nonobjc subscript(key: String) -> Float? {
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
	@nonobjc subscript(key: String) -> Double? {
		get {
			if let obj = object(forKey: key) {
				if let aDoub = obj as? Double {
					return aDoub
				} else if let aDoub = obj as? Float {
					return Double(aDoub)
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
	/// When getting, the following is attempted by the Foundation
	/// framework to convert it to a `URL`:
	/// * If the value is a `String` path, then it will construct a file URL to that path. 
	/// * If the value is an archived URL from `-setURL:forKey:`, or is set via this URL subscript setter, it will be unarchived.
	/// * If the value is absent or can't be converted to a `URL`, `nil` will be returned.
	@nonobjc @inlinable subscript(key: String) -> URL? {
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
	@nonobjc subscript(key: String) -> Bool? {
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

public extension Bundle {
	/// Creates a new CoreFoundation `CFBundle` from the current bundle's URL.
	///
	/// Make sure you `CFRetain` the returned `CFBundleRef` if you use this getter in Objective-C and you want to keep
	/// the value past the current scope.
	@objc(CFBundle) var cfBundle: CFBundle {
		return CFBundleCreate(kCFAllocatorDefault, bundleURL as NSURL)
	}
	
	/// Creates a new `Bundle` object from the url of the passed-in
	/// `CFBundle`.
	/// - parameter cfBundle: The `CFBundle` to get the URL from to
	/// create a new `Bundle` object.
	@objc(initWithCFBundle:) convenience init(cfBundle: CFBundle) {
		let cfURL = CFBundleCopyBundleURL(cfBundle)!
		self.init(url: cfURL as URL)!
	}
}
