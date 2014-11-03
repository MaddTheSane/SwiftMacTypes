//
//  PlayerPROCoreAdditions.swift
//  PPMacho
//
//  Created by C.W. Betts on 7/24/14.
//
//

import Darwin.MacTypes
import Foundation
#if os(OSX)
import CoreServices
#endif

private let macRomanEncoding = CFStringBuiltInEncodings.MacRoman.rawValue

#if os(OSX)
	
	public func OSTypeToString(theType: OSType) -> String? {
		if let toRet = UTCreateStringForOSType(theType) {
			return CFStringToString(toRet.takeRetainedValue())
		} else {
			return nil
		}
	}
	
	public func StringToOSType(theString: String) -> OSType {
		return UTGetOSTypeFromString(StringToCFString(theString))
	}
#else
	
	private func Ptr2OSType(aChar: [Int8]) -> OSType {
		let val0 = UInt32(aChar[0])
		let val1 = UInt32(aChar[1])
		let val2 = UInt32(aChar[2])
		let val3 = UInt32(aChar[3])
		return OSType((val0 << 24) | (val1 << 16) | (val2 << 8) | (val3))
	}
	
	private func OSType2Ptr(aOSType: OSType, inout aChar: [Int8]) {
		let var1 = (aOSType >> 24) & 0xFF
		let var2 = (aOSType >> 16) & 0xFF
		let var3 = (aOSType >> 8) & 0xFF
		let var4 = (aOSType) & 0xFF
		
		aChar[0] = Int8(var1)
		aChar[1] = Int8(var2)
		aChar[2] = Int8(var3)
		aChar[3] = Int8(var4)
		aChar[4] = 0
	}
	
	public func OSTypeToString(theType: OSType) -> String? {
		var ourOSType = [Int8](count: 5, repeatedValue: 0)
	
		OSType2Ptr(theType, &ourOSType)
		return NSString(bytes: ourOSType, length: 4, encoding: NSMacOSRomanStringEncoding);
	}
	
	public func StringToOSType(theString: String) -> OSType {
		var ourOSType = [Int8](count: 5, repeatedValue: 0)
		let anNSStr = theString as NSString
		var ourLen = anNSStr.lengthOfBytesUsingEncoding(NSMacOSRomanStringEncoding)
		if ourLen > 4 {
			ourLen = 4
		} else if ourLen == 0 {
			return 0
		}
	
		let aData = anNSStr.cStringUsingEncoding(NSMacOSRomanStringEncoding)
		
		for i in 0 ..< ourLen {
			ourOSType[i] = aData[i]
		}
		
		return Ptr2OSType(ourOSType)
	}
#endif

extension String {
	public init(pascalString pStr: ConstStringPtr, encoding: CFStringEncoding = macRomanEncoding) {
		let theStr = CFStringCreateWithPascalString(kCFAllocatorDefault, pStr, encoding)
		self = CFStringToString(theStr)
	}
	
	public init(pascalString pStr: Str255, encoding: CFStringEncoding = macRomanEncoding) {
		let mirror = reflect(pStr)
		let unwrapped: [UInt8] = GetArrayFromMirror(mirror)
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	public init(pascalString pStr: Str63, encoding: CFStringEncoding = macRomanEncoding) {
		let mirror = reflect(pStr)
		let unwrapped: [UInt8] = GetArrayFromMirror(mirror)
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	public init(pascalString pStr: Str32, encoding: CFStringEncoding = macRomanEncoding) {
		let mirror = reflect(pStr)
		let unwrapped: [UInt8] = GetArrayFromMirror(mirror)
		self.init(pascalString: unwrapped, encoding: encoding)
	}

	public init(pascalString pStr: Str31, encoding: CFStringEncoding = macRomanEncoding) {
		let mirror = reflect(pStr)
		let unwrapped: [UInt8] = GetArrayFromMirror(mirror)
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	public init(pascalString pStr: Str27, encoding: CFStringEncoding = macRomanEncoding) {
		let mirror = reflect(pStr)
		let unwrapped: [UInt8] = GetArrayFromMirror(mirror)
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	public init(pascalString pStr: Str15, encoding: CFStringEncoding = macRomanEncoding) {
		let mirror = reflect(pStr)
		let unwrapped: [UInt8] = GetArrayFromMirror(mirror)
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	public init(pascalString pStr: Str32Field, encoding: CFStringEncoding = macRomanEncoding) {
		var unwrapped = [UInt8]()
		var mirror = reflect(pStr)
		// And this is why this version can't use GetArrayFromMirror...
		// We skip the last byte because it's not used
		// and may, in fact, be garbage.
		for i in 0..<(mirror.count - 1) {
			var aChar = mirror[i].1.value as UInt8
			unwrapped.append(aChar)
		}
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	public init(_ pStr: ConstStringPtr) {
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
	public init(_ toInit: String) {
		self = StringToOSType(toInit)
	}
	
	public init(unicodeScalarLiteral usl: String) {
		let tmpUnscaled = String(unicodeScalarLiteral: usl)
		self = StringToOSType(tmpUnscaled)
	}
	
	public init(extendedGraphemeClusterLiteral egcl: String) {
		let tmpUnscaled = String(extendedGraphemeClusterLiteral: egcl)
		self.init(tmpUnscaled)
	}
	
	public init(stringLiteral toInit: String) {
		self = StringToOSType(toInit)
	}
	
	public init(_ toInit: (Int8, Int8, Int8, Int8, Int8)) {
		self = OSType((toInit.0, toInit.1, toInit.2, toInit.3))
	}
	
	public var OSTypeStringValue: String? {
		return OSTypeToString(self)
	}
	
	public init(_ toInit: (Int8, Int8, Int8, Int8)) {
		let val0 = OSType(toInit.0)
		let val1 = OSType(toInit.1)
		let val2 = OSType(toInit.2)
		let val3 = OSType(toInit.3)
		self = OSType((val0 << 24) | (val1 << 16) | (val2 << 8) | (val3))
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
}

extension Boolean : BooleanLiteralConvertible, BooleanType {
	public init(booleanLiteral v : Bool) {
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
	
	public var boolValue: Bool {
		if (self == 0) {
			return false
		} else {
			return true
		}
	}
}
