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


/// Converts an OSType to a String value. May return nil.
public func OSTypeToString(theType: OSType) -> String? {
	#if os(OSX)
		return UTCreateStringForOSType(theType).takeRetainedValue() as String
		#else
		func OSType2Ptr(type: OSType) -> [CChar] {
			var ourOSType = [Int8](count: 5, repeatedValue: 0)
			var intType = type.bigEndian
			memcpy(&ourOSType, &intType, 4)
			
			return ourOSType
		}
		
		let ourOSType = OSType2Ptr(theType)
		return NSString(bytes: ourOSType, length: 4, encoding: NSMacOSRomanStringEncoding) as? String
	#endif
}

/// Converts an OSType to a String value. May return a hexadecimal string.
public func OSTypeToString(theType: OSType, useHexIfInvalid: ()) -> String {
	if let ourStr = OSTypeToString(theType) {
		return ourStr
	} else {
		return String(format: "0x%08X", theType)
	}
}

/// Converts a string value to an OSType, truncating to the first four characters.
public func StringToOSType(theString: String, detectHex: Bool = false) -> OSType {
	if detectHex && theString.characters.count > 4 {
		let aScann = NSScanner(string: theString)
		var tmpnum: UInt32 = 0
		if aScann.scanHexInt(&tmpnum) && tmpnum != UInt32.max {
			return tmpnum
		}
	}
	#if os(OSX)
		return UTGetOSTypeFromString(theString)
		#else
		func Ptr2OSType(str: [CChar]) -> OSType {
			var type: OSType = 0x20202020 // four spaces. Can't really be represented the same way as in C
			var i = str.count - 1
			if i > 4 {
				i = 4
			}
			memcpy(&type, str, i)
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
extension String {
	/// The base initializer for the Pascal String types.
	/// Gets passed a CFStringEncoding because the underlying function used to generate
	/// strings uses that.
	public init?(pascalString pStr: UnsafePointer<UInt8>, encoding: CFStringEncoding, maximumLength: UInt8 = 255) {
		if pStr.memory > maximumLength {
			return nil
		}
		if let theStr = CFStringCreateWithPascalString(kCFAllocatorDefault, pStr, encoding) {
			self = theStr as String
		} else {
			return nil
		}
	}
	
	/// Converts a pointer to a Pascal string into a Swift string.
	///
	/// - parameter pStr: a pointer to the Pascal string in question. You may need to use `getArrayFromMirror` if the value is a Tuple.
	/// - parameter encoding: The encoding of the pascal stiring. The default is `NSMacOSRomanStringEncoding`.
	/// - parameter maximumLength: The maximum length of the Pascal string. The default is `255`. If the first byte is larger than this value, the constructor returns `nil`.
	///
	/// The main initializer. Converts the encoding to a CFStringEncoding for use
	/// in the base initializer.
	public init?(pascalString pStr: UnsafePointer<UInt8>, encoding: NSStringEncoding = NSMacOSRomanStringEncoding, maximumLength: UInt8 = 255) {
		let CFEncoding = CFStringConvertNSStringEncodingToEncoding(encoding)
		if CFEncoding == kCFStringEncodingInvalidId {
			return nil
		}
		self.init(pascalString: pStr, encoding: CFEncoding, maximumLength: maximumLength)
	}
}

extension OSType: StringLiteralConvertible {
	public init(stringValue toInit: String) {
		self = StringToOSType(toInit, detectHex: true)
	}
	
	public init(_ toInit: String) {
		self = StringToOSType(toInit, detectHex: true)
	}
	
	public init(unicodeScalarLiteral usl: String) {
		let tmpUnscaled = String(unicodeScalarLiteral: usl)
		self.init(stringValue: tmpUnscaled)
	}
	
	public init(extendedGraphemeClusterLiteral egcl: String) {
		let tmpUnscaled = String(extendedGraphemeClusterLiteral: egcl)
		self.init(stringValue: tmpUnscaled)
	}
	
	public init(stringLiteral toInit: String) {
		self.init(stringValue: toInit)
	}
	
	public init(_ toInit: (Int8, Int8, Int8, Int8, Int8)) {
		self = OSType((toInit.0, toInit.1, toInit.2, toInit.3))
	}
	
	/// Returns a string representation of the OSType.
	/// It may be encoded as a hexadecimal string.
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
	
	/// Returns a tuple with four values
	public func toFourChar() -> (Int8, Int8, Int8, Int8) {
		let var1 = (self >> 24) & 0xFF
		let var2 = (self >> 16) & 0xFF
		let var3 = (self >> 8) & 0xFF
		let var4 = (self) & 0xFF
		return (Int8(var1), Int8(var2), Int8(var3), Int8(var4))
	}
	
	/// Returns a tuple with five values, the last one being zero
	public func toFourChar() -> (Int8, Int8, Int8, Int8, Int8) {
		let outVar: (Int8, Int8, Int8, Int8) = toFourChar()
		return (outVar.0, outVar.1, outVar.2, outVar.3, 0)
	}
}

#if os(OSX)
extension String {
	/// HFSUniStr255 is declared internally on OS X as part of the HFS headers. iOS doesn't use any version of HFS, so it doesn't have this function.
	public init(HFSUniStr: HFSUniStr255) {
		let uniStr: [UInt16] = getArrayFromMirror(Mirror(reflecting: HFSUniStr.unicode))
		self = NSString(bytes: uniStr, length: Int(HFSUniStr.length), encoding: NSUTF16StringEncoding) as! String
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
	
	public var stringValue: String {
		return OSTypeToString(self.rawValue) ?? "    "
	}
}

public enum CarbonFolderIcons: OSType {
	case Generic = 0x666C6472
	case Drop = 0x64626F78
	case Mounted = 0x6D6E7464
	case Open = 0x6F666C64
	case Owned = 0x6F776E64
	case Private = 0x70727666
	case Shared = 0x7368666C
	
	public var stringValue: String {
		return OSTypeToString(self.rawValue) ?? "    "
	}
}
#endif
