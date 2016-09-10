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
import AppKit.NSWorkspace
import AppKit.NSImage
#endif
import CoreGraphics


/// Converts an `OSType` to a `String` value. May return `nil`.
public func OSTypeToString(_ theType: OSType) -> String? {
	#if os(OSX)
		let anUnmanaged = UTCreateStringForOSType(theType) as Unmanaged<CFString>?
		return anUnmanaged?.takeRetainedValue() as String?
	#else
		func OSType2Ptr(type: OSType) -> [CChar] {
			var ourOSType = [Int8](repeating: 0, count: 5)
			var intType = type.bigEndian
			memcpy(&ourOSType, &intType, 4)
			
			return ourOSType
		}
		
		let ourOSType = OSType2Ptr(type: theType)
		return NSString(bytes: ourOSType, length: 4, encoding: String.Encoding.macOSRoman.rawValue) as String?
	#endif
}

/// Converts an `OSType` to a `String` value. May return a hexadecimal string.
public func OSTypeToString(_ theType: OSType, useHexIfInvalid: ()) -> String {
	if let ourStr = OSTypeToString(theType) {
		return ourStr
	} else {
		return String(format: "0x%08X", theType)
	}
}

/// Converts a `String` value to an `OSType`, truncating to the first four characters.
public func toOSType(string theString: String, detectHex: Bool = false) -> OSType {
	if detectHex && theString.characters.count > 4 {
		let aScann = Scanner(string: theString)
		var tmpnum: UInt32 = 0
		if aScann.scanHexInt32(&tmpnum) && tmpnum != UInt32.max {
			return tmpnum
		}
	}
	#if os(OSX)
		return UTGetOSTypeFromString(theString as NSString)
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
		var ourOSType = [Int8](repeating: 0, count: 5)
		var ourLen = theString.lengthOfBytes(using: String.Encoding.macOSRoman)
		if ourLen > 4 {
			ourLen = 4
		} else if ourLen == 0 {
			return 0
		}
		
		let aData = theString.cString(using: String.Encoding.macOSRoman)!
		
		for i in 0 ..< ourLen {
			ourOSType[i] = aData[i]
		}
		
		return Ptr2OSType(str: ourOSType)
	#endif
}

public var currentCFMacStringEncoding: CFStringEncoding {
	return CFStringGetMostCompatibleMacStringEncoding(CFStringGetSystemEncoding())
}

/// The current system encoding that is the most like a Mac Classic encoding
public var currentMacStringEncoding: String.Encoding {
	return String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(currentCFMacStringEncoding))
}

/// Pascal String extensions
extension String {
	/// A pascal string that is 256 bytes long, containing at least 255 characters.
	public typealias PStr255 = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
	/// A pascal string that is 64 bytes long, containing at least 63 characters.
	public typealias PStr63 = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
	/// A pascal string that is 33 bytes long, containing at least 32 characters.
	public typealias PStr32 = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
	/// A pascal string that is 32 bytes long, containing at least 31 characters.
	public typealias PStr31 = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8)
	/// A pascal string that is 28 bytes long, containing at least 27 characters.
	public typealias PStr27 = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8)
	/// A pascal string that is 16 bytes long, containing at least 15 characters.
	public typealias PStr15 = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
	/// A pascal string that is 34 bytes long, containing at least 32 characters.
	///
	/// The last byte is unused as it was used for padding over a network.
	public typealias PStr32Field = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
	
	/// The base initializer for the Pascal String types.
	/// Gets passed a `CFStringEncoding` because the underlying function used to generate
	/// the string uses that.
	private init?(pascalString pStr: UnsafePointer<UInt8>, encoding: CFStringEncoding, maximumLength: UInt8 = 255) {
		if pStr.pointee > maximumLength {
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
	/// - parameter pStr: a pointer to the Pascal string in question. You may need to use `getArrayFromMirror` or `arrayFromObject` if the value is a Tuple.
	/// - parameter encoding: The encoding of the pascal stiring. The default is `NSMacOSRomanStringEncoding`.
	/// - parameter maximumLength: The maximum length of the Pascal string. The default is `255`. If the first byte is larger than this value, the constructor returns `nil`.
	///
	/// The main initializer. Converts the encoding to a `CFStringEncoding` for use
	/// in the base initializer.
	public init?(pascalString pStr: UnsafePointer<UInt8>, encoding: String.Encoding = String.Encoding.macOSRoman, maximumLength: UInt8 = 255) {
		let CFEncoding = CFStringConvertNSStringEncodingToEncoding(encoding.rawValue)
		if CFEncoding == kCFStringEncodingInvalidId {
			return nil
		}
		self.init(pascalString: pStr, encoding: CFEncoding, maximumLength: maximumLength)
	}
	
	/// Converts a tuple of a Pascal string into a Swift string.
	///
	/// - parameter pStr: a tuple of the Pascal string in question.
	/// - parameter encoding: The encoding of the pascal stiring. The default is `NSMacOSRomanStringEncoding`.
	public init?(pascalString pStr: PStr255, encoding: String.Encoding = String.Encoding.macOSRoman) {
		let unwrapped: [UInt8] = try! arrayFromObject(reflecting: pStr)
		// a UInt8 can't reference any number greater than 255,
		// so we just pass it to the main initializer
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	/// Converts a tuple of a Pascal string into a Swift string.
	///
	/// - parameter pStr: a tuple of the Pascal string in question.
	/// - parameter encoding: The encoding of the pascal stiring. The default is `NSMacOSRomanStringEncoding`.
	public init?(pascalString pStr: PStr63, encoding: String.Encoding = String.Encoding.macOSRoman) {
		let unwrapped: [UInt8] = try! arrayFromObject(reflecting: pStr)
		if unwrapped[0] > 63 {
			return nil
		}
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	/// Converts a tuple of a Pascal string into a Swift string.
	///
	/// - parameter pStr: a tuple of the Pascal string in question.
	/// - parameter encoding: The encoding of the pascal stiring. The default is `NSMacOSRomanStringEncoding`.
	public init?(pascalString pStr: PStr32, encoding: String.Encoding = String.Encoding.macOSRoman) {
		let unwrapped: [UInt8] = try! arrayFromObject(reflecting: pStr)
		if unwrapped[0] > 32 {
			return nil
		}
		
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	/// Converts a tuple of a Pascal string into a Swift string.
	///
	/// - parameter pStr: a tuple of the Pascal string in question.
	/// - parameter encoding: The encoding of the pascal stiring. The default is `NSMacOSRomanStringEncoding`.
	public init?(pascalString pStr: PStr31, encoding: String.Encoding = String.Encoding.macOSRoman) {
		let unwrapped: [UInt8] = try! arrayFromObject(reflecting: pStr)
		if unwrapped[0] > 31 {
			return nil
		}
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	/// Converts a tuple of a Pascal string into a Swift string.
	///
	/// - parameter pStr: a tuple of the Pascal string in question.
	/// - parameter encoding: The encoding of the pascal stiring. The default is `NSMacOSRomanStringEncoding`.
	public init?(pascalString pStr: PStr27, encoding: String.Encoding = String.Encoding.macOSRoman) {
		let unwrapped: [UInt8] = try! arrayFromObject(reflecting: pStr)
		if unwrapped[0] > 27 {
			return nil
		}
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	/// Converts a tuple of a Pascal string into a Swift string.
	///
	/// - parameter pStr: a tuple of the Pascal string in question.
	/// - parameter encoding: The encoding of the pascal stiring. The default is `NSMacOSRomanStringEncoding`.
	public init?(pascalString pStr: PStr15, encoding: String.Encoding = String.Encoding.macOSRoman) {
		let unwrapped: [UInt8] = try! arrayFromObject(reflecting: pStr)
		if unwrapped[0] > 15 {
			return nil
		}
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	/// Converts a tuple of a Pascal string into a Swift string.
	///
	/// - parameter pStr: a tuple of the Pascal string in question.
	/// - parameter encoding: The encoding of the pascal stiring. The default is `NSMacOSRomanStringEncoding`.
	///
	/// The last byte in a `Str32Field` is unused,
	/// so the last byte isn't read.
	public init?(pascalString pStr: PStr32Field, encoding: String.Encoding = String.Encoding.macOSRoman) {
		let unwrapped: [UInt8] = try! arrayFromObject(reflecting: pStr)
		if unwrapped[0] > 32 {
			return nil
		}
		
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	/// Convenience initializer, passing a `PStr255` (or a tuple with *256* `UInt8`s)
	public init?(_ pStr: PStr255) {
		self.init(pascalString: pStr)
	}
	
	/// Convenience initializer, passing a `PStr63` (or a tuple with 64 `UInt8`s)
	public init?(_ pStr: PStr63) {
		self.init(pascalString: pStr)
	}
	
	/// Convenience initializer, passing a `PStr32` (or a tuple with 33 `UInt8`s)
	public init?(_ pStr: PStr32) {
		self.init(pascalString: pStr)
	}
	
	/// Convenience initializer, passing a `PStr31` (or a tuple with 32 `UInt8`s)
	public init?(_ pStr: PStr31) {
		self.init(pascalString: pStr)
	}
	
	/// Convenience initializer, passing a `PStr27` (or a tuple with 28 `UInt8`s)
	public init?(_ pStr: PStr27) {
		self.init(pascalString: pStr)
	}
	
	/// Convenience initializer, passing a `PStr15` (or a tuple with 16 `UInt8`s)
	public init?(_ pStr: PStr15) {
		self.init(pascalString: pStr)
	}
	
	/// Convenience initializer, passing a `PStr32Field` (or a tuple with 34 `UInt8`s, with the last byte ignored)
	public init?(_ pStr: PStr32Field) {
		self.init(pascalString: pStr)
	}
}

extension OSType: ExpressibleByStringLiteral {
	/// Encodes the passed `String` value to an `OSType`.
	/// The string value may be formatted as a hexadecimal string.
	/// Only the first four characters are read.
	/// The strings' characters must be present in the Mac Roman string encoding.
	public init(stringValue toInit: String) {
		self = toOSType(string: toInit, detectHex: true)
	}
	
	public init(unicodeScalarLiteral usl: String) {
		let tmpUnscaled = String(unicodeScalarLiteral: usl)
		self.init(stringValue: tmpUnscaled)
	}
	
	public init(extendedGraphemeClusterLiteral egcl: String) {
		let tmpUnscaled = String(extendedGraphemeClusterLiteral: egcl)
		self.init(stringValue: tmpUnscaled)
	}
	
	/// Encodes the passed string literal value to an `OSType`.
	/// The string value may be formatted as a hexadecimal string.
	/// Only the first four characters are read.
	/// The strings' characters must be present in the Mac Roman string encoding.
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
	
	/// Returns a tuple with four values.
	public func toFourChar() -> (Int8, Int8, Int8, Int8) {
		let var1 = (self >> 24) & 0xFF
		let var2 = (self >> 16) & 0xFF
		let var3 = (self >> 8) & 0xFF
		let var4 = (self) & 0xFF
		return (Int8(var1), Int8(var2), Int8(var3), Int8(var4))
	}
	
	/// Returns a tuple with five values, the last one being zero for null-termination.
	public func toFourChar() -> (Int8, Int8, Int8, Int8, Int8) {
		let outVar: (Int8, Int8, Int8, Int8) = toFourChar()
		return (outVar.0, outVar.1, outVar.2, outVar.3, 0)
	}
}

#if os(OSX)
extension String {
	/// HFSUniStr255 is declared internally on OS X as part of the HFS headers. iOS doesn't have this struct public.
	public init?(HFSUniStr: HFSUniStr255) {
		let uniChars: [UInt16] = try! arrayFromObject(reflecting: HFSUniStr.unicode)
		var uniStr = Array(uniChars[0 ..< Int(HFSUniStr.length)])
		uniStr.append(0) // add null termination
		guard let toRet = String.decodeCString(uniStr, as: UTF16.self, repairingInvalidCodeUnits: false) else {
			return nil
		}
		self = toRet.result
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
		return OSTypeToString(rawValue) ?? "    "
	}
	
	public var iconRepresentation: NSImage {
		return NSWorkspace.shared().icon(forFileType: NSFileTypeForHFSTypeCode(rawValue))
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
		return OSTypeToString(rawValue) ?? "    "
	}
	
	public var iconRepresentation: NSImage {
		return NSWorkspace.shared().icon(forFileType: NSFileTypeForHFSTypeCode(rawValue))
	}
}
#endif
