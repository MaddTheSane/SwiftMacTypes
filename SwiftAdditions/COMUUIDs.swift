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
public var iUnknownUUID: UUID {
	return UUID(uuid:(
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x46))
}

public protocol IUnknown {
	func queryInterface(_ iid: REFIID, ppv: UnsafeMutablePointer<LPVOID?>?) -> HRESULT
}

extension IUnknown {
	public func queryInterface(UUID: CFUUID, ppv: UnsafeMutablePointer<LPVOID?>?) -> HRESULT {
		let bytes = CFUUIDGetUUIDBytes(UUID)
		
		return queryInterface(bytes, ppv: ppv)
	}
	
	public func queryInterface(UUID: UUID, ppv: UnsafeMutablePointer<LPVOID?>?) -> HRESULT {
		let bytes = UUID.cfUUID
		
		return queryInterface(UUID: bytes, ppv: ppv)
	}
}
