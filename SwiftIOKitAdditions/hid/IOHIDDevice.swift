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
	/// Creates an element from an `io_service_t`.
	///
	/// The `io_service_t` passed in this method must reference an object
	/// in the kernel of type `IOHIDDevice`.
	/// - parameter allocator: Allocator to be used during creation.
	/// - parameter service: Reference to service object in the kernel.
	/// - returns: Returns a new `IOHIDDevice`.
	@inlinable class func create(allocator: CFAllocator? = kCFAllocatorDefault, service: io_service_t) -> IOHIDDevice? {
		return IOHIDDeviceCreate(allocator, service)
	}
	
	/// The `io_service_t` for the `IOHIDDevice`, if it has one.
	///
	/// If the `IOHIDDevice` references an object in the kernel, this is
	/// used to get the `io_service_t` for that object.
	/// Is `nil` if the device isn't in the kernel.
	@inlinable var service: io_service_t? {
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
	@inlinable func open(options: IOOptionBits = 0) -> IOReturn {
		return IOHIDDeviceOpen(self, options)
	}
	
	/// Closes communication with a HID device.
	///
	/// This closes a link between the client's task and the actual
	/// device.
	/// - parameter options: Option bits to be sent down to the device.
	/// - returns: Returns kIOReturnSuccess if successful.
	@inlinable func close(options: IOOptionBits = 0) -> IOReturn {
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
	@inlinable func conformsTo(usagePage: UInt32, usage: UInt32) -> Bool {
		return IOHIDDeviceConformsTo(self, usagePage, usage)
	}
	
	/// Obtains a property from an `IOHIDDevice`.
	///
	/// Property keys are prefixed by *kIOHIDDevice* and declared in
	/// *<IOKit/hid/IOHIDKeys.h>*.
	/// - parameter key: `String` containing key to be used when querying the
	/// device.
	/// - returns: Returns the property.
	@inlinable func getProperty(forKey key: String) -> Any? {
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
	/// - returns: Returns `Array` containing multiple `IOHIDElement` object.
	func elements(matching: [String: Any]?, options: IOOptionBits = 0) -> [IOHIDElement]? {
		return IOHIDDeviceCopyMatchingElements(self, matching as NSDictionary?, options) as? [IOHIDElement]
	}
	
	/// Schedules HID device with run loop.
	///
	/// Formally associates device with client's run loop. Scheduling
	/// this device with the run loop is necessary before making use of
	/// any asynchronous APIs.
	/// - parameter runLoop: `RunLoop` to be used when scheduling any asynchronous
	/// activity.
	/// - parameter runLoopMode: Run loop mode to be used when scheduling any
	/// asynchronous activity.
	@inlinable func schedule(with runLoop: CFRunLoop, mode runLoopMode: CFString) {
		IOHIDDeviceScheduleWithRunLoop(self, runLoop, runLoopMode)
	}
	
	/// Unschedules HID device with run loop.
	///
	/// Formally disassociates device with client's run loop.
	/// - parameter runLoop: RunLoop to be used when unscheduling any asynchronous
	/// activity.
	/// - parameter runLoopMode: Run loop mode to be used when unscheduling any
	/// asynchronous activity.
	@inlinable func unschedule(from runLoop: CFRunLoop, mode runLoopMode: CFString) {
		IOHIDDeviceUnscheduleFromRunLoop(self, runLoop, runLoopMode)
	}
	
	/// Sets the dispatch queue to be associated with the IOHIDDevice.
	/// This is necessary in order to receive asynchronous events from the kernel.
	///
	/// An IOHIDDevice should not be associated with both a runloop and dispatch
	/// queue. A call to `setDispatchQueue(_:)` should only be made once.
	///
	/// If a dispatch queue is set but never used, a call to `cancel()` followed
	/// by `activate()` should be performed in that order.
	///
	/// After a dispatch queue is set, the `IOHIDDevice` must make a call to activate
	/// via `activate()` and cancel via `cancel()`. All calls to "Register"
	/// functions should be done before activation and not after cancellation.
	/// - parameter queue: The dispatch queue to which the event handler block will
	/// be submitted.
	@available(OSX 10.15, *)
	@inlinable func setDispatchQueue(_ queue: DispatchQueue) {
		IOHIDDeviceSetDispatchQueue(self, queue)
	}
	
	/// Sets a cancellation handler for the dispatch queue associated with
	/// `setDispatchQueue(_:)`.
	///
	/// The cancellation handler (if specified) will be will be submitted to the
	/// device's dispatch queue in response to a call to `cancel()` after
	/// all the events have been handled.
	///
	/// `setCancelHandler(_:)` should not be used when scheduling with
	/// a run loop.
	///
	/// The `IOHIDDevice` should only be released after the device has been
	/// cancelled, and the cancel handler has been called. This is to ensure all
	/// asynchronous objects are released. For example:
	///````
	/// let deviceRetained = Unmanaged.passRetained(device)
	/// let cancelHandler = {
	///     deviceRetained.release()
	/// }()
	/// device.setCancelHandler(cancelHandler)
	/// device.activate()
	/// device.cancel()
	///````
	/// - parameter handler: The cancellation handler block to be associated with
	/// the dispatch queue.
	@available(OSX 10.15, *)
	@inlinable func setCancelHandler(_ handler: @escaping () -> Void) {
		IOHIDDeviceSetCancelHandler(self, handler)
	}
	
	/// Activates the `IOHIDDevice` object.
	///
	/// An `IOHIDDevice` object associated with a dispatch queue is created
	/// in an inactive state. The object must be activated in order to
	/// receive asynchronous events from the kernel.
	///
	/// A dispatch queue must be set via `setDispatchQueue(_:)` before
	/// activation.
	///
	/// An activated device must be cancelled via `cancel()`. All calls
	/// to "Register" functions should be done before activation
	/// and not after cancellation.
	///
	/// Calling `activate()` on an active `IOHIDDevice` has no effect.
	@available(OSX 10.15, *)
	@inlinable func activate() {
		IOHIDDeviceActivate(self)
	}
	
	/// Cancels the `IOHIDDevice` preventing any further invocation
	/// of its event handler block.
	///
	/// Cancelling prevents any further invocation of the event handler block for
	/// the specified dispatch queue, but does not interrupt an event handler
	/// block that is already in progress.
	///
	/// Explicit cancellation of the `IOHIDDevice` is required, no implicit
	/// cancellation takes place.
	///
	/// Calling `cancel()` on an already cancelled queue has no effect.
	///
	/// The `IOHIDDevice` should only be released after the device has been
	/// cancelled, and the cancel handler has been called. This is to ensure all
	/// asynchronous objects are released.
	@available(OSX 10.15, *)
	@inlinable func cancel() {
		IOHIDDeviceCancel(self)
	}
	
	/// Registers a callback to be used when a `IOHIDDevice` is removed.
	///
	/// In most cases this occurs when a device is unplugged.
	///
	/// If a dispatch queue is set, this call must occur before activation.
	/// - parameter callback: Pointer to a callback method of type `IOHIDCallback`.
	/// - parameter context: Pointer to data to be passed to the callback.
	@inlinable func registerRemoval(callback: IOHIDCallback?, context: UnsafeMutableRawPointer?) {
		IOHIDDeviceRegisterRemovalCallback(self, callback, context)
	}
	
	/// Registers a callback to be used when an input value is issued by
	/// the device.
	///
	/// An input element refers to any element of type
	/// `kIOHIDElementTypeInput` and is usually issued by interrupt driven
	/// reports.  If more specific element values are desired, you can
	/// specify matching criteria via `setInputValueMatching(_:)`
	/// and `setInputValueMatching(multiple:)`.
	///
	/// If a dispatch queue is set, this call must occur before activation.
	/// - parameter callback: Pointer to a callback method of type IOHIDValueCallback.
	/// - parameter context: Pointer to data to be passed to the callback.
	@inlinable func registerInputValue(callback: IOHIDValueCallback?, context: UnsafeMutableRawPointer?) {
		IOHIDDeviceRegisterInputValueCallback(self, callback, context)
	}
	
	/// Registers a callback to be used when an input report is issued
	/// by the device.
	/// An input report is an interrupt driver report issued by the
	/// device.
	///
	/// If a dispatch queue is set, this call must occur before activation.
	/// - parameter report: Pointer to preallocated buffer in which to copy inbound
	/// report data.
	/// - parameter reportLength: Length of preallocated buffer.
	/// - parameter callback: Pointer to a callback method of type
	/// `IOHIDReportCallback`.
	/// - parameter context: Pointer to data to be passed to the callback.
	@inlinable func registerInputReport(_ report: UnsafeMutablePointer<UInt8>, length reportLength: CFIndex, callback: IOHIDReportCallback?, context: UnsafeMutableRawPointer?) {
		IOHIDDeviceRegisterInputReportCallback(self, report, reportLength, callback, context)
	}
	
	/// Registers a timestamped callback to be used when an input report is issued
	/// by the device.
	///
	/// An input report is an interrupt driver report issued by the
	/// device.
	///
	/// If a dispatch queue is set, this call must occur before activation.
	/// - parameter report: Pointer to preallocated buffer in which to copy inbound
	/// report data.
	/// - parameter reportLength: Length of preallocated buffer.
	/// - parameter callback: Pointer to a callback method of type
	/// `IOHIDReportWithTimeStampCallback`.
	/// - parameter context: Pointer to data to be passed to the callback.
	@available(OSX 10.10, *)
	@inlinable func registerInputReport(_ report: UnsafeMutablePointer<UInt8>, length reportLength: CFIndex, timeStampCallback callback: IOHIDReportWithTimeStampCallback?, context: UnsafeMutableRawPointer?) {
		IOHIDDeviceRegisterInputReportWithTimeStampCallback(self, report, reportLength, callback, context)
	}
	
	/// Sets matching criteria for input values received via
	/// `registerInputValue(callback:context:)`.
	///
	/// Matching keys are prefixed by *kIOHIDElement* and declared in
	/// *<IOKit/hid/IOHIDKeys.h>*.  Passing a `nil` dictionary will result
	/// in all devices being enumerated. Any subsequent calls will cause
	/// the hid manager to release previously matched input elements and
	/// restart the matching process using the revised criteria.  If
	/// interested in multiple, specific device elements, please defer to
	/// using `setInputValueMatching(multiple:)`.
	///
	/// If a dispatch queue is set, this call must occur before activation.
	/// - parameter matching: `Dictionary` containg device matching criteria.
	func setInputValueMatching(_ matching: [String: Any]?) {
		IOHIDDeviceSetInputValueMatching(self, matching as NSDictionary?)
	}
	
	/// Sets multiple matching criteria for input values received via
	/// `registerInputValue(callback:context:)`.
	///
	/// Matching keys are prefixed by *kIOHIDElement* and declared in
	/// *<IOKit/hid/IOHIDKeys.h>*.  This method is useful if interested
	/// in multiple, specific elements.
	///
	/// If a dispatch queue is set, this call must occur before activation.
	/// - parameter multiple: `Array` containing multiple `Dictionary` objects
	/// containg input element matching criteria.
	func setInputValueMatching(multiple: [[String: Any]]?) {
		IOHIDDeviceSetInputValueMatchingMultiple(self, multiple as NSArray?)
	}
	
	/// Sets a value for an element.
	///
	/// This method behaves synchronously and will block until the
	/// report has been issued to the device.  It is only relevent for
	/// either output or feature type elements.  If setting values for
	/// multiple elements you may want to consider using
	/// `setValue(multiple:)` or `IOHIDTransaction`.
	/// - parameter element: `IOHIDElement` whose value is to be modified.
	/// - parameter value: `IOHIDValue` containing value to be set.
	/// - returns: Returns `kIOReturnSuccess` if successful.
	@inlinable func setValue(_ value: IOHIDValue, element: IOHIDElement) -> IOReturn {
		return IOHIDDeviceSetValue(self, element, value)
	}
	
	/// Sets multiple values for multiple elements.
	///
	/// This method behaves synchronously and will block until the
	/// report has been issued to the device.  It is only relevent for
	/// either output or feature type elements.
	/// - parameter multiple: `Dictionary` where key is `IOHIDElement` and
	/// value is `IOHIDValue`.
	/// - returns: Returns `kIOReturnSuccess` if successful.
	func setValue(multiple: [IOHIDElement: IOHIDValue]) -> IOReturn {
		return IOHIDDeviceSetValueMultiple(self, multiple as NSDictionary)
	}
	
	/// Sets a value for an element and returns status via a completion
	/// callback.
	///
	/// This method behaves asynchronously and will invoke the callback
	/// once the report has been issued to the device.  It is only
	/// relevent for either output or feature type elements.
	/// If setting values for multiple elements you may want to
	/// consider using `IOHIDDeviceSetValueWithCallback` or
	/// `IOHIDTransaction`.
	/// - parameter element: `IOHIDElement` whose value is to be modified.
	/// - parameter value: `IOHIDValue` containing value to be set.
	/// - parameter timeout: `CFTimeInterval` containing the timeout.
	/// - parameter callback: Pointer to a callback method of type
	/// `IOHIDValueCallback`.
	/// - parameter context: Pointer to data to be passed to the callback.
	/// - returns: Returns `kIOReturnSuccess` if successful.
	func setValue(_ value: IOHIDValue, element: IOHIDElement, timeout: CFTimeInterval, callback: IOHIDValueCallback?, context: UnsafeMutableRawPointer?) -> IOReturn {
		return IOHIDDeviceSetValueWithCallback(self, element, value, timeout, callback, context)
	}
	
	/// Sets multiple values for multiple elements and returns status
	/// via a completion callback.
	///
	/// This method behaves asynchronously and will invoke the callback
	/// once the report has been issued to the device.  It is only
	/// relevent for either output or feature type elements.
	/// - parameter multiple: `Dictionary` where key is `IOHIDElement` and
	/// value is `IOHIDValue`.
	/// - parameter timeout: `CFTimeInterval` containing the timeout.
	/// - parameter callback: Pointer to a callback method of type
	/// `IOHIDValueMultipleCallback`.
	/// - parameter context: Pointer to data to be passed to the callback.
	/// - returns: Returns `kIOReturnSuccess` if successful.
	func setValue(multiple: [IOHIDElement: IOHIDValue], timeout: CFTimeInterval, callback: IOHIDValueMultipleCallback?, context: UnsafeMutableRawPointer?) -> IOReturn {
		return IOHIDDeviceSetValueMultipleWithCallback(self, multiple as NSDictionary, timeout, callback, context)
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
	
	/// Copies a values for multiple elements and returns status via a
	/// completion callback.
	///
	/// This method behaves asynchronusly and is only relevent for
	/// either output or feature type elements.
	/// - parameter elements: `Array` containing multiple `IOHIDElement`s whose
	/// values are to be obtained.
	/// - parameter pMultiple: Pointer to `Dictionary` where the keys are the
	/// provided elements and the values are the requested values.
	/// - parameter timeout: `CFTimeInterval` containing the timeout.
	/// - parameter callback: Pointer to a callback method of type
	/// `IOHIDValueMultipleCallback`.
	/// - parameter context: Pointer to data to be passed to the callback.
	/// - returns: Returns `kIOReturnSuccess` if successful.
	func getValue(elements: [IOHIDElement], multiple pMultiple: UnsafeMutablePointer<[IOHIDElement: Any]?>?, timeout: CFTimeInterval, callback: IOHIDValueMultipleCallback?, context: UnsafeMutableRawPointer?) -> IOReturn {
		var tmpPtr: Unmanaged<CFDictionary>? = nil
		
		let err = IOHIDDeviceCopyValueMultipleWithCallback(self, elements as NSArray, &tmpPtr, timeout, callback, context)
		
		pMultiple?.pointee = tmpPtr?.takeRetainedValue() as? [IOHIDElement : Any]
		
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
	@inlinable func setReport(type reportType: IOHIDReportType, id reportID: CFIndex, _ report: UnsafePointer<UInt8>, length reportLength: CFIndex) -> IOReturn {
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
	@inlinable func setReport(type reportType: IOHIDReportType, id reportID: CFIndex, _ report: UnsafePointer<UInt8>, length reportLength: CFIndex, timeout: CFTimeInterval, callback: IOHIDReportCallback?, context: UnsafeMutableRawPointer?) -> IOReturn {
		return IOHIDDeviceSetReportWithCallback(self, reportType, reportID, report, reportLength, timeout, callback, context)
	}
	
	/// Obtains a report from the device.
	///
	/// This method behaves synchronously and will block until the
	/// report has been received from the device.  This is only intended
	/// for feature reports because of sporadic devicesupport for
	/// polling input reports.  Please defer to using
	/// `registerInputReport(_:length:callback:context:)` for obtaining input
	/// reports.
	/// - parameter reportType: Type of report being requested.
	/// - parameter reportID: ID of the report being requested.
	/// - parameter report: Pointer to preallocated buffer in which to copy inbound
	/// report data.
	/// - parameter pReportLength: Pointer to length of preallocated buffer.  This
	/// value will be modified to refect the length of the returned
	/// report.
	/// - returns: Returns `kIOReturnSuccess` if successful.
	@inlinable func getReport(type reportType: IOHIDReportType, id reportID: CFIndex, _ report: UnsafeMutablePointer<UInt8>, length pReportLength: UnsafeMutablePointer<CFIndex>) -> IOReturn {
		return IOHIDDeviceGetReport(self, reportType, reportID, report, pReportLength)
	}
	
	/// Obtains a report from the device.
	///
	/// This method behaves asynchronously and will block until the
	/// report has been received from the device.  This is only intended
	/// for feature reports because of sporadic devicesupport for
	/// polling input reports.  Please defer to using
	/// `registerInputReport(_:length:callback:context:)` for obtaining input
	/// reports.
	/// - parameter reportType: Type of report being requested.
	/// - parameter reportID: ID of the report being requested.
	/// - parameter report: Pointer to preallocated buffer in which to copy inbound
	/// report data.
	/// - parameter pReportLength: Pointer to length of preallocated buffer.  This
	/// value will be modified to refect the length of the returned
	/// report.
	/// - parameter callback Pointer to a callback method of type
	/// `IOHIDReportCallback`.
	/// - parameter context: Pointer to data to be passed to the callback.
	/// - returns: Returns kIOReturnSuccess if successful.
	@inlinable func getReport(type reportType: IOHIDReportType, id reportID: CFIndex, _ report: UnsafeMutablePointer<UInt8>, length pReportLength: UnsafeMutablePointer<CFIndex>, timeout: CFTimeInterval, callback: @escaping IOHIDReportCallback, context: UnsafeMutableRawPointer) -> IOReturn {
		return IOHIDDeviceGetReportWithCallback(self, reportType, reportID, report, pReportLength, timeout, callback, context)
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
	/// `registerInputReport(_:length:callback:context:)` for obtaining input
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
	
	/// Schedules HID device with run loop.
	///
	/// Formally associates device with client's run loop. Scheduling
	/// this device with the run loop is necessary before making use of
	/// any asynchronous APIs.
	/// - parameter runLoop: `RunLoop` to be used when scheduling any asynchronous
	/// activity.
	/// - parameter runLoopMode: Run loop mode to be used when scheduling any
	/// asynchronous activity.
	func schedule(with runLoop: RunLoop, mode runLoopMode: RunLoop.Mode) {
		schedule(with: runLoop.getCFRunLoop(), mode: runLoopMode.rawValue as CFString)
	}
	
	/// Unschedules HID device with run loop.
	///
	/// Formally disassociates device with client's run loop.
	/// - parameter runLoop: RunLoop to be used when unscheduling any asynchronous
	/// activity.
	/// - parameter runLoopMode: Run loop mode to be used when unscheduling any
	/// asynchronous activity.
	func unschedule(from runLoop: RunLoop, mode runLoopMode: RunLoop.Mode) {
		unschedule(from: runLoop.getCFRunLoop(), mode: runLoopMode.rawValue as CFString)
	}
}
