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
import FoundationAdditions


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
		var tmpnum: UInt64 = 0
		if aScann.scanHexInt64(&tmpnum) && tmpnum != UInt64.max {
			return OSType(tmpnum)
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
	
	private static func convertToStrEnc(from cfEnc: CFStringEncodings) -> String.Encoding {
		let val = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
		return String.Encoding(rawValue: val)
	}
	
	static let macOSJapanese = convertToStrEnc(from: .macJapanese)
	
	static let macOSTraditionalChinese = convertToStrEnc(from: .macChineseTrad)
	
	static let macOSKorean = convertToStrEnc(from: .macKorean)

	static let macOSArabic = convertToStrEnc(from: .macArabic)

	static let macOSHebrew = convertToStrEnc(from: .macHebrew)

	static let macOSGreek = convertToStrEnc(from: .macGreek)

	static let macOSCyrillic = convertToStrEnc(from: .macCyrillic)
	
	static let macOSDevanagari = convertToStrEnc(from: .macDevanagari)
	
	static let macOSGurmukhi = convertToStrEnc(from: .macGurmukhi)
	
	static let macOSGujarati = convertToStrEnc(from: .macGujarati)
	
	static let macOSOriya = convertToStrEnc(from: .macOriya)
	
	static let macOSBengali = convertToStrEnc(from: .macBengali)
	
	static let macOSTamil = convertToStrEnc(from: .macTamil)
	
	static let macOSTelugu = convertToStrEnc(from: .macTelugu)
	
	static let macOSKannada = convertToStrEnc(from: .macKannada)
	
	static let macOSMalayalam = convertToStrEnc(from: .macMalayalam)
	
	static let macOSSinhalese = convertToStrEnc(from: .macSinhalese)
	
	static let macOSBurmese = convertToStrEnc(from: .macBurmese)
	
	static let macOSKhmer = convertToStrEnc(from: .macKhmer)
	
	static let macOSThai = convertToStrEnc(from: .macThai)
	
	static let macOSLaotian = convertToStrEnc(from: .macLaotian)
	
	static let macOSGeorgian = convertToStrEnc(from: .macGeorgian)
	
	static let macOSArmenian = convertToStrEnc(from: .macArmenian)
	
	static let macOSSimplifiedChinese = convertToStrEnc(from: .macChineseSimp)
	
	static let macOSTibetan = convertToStrEnc(from: .macTibetan)
	
	static let macOSMongolian = convertToStrEnc(from: .macMongolian)
	
	static let macOSEthiopic = convertToStrEnc(from: .macEthiopic)
	
	static let macOSCentralEuropeRoman = convertToStrEnc(from: .macCentralEurRoman)
	
	static let macOSVietnamese = convertToStrEnc(from: .macVietnamese)
	
	static let macOSExtendedArabic = convertToStrEnc(from: .macExtArabic)
	
	/* The following use script code 0, smRoman */
	static let macOSSymbol = convertToStrEnc(from: .macSymbol)
	
	static let macOSDingbats = convertToStrEnc(from: .macDingbats)
	
	static let macOSTurkish = convertToStrEnc(from: .macTurkish)
	
	static let macOSCroatian = convertToStrEnc(from: .macCroatian)
	
	static let macOSIcelandic = convertToStrEnc(from: .macIcelandic)
	
	static let macOSRomanian = convertToStrEnc(from: .macRomanian)
	
	static let macOSCeltic = convertToStrEnc(from: .macCeltic)
	
	static let macOSGaelic = convertToStrEnc(from: .macGaelic)
	/* The following use script code 4, smArabic */
	/// Like `.macOSArabic` but uses Farsi digits.
	static let macOSFarsi = convertToStrEnc(from: .macFarsi)
	/// The following use script code 7, `smCyrillic`.
	static let macOSUkrainian = convertToStrEnc(from: .macUkrainian)
	/// The following use script code 32, `smUnimplemented`.
	static let macOSInuit = convertToStrEnc(from: .macInuit)
	
	/// VT100/102 font from Comm Toolbox: Latin-1 repertoire + box drawing etc.
	static let macOSVT100 = convertToStrEnc(from: .macVT100)
	
	/// Meta-value, should never appear in a table.
	static let macOSHFS = convertToStrEnc(from: .macHFS)
	
	/* ISO 8-bit and 7-bit encodings begin at 0x200 */
	/// ISO 8859-2.
	static let isoLatin2 = convertToStrEnc(from: .isoLatin2)
	
	/// ISO 8859-3.
	static let isoLatin3 = convertToStrEnc(from: .isoLatin3)
	
	/// ISO 8859-4.
	static let isoLatin4 = convertToStrEnc(from: .isoLatin4)
	
	/// ISO 8859-5.
	static let isoLatinCyrillic = convertToStrEnc(from: .isoLatinCyrillic)
	
	/// ISO 8859-6, =ASMO 708, =DOS CP 708.
	static let isoLatinArabic = convertToStrEnc(from: .isoLatinArabic)
	
	/// ISO 8859-7.
	static let isoLatinGreek = convertToStrEnc(from: .isoLatinGreek)
	
	/// ISO 8859-8.
	static let isoLatinHebrew = convertToStrEnc(from: .isoLatinHebrew)
	
	/// ISO 8859-9.
	static let isoLatin5 = convertToStrEnc(from: .isoLatin5)
	
	/// ISO 8859-10.
	static let isoLatin6 = convertToStrEnc(from: .isoLatin6)
	
	/// ISO 8859-11.
	static let isoLatinThai = convertToStrEnc(from: .isoLatinThai)
	
	/// ISO 8859-13.
	static let isoLatin7 = convertToStrEnc(from: .isoLatin7)
	
	/// ISO 8859-14.
	static let isoLatin8 = convertToStrEnc(from: .isoLatin8)
	
	/// ISO 8859-15.
	static let isoLatin9 = convertToStrEnc(from: .isoLatin9)
	
	/// ISO 8859-16.
	static let isoLatin10 = convertToStrEnc(from: .isoLatin10)
	
	/* MS-DOS & Windows encodings begin at 0x400 */
	/// code page 437.
	static let dosLatinUS = convertToStrEnc(from: .dosLatinUS)
	/// code page 737 (formerly code page 437G).
	static let dosGreek = convertToStrEnc(from: .dosGreek)
	/// code page 775.
	static let dosBalticRim = convertToStrEnc(from: .dosBalticRim)
	/// code page 850, "Multilingual".
	static let dosLatin1 = convertToStrEnc(from: .dosLatin1)
	/// code page 851.
	static let dosGreek1 = convertToStrEnc(from: .dosGreek1)
	/// code page 852, Slavic.
	static let dosLatin2 = convertToStrEnc(from: .dosLatin2)
	/// code page 855, IBM Cyrillic.
	static let dosCyrillic = convertToStrEnc(from: .dosCyrillic)
	/// code page 857, IBM Turkish.
	static let dosTurkish = convertToStrEnc(from: .dosTurkish)
	/// code page 860.
	static let dosPortuguese = convertToStrEnc(from: .dosPortuguese)
	/// code page 861.
	static let dosIcelandic = convertToStrEnc(from: .dosIcelandic)
	/// code page 862.
	static let dosHebrew = convertToStrEnc(from: .dosHebrew)
	/// code page 863.
	static let dosCanadianFrench = convertToStrEnc(from: .dosCanadianFrench)
	/// code page 864.
	static let dosArabic = convertToStrEnc(from: .dosArabic)
	/// code page 865.
	static let dosNordic = convertToStrEnc(from: .dosNordic)
	/// code page 866.
	static let dosRussian = convertToStrEnc(from: .dosRussian)
	/// code page 869, IBM Modern Greek.
	static let dosGreek2 = convertToStrEnc(from: .dosGreek2)
	/// code page 874, also for Windows.
	static let dosThai = convertToStrEnc(from: .dosThai)
	/// code page 932, also for Windows.
	static let dosJapanese = convertToStrEnc(from: .dosJapanese)
	/// code page 936, also for Windows.
	static let dosSimplifiedChinese = convertToStrEnc(from: .dosChineseSimplif)
	/// code page 949, also for Windows; Unified Hangul Code.
	static let dosKorean = convertToStrEnc(from: .dosKorean)
	/// code page 950, also for Windows.
	static let dosTraditionalChinese = convertToStrEnc(from: .dosChineseTrad)
	/// code page 1250, Central Europe.
	static let windowsLatin2 = convertToStrEnc(from: .windowsLatin2)
	/// code page 1251, Slavic Cyrillic.
	static let windowsCyrillic = convertToStrEnc(from: .windowsCyrillic)
	/// code page 1253.
	static let windowsGreek = convertToStrEnc(from: .windowsGreek)
	/// code page 1254, Turkish.
	static let windowsLatin5 = convertToStrEnc(from: .windowsLatin5)
	/// code page 1255.
	static let windowsHebrew = convertToStrEnc(from: .windowsHebrew)
	/// code page 1256.
	static let windowsArabic = convertToStrEnc(from: .windowsArabic)
	/// code page 1257.
	static let windowsBalticRim = convertToStrEnc(from: .windowsBalticRim)
	/// code page 1258.
	static let windowsVietnamese = convertToStrEnc(from: .windowsVietnamese)
	/// code page 1361, for Windows NT.
	static let windowsKoreanJohab = convertToStrEnc(from: .windowsKoreanJohab)
	
	/* Various national standards begin at 0x600 */
	/// ANSEL (ANSI Z39.47).
	static let ANSEL = convertToStrEnc(from: .ANSEL)
	static let JIS_X0201_76 = convertToStrEnc(from: .JIS_X0201_76)
	static let JIS_X0208_83 = convertToStrEnc(from: .JIS_X0208_83)
	static let JIS_X0208_90 = convertToStrEnc(from: .JIS_X0208_90)
	static let JIS_X0212_90 = convertToStrEnc(from: .JIS_X0212_90)
	static let JIS_C6226_78 = convertToStrEnc(from: .JIS_C6226_78)
	
	/// Shift-JIS format encoding of JIS X0213 planes 1 and 2.
	static let shiftJIS_X0213 = convertToStrEnc(from: .shiftJIS_X0213)
	
	/// JIS X0213 in plane-row-column notation.
	static let shiftJIS_X0213_MenKuTen = convertToStrEnc(from: .shiftJIS_X0213_MenKuTen)
	
	static let GB_2312_80 = convertToStrEnc(from: .GB_2312_80)
	
	/// annex to GB 13000-93; for Windows 95.
	static let GBK_95 = convertToStrEnc(from: .GBK_95)
	
	
	static let GB_18030_2000 = convertToStrEnc(from: .GB_18030_2000)
	
	/// same as KSC 5601-92 without Johab annex.
	static let KSC_5601_87 = convertToStrEnc(from: .KSC_5601_87)
	
	/// KSC 5601-92 Johab annex.
	static let KSC_5601_92_Johab = convertToStrEnc(from: .ksc_5601_92_Johab)
	
	/// CNS 11643-1992 plane 1.
	static let CNS_11643_92_P1 = convertToStrEnc(from: .CNS_11643_92_P1)
	
	/// CNS 11643-1992 plane 2.
	static let CNS_11643_92_P2 = convertToStrEnc(from: .CNS_11643_92_P2)
	
	/// CNS 11643-1992 plane 3 (was plane 14 in 1986 version).
	static let CNS_11643_92_P3 = convertToStrEnc(from: .CNS_11643_92_P3)

	/* ISO 2022 collections begin at 0x800 */
	static let ISO_2022_JP = convertToStrEnc(from: .ISO_2022_JP)
	
	static let ISO_2022_JP_2 = convertToStrEnc(from: .ISO_2022_JP_2)
	
	/// RFC 2237.
	static let ISO_2022_JP_1 = convertToStrEnc(from: .ISO_2022_JP_1)
	
	/// JIS X0213.
	static let ISO_2022_JP_3 = convertToStrEnc(from: .ISO_2022_JP_3)
	static let ISO_2022_CN = convertToStrEnc(from: .ISO_2022_CN)
	
	static let ISO_2022_CN_EXT = convertToStrEnc(from: .ISO_2022_CN_EXT)
	
	static let ISO_2022_KR = convertToStrEnc(from: .ISO_2022_KR)

			/* EUC collections begin at 0x900 */
	/// ISO 646, 1-byte katakana, JIS 208, JIS 212.
	static let EUC_JP = convertToStrEnc(from: .EUC_JP)
	
	/// ISO 646, GB 2312-80.
	static let EUC_CN = convertToStrEnc(from: .EUC_CN)
	
	/// ISO 646, CNS 11643-1992 Planes 1-16.
	static let EUC_TW = convertToStrEnc(from: .EUC_TW)
	
	/// ISO 646, KS C 5601-1987.
	static let EUC_KR = convertToStrEnc(from: .EUC_KR)

			/* Misc standards begin at 0xA00 */
	/// plain Shift-JIS.
	static let shiftJIS = convertToStrEnc(from: .shiftJIS)
	
	/// Russian internet standard.
	static let KOI8_R = convertToStrEnc(from: .KOI8_R)
	
	/// Big-5 (has variants).
	static let big5 = convertToStrEnc(from: .big5)
	
	/// Mac OS Roman permuted to align with ISO Latin-1.
	static let macOSRomanLatin1 = convertToStrEnc(from: .macRomanLatin1)
	
	/// HZ (RFC 1842, for Chinese mail & news).
	static let HZ_GB_2312 = convertToStrEnc(from: .HZ_GB_2312)
	
	
	/// Big-5 with Hong Kong special char set supplement.
	static let big5_HKSCS_1999 = convertToStrEnc(from: .big5_HKSCS_1999)
	
	/// RFC 1456, Vietnamese.
	static let VISCII = convertToStrEnc(from: .VISCII)
	
	/// RFC 2319, Ukrainian.
	static let KOI8_U = convertToStrEnc(from: .KOI8_U)
	
	/// Taiwan Big-5E standard.
	static let big5_E = convertToStrEnc(from: .big5_E)
	
	/* Other platform encodings*/
	/// NextStep Japanese encoding.
	static let nextStepJapanese = convertToStrEnc(from: .nextStepJapanese)
	
	/* EBCDIC & IBM host encodings begin at 0xC00 */
	/// basic EBCDIC-US.
	static let EBCDIC_US = convertToStrEnc(from: .EBCDIC_US)
	
	/// code page 037, extended EBCDIC (Latin-1 set) for US, Canada.
	static let EBCDIC_CP037 = convertToStrEnc(from: .EBCDIC_CP037)
	
	/// `kTextEncodingUnicodeDefault` + `kUnicodeUTF7Format` RFC2152.
	static let UTF7 = convertToStrEnc(from: .UTF7)
	
	/// UTF-7 (IMAP folder variant) RFC3501.
	static let UTF7_IMAP = convertToStrEnc(from: .UTF7_IMAP)
}

/// Pascal String extensions
public extension String {
	/// A pascal string that is 256 bytes long, containing at most 255 characters.
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
	/// A pascal string that is 64 bytes long, containing at most 63 characters.
	typealias PStr63 = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
	/// A pascal string that is 33 bytes long, containing at most 32 characters.
	typealias PStr32 = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
	/// A pascal string that is 32 bytes long, containing at most 31 characters.
	typealias PStr31 = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8)
	/// A pascal string that is 28 bytes long, containing at most 27 characters.
	typealias PStr27 = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8)
	/// A pascal string that is 16 bytes long, containing at most 15 characters.
	typealias PStr15 = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
		UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
	/// A pascal string that is 34 bytes long, containing at most 32 characters.
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
	/// `nil`. The default is *255*, the largest value a `UInt8` can hold.
	init?(pascalString pStr: UnsafePointer<UInt8>, encoding: CFStringEncoding, maximumLength: UInt8 = 255) {
		if pStr.pointee > maximumLength {
			return nil
		}
		if let theStr = CFStringCreateWithPascalString(kCFAllocatorDefault, pStr, encoding) {
			self = String(theStr)
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
	/// `nil`. The default is *255*, the largest value a `UInt8` can hold.
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
}

public extension OSType {
	/// Encodes the passed `String` value to an `OSType`.
	///
	/// The string value may be formatted as a hexadecimal string.
	/// Only the first four characters are read.
	/// The string's characters must be present in the Mac Roman string encoding.
	init(osTypeStringValue toInit: String) {
		self = toOSType(toInit, detectHex: true)
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
	/// `HFSUniStr255` is declared internally on OS X as part of the HFS headers. iOS doesn't have this struct public.
	public init?(HFSUniStr: HFSUniStr255) {
		guard HFSUniStr.length < 256 else {
			return nil
		}
		let uniChars: [UInt16] = try! arrayFromObject(reflecting: HFSUniStr.unicode)
		let uniStr = uniChars[0 ..< Int(HFSUniStr.length)]
		let dat = uniStr.withUnsafeBufferPointer { (buf) -> Data in
			return Data(buffer: buf)
		}
		guard let toRet = String(data: dat, encoding: .macOSHFS) else {
			return nil
		}
		self = toRet
	}
}

/// For `OSType`s that have icon representations somewhere in macOS code.
public protocol OSTypeIconConvertable: RawRepresentable where RawValue == OSType {
	/// The icon representation of the `OSType`.
	///
	/// Note that some icons might not be present on modern versions of macOS, as some icons were
	/// used for pre-Mac OS X versions of Mac OS. Instead, the returned icon might be a generic icon, usually a
	/// blank document icon, but might return a Finder icon.
	var iconRepresentation: NSImage { get }
}

public extension OSTypeIconConvertable {
	var iconRepresentation: NSImage {
		return NSWorkspace.shared.icon(forFileType: NSFileTypeForHFSTypeCode(rawValue))
	}
}

/// Toolbar icons
public enum CarbonToolbarIcons: OSType, OSTypeConvertable, OSTypeIconConvertable, Hashable, @unchecked Sendable {
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
}

/// Folders
public enum CarbonFolderIcons: OSType, OSTypeConvertable, OSTypeIconConvertable, Hashable, @unchecked Sendable {
	case generic = 0x666C6472
	case drop = 0x64626F78
	case mounted = 0x6D6E7464
	case open = 0x6F666C64
	case owned = 0x6F776E64
	case `private` = 0x70727666
	case shared = 0x7368666C
}

/// Sharing Privileges icons
public enum CarbonSharingPrivilegesIcons: OSType, OSTypeConvertable, OSTypeIconConvertable, Hashable, @unchecked Sendable, CaseIterable {
	case notApplicable = 0x73686e61
	case readOnly = 0x7368726f
	case readWrite = 0x73687277
	case unknown = 0x7368756b
	case writable = 0x77726974
}

/// Users and Groups icons
public enum CarbonUserAndGroupIcons: OSType, OSTypeConvertable, OSTypeIconConvertable, Hashable, @unchecked Sendable {
	case userFolder = 0x75666c64
	case workgroupFolder = 0x77666c64
	case guestUser = 0x67757372
	case user = 0x75736572
	case owner = 0x73757372
	case group = 0x67727570
}

/// Badges
public enum CarbonBadgeIcons: OSType, OSTypeConvertable, OSTypeIconConvertable, Hashable, @unchecked Sendable {
	case appleScript = 0x73637270
	case locked = 0x6c626467
	case mounted = 0x6d626467
	case shared = 0x73626467
	case alias = 0x61626467
	case alertCaution = 0x63626467
}

/// Alert icons
public enum CarbonAlertIcons: OSType, OSTypeConvertable, OSTypeIconConvertable, Hashable, @unchecked Sendable, CaseIterable {
	case note = 0x6e6f7465
	case caution = 0x63617574
	case stop = 0x73746f70
}

/// Networking icons
public enum CarbonNetworkingIcons: OSType, OSTypeConvertable, OSTypeIconConvertable, Hashable, @unchecked Sendable {
	case appleTalk = 0x61746c6b
	case appleTalkZone = 0x61747a6e
	case afpServer = 0x61667073
	case ftpServer = 0x66747073
	case httpServer = 0x68747073
	case genericNetwork = 0x676e6574
	case ipFileServer = 0x69737276
}

/// Other icons
public enum CarbonOtherIcons: OSType, OSTypeConvertable, OSTypeIconConvertable, Hashable, @unchecked Sendable {
	case appleLogo = 0x6361706c
	case appleMenu = 0x7361706c
	case backwardArrow = 0x6261726f
	case favoriteItems = 0x66617672
	case forwardArrow = 0x6661726f
	case grid = 0x67726964
	case help = 0x68656c70
	case keepArranged = 0x61726e67
	case locked = 0x6c6f636b
	case noFiles = 0x6e66696c
	case noFolder = 0x6e666c64
	case noWrite = 0x6e777274
	case protectedApplicationFolder = 0x70617070
	case protectedSystemFolder = 0x70737973
	case recentItems = 0x72636e74
	case shortcut = 0x73687274
	case sortAscending = 0x61736e64
	case sortDescending = 0x64736e64
	case unlocked = 0x756c636b
	case connectTo = 0x636e6374
	case genericWindow = 0x6777696e
	case questionMark = 0x71756573
	case deleteAlias = 0x64616c69
	case ejectMedia = 0x656a6563
	case burning = 0x6275726e
	case rightContainerArrow = 0x72636172
}

/// Special folders
///
/// This was created back in the Mac OS 8/9 days: most of these don't have a modern macOS version.
public enum CarbonSpecialFolderIcons: OSType, OSTypeConvertable, OSTypeIconConvertable, Hashable, @unchecked Sendable {
	case appearance = 0x61707072
	case appleMenu = 0x616d6e75
	case applications = 0x61707073
	case applicationSupport = 0x61737570
	case colorSync = 0x70726f66
	case contextualMenuItems = 0x636d6e75
	case controlPanelDisabled = 0x63747244
	case controlPanel = 0x6374726c
	case documents = 0x646f6373
	case extensionsDisabled = 0x65787444
	case extensions = 0x6578746e
	case favorites = 0x66617673
	case fonts = 0x666f6e74
	case internetSearchSites = 0x69737366
	case `public` = 0x70756266
	case printerDescription = 0x70706466
	case printMonitor = 0x70726e74
	case recentApplications = 0x72617070
	case recentDocuments = 0x72646f63
	case recentServers = 0x72737276
	case shutdownItemsDisabled = 0x73686444
	case shutdownItems = 0x73686466
	case speakableItems = 0x73706b69
	case startupItemsDisabled = 0x73747244
	case startupItems = 0x73747274
	case systemExtensionDisabled = 0x6d616344
	case systemFolder = 0x6d616373
	case voices = 0x66766f63
	case appleExtras = 0x616578c4
	case assistants = 0x617374c4
	case controlStripModules = 0x736476c4
	case help = 0xc4686c70
	case internet = 0x696e74c4
	case internetPlugIn = 0xc46e6574
	case locales = 0xc46c6f63
	case macOSReadMe = 0x6d6f72c4
	case preferences = 0x707266c4
	case printerDriver = 0xc4707264
	case scriptingAdditions = 0xc4736372
	case sharedLibraries = 0xc46c6962
	case scripts = 0x736372c4
	case textEncodings = 0xc4746578
	case users = 0x757372c4
	case utilities = 0x757469c4
}

/// Generic Finder icons
///
/// This was created back in the Mac OS 8/9 days: most of these don't have a modern macOS version.
public enum CarbonGenericFinderIcons: OSType, OSTypeConvertable, OSTypeIconConvertable, Hashable, @unchecked Sendable {
	case clipboard = 0x434c4950
	case clippingUnknownType = 0x636c7075
	case clippingPictureType = 0x636c7070
	case clippingTextType = 0x636c7074
	case clippingSoundType = 0x636c7073
	case desktop = 0x6465736b
	case finder = 0x464e4452
	case computer = 0x726f6f74
	case fontSuitcase = 0x4646494c
	case fullTrash = 0x66747268
	case application = 0x4150504c
	case cdrom = 0x63646472
	case controlPanel = 0x41505043
	case controlStripModule = 0x73646576
	case component = 0x74686e67
	case deskAccessory = 0x41505044
	case document = 0x646f6375
	case editionFile = 0x65647466
	case `extension` = 0x494e4954
	case fileServer = 0x73727672
	case font = 0x6666696c
	case fontScaler = 0x73636c72
	case floppy = 0x666c7079
	case hardDisk = 0x6864736b
	case iDisk = 0x6964736b
	case removableMedia = 0x726d6f76
	case moverObject = 0x6d6f7672
	case pcCard = 0x70636d63
	case preferences = 0x70726566
	case queryDocument = 0x71657279
	case ramDisk = 0x72616d64
	case sharedLibary = 0x73686c62
	case stationery = 0x73646f63
	case suitcase = 0x73756974
	case url = 0x6775726c
	case worm = 0x776f726d
	case internationalResources = 0x6966696c
	case keyboardLayout = 0x6b66696c
	case soundFile = 0x7366696c
	case systemSuitcase = 0x7a737973
	case trash = 0x74727368
	case trueTypeFont = 0x7466696c
	case trueTypeFlatFont = 0x73666e74
	case trueTypeMultiFlatFont = 0x74746366
	case userIDisk = 0x7564736b
	case unknownFSObject = 0x756e6673
}

#endif

/// For `OSType` values that can be represented as a four-character string with values in the
/// *Mac OS Roman* string encoding.
public protocol OSTypeConvertable: RawRepresentable where RawValue == OSType {
	/// The value's string representation.
	///
	/// The value must be representable in the Mac OS Roman encoding.
	/// If the value contains any escape characters (*0x00*..*0x20*)
	/// or is unable to be seen as a Mac OS Roman string, will be an empty string.
	var macStringValue: String { get }
}

public extension OSTypeConvertable {
	var macStringValue: String {
		return OSTypeToString(self.rawValue) ?? ""
	}
}

/// Old QuickDraw text styles.
public struct QuickDrawStyle : OptionSet {
	public let rawValue: UInt8

	public init(rawValue value: UInt8) { self.rawValue = value }

	public static var bold: QuickDrawStyle {
		return QuickDrawStyle(rawValue: 1)
	}

	public static var italic: QuickDrawStyle {
		return QuickDrawStyle(rawValue: 2)
	}
	
	public static var underline: QuickDrawStyle {
		return QuickDrawStyle(rawValue: 4)
	}
	
	public static var outline: QuickDrawStyle {
		return QuickDrawStyle(rawValue: 8)
	}
	
	public static var shadow: QuickDrawStyle {
		return QuickDrawStyle(rawValue: 0x10)
	}
	
	public static var condensed: QuickDrawStyle {
		return QuickDrawStyle(rawValue: 0x20)
	}
	
	public static var extended: QuickDrawStyle {
		return QuickDrawStyle(rawValue: 0x40)
	}
}
