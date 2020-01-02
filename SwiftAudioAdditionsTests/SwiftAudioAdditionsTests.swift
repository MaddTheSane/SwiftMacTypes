//
//  SwiftAudioAdditionsTests.swift
//  SwiftAudioAdditionsTests
//
//  Created by C.W. Betts on 4/21/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Foundation
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
		var asbd = AudioStreamBasicDescription()
		XCTAssertNoThrow(asbd = try AudioStreamBasicDescription(fromText: "BEI16@44100,2"))
		XCTAssertNoThrow(asbd = try AudioStreamBasicDescription(fromText: "BEI16@44100,2"))
		XCTAssertNoThrow(asbd = try AudioStreamBasicDescription(fromText: "BEI16.1@44100:L5"))
		XCTAssertNoThrow(asbd = try AudioStreamBasicDescription(fromText: "-BEI16@44100,2D"))
		XCTAssertNoThrow(asbd = try AudioStreamBasicDescription(fromText: "-BEUI16@44100,2D"))
		XCTAssertNoThrow(asbd = try AudioStreamBasicDescription(fromText: "BEI16@44100,2D"))
		XCTAssertNoThrow(asbd = try AudioStreamBasicDescription(fromText: "BEI16@44100,2I"))
		XCTAssertNoThrow(asbd = try AudioStreamBasicDescription(fromText: "LEF16@48000,2"))
		XCTAssertNoThrow(asbd = try AudioStreamBasicDescription(fromText: "aac@48000,2"))
		XCTAssertNoThrow(asbd = try AudioStreamBasicDescription(fromText: "aac"))
		XCTAssertNoThrow(asbd = try AudioStreamBasicDescription(fromText: "aac/5bE"))
		_=asbd
	}
	
	func testInvalidASBDStringInits() {
		var asbd: AudioStreamBasicDescription?
		XCTAssertThrowsError(asbd = try AudioStreamBasicDescription(fromText: "aac,D"))
		XCTAssertThrowsError(asbd = try AudioStreamBasicDescription(fromText: "aa"))
		XCTAssertThrowsError(asbd = try AudioStreamBasicDescription(fromText: ""))
		XCTAssertThrowsError(asbd = try AudioStreamBasicDescription(fromText: "@441100"))
		XCTAssertThrowsError(asbd = try AudioStreamBasicDescription(fromText: "\\x20\\x20"))
		XCTAssertThrowsError(asbd = try AudioStreamBasicDescription(fromText: "\\x20\\y20"))
		XCTAssertThrowsError(asbd = try AudioStreamBasicDescription(fromText: "B"))
		XCTAssertThrowsError(asbd = try AudioStreamBasicDescription(fromText: "BE"))
		XCTAssertThrowsError(asbd = try AudioStreamBasicDescription(fromText: "BEI16.c@44100,2"))
		XCTAssertThrowsError(asbd = try AudioStreamBasicDescription(fromText: "aac/5bEé"))
		XCTAssertThrowsError(asbd = try AudioStreamBasicDescription(fromText: "aac/5bE,12D"))
		XCTAssertThrowsError(asbd = try AudioStreamBasicDescription(fromText: "aac/5bE;"))
		XCTAssertThrowsError(asbd = try AudioStreamBasicDescription(fromText: "aac/5bG"))
		_=asbd
	}
}
