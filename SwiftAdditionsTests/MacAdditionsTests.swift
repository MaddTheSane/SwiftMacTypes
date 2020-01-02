//
//  MacAdditionsTests.swift
//  SwiftAdditionsTests
//
//  Created by C.W. Betts on 4/4/18.
//  Copyright © 2018 C.W. Betts. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftAdditions
import CoreFoundation.CFStringEncodingExt

class MacAdditionsTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testPascalStrings() {
		let pStr255: String.PStr255 = (2, 72, 105, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									   0, 0, 0, 0, 0, 0, 0, 0, 0)
		/// A pascal string that is 64 bytes long, containing at least 63 characters.
		let pStr63: String.PStr63 = (2, 72, 105, 0, 0, 0, 0,
									 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									 0, 0, 0, 0, 0, 0, 0)
		/// A pascal string that is 33 bytes long, containing at least 32 characters.
		let pStr32: String.PStr32 = (2, 72, 105, 0, 0, 0, 0,
									 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									 0, 0, 0, 0, 0, 0)
		/// A pascal string that is 32 bytes long, containing at least 31 characters.
		let pStr31: String.PStr31 = (2, 72, 105, 0, 0, 0, 0,
									 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									 0, 0, 0, 0, 0)
		/// A pascal string that is 28 bytes long, containing at least 27 characters.
		let pStr27: String.PStr27 = (2, 72, 105, 0, 0, 0, 0,
									 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									 0)
		/// A pascal string that is 16 bytes long, containing at least 15 characters.
		let pStr15: String.PStr15 = (2, 72, 105, 0, 0, 0, 0,
									 0, 0, 0, 0, 0, 0, 0, 0, 0)
		/// A pascal string that is 34 bytes long, containing at least 32 characters.
		///
		/// The last byte is unused as it was used for padding over a network.
		let pStr32Field: String.PStr32Field = (2, 72, 105, 0, 0, 0,
											   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											   0, 0, 0, 0, 0, 0, 0, 0)
		
		var aStr = String(pascalString: pStr255)
		XCTAssertNotNil(aStr, "Pascal String '\(pStr255)' invalid")
		aStr = String(pascalString: pStr63)
		XCTAssertNotNil(aStr, "Pascal String '\(pStr63)' invalid")
		aStr = String(pascalString: pStr32)
		XCTAssertNotNil(aStr, "Pascal String '\(pStr32)' invalid")
		aStr = String(pascalString: pStr31)
		XCTAssertNotNil(aStr, "Pascal String '\(pStr31)' invalid")
		aStr = String(pascalString: pStr27)
		XCTAssertNotNil(aStr, "Pascal String '\(pStr27)' invalid")
		aStr = String(pascalString: pStr15)
		XCTAssertNotNil(aStr, "Pascal String '\(pStr15)' invalid")
		aStr = String(pascalString: pStr32Field)
		XCTAssertNotNil(aStr, "Pascal String '\(pStr32Field)' invalid")
	}
	
	func testInvalidPascalStrings() {
		let pStr15: String.PStr15 = (255, 72, 105, 0, 0, 0, 0,
									 0, 0, 0, 0, 0, 0, 0, 0, 0)
		let pStr27: String.PStr27 = (28, 72, 105, 0, 0, 0, 0,
									 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									 0)
		var aStr = String(pascalString: pStr15)
		XCTAssertNil(aStr)
		aStr = String(pascalString: pStr27)
		XCTAssertNil(aStr)
	}
	
	/*
	TODO: Test encodings that Cocoa can decode:
	0
1
2
3
4
5
6
7
9
10
11
21
25
26
29
33
34
35
36
37
38
39
40
140
152
236
	
	CFStringBuiltInEncodings.macRoman
	CFStringEncodings.macJapanese
	CFStringEncodings.macChineseTrad
	CFStringEncodings.macKorean
	CFStringEncodings.macArabic
	CFStringEncodings.macHebrew
	CFStringEncodings.macGreek
	CFStringEncodings.macCyrillic
	CFStringEncodings.macDevanagari
	CFStringEncodings.macGurmukhi
	CFStringEncodings.macGujarati
	CFStringEncodings.macThai
	CFStringEncodings.macChineseSimp
	CFStringEncodings.macTibetan
	CFStringEncodings.macCentralEurRoman
	CFStringEncodings.macSymbol
	CFStringEncodings.macDingbats
	CFStringEncodings.macTurkish
	CFStringEncodings.macCroatian
	CFStringEncodings.macIcelandic
	CFStringEncodings.macRomanian
	CFStringEncodings.macCeltic
	CFStringEncodings.macGaelic
	CFStringEncodings.macFarsi
	CFStringEncodings.macUkrainian
	CFStringEncodings.macInuit
	

*/
}
