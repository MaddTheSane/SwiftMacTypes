//
//  MacErrorTests.swift
//  SwiftAdditionsTests
//
//  Created by C.W. Betts on 12/15/19.
//  Copyright © 2019 C.W. Betts. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftAdditions

class MacErrorTests: XCTestCase {
	
	override func setUp() {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func testCatchableError() {
		do {
			throw NSError(domain: NSOSStatusErrorDomain, code: -50 /* paramErr */, userInfo: nil)
		} catch let error as SAMacError {
			XCTAssertEqual(error.code, SAMacError.Code.parameter)
		} catch {
			XCTFail("unknown error \(error)")
		}
	}
	
	func testCatchNSError() {
		do {
			throw SAMacError(.parameter)
		} catch let error as NSError {
			XCTAssertEqual(error.domain, NSOSStatusErrorDomain)
			XCTAssertEqual(error.code, -50)
		}
	}
}
