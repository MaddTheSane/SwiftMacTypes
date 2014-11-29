//
//  PlayerPROCoreAdditions.swift
//  PPMacho
//
//  Created by C.W. Betts on 7/24/14.
//
//

import Foundation
import Darwin.MacTypes
#if os(OSX)
import CoreServices
#endif

#if os(OSX)
	public func OSTypeToString(theType: OSType) -> String? {
		if let toRet = UTCreateStringForOSType(theType) {
			return toRet.takeRetainedValue()
		} else {
			return nil
		}
	}
	
	public func StringToOSType(theString: String) -> OSType {
		return UTGetOSTypeFromString(theString)
	}
#else
	public func OSTypeToString(theType: OSType) -> String? {
		func OSType2Ptr(type: OSType) -> [CChar] {
			var ourOSType = [Int8](count: 5, repeatedValue: 0)
			var intType = type.bigEndian
			memcpy(&ourOSType, &intType, 4)
			
			return ourOSType
		}
	
		let ourOSType = OSType2Ptr(theType)
		return NSString(bytes: ourOSType, length: 4, encoding: NSMacOSRomanStringEncoding);
	}
	
	public func StringToOSType(theString: String) -> OSType {
		func Ptr2OSType(str: [CChar]) -> OSType {
			var type: OSType = 0x20202020 // four spaces. Can't really be represented the same way as it is in C
			var i = countElements(str) - 1
			if i > 4 {
				i = 4
			}
			memcpy(&type, str, UInt(i))
			type = type.bigEndian
			
			return type
		}
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

public var CurrentCFMacStringEncoding: CFStringEncoding {
	return CFStringGetMostCompatibleMacStringEncoding(CFStringGetSystemEncoding())
}

/// The current system encoding that is the most like a Mac Classic encoding
public var CurrentMacStringEncoding: NSStringEncoding {
	return CFStringConvertEncodingToNSStringEncoding(CurrentCFMacStringEncoding)
}

/// Pascal String extensions
/// The init functions will return nil if the Pascal string says its length is longer than
/// the enclosing type
extension String {
	public init?(pascalString pStr: ConstStringPtr, encoding: CFStringEncoding) {
		if let theStr = CFStringCreateWithPascalString(kCFAllocatorDefault, pStr, encoding) {
			self = theStr
		} else {
			return nil
		}
	}
	
	public init?(pascalString pStr: ConstStringPtr, encoding: NSStringEncoding = NSMacOSRomanStringEncoding) {
		let CFEncoding = CFStringConvertNSStringEncodingToEncoding(encoding)
		if CFEncoding == kCFStringEncodingInvalidId {
			return nil
		}
		if let theStr = CFStringCreateWithPascalString(kCFAllocatorDefault, pStr, CFEncoding) {
			self = theStr
		} else {
			return nil
		}
	}
	
	public init?(pascalString pStr: Str255, encoding: NSStringEncoding = NSMacOSRomanStringEncoding) {
		let mirror = reflect(pStr)
		let unwrapped: [UInt8] = GetArrayFromMirror(mirror)
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	public init?(pascalString pStr: Str63, encoding: NSStringEncoding = NSMacOSRomanStringEncoding) {
		let mirror = reflect(pStr)
		let unwrapped: [UInt8] = GetArrayFromMirror(mirror)
		if unwrapped[0] > 63 {
			return nil
		}
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	public init?(pascalString pStr: Str32, encoding: NSStringEncoding = NSMacOSRomanStringEncoding) {
		let mirror = reflect(pStr)
		let unwrapped: [UInt8] = GetArrayFromMirror(mirror)
		if unwrapped[0] > 32 {
			return nil
		}

		self.init(pascalString: unwrapped, encoding: encoding)
	}

	public init?(pascalString pStr: Str31, encoding: NSStringEncoding = NSMacOSRomanStringEncoding) {
		let mirror = reflect(pStr)
		let unwrapped: [UInt8] = GetArrayFromMirror(mirror)
		if unwrapped[0] > 31 {
			return nil
		}
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	public init?(pascalString pStr: Str27, encoding: NSStringEncoding = NSMacOSRomanStringEncoding) {
		let mirror = reflect(pStr)
		let unwrapped: [UInt8] = GetArrayFromMirror(mirror)
		if unwrapped[0] > 27 {
			return nil
		}
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	public init?(pascalString pStr: Str15, encoding: NSStringEncoding = NSMacOSRomanStringEncoding) {
		let mirror = reflect(pStr)
		let unwrapped: [UInt8] = GetArrayFromMirror(mirror)
		if unwrapped[0] > 15 {
			return nil
		}
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	public init?(pascalString pStr: Str32Field, encoding: NSStringEncoding = NSMacOSRomanStringEncoding) {
		var unwrapped = [UInt8]()
		var mirror = reflect(pStr)
		// And this is why this version can't use GetArrayFromMirror...
		// We skip the last byte because it's not used
		// and may, in fact, be garbage.
		for i in 0..<(mirror.count - 1) {
			var aChar = mirror[i].1.value as UInt8
			unwrapped.append(aChar)
		}
		if unwrapped[0] > 32 {
			return nil
		}
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	public init?(_ pStr: ConstStringPtr) {
		self.init(pascalString: pStr)
	}

	public init?(_ pStr: Str255) {
		self.init(pascalString: pStr)
	}
	
	public init?(_ pStr: Str63) {
		self.init(pascalString: pStr)
	}
	
	public init?(_ pStr: Str32) {
		self.init(pascalString: pStr)
	}
	
	public init?(_ pStr: Str31) {
		self.init(pascalString: pStr)
	}
	
	public init?(_ pStr: Str27) {
		self.init(pascalString: pStr)
	}
	
	public init?(_ pStr: Str15) {
		self.init(pascalString: pStr)
	}
	
	public init?(_ pStr: Str32Field) {
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
	
	public var stringValue: String? {
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
	
	public var boolValue: Bool {
		if (self == 0) {
			return false
		} else {
			return true
		}
	}
}

extension NumVersion: Printable {
	public init(_ version: UInt32) {
		// FIXME: endian issues?
		nonRelRev = UInt8((version >> 0) & 0xFF)
		stage = UInt8((version >> 8) & 0xFF)
		minorAndBugRev = UInt8((version >> 16) & 0xFF)
		majorRev = UInt8((version >> 24) & 0xFF)
	}
	
	public init() {
		self.init(0)
	}
	
	public enum Stage: UInt8 {
		case Develop	= 0x20
		case Alpha		= 0x40
		case Beta		= 0x60
		case Final		= 0x80
	}
	
	public var bugRev: UInt8 {
		var aBugRev = minorAndBugRev & 0x0F
		return aBugRev
	}
	
	public var minorRev: UInt8 {
		return minorAndBugRev >> 4
	}
	
	public init(major: UInt8, minor: UInt8, bug: UInt8, stage: Stage, nonRelease: UInt8) {
		majorRev = major
		minorAndBugRev = (minor << 4) & 0xF0 | bug & 0x0F
		self.stage = stage.rawValue
		nonRelRev = nonRelease
	}
	
	public var developmentStage: Stage? {
		let toRet = stage & 0xF0
		return Stage(rawValue: toRet)
	}
	
	public var rawValue: UInt32 {
		// FIXME: endian issues?
		var a = UInt32(nonRelRev)
		var b = UInt32(stage)
		var c = UInt32(minorAndBugRev)
		var d = UInt32(majorRev)
		
		return d << 24 | c << 16 | b << 8 | a
	}
	
	public var description: String {
		var ourStage = developmentStage ?? Stage.Develop
		var ourStrStage: String
		switch ourStage {
		case .Develop:
			ourStrStage = "Develop"
			
		case .Alpha:
			ourStrStage = "Alpha"
			
		case .Beta:
			ourStrStage = "Beta"
			
		case .Final:
			ourStrStage = "Final"
		}
		let blankStr = ""
		return "\(majorRev).\(minorRev).\(bugRev) \(ourStrStage)\(nonRelRev == 0 ? blankStr : nonRelRev.description)"
	}
}
