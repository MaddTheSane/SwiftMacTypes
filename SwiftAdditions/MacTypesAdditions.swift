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
/// - parameter theType: The `OSType` to convert to a string representation.
/// - returns: A string representation of `theType`, or `nil` if it can't be converted.
public func OSTypeToString(_ theType: OSType) -> String? {
	func OSType2Ptr(type: OSType) -> [UInt8] {
		var ourOSType = [UInt8](repeating: 0, count: 4)
		var intType = type.bigEndian
		memcpy(&ourOSType, &intType, 4)
		
		return ourOSType
	}
	
	let ourOSType = OSType2Ptr(type: theType)
	for char in ourOSType[0..<4] {
		if (UInt8(0)..<0x20).contains(char) {
			return nil
		}
	}
	let ourData = Data(ourOSType)
	return String(data: ourData, encoding: .macOSRoman)
}

/// Converts an `OSType` to a `String` value. May return a hexadecimal representation.
/// - parameter theType: The `OSType` to convert to a string representation.
/// - returns: A string representation of `theType`, or the hexadecimal representation of `theType` if it can't be converted.
public func OSTypeToString(_ theType: OSType, useHexIfInvalid: ()) -> String {
	if let ourStr = OSTypeToString(theType), ourStr.count == 4 {
		return ourStr
	} else {
		return String(format: "0x%08X", theType)
	}
}

@available(swift, introduced: 2.0, deprecated: 5.0, obsoleted: 6.0, renamed: "toOSType(_:detectHex:)")
public func toOSType(string theString: String, detectHex: Bool = false) -> OSType {
	return toOSType(theString, detectHex: detectHex)
}

/// Converts a `String` value to an `OSType`, truncating to the first four characters.
///
/// If `theString` is longer than four characters, only the first four characters are used.
/// If `theString` is shorter than four characters, the missing character spots are filled in with spaces (*0x20*).
/// - parameter theString: The `String` to get the OSType value from
/// - parameter detectHex: If `true`, attempts to detect if the string is formatted as  a hexadecimal value.
/// - returns: `theString` converted to an OSType, or *0* if the string can't be represented in the Mac OS Roman string encoding.
public func toOSType(_ theString: String, detectHex: Bool = false) -> OSType {
	if detectHex && theString.count > 4 {
		let aScann = Scanner(string: theString)
		var tmpnum: UInt32 = 0
		if aScann.scanHexInt32(&tmpnum) && tmpnum != UInt32.max {
			return tmpnum
		}
	}
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
	var ourLen = theString.lengthOfBytes(using: .macOSRoman)
	if ourLen > 4 {
		ourLen = 4
	} else if ourLen == 0 {
		return 0
	}
	
	guard let aData = theString.cString(using: .macOSRoman) else {
		return 0
	}
	
	for i in 0 ..< ourLen {
		ourOSType[i] = aData[i]
	}
	
	return Ptr2OSType(str: ourOSType)
}

/// The current system encoding as a `CFStringEncoding` that is 
/// the most like a Mac Classic encoding.
///
/// Deprecated. Usage of the underlying APIs are discouraged.
/// If you really need this info, call `CFStringGetMostCompatibleMacStringEncoding`
/// with the value from `CFStringGetSystemEncoding` instead.
@available(swift, introduced: 2.0, deprecated: 5.0, message: "Usage is discouraged. Read documentation about CFStringGetSystemEncoding() for more info.")
public var currentCFMacStringEncoding: CFStringEncoding {
	let cfEnc = CFStringGetSystemEncoding()
	return CFStringGetMostCompatibleMacStringEncoding(cfEnc)
}

/// The current system encoding that is the most like a Mac Classic encoding.
///
/// Deprecated, use `String.Encoding.currentCompatibleClassic` instead
@available(swift, introduced: 2.0, deprecated: 5.0, obsoleted: 6.0, renamed: "String.Encoding.currentCompatibleClassic")
public var currentMacStringEncoding: String.Encoding {
	return String.Encoding.currentCompatibleClassic
}

public extension String.Encoding {
	/// The current encoding that is the most similar to a Mac Classic encoding.
	///
	/// Useful for the Pascal string functions.
	var mostCompatibleClassic: String.Encoding {
		let cfEnc = self.cfStringEncoding
		assert(cfEnc != kCFStringEncodingInvalidId, "encoding \(self) (\(self.rawValue)) has an unknown CFStringEncoding counterpart!")
		let mostMacLike = CFStringGetMostCompatibleMacStringEncoding(cfEnc)
		let nsMostMacLike = CFStringConvertEncodingToNSStringEncoding(mostMacLike)
		return String.Encoding(rawValue: nsMostMacLike)
	}
	
	/// The current system encoding that is the most like a Mac Classic encoding.
	static var currentCompatibleClassic: String.Encoding {
		var cfEnc = CFStringGetSystemEncoding()
		cfEnc = CFStringGetMostCompatibleMacStringEncoding(cfEnc)
		let nsEnc = CFStringConvertEncodingToNSStringEncoding(cfEnc)
		let toRet = String.Encoding(rawValue: nsEnc)
		return toRet
	}
	
	/// Converts the current encoding to the equivalent `CFStringEncoding`.
	@inlinable var cfStringEncoding: CFStringEncoding {
		return CFStringConvertNSStringEncodingToEncoding(self.rawValue)
	}
	
	/// Converts the current encoding to the equivalent `CFStringEncoding`.
	///
	/// Deprecated. Use `cfStringEncoding` instead.
	@available(swift, introduced: 2.0, deprecated: 5.0, obsoleted: 6.0, renamed: "cfStringEncoding")
	var toCFStringEncoding: CFStringEncoding {
		return cfStringEncoding
	}
}

public extension String.Encoding {
	
	private static func convertToNSStrEnc(from cfEnc: CFStringEncodings) -> UInt {
		return CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
	}
	
	static var macOSJapanese: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macJapanese))
	}
	
	static var macOSTraditionalChinese: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macChineseTrad))
	}

	static var macOSKorean: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macChineseTrad))
	}

	static var macOSArabic: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macArabic))
	}

	static var macOSHebrew: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macHebrew))
	}

	static var macOSGreek: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macGreek))
	}

	static var macOSCyrillic: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macCyrillic))
	}
	
	static var macOSDevanagari: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macDevanagari))
	}
	
	static var macOSGurmukhi: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macGurmukhi))
	}
	
	static var macOSGujarati: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macGujarati))
	}
	
	static var macOSOriya: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macOriya))
	}
	
	static var macOSBengali: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macBengali))
	}
	
	static var macOSTamil: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macTamil))
	}
	
	static var macOSTelugu: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macTelugu))
	}
	
	static var macOSKannada: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macKannada))
	}
	
	static var macOSMalayalam: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macMalayalam))
	}
	
	static var macOSSinhalese: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macSinhalese))
	}
	
	static var macOSBurmese: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macBurmese))
	}
	
	static var macOSKhmer: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macKhmer))
	}
	
	static var macOSThai: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macThai))
	}
	
	static var macOSLaotian: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macLaotian))
	}
	
	static var macOSGeorgian: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macGeorgian))
	}
	
	static var macOSArmenian: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macArmenian))
	}
	
	static var macOSSimplifiedChinese: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macChineseSimp))
	}
	
	static var macOSTibetan: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macTibetan))
	}
	
	static var macOSMongolian: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macMongolian))
	}
	
	static var macOSEthiopic: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macEthiopic))
	}
	
	static var macOSCentralEuropeRoman: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macCentralEurRoman))
	}
	
	static var macOSVietnamese: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macVietnamese))
	}
	
	static var macOSExtendedArabic: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macExtArabic))
	}
	
	/* The following use script code 0, smRoman */
	static var macOSSymbol: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macSymbol))
	}
	
	static var macOSDingbats: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macDingbats))
	}
	
	static var macOSTurkish: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macTurkish))
	}
	
	static var macOSCroatian: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macCroatian))
	}
	
	static var macOSIcelandic: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macIcelandic))
	}
	
	static var macOSRomanian: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macRomanian))
	}
	
	static var macOSCeltic: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macCeltic))
	}
	
	static var macOSGaelic: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macGaelic))
	}
	/* The following use script code 4, smArabic */
	/// Like `.macOSArabic` but uses Farsi digits
	static var macOSFarsi: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macFarsi))
	}
	/// The following use script code 7, `smCyrillic`
	static var macOSUkrainian: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macUkrainian))
	}
	/// The following use script code 32, `smUnimplemented`
	static var macOSInuit: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macInuit))
	}
	
	/// VT100/102 font from Comm Toolbox: Latin-1 repertoire + box drawing etc
	static var macOSVT100: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macVT100))
	}
	
	/// Meta-value, should never appear in a table
	static var macOSHFS: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macHFS))
	}
	
	/* Unicode & ISO UCS encodings begin at 0x100 */
	/* We don't use Unicode variations defined in TextEncoding; use the ones in CFString.h, instead. */
	
	/* ISO 8-bit and 7-bit encodings begin at 0x200 */
	/// ISO 8859-2
	static var isoLatin2: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.isoLatin2))
	}
	
	/// ISO 8859-3
	static var isoLatin3: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.isoLatin3))
	}
	
	/// ISO 8859-4
	static var isoLatin4: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.isoLatin4))
	}
	
	/// ISO 8859-5
	static var isoLatinCyrillic: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.isoLatinCyrillic))
	}
	
	/// ISO 8859-6, =ASMO 708, =DOS CP 708
	static var isoLatinArabic: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.isoLatinArabic))
	}
	
	/// ISO 8859-7
	static var isoLatinGreek: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.isoLatinGreek))
	}
	
	/// ISO 8859-8
	static var iSOLatinHebrew: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.isoLatinHebrew))
	}
	
	/// ISO 8859-9
	static var isoLatin5: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.isoLatin5))
	}
	
	/// ISO 8859-10
	static var isoLatin6: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.isoLatin6))
	}
	
	/// ISO 8859-11
	static var isoLatinThai: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.isoLatinThai))
	}
	
	/// ISO 8859-13
	static var isoLatin7: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.isoLatin7))
	}
	
	/// ISO 8859-14
	static var isoLatin8: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.isoLatin8))
	}
	
	/// ISO 8859-15
	static var isoLatin9: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.isoLatin9))
	}
	
	/// ISO 8859-16
	static var isoLatin10: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.isoLatin10))
	}
	
	/* MS-DOS & Windows encodings begin at 0x400 */
	/// code page 437
	static var dosLatinUS: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.dosLatinUS))
	}
	/// code page 737 (formerly code page 437G)
	static var dosGreek: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.dosGreek))
	}
	/// code page 775
	static var dosBalticRim: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.dosBalticRim))
	}
	/// code page 850, "Multilingual"
	static var dosLatin1: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.dosLatin1))
	}
	/// code page 851
	static var dosGreek1: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.dosGreek1))
	}
	/// code page 852, Slavic
	static var dosLatin2: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.dosLatin2))
	}
	/// code page 855, IBM Cyrillic
	static var dosCyrillic: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.dosCyrillic))
	}
	/// code page 857, IBM Turkish
	static var dosTurkish: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.dosTurkish))
	}
	/// code page 860
	static var dosPortuguese: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.dosPortuguese))
	}
	/// code page 861
	static var dosIcelandic: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.dosIcelandic))
	}
	/// code page 862
	static var dosHebrew: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.dosHebrew))
	}
	/// code page 863
	static var dosCanadianFrench: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.dosCanadianFrench))
	}
	/// code page 864
	static var dosArabic: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.dosArabic))
	}
	/// code page 865
	static var dosNordic: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.dosNordic))
	}
	/// code page 866
	static var dosRussian: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.dosRussian))
	}
	/// code page 869, IBM Modern Greek
	static var dosGreek2: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.dosGreek2))
	}
	/// code page 874, also for Windows
	static var dosThai: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.dosThai))
	}
	/// code page 932, also for Windows
	static var dosJapanese: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.dosJapanese))
	}
	/// code page 936, also for Windows
	static var dosSimplifiedChinese: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.dosChineseSimplif))
	}
	/// code page 949, also for Windows; Unified Hangul Code
	static var dosKorean: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.dosKorean))
	}
	/// code page 950, also for Windows
	static var dosTraditionalChinese: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.dosChineseTrad))
	}
	/// code page 1250, Central Europe
	static var windowsLatin2: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.windowsLatin2))
	}
	/// code page 1251, Slavic Cyrillic
	static var windowsCyrillic: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.windowsCyrillic))
	}
	/// code page 1253
	static var windowsGreek: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.windowsGreek))
	}
	/// code page 1254, Turkish
	static var windowsLatin5: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.windowsLatin5))
	}
	/// code page 1255
	static var windowsHebrew: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.windowsHebrew))
	}
	/// code page 1256
	static var windowsArabic: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.windowsArabic))
	}
	/// code page 1257
	static var windowsBalticRim: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.windowsBalticRim))
	}
	/// code page 1258
	static var windowsVietnamese: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.windowsVietnamese))
	}
	/// code page 1361, for Windows NT
	static var windowsKoreanJohab: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.windowsKoreanJohab))
	}
	
	/* Various national standards begin at 0x600 */
	/// ANSEL (ANSI Z39.47)
	static var ANSEL: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.ANSEL))
	}
	static var JIS_X0201_76: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.JIS_X0201_76))
	}
	static var JIS_X0208_83: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.JIS_X0208_83))
	}
	static var JIS_X0208_90: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.JIS_X0208_90))
	}
	static var JIS_X0212_90: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.JIS_X0212_90))
	}
	static var JIS_C6226_78: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.JIS_C6226_78))
	}
	
	/// Shift-JIS format encoding of JIS X0213 planes 1 and 2
	static var shiftJIS_X0213: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.shiftJIS_X0213))
	}
	
	/// JIS X0213 in plane-row-column notation
	static var shiftJIS_X0213_MenKuTen: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.shiftJIS_X0213_MenKuTen))
	}
	
	static var GB_2312_80: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.GB_2312_80))
	}
	
	/// annex to GB 13000-93; for Windows 95
	static var GBK_95: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.GBK_95))
	}
	
	
	static var gB_18030_2000: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.GB_18030_2000))
	}
	
	/// same as KSC 5601-92 without Johab annex
	static var kSC_5601_87: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.KSC_5601_87))
	}
	
	/// KSC 5601-92 Johab annex
	static var kSC_5601_92_Johab: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.ksc_5601_92_Johab))
	}
	
	/// CNS 11643-1992 plane 1
	static var CNS_11643_92_P1: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.CNS_11643_92_P1))
	}
	
	/// CNS 11643-1992 plane 2
	static var CNS_11643_92_P2: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.CNS_11643_92_P2))
	}
	
	/// CNS 11643-1992 plane 3 (was plane 14 in 1986 version)
	static var CNS_11643_92_P3: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.CNS_11643_92_P3))
	}

	/* ISO 2022 collections begin at 0x800 */
	static var ISO_2022_JP: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.ISO_2022_JP))
	}
	
	static var ISO_2022_JP_2: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.ISO_2022_JP_2))
	}
	
	/// RFC 2237
	static var ISO_2022_JP_1: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.ISO_2022_JP_1))
	}
	
	/// JIS X0213
	static var ISO_2022_JP_3: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.ISO_2022_JP_3))
	}
	static var ISO_2022_CN: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.ISO_2022_CN))
	}
	
	static var ISO_2022_CN_EXT: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.ISO_2022_CN_EXT))
	}
	
	static var ISO_2022_KR: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.ISO_2022_KR))
	}

			/* EUC collections begin at 0x900 */
	/// ISO 646, 1-byte katakana, JIS 208, JIS 212
	static var EUC_JP: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.EUC_JP))
	}
	
	/// ISO 646, GB 2312-80
	static var EUC_CN: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.EUC_CN))
	}
	
	/// ISO 646, CNS 11643-1992 Planes 1-16
	static var EUC_TW: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.EUC_TW))
	}
	
	/// ISO 646, KS C 5601-1987
	static var eUC_KR: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.EUC_KR))
	}

			/* Misc standards begin at 0xA00 */
	/// plain Shift-JIS
	static var shiftJIS: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.shiftJIS))
	}
	
	/// Russian internet standard
	static var KOI8_R: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.KOI8_R))
	}
	
	/// Big-5 (has variants)
	static var big5: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.big5))
	}
	
	/// Mac OS Roman permuted to align with ISO Latin-1
	static var macOSRomanLatin1: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.macRomanLatin1))
	}
	
	/// HZ (RFC 1842, for Chinese mail & news)
	static var HZ_GB_2312: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.HZ_GB_2312))
	}
	
	/// Big-5 with Hong Kong special char set supplement
	static var big5_HKSCS_1999: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.big5_HKSCS_1999))
	}
	
	/// RFC 1456, Vietnamese
	static var VISCII: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.VISCII))
	}
	
	/// RFC 2319, Ukrainian
	static var KOI8_U: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.KOI8_U))
	}
	
	/// Taiwan Big-5E standard
	static var big5_E: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.big5_E))
	}
	
	/* Other platform encodings*/
	/// NextStep Japanese encoding
	static var nextStepJapanese: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.nextStepJapanese))
	}
	
	/* EBCDIC & IBM host encodings begin at 0xC00 */
	/// basic EBCDIC-US
	static var EBCDIC_US: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.EBCDIC_US))
	}
	
	/// code page 037, extended EBCDIC (Latin-1 set) for US,Canada...
	static var EBCDIC_CP037: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.EBCDIC_CP037))
	}
	
	/// `kTextEncodingUnicodeDefault` + `kUnicodeUTF7Format` RFC2152
	static var UTF7: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.UTF7))
	}
	
	/// UTF-7 (IMAP folder variant) RFC3501
	static var UTF7_IMAP: String.Encoding {
		return String.Encoding(rawValue: convertToNSStrEnc(from: CFStringEncodings.UTF7_IMAP))
	}
}

/// Pascal String extensions
public extension String {
	/// A pascal string that is 256 bytes long, containing at least 255 characters.
	typealias PStr255 = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
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
	typealias PStr63 = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
	/// A pascal string that is 33 bytes long, containing at least 32 characters.
	typealias PStr32 = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
	/// A pascal string that is 32 bytes long, containing at least 31 characters.
	typealias PStr31 = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8)
	/// A pascal string that is 28 bytes long, containing at least 27 characters.
	typealias PStr27 = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8)
	/// A pascal string that is 16 bytes long, containing at least 15 characters.
	typealias PStr15 = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
	/// A pascal string that is 34 bytes long, containing at least 32 characters.
	///
	/// The last byte is unused as it was used for padding over a network.
	typealias PStr32Field = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
	
	/// The base initializer for the Pascal String types.
	///
	/// Gets passed a `CFStringEncoding` because the underlying function used to generate
	/// the string uses that.
	/// - parameter pStr: a pointer to the Pascal string in question. You may need
	/// to use `arrayFromObject(reflecting:)` if the value is a tuple.
	/// - parameter encoding: The encoding of the Pascal string, as a
	/// `CFStringEncoding`.
	/// - parameter maximumLength: The maximum length of the Pascal string.
	/// If the first byte contains a value higher than this, the constructor returns
	/// `nil`. The default is *255*, the largest value a *UInt8* can hold.
	init?(pascalString pStr: UnsafePointer<UInt8>, encoding: CFStringEncoding, maximumLength: UInt8 = 255) {
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
	/// - parameter pStr: a pointer to the Pascal string in question. You may need 
	/// to use `arrayFromObject(reflecting:)` if the value is a tuple.
	/// - parameter encoding: The encoding of the Pascal string.
	/// The default is `String.Encoding.macOSRoman`.
	/// - parameter maximumLength: The maximum length of the Pascal string. 
	/// If the first byte contains a value higher than this, the constructor returns
	/// `nil`. The default is *255*, the largest value a *UInt8* can hold.
	///
	/// The main initializer. Converts the encoding to a `CFStringEncoding` for use
	/// in the base initializer.
	init?(pascalString pStr: UnsafePointer<UInt8>, encoding: String.Encoding = .macOSRoman, maximumLength: UInt8 = 255) {
		let CFEncoding = encoding.cfStringEncoding
		guard CFEncoding != kCFStringEncodingInvalidId else {
			return nil
		}
		self.init(pascalString: pStr, encoding: CFEncoding, maximumLength: maximumLength)
	}
	
	/// Converts a tuple of a Pascal string into a Swift string.
	///
	/// - parameter pStr: a tuple of the Pascal string in question.
	/// - parameter encoding: The encoding of the Pascal string.
	/// The default is `String.Encoding.macOSRoman`.
	init?(pascalString pStr: PStr255, encoding: String.Encoding = .macOSRoman) {
		let unwrapped: [UInt8] = try! arrayFromObject(reflecting: pStr)
		// a UInt8 can't reference any number greater than 255,
		// so we just pass it to the main initializer
		self.init(pascalString: unwrapped, encoding: encoding)
	}
	
	/// Converts a tuple of a Pascal string into a Swift string.
	///
	/// - parameter pStr: a tuple of the Pascal string in question.
	/// - parameter encoding: The encoding of the Pascal string.
	/// The default is `String.Encoding.macOSRoman`.
	init?(pascalString pStr: PStr63, encoding: String.Encoding = .macOSRoman) {
		let unwrapped: [UInt8] = try! arrayFromObject(reflecting: pStr)
		
		self.init(pascalString: unwrapped, encoding: encoding, maximumLength: 63)
	}
	
	/// Converts a tuple of a Pascal string into a Swift string.
	///
	/// - parameter pStr: a tuple of the Pascal string in question.
	/// - parameter encoding: The encoding of the Pascal string.
	/// The default is `String.Encoding.macOSRoman`.
	init?(pascalString pStr: PStr32, encoding: String.Encoding = .macOSRoman) {
		let unwrapped: [UInt8] = try! arrayFromObject(reflecting: pStr)
		
		self.init(pascalString: unwrapped, encoding: encoding, maximumLength: 32)
	}
	
	/// Converts a tuple of a Pascal string into a Swift string.
	///
	/// - parameter pStr: a tuple of the Pascal string in question.
	/// - parameter encoding: The encoding of the Pascal string.
	/// The default is `String.Encoding.macOSRoman`.
	init?(pascalString pStr: PStr31, encoding: String.Encoding = .macOSRoman) {
		let unwrapped: [UInt8] = try! arrayFromObject(reflecting: pStr)
		
		self.init(pascalString: unwrapped, encoding: encoding, maximumLength: 31)
	}
	
	/// Converts a tuple of a Pascal string into a Swift string.
	///
	/// - parameter pStr: a tuple of the Pascal string in question.
	/// - parameter encoding: The encoding of the Pascal string.
	/// The default is `String.Encoding.macOSRoman`.
	init?(pascalString pStr: PStr27, encoding: String.Encoding = .macOSRoman) {
		let unwrapped: [UInt8] = try! arrayFromObject(reflecting: pStr)
		
		self.init(pascalString: unwrapped, encoding: encoding, maximumLength: 27)
	}
	
	/// Converts a tuple of a Pascal string into a Swift string.
	///
	/// - parameter pStr: a tuple of the Pascal string in question.
	/// - parameter encoding: The encoding of the Pascal string.
	/// The default is `String.Encoding.macOSRoman`.
	init?(pascalString pStr: PStr15, encoding: String.Encoding = .macOSRoman) {
		let unwrapped: [UInt8] = try! arrayFromObject(reflecting: pStr)
		
		self.init(pascalString: unwrapped, encoding: encoding, maximumLength: 15)
	}
	
	/// Converts a tuple of a Pascal string into a Swift string.
	///
	/// - parameter pStr: a tuple of the Pascal string in question.
	/// - parameter encoding: The encoding of the Pascal string.
	/// The default is `String.Encoding.macOSRoman`.
	///
	/// The last byte in a `Str32Field` is unused,
	/// so the last byte isn't read.
	init?(pascalString pStr: PStr32Field, encoding: String.Encoding = .macOSRoman) {
		let unwrapped: [UInt8] = try! arrayFromObject(reflecting: pStr)
		
		self.init(pascalString: unwrapped, encoding: encoding, maximumLength: 32)
	}
	
	/// Convenience initializer, passing a `PStr255` (or a tuple with *256* `UInt8`s)
	@available(swift, introduced: 2.0, deprecated: 5.0, obsoleted: 6.0)
	init?(_ pStr: PStr255) {
		self.init(pascalString: pStr)
	}
	
	/// Convenience initializer, passing a `PStr63` (or a tuple with 64 `UInt8`s)
	@available(swift, introduced: 2.0, deprecated: 5.0, obsoleted: 6.0)
	init?(_ pStr: PStr63) {
		self.init(pascalString: pStr)
	}
	
	/// Convenience initializer, passing a `PStr32` (or a tuple with 33 `UInt8`s)
	@available(swift, introduced: 2.0, deprecated: 5.0, obsoleted: 6.0)
	init?(_ pStr: PStr32) {
		self.init(pascalString: pStr)
	}
	
	/// Convenience initializer, passing a `PStr31` (or a tuple with 32 `UInt8`s)
	@available(swift, introduced: 2.0, deprecated: 5.0, obsoleted: 6.0)
	init?(_ pStr: PStr31) {
		self.init(pascalString: pStr)
	}
	
	/// Convenience initializer, passing a `PStr27` (or a tuple with 28 `UInt8`s)
	@available(swift, introduced: 2.0, deprecated: 5.0, obsoleted: 6.0)
	init?(_ pStr: PStr27) {
		self.init(pascalString: pStr)
	}
	
	/// Convenience initializer, passing a `PStr15` (or a tuple with 16 `UInt8`s)
	@available(swift, introduced: 2.0, deprecated: 5.0, obsoleted: 6.0)
	init?(_ pStr: PStr15) {
		self.init(pascalString: pStr)
	}
	
	/// Convenience initializer, passing a `PStr32Field` (or a tuple with 34 `UInt8`s, with the last byte ignored)
	@available(swift, introduced: 2.0, deprecated: 5.0, obsoleted: 6.0)
	init?(_ pStr: PStr32Field) {
		self.init(pascalString: pStr)
	}
}

public extension OSType {
	/// Encodes the passed `String` value to an `OSType`.
	///
	/// The string value may be formatted as a hexadecimal string.
	/// Only the first four characters are read.
	/// The string's characters must be present in the Mac Roman string encoding.
	init(stringValue toInit: String) {
		self = toOSType(toInit, detectHex: true)
	}
	
	/// Encodes the passed string literal value to an `OSType`.
	///
	/// The string value may be formatted as a hexadecimal string.
	/// Only the first four characters are read.
	/// The strings' characters must be present in the Mac Roman string encoding.
	init(stringLiteral toInit: String) {
		self.init(stringValue: toInit)
	}
	
	/// Creates an `OSType` from a tuple with five characters, ignoring the fifth.
	init(_ toInit: (Int8, Int8, Int8, Int8, Int8)) {
		self.init((toInit.0, toInit.1, toInit.2, toInit.3))
	}
	
	/// Returns a string representation of this OSType.
	/// It may be encoded as a hexadecimal string.
	var stringValue: String {
		return OSTypeToString(self, useHexIfInvalid: ())
	}
	
	/// Creates an `OSType` from a tuple with four characters.
	init(_ toInit: (Int8, Int8, Int8, Int8)) {
		let val0 = OSType(UInt8(bitPattern: toInit.0))
		let val1 = OSType(UInt8(bitPattern: toInit.1))
		let val2 = OSType(UInt8(bitPattern: toInit.2))
		let val3 = OSType(UInt8(bitPattern: toInit.3))
		self.init((val0 << 24) | (val1 << 16) | (val2 << 8) | (val3))
	}
	
	/// Returns a tuple with four values.
	func toFourChar() -> (Int8, Int8, Int8, Int8) {
		let var1 = UInt8((self >> 24) & 0xFF)
		let var2 = UInt8((self >> 16) & 0xFF)
		let var3 = UInt8((self >> 8) & 0xFF)
		let var4 = UInt8((self) & 0xFF)
		return (Int8(bitPattern: var1), Int8(bitPattern: var2), Int8(bitPattern: var3), Int8(bitPattern: var4))
	}
	
	/// Returns a tuple with five values, the last one being zero for null-termination.
	func toFourChar() -> (Int8, Int8, Int8, Int8, Int8) {
		let outVar: (Int8, Int8, Int8, Int8) = toFourChar()
		return (outVar.0, outVar.1, outVar.2, outVar.3, 0)
	}
}

#if os(OSX)
extension String {
	// HFSUniStr255 is declared internally on OS X as part of the HFS headers. iOS doesn't have this struct public.
	public init?(HFSUniStr: HFSUniStr255) {
		guard HFSUniStr.length < 256 else {
			return nil
		}
		let uniChars: [UInt16] = try! arrayFromObject(reflecting: HFSUniStr.unicode)
		var uniStr = Array(uniChars[0 ..< Int(HFSUniStr.length)])
		uniStr.append(0) // add null termination
		guard let toRet = String.decodeCString(uniStr, as: UTF16.self, repairingInvalidCodeUnits: false) else {
			return nil
		}
		self = toRet.result
	}
}

public enum CarbonToolbarIcons: OSType, OSTypeConvertable {
	case customize = 0x74637573
	case delete = 0x7464656C
	case favorite = 0x74666176
	case home = 0x74686F6D
	case advanced = 0x74626176
	case info = 0x7462696E
	case labels = 0x74626C62
	case applicationFolder = 0x74417073
	case documentsFolder = 0x74446F63
	case moviesFolder = 0x744D6F76
	case musicFolder = 0x744D7573
	case picturesFolder = 0x74506963
	case publicFolder = 0x74507562
	case desktopFolder = 0x7444736B
	case downloadsFolder = 0x7444776E
	case libraryFolder = 0x744C6962
	case utilitiesFolder = 0x7455746C
	case sitesFolder = 0x74537473

	public var iconRepresentation: NSImage {
		return NSWorkspace.shared.icon(forFileType: NSFileTypeForHFSTypeCode(rawValue))
	}
}

public enum CarbonFolderIcons: OSType, OSTypeConvertable {
	case generic = 0x666C6472
	case drop = 0x64626F78
	case mounted = 0x6D6E7464
	case open = 0x6F666C64
	case owned = 0x6F776E64
	case `private` = 0x70727666
	case shared = 0x7368666C
	
	public var iconRepresentation: NSImage {
		return NSWorkspace.shared.icon(forFileType: NSFileTypeForHFSTypeCode(rawValue))
	}
}

#endif
