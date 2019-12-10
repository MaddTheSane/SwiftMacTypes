//
//  IOHIDDevice.swift
//  SwiftIOKitAdditions
//
//  Created by C.W. Betts on 12/9/19.
//  Copyright © 2019 C.W. Betts. All rights reserved.
//

import Foundation
import IOKit.hid

public extension IOHIDDevice {
	/// The type identifier of all `IOHIDDevice` instances.
	class var typeID: CFTypeID {
		return IOHIDDeviceGetTypeID()
	}
	
	/// Creates an element from an `io_service_t`.
	///
	/// The `io_service_t` passed in this method must reference an object
	/// in the kernel of type `IOHIDDevice`.
	/// - parameter allocator: Allocator to be used during creation.
	/// - parameter service: Reference to service object in the kernel.
	/// - returns: Returns a new `IOHIDDevice`.
	class func create(allocator: CFAllocator?, service: io_service_t) -> IOHIDDevice? {
		return IOHIDDeviceCreate(allocator, service)
	}
	
	/// The `io_service_t` for the `IOHIDDevice`, if it has one.
	///
	/// If the `IOHIDDevice` references an object in the kernel, this is
	/// used to get the `io_service_t` for that object.
	/// Is `nil` if the device isn't in the kernel.
	var service: io_service_t? {
		let toRet = IOHIDDeviceGetService(self)
		if toRet == MACH_PORT_NULL {
			return nil
		}
		return toRet
	}
	
	/// Opens a HID device for communication.
	///
	/// Before the client can issue commands that change the state of
	/// the device, it must have succeeded in opening the device. This
	/// establishes a link between the client's task and the actual
	/// device.  To establish an exclusive link use the
	/// `kIOHIDOptionsTypeSeizeDevice` option.
	/// - parameter options: Option bits to be sent down to the device.
	/// - returns: Returns kIOReturnSuccess if successful.
	func open(options: IOOptionBits = 0) -> IOReturn {
		return IOHIDDeviceOpen(self, options)
	}
	
	/// Closes communication with a HID device.
	///
	/// This closes a link between the client's task and the actual
	/// device.
	/// - parameter options: Option bits to be sent down to the device.
	/// - returns: Returns kIOReturnSuccess if successful.
	func close(options: IOOptionBits = 0) -> IOReturn {
		return IOHIDDeviceClose(self, options)
	}
	
	/// Convenience function that scans the Application Collection
	/// elements to see if it conforms to the provided `usagePage`
	/// and `usage`.
	///
	/// Examples of Application Collection usages pairs are:
	/// ````
	/// usagePage = kHIDPage_GenericDesktop
	/// usage = kHIDUsage_GD_Mouse
	/// ````
	/// **or**
	/// ````
	/// usagePage = kHIDPage_GenericDesktop
	/// usage = kHIDUsage_GD_Keyboard
	/// ````
	/// - parameter usagePage: Device usage page
	/// - parameter usage: Device usage
	/// - returns: Returns `true` if device conforms to provided usage.
	func conformsTo(usagePage: UInt32, usage: UInt32) -> Bool {
		return IOHIDDeviceConformsTo(self, usagePage, usage)
	}
	
	/// Obtains a property from an `IOHIDDevice`.
	///
	/// Property keys are prefixed by kIOHIDDevice and declared in
	/// *<IOKit/hid/IOHIDKeys.h>*.
	/// - parameter key: `String` containing key to be used when querying the
	/// device.
	/// - returns: Returns the property.
	func getProperty(forKey key: String) -> Any? {
		return IOHIDDeviceGetProperty(self, key as NSString)
	}
	
	typealias GetValueOptions = IOHIDDeviceGetValueOptions

	/// Gets a value for an element.
	///
	/// This method behaves synchronously and return back immediately
	/// for input type element.  If requesting a value for a feature
	/// element, this will block until the report has been issued to the
	/// device.  If obtaining values for multiple elements you may want
	/// to consider using `IOHIDDeviceCopyValueMultiple` or `IOHIDTransaction`.
	/// - parameter element: IOHIDElementRef whose value is to be obtained.
    /// - parameter value: Pointer to IOHIDValueRef to be obtained.
    /// - returns: Returns `kIOReturnSuccess` if successful.
	@available(OSX 10.13, *)
	func getValue(element: IOHIDElement, value: UnsafeMutablePointer<IOHIDValue?>, options: GetValueOptions) -> IOReturn {
		// ugly, icky hack!
		let hi = malloc(MemoryLayout<UnsafeMutablePointer<Unmanaged<IOHIDValue>>>.alignment).assumingMemoryBound(to: Unmanaged<IOHIDValue>.self)
		let err = IOHIDDeviceGetValueWithOptions(self, element, hi, options.rawValue)
		if err == kIOReturnSuccess {
			value.pointee = hi.pointee.takeUnretainedValue()
		}
		free(hi)
		return err
	}
}
