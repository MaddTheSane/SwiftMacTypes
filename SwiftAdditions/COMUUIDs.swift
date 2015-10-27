//
//  COMUUIDs.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 11/7/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import CoreFoundation
import CoreFoundation.CFPlugInCOM
import Foundation.NSUUID

/// The IUnknown UUID used by COM APIs.
public let IUnknownUUID: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorSystemDefault,
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x46)

public func QueryInterface<X where X: IUnknown>(thisPointer: X, UUID: NSUUID, ppv: UnsafeMutablePointer<LPVOID>) -> HRESULT {
	let bytes = UUID.cfUUID
	
	return QueryInterface(thisPointer, UUID: bytes, ppv: ppv)
}

public func QueryInterface<X where X: IUnknown>(thisPointer: X, UUID: CFUUID, ppv: UnsafeMutablePointer<LPVOID>) -> HRESULT {
	let bytes = CFUUIDGetUUIDBytes(UUID)
	
	return thisPointer.queryInterface(bytes, ppv: ppv)
}

public protocol IUnknown {
	func queryInterface(iid: REFIID, ppv: UnsafeMutablePointer<LPVOID>) -> HRESULT
}
