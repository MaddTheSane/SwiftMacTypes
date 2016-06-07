//
//  CharacterAdditionsTests.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 6/7/16.
//  Copyright © 2016 C.W. Betts. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftAdditions

class CharacterAdditionsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testValidASCIIToChars() {
		let hi = "Hello".toASCIICharacters()
		if hi == nil {
			XCTFail()
		}
    }

    func testValidASCIIFromChars() {
		//let hi = [0x22, 0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x22]
		let hi: [ASCIICharacter] = [.DoubleQuote, .LetterUppercaseH, .LetterLowercaseE, .LetterLowercaseL, .LetterLowercaseL, .LetterLowercaseO, .DoubleQuote]
		let hi2 = String(asciiCharacters: hi)
		XCTAssertEqual("\"Hello\"", hi2)
    }
	
	func testInvalidASCIIFromChars() {
		//let hi = [0x22, 0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x22]
		let hi: [ASCIICharacter] = [.DoubleQuote, .LetterUppercaseH, .Invalid, .LetterLowercaseL, .LetterLowercaseL, .LetterLowercaseO, .Invalid, .Invalid, .DoubleQuote]
		let hi2 = String(asciiCharacters: hi)
		XCTAssertEqual("\"H\u{FFFD}llo\u{FFFD}\u{FFFD}\"", hi2)
	}
}
