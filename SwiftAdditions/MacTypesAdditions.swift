//
//  PlayerPROCoreAdditions.swift
//  PPMacho
//
//  Created by C.W. Betts on 7/24/14.
//
//

import Darwin.MacTypes
import Foundation
import CoreServices

extension String {
	public init(pascalString pStr: StringPtr, encoding: CFStringEncoding = CFStringEncoding(CFStringBuiltInEncodings.MacRoman.toRaw())) {
		let theStr = CFStringCreateWithPascalString(kCFAllocatorDefault, pStr, encoding)
		self = theStr as NSString
	}
	
	public init(pascalString pStr: Str255, encoding: CFStringEncoding = CFStringEncoding(CFStringBuiltInEncodings.MacRoman.toRaw())) {
		var unwrapped = [UInt8]()
		let mirror = reflect(pStr)
		for i in 0..<mirror.count {
			let aChar = mirror[i].1.value as UInt8
			unwrapped.append(aChar)
		}
		let theStr = CFStringCreateWithPascalString(kCFAllocatorDefault, &unwrapped, encoding)
		self = theStr as NSString
	}
	
	public init(pascalString pStr: Str63, encoding: CFStringEncoding = CFStringEncoding(CFStringBuiltInEncodings.MacRoman.toRaw())) {
		var unwrapped = [UInt8]()
		let mirror = reflect(pStr)
		for i in 0..<mirror.count {
			let aChar = mirror[i].1.value as UInt8
			unwrapped.append(aChar)
		}
		let theStr = CFStringCreateWithPascalString(kCFAllocatorDefault, &unwrapped, encoding)
		self = theStr as NSString
	}
	
	public init(pascalString pStr: Str32, encoding: CFStringEncoding = CFStringEncoding(CFStringBuiltInEncodings.MacRoman.toRaw())) {
		var unwrapped = [UInt8]()
		let mirror = reflect(pStr)
		for i in 0..<mirror.count {
			let aChar = mirror[i].1.value as UInt8
			unwrapped.append(aChar)
		}
		let theStr = CFStringCreateWithPascalString(kCFAllocatorDefault, &unwrapped, encoding)
		self = theStr as NSString
	}

	public init(pascalString pStr: Str31, encoding: CFStringEncoding = CFStringEncoding(CFStringBuiltInEncodings.MacRoman.toRaw())) {
		var unwrapped = [UInt8]()
		let mirror = reflect(pStr)
		for i in 0..<mirror.count {
			let aChar = mirror[i].1.value as UInt8
			unwrapped.append(aChar)
		}
		let theStr = CFStringCreateWithPascalString(kCFAllocatorDefault, &unwrapped, encoding)
		self = theStr as NSString
	}
	
	public init(pascalString pStr: Str27, encoding: CFStringEncoding = CFStringEncoding(CFStringBuiltInEncodings.MacRoman.toRaw())) {
		var unwrapped = [UInt8]()
		let mirror = reflect(pStr)
		for i in 0..<mirror.count {
			let aChar = mirror[i].1.value as UInt8
			unwrapped.append(aChar)
		}
		let theStr = CFStringCreateWithPascalString(kCFAllocatorDefault, &unwrapped, encoding)
		self = theStr as NSString
	}
	
	public init(pascalString pStr: Str15, encoding: CFStringEncoding = CFStringEncoding(CFStringBuiltInEncodings.MacRoman.toRaw())) {
		var unwrapped = [UInt8]()
		let mirror = reflect(pStr)
		for i in 0..<mirror.count {
			let aChar = mirror[i].1.value as UInt8
			unwrapped.append(aChar)
		}
		let theStr = CFStringCreateWithPascalString(kCFAllocatorDefault, &unwrapped, encoding)
		self = theStr as NSString
	}
	
	public init(pascalString pStr: Str32Field, encoding: CFStringEncoding = CFStringEncoding(CFStringBuiltInEncodings.MacRoman.toRaw())) {
		var unwrapped = [UInt8]()
		var mirror = reflect(pStr)
		// We skip the last byte because it's not used
		// and may, in fact, be garbage.
		for i in 0..<(mirror.count - 1) {
			var aChar = mirror[i].1.value as UInt8
			unwrapped.append(aChar)
		}
		let theStr = CFStringCreateWithPascalString(kCFAllocatorDefault, &unwrapped, encoding)
		self = theStr as NSString
	}
	
	public init(_ pStr: StringPtr) {
		self.init(pascalString: pStr)
	}

	public init(_ pStr: Str255) {
		self.init(pascalString: pStr)
	}
	
	public init(_ pStr: Str63) {
		self.init(pascalString: pStr)
	}
	
	public init(_ pStr: Str32) {
		self.init(pascalString: pStr)
	}
	
	public init(_ pStr: Str31) {
		self.init(pascalString: pStr)
	}
	
	public init(_ pStr: Str27) {
		self.init(pascalString: pStr)
	}
	
	public init(_ pStr: Str15) {
		self.init(pascalString: pStr)
	}
	
	public init(_ pStr: Str32Field) {
		self.init(pascalString: pStr)
	}
}

extension OSType: StringLiteralConvertible {
	public var stringValue: String { get {
		let toRet = UTCreateStringForOSType(self).takeRetainedValue()
		return toRet as NSString as String
	}}
	
	public init(_ toInit: (Int8, Int8, Int8, Int8, Int8)) {
		self = OSType((toInit.0, toInit.1, toInit.2, toInit.3))
	}

	public init(_ toInit: (Int8, Int8, Int8, Int8)) {
		let val0 = OSType(toInit.0)
		let val1 = OSType(toInit.1)
		let val2 = OSType(toInit.2)
		let val3 = OSType(toInit.3)
		self = OSType(val0 << 24) | (val1 << 16) | (val2 << 8) | (val3)
	}

	public func toFourChar() -> (Int8, Int8, Int8, Int8) {
		let var1 = (self >> 24) & 0xFF
		let var2 = (self >> 16) & 0xFF
		let var3 = (self >> 8) & 0xFF
		let var4 = (self) & 0xFF
		return (Int8(var1), Int8(var2), Int8(var3), Int8(var4))
	}
	
	public func toFourChar() -> (Int8, Int8, Int8, Int8, Int8) {
		let outVar: (Int8, Int8, Int8, Int8) = toFourChar()
		return (outVar.0, outVar.1, outVar.2, outVar.3, 0)
	}

	public init(_ toInit: String) {
		self = UTGetOSTypeFromString(toInit as NSString as CFString)
	}
	
	public static func convertFromStringLiteral(value: String) -> OSType {
		return OSType(value)
	}
	
	public static func convertFromExtendedGraphemeClusterLiteral(value: String) -> OSType {
		var tmpStr = String.convertFromExtendedGraphemeClusterLiteral(value)
		return self.convertFromStringLiteral(tmpStr)
	}

}

extension Boolean : BooleanLiteralConvertible, BooleanType {
	public init(_ v : BooleanType) {
		if v.boolValue {
			self = 1
		} else {
			self = 0
		}
	}
	
	public static func convertFromBooleanLiteral(value: BooleanLiteralType) -> Boolean {
		if (value == true) {
			return 1
		} else {
			return 0
		}
	}
	
	public var boolValue: Bool { get {
		if (self == 0) {
			return false
		} else {
			return true
		}}
	}
}
