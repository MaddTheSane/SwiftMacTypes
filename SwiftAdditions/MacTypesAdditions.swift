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
import CoreGraphics

public func ==(lhs: NumVersion, rhs: NumVersion) -> Bool {
	if lhs.nonRelRev != rhs.nonRelRev {
		return false
	}
	if lhs.stage != rhs.stage {
		return false
	}
	if lhs.minorAndBugRev != rhs.minorAndBugRev {
		return false
	}
	if lhs.majorRev != rhs.majorRev {
		return false
	}
	return true
}

public func OSTypeToString(theType: OSType) -> String? {
	#if os(OSX)
		if let toRet = UTCreateStringForOSType(theType) {
			return toRet.takeRetainedValue()
		} else {
			return nil
		}
		#else
		func OSType2Ptr(type: OSType) -> [CChar] {
			var ourOSType = [Int8](count: 5, repeatedValue: 0)
			var intType = type.bigEndian
			memcpy(&ourOSType, &intType, 4)
			
			return ourOSType
		}
		
		let ourOSType = OSType2Ptr(theType)
		return NSString(bytes: ourOSType, length: 4, encoding: NSMacOSRomanStringEncoding);
	#endif
}

public func OSTypeToString(theType: OSType, #useHexIfInvalid: ()) -> String {
	if let ourStr = OSTypeToString(theType) {
		return ourStr
	} else {
		return NSString(format: "0x%08X", theType)
	}
}

public func StringToOSType(theString: String, detectHex: Bool = false) -> OSType {
	let elementsCount = countElements(theString)
	if elementsCount > 4 && detectHex {
		let aScann = NSScanner(string: theString)
		var tmpnum: UInt32 = 0
		if aScann.scanHexInt(&tmpnum) {
			return tmpnum
		}
	}
	#if os(OSX)
		return UTGetOSTypeFromString(theString)
		#else
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
	#endif
}

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
	/// The base initializer for the Pascal String types.
	/// Gets passed a CFStringEncoding because the underlying function used to generate
	/// strings uses that
	public init?(pascalString pStr: ConstStringPtr, encoding: CFStringEncoding) {
		if let theStr = CFStringCreateWithPascalString(kCFAllocatorDefault, pStr, encoding) {
			self = theStr
		} else {
			return nil
		}
	}
	
	/// The main initializer. Converts the encoding to a CFStringEncoding for use
	/// in the base initializer.
	public init?(pascalString pStr: ConstStringPtr, encoding: NSStringEncoding = NSMacOSRomanStringEncoding) {
		let CFEncoding = CFStringConvertNSStringEncodingToEncoding(encoding)
		if CFEncoding == kCFStringEncodingInvalidId {
			return nil
		}
		self.init(pascalString: pStr, encoding: CFEncoding)
	}
	
	public init?(pascalString pStr: Str255, encoding: NSStringEncoding = NSMacOSRomanStringEncoding) {
		let mirror = reflect(pStr)
		let unwrapped: [UInt8] = GetArrayFromMirror(mirror)!
		// a UInt8 can't reference any number greater than 255,
		// so we just pass it to the main initializer
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	public init?(pascalString pStr: Str63, encoding: NSStringEncoding = NSMacOSRomanStringEncoding) {
		let mirror = reflect(pStr)
		let unwrapped: [UInt8] = GetArrayFromMirror(mirror)!
		if unwrapped[0] > 63 {
			return nil
		}
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	public init?(pascalString pStr: Str32, encoding: NSStringEncoding = NSMacOSRomanStringEncoding) {
		let mirror = reflect(pStr)
		let unwrapped: [UInt8] = GetArrayFromMirror(mirror)!
		if unwrapped[0] > 32 {
			return nil
		}

		self.init(pascalString: unwrapped, encoding: encoding)
	}

	public init?(pascalString pStr: Str31, encoding: NSStringEncoding = NSMacOSRomanStringEncoding) {
		let mirror = reflect(pStr)
		let unwrapped: [UInt8] = GetArrayFromMirror(mirror)!
		if unwrapped[0] > 31 {
			return nil
		}
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	public init?(pascalString pStr: Str27, encoding: NSStringEncoding = NSMacOSRomanStringEncoding) {
		let mirror = reflect(pStr)
		let unwrapped: [UInt8] = GetArrayFromMirror(mirror)!
		if unwrapped[0] > 27 {
			return nil
		}
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	public init?(pascalString pStr: Str15, encoding: NSStringEncoding = NSMacOSRomanStringEncoding) {
		let mirror = reflect(pStr)
		let unwrapped: [UInt8] = GetArrayFromMirror(mirror)!
		if unwrapped[0] > 15 {
			return nil
		}
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	/// The last byte in a Str32Field is unused,
	/// so the last byte isn't read.
	public init?(pascalString pStr: Str32Field, encoding: NSStringEncoding = NSMacOSRomanStringEncoding) {
		var unwrapped = [UInt8]()
		let mirror = reflect(pStr)
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
	
	/// Convenience initializer, passing a Str255 (or a tuple with 256(!) UInt8s)
	public init?(_ pStr: Str255) {
		self.init(pascalString: pStr)
	}
	
	/// Convenience initializer, passing a Str63 (or a tuple with 64 UInt8s)
	public init?(_ pStr: Str63) {
		self.init(pascalString: pStr)
	}
	
	/// Convenience initializer, passing a Str32 (or a tuple with 33 UInt8s)
	public init?(_ pStr: Str32) {
		self.init(pascalString: pStr)
	}
	
	/// Convenience initializer, passing a Str31 (or a tuple with 32 UInt8s)
	public init?(_ pStr: Str31) {
		self.init(pascalString: pStr)
	}
	
	/// Convenience initializer, passing a Str27 (or a tuple with 28 UInt8s)
	public init?(_ pStr: Str27) {
		self.init(pascalString: pStr)
	}
	
	/// Convenience initializer, passing a Str15 (or a tuple with 16 UInt8s)
	public init?(_ pStr: Str15) {
		self.init(pascalString: pStr)
	}
	
	/// Convenience initializer, passing a Str32Field (or a tuple with 34 UInt8s, with the last byte ignored)
	public init?(_ pStr: Str32Field) {
		self.init(pascalString: pStr)
	}
}

extension OSType: StringLiteralConvertible {
	public init(_ toInit: String) {
		self = StringToOSType(toInit, detectHex: true)
	}
	
	public init(unicodeScalarLiteral usl: String) {
		let tmpUnscaled = String(unicodeScalarLiteral: usl)
		self.init(tmpUnscaled)
	}
	
	public init(extendedGraphemeClusterLiteral egcl: String) {
		let tmpUnscaled = String(extendedGraphemeClusterLiteral: egcl)
		self.init(tmpUnscaled)
	}
	
	public init(stringLiteral toInit: String) {
		self.init(toInit)
	}
	
	public init(_ toInit: (Int8, Int8, Int8, Int8, Int8)) {
		self = OSType((toInit.0, toInit.1, toInit.2, toInit.3))
	}
	
	public var stringValue: String {
		return OSTypeToString(self, useHexIfInvalid: ())
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

extension NumVersion: Printable, Equatable {
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
		let aBugRev = minorAndBugRev & 0x0F
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
		let ourStage = developmentStage ?? Stage.Develop
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

#if false
private func FixedToFloat(aFixed: Fixed) -> Float {
	let fixed1: Fixed = 0x00010000
	let ffixed1 = Float(fixed1)
	let faFixed = Float(aFixed)
	return faFixed / ffixed1
}

private func FixedToDouble(aFixed: Fixed) -> Double {
	let fixed1: Fixed = 0x00010000
	let ffixed1 = Double(fixed1)
	let faFixed = Double(aFixed)
	return faFixed / ffixed1
}
#endif

private func FixedToCGFloat(aFixed: Fixed) -> CGFloat {
	let fixed1: Fixed = 0x00010000
	let ffixed1 = CGFloat(fixed1)
	let faFixed = CGFloat(aFixed)
	return faFixed / ffixed1
}

extension CGRect {
	public init(CarbonRect rect: Rect) {
		self.init(x: Int(rect.left), y: Int(rect.top), width: Int(rect.right - rect.left), height: Int(rect.bottom - rect.top))
	}
	
	public init(CarbonFixedRect rect: FixedRect) {
		let floatLeft = FixedToCGFloat(rect.left)
		let floatTop = FixedToCGFloat(rect.top)
		self.init(x: floatLeft, y: floatTop, width: FixedToCGFloat(rect.right) - floatLeft, height: FixedToCGFloat(rect.bottom) - floatTop)
	}
}

extension CGPoint {
	public init(CarbonPoint point: Point) {
		self.init(x: Int(point.v), y: Int(point.h))
	}
	
	public init(CarbonFixedPoint fixedPoint: FixedPoint) {
		self.init(x: FixedToCGFloat(fixedPoint.x), y: FixedToCGFloat(fixedPoint.y))
	}
}

#if os(OSX)
extension String {
	/// HFSUniStr255 is declared internally on OS X, but not on iOS
	public init(HFSUniStr: HFSUniStr255) {
		let uniStr: [UInt16] = GetArrayFromMirror(reflect(HFSUniStr.unicode))!
		self = NSString(bytes: uniStr, length: Int(HFSUniStr.length), encoding: NSUTF16StringEncoding)!
	}
}
	
public enum CarbonToolbarIcons: OSType {
	case Customize = 0x74637573
	case Delete = 0x7464656C
	case Favorite = 0x74666176
	case Home = 0x74686F6D
	case Advanced = 0x74626176
	case Info = 0x7462696E
	case Labels = 0x74626C62
	case ApplicationFolder = 0x74417073
	case DocumentsFolder = 0x74446F63
	case MoviesFolder = 0x744D6F76
	case MusicFolder = 0x744D7573
	case PicturesFolder = 0x74506963
	case PublicFolder = 0x74507562
	case DesktopFolder = 0x7444736B
	case DownloadsFolder = 0x7444776E
	case LibraryFolder = 0x744C6962
	case UtilitiesFolder = 0x7455746C
	case SitesFolder = 0x74537473
}

#endif
