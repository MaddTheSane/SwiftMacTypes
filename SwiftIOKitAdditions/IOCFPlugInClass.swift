//
//  IOHIDDeviceClass.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 11/20/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Foundation
import IOKit
import IOKit.hid
import IOKit.usb.IOUSBLib
import SwiftAdditions

public typealias IOCFPlugInInterfaceHandle = UnsafeMutablePointer<UnsafeMutablePointer<IOCFPlugInInterface>>

public class IOCFPlugInInterfaceClass: IUnknown {
	private var interfaceStruct: IOCFPlugInInterfaceHandle = nil
	
	public init?(plugInInterface: IOCFPlugInInterfaceHandle) {
		if plugInInterface == nil {
			return nil
		} else if plugInInterface.memory == nil {
			return nil
		}
		interfaceStruct = plugInInterface
		SARetain(plugInInterface)
	}
	
	deinit {
		if interfaceStruct != nil {
			SARelease(interfaceStruct)
		}
	}
	
	private var unwrappedInterface: IOCFPlugInInterface {
		return interfaceStruct.memory.memory
	}
	
	public var version: UInt16 {
		return unwrappedInterface.version
	}
	
	public var revision: UInt16 {
		return unwrappedInterface.revision
	}
	
	public func stop() -> IOReturn {
		return SAIOStop(interfaceStruct)
	}
	
	public func start(#propertyTable: NSDictionary, service: io_service_t) -> IOReturn {
		return SAIOStart(interfaceStruct, propertyTable, service)
	}
	
	public func probe(#propertyTable: NSDictionary, service: io_service_t, inout order: Int32) -> IOReturn {
		return SAIOProbe(interfaceStruct, propertyTable, service, &order)
	}
	
	public func queryInterface(iid: REFIID, ppv: UnsafeMutablePointer<LPVOID>) -> HRESULT {
		return SAQueryInterface(interfaceStruct, iid, ppv)
	}
}
