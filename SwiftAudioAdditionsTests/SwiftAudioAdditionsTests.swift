//
//  SwiftAudioAdditionsTests.swift
//  SwiftAudioAdditionsTests
//
//  Created by C.W. Betts on 4/21/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Cocoa
import AudioToolbox
import CoreAudio
@testable import SwiftAudioAdditions
import XCTest

class SwiftAudioAdditionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testASBDStringInit() {
        // This is an example of a functional test case.
		var asbd = AudioStreamBasicDescription(fromText: "BEI16@44100,2")
        XCTAssert(asbd != nil, "Invalid asbd format?")
		asbd = AudioStreamBasicDescription(fromText: "BEI16@44100,2D")
		XCTAssert(asbd != nil, "Invalid asbd format?")
		asbd = AudioStreamBasicDescription(fromText: "BEI16@44100,2I")
		XCTAssert(asbd != nil, "Invalid asbd format?")
		asbd = AudioStreamBasicDescription(fromText: "LEF16@48000,2")
		XCTAssert(asbd != nil, "Invalid asbd format?")
		asbd = AudioStreamBasicDescription(fromText: "aac@48000,2")
		XCTAssert(asbd != nil, "Invalid asbd format?")
		asbd = AudioStreamBasicDescription(fromText: "aac")
		XCTAssert(asbd != nil, "Invalid asbd format?")
    }
	
	func testInvalidASBDStringInits() {
		var asbd: AudioStreamBasicDescription?
		XCTAssertEqual(asbd, nil)
		asbd = AudioStreamBasicDescription(fromText: "aac,D")
		XCTAssertEqual(asbd, nil)
		asbd = AudioStreamBasicDescription(fromText: "")
		XCTAssertEqual(asbd, nil)
		asbd = AudioStreamBasicDescription(fromText: "@441100")
		XCTAssertEqual(asbd, nil)
		asbd = AudioStreamBasicDescription(fromText: "\\x20\\x20")
		XCTAssertEqual(asbd, nil)
		asbd = AudioStreamBasicDescription(fromText: "B")
		XCTAssertEqual(asbd, nil)
		asbd = AudioStreamBasicDescription(fromText: "BE")
		XCTAssertEqual(asbd, nil)
	}
}
