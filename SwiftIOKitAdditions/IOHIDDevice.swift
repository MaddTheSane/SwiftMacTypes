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
	
	/// Sets a property for an `IOHIDDevice`.
	///
	/// Property keys are prefixed by *kIOHIDDevice* and declared in
	/// *<IOKit/hid/IOHIDKeys.h>*.
	/// - parameter key: `String` containing key to be used when modifiying the
	/// device property.
	/// - parameter property: The property to be set.
	/// - returns: Returns `true` if successful.
	func setProperty(_ property: Any, forKey key: String) -> Bool {
		return IOHIDDeviceSetProperty(self, key as NSString, property as AnyObject)
	}
	
	/// Obtains HID elements that match the criteria contained in the
	/// matching dictionary.
	///
	/// Matching keys are prefixed by *kIOHIDElement* and declared in
	/// *<IOKit/hid/IOHIDKeys.h>*.  Passing a `nil` dictionary will result
	/// in all device elements being returned.
	/// - parameter matching: `Dictionary` containg element matching criteria.
	/// - parameter options: Reserved for future use.
	/// - returns: Returns `Array` containing multiple IOHIDElement object.
	func elements(matching: [String: Any]?, options: IOOptionBits = 0) -> [IOHIDElement]? {
		return IOHIDDeviceCopyMatchingElements(self, matching as NSDictionary?, options) as? [IOHIDElement]
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
	func getValue(element: IOHIDElement, _ value: UnsafeMutablePointer<IOHIDValue?>, options: GetValueOptions) -> IOReturn {
		// ugly, icky hack!
		let hi = malloc(MemoryLayout<UnsafeMutablePointer<Unmanaged<IOHIDValue>>>.alignment).assumingMemoryBound(to: Unmanaged<IOHIDValue>.self)
		let err = IOHIDDeviceGetValueWithOptions(self, element, hi, options.rawValue)
		if err == kIOReturnSuccess {
			value.pointee = hi.pointee.takeUnretainedValue()
		}
		free(hi)
		return err
	}
	
	/// Copies a values for multiple elements.
	///
	/// This method behaves synchronously and return back immediately
	/// for input type element.  If requesting a value for a feature
	/// element, this will block until the report has been issued to the
	/// device.
	/// - parameter elements: `Array` containing multiple `IOHIDElement`s whose
	/// values are to be obtained.
	/// - parameter values: Pointer to `Dictionary` where the keys are the
	/// provided elements and the values are the requested values.
	/// - returns: Returns `kIOReturnSuccess` if successful.
	func getValues(elements: [IOHIDElement], _ values: UnsafeMutablePointer<[IOHIDElement: Any]?>) -> IOReturn {
		var tmpDict: Unmanaged<CFDictionary>? = nil
		let err = IOHIDDeviceCopyValueMultiple(self, elements as NSArray, &tmpDict)
		if let aDict = tmpDict?.takeRetainedValue() {
			values.pointee = (aDict as! [IOHIDElement: Any])
		}
		return err
	}
	
	/// Sends a report to the device.
	///
	/// This method behaves synchronously and will block until the
	/// report has been issued to the device.  It is only relevent for
	/// either output or feature type reports.
	/// - parameter reportType: Type of report being sent.
	/// - parameter reportID: ID of the report being sent.  If the device supports
	/// multiple reports, this should also be set in the first byte of
	/// the report.
	/// - parameter report: The report bytes to be sent to the device.
	/// - parameter reportLength: The length of the report to be sent to the device.
	/// - returns: Returns kIOReturnSuccess if successful.
	func setReport(type reportType: IOHIDReportType, id reportID: CFIndex, _ report: UnsafePointer<UInt8>, length reportLength: CFIndex) -> IOReturn {
		return IOHIDDeviceSetReport(self, reportType, reportID, report, reportLength)
	}
	
	/// Sends a report to the device.
	///
	/// This method behaves asynchronously and will block until the
	/// report has been issued to the device.  It is only relevent for
	/// either output or feature type reports.
	/// - parameter reportType: Type of report being sent.
	/// - parameter reportID: ID of the report being sent.  If the device supports
	/// multiple reports, this should also be set in the first byte of
	/// the report.
	/// - parameter report: The report bytes to be sent to the device.
	/// - parameter reportLength: The length of the report to be sent to the device.
	/// - parameter timeout: `CFTimeInterval` containing the timeout.
	/// - parameter callback: Pointer to a callback method of type
	/// `IOHIDReportCallback`.
	/// - parameter context: Pointer to data to be passed to the callback.
	/// - returns: Returns `kIOReturnSuccess` if successful.
	func setReport(type reportType: IOHIDReportType, id reportID: CFIndex, _ report: UnsafePointer<UInt8>, length reportLength: CFIndex, timeout: CFTimeInterval, callback: IOHIDReportCallback?, context: UnsafeMutableRawPointer?) -> IOReturn {
		return IOHIDDeviceSetReportWithCallback(self, reportType, reportID, report, reportLength, timeout, callback, context)
	}
	
	/// Obtains a report from the device.
	///
	/// This method behaves synchronously and will block until the
	/// report has been received from the device.  This is only intended
	/// for feature reports because of sporadic devicesupport for
	/// polling input reports.  Please defer to using
	/// `IOHIDDeviceRegisterInputReportCallback` for obtaining input
	/// reports.
	/// - parameter reportType: Type of report being requested.
    /// - parameter reportID: ID of the report being requested.
    /// - parameter report: Pointer to preallocated buffer in which to copy inbound
    /// report data.
    /// - parameter pReportLength: Pointer to length of preallocated buffer.  This
    /// value will be modified to refect the length of the returned
    /// report.
    /// - returns: Returns kIOReturnSuccess if successful.
	func getReport(type reportType: IOHIDReportType, id reportID: CFIndex, _ report: UnsafeMutablePointer<UInt8>, length pReportLength: UnsafeMutablePointer<CFIndex>) -> IOReturn {
		return IOHIDDeviceGetReport(self, reportType, reportID, report, pReportLength)
	}
}


public extension IOHIDDevice {
	/// Sends a report to the device.
	///
	/// This method behaves synchronously and will block until the
	/// report has been issued to the device.  It is only relevent for
	/// either output or feature type reports.
	/// - parameter reportType: Type of report being sent.
	/// - parameter reportID: ID of the report being sent.  If the device supports
	/// multiple reports, this should also be set in the first byte of
	/// the report.
	/// - parameter data: The report data to be sent to the device.
	/// - returns: Returns kIOReturnSuccess if successful.
	func setReport(type reportType: IOHIDReportType, id reportID: CFIndex, data: Data) -> IOReturn {
		return data.withUnsafeBytes { (rbp) -> IOReturn in
			IOHIDDeviceSetReport(self, reportType, reportID, rbp.bindMemory(to: UInt8.self).baseAddress!, rbp.count)
		}
	}
	
	/// Obtains a report from the device.
	///
	/// This method behaves synchronously and will block until the
	/// report has been received from the device.  This is only intended
	/// for feature reports because of sporadic devicesupport for
	/// polling input reports.  Please defer to using
	/// `IOHIDDeviceRegisterInputReportCallback` for obtaining input
	/// reports.
	/// - parameter reportType: Type of report being requested.
    /// - parameter reportID: ID of the report being requested.
    /// - parameter data: Reference to a `Data` struct with the count
    /// - returns: Returns `kIOReturnSuccess` if successful, or `kIOReturnUnderrun`
	/// if `data` is empty.
	func getReport(type reportType: IOHIDReportType, id reportID: CFIndex, data: inout Data) -> IOReturn {
		if data.count == 0 {
			return kIOReturnUnderrun
		}
		var length: CFIndex = data.count
		let retVal = data.withUnsafeMutableBytes { (rbp) -> IOReturn in
			IOHIDDeviceGetReport(self, reportType, reportID, rbp.bindMemory(to: UInt8.self).baseAddress!, &length)
		}
		data.count = length
		return retVal
	}
}
