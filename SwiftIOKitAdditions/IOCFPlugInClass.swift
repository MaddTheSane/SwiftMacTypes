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

public typealias IOCFPlugInInterfaceHandle = UnsafeMutablePointer<UnsafeMutablePointer<IOCFPlugInInterface>?>?

open class IOCFPlugInInterfaceClass: IUnknown {
	/// Should only be accessed by subclasses!
	public private(set) var interfaceStruct: IOCFPlugInInterfaceHandle = nil
	
	public init?(plugInInterface: IOCFPlugInInterfaceHandle) {
		if plugInInterface == nil {
			return nil
		} else if plugInInterface?.pointee == nil {
			return nil
		}
		interfaceStruct = plugInInterface
		_ = unwrappedInterface.AddRef(interfaceStruct)
	}
	
	deinit {
		if interfaceStruct != nil {
			_ = unwrappedInterface.Release(interfaceStruct)
		}
	}
	
	private var unwrappedInterface: IOCFPlugInInterface {
		return interfaceStruct!.pointee!.pointee
	}
	
	open var version: UInt16 {
		return unwrappedInterface.version
	}
	
	open var revision: UInt16 {
		return unwrappedInterface.revision
	}
	
	open func stop() -> IOReturn {
		return unwrappedInterface.Stop(interfaceStruct)
	}
	
	open func start(propertyTable: NSDictionary, service: io_service_t) -> IOReturn {
		return unwrappedInterface.Start(interfaceStruct, propertyTable, service)
	}
	
	open func probe(propertyTable: NSDictionary, service: io_service_t, order: inout Int32) -> IOReturn {
		return unwrappedInterface.Probe(interfaceStruct, propertyTable, service, &order)
	}
	
	open func queryInterface(_ iid: REFIID, ppv: UnsafeMutablePointer<LPVOID?>?) -> HRESULT {
		return unwrappedInterface.QueryInterface(interfaceStruct, iid, ppv)
	}
}
