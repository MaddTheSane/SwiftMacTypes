//
//  SwiftAdditionsTests.swift
//  SwiftAdditionsTests
//
//  Created by C.W. Betts on 8/22/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftAdditions

class SwiftAdditionsTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testByteOrder() {
		let bo = Int(OSHostByteOrder())
		var inferredBo: Int
		
		switch ByteOrder.current {
		case .big:
			inferredBo = OSBigEndian
			break
			
		case .little:
			inferredBo = OSLittleEndian
			break
			
		case .unknown:
			inferredBo = OSUnknownByteOrder
			break
		}
		XCTAssertEqual(inferredBo, bo)
	}
	
	func testNSUUIDTranslators() {
		let aUUID = NSUUID()
		let aCFUUID = aUUID.cfUUID
		let bUUID = NSUUID(CFUUID: aCFUUID)
		XCTAssertEqual(aUUID, bUUID)
	}
	
	func testUUIDTranslators() {
		let aUUID = UUID()
		let aCFUUID = aUUID.cfUUID
		let bUUID = UUID(cfUUID: aCFUUID)
		XCTAssertEqual(aUUID, bUUID)
	}
	
	func testSubStringFunction() {
		//Simple ASCII string: both representations should be the same
		var testString = "hi How are you today?"
		var subString = testString.substringWithLength(utf8: 10)
		var subString2 = testString.substringWithLength(utf16: 10)
		XCTAssertEqual(subString, subString2)
		
		//Emoji-heavy string. UTF-16 gets more than UTF-8
		testString = "hi 🙃🐱🦄  🌊🎮🎯🚵🏹"
		subString = testString.substringWithLength(utf8: 10)
		subString2 = testString.substringWithLength(utf16: 10)
		XCTAssertNotEqual(subString, subString2)

		//Simple, short non-ASCII string
		testString = "Olé"
		subString = testString.substringWithLength(utf8: 10)
		XCTAssertEqual(testString, subString)
		subString2 = testString.substringWithLength(utf16: 10)
		XCTAssertEqual(testString, subString2)
		XCTAssertEqual(subString2, subString)

		//bounds testing
		testString = "Résumé"
		subString = testString.substringWithLength(utf8: 6)
		subString2 = testString.substringWithLength(utf8: 7)
		XCTAssertEqual(subString2, subString)
		subString = testString.substringWithLength(utf16: 6)
		subString2 = testString.substringWithLength(utf16: 7)
		XCTAssertEqual(testString, subString2)
		XCTAssertEqual(subString, subString2)
	}
}
