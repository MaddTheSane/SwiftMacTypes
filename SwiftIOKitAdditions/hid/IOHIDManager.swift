//
//  IOHIDManager.swift
//  SwiftIOKitAdditions
//
//  Created by C.W. Betts on 12/9/19.
//  Copyright © 2019 C.W. Betts. All rights reserved.
//

import Foundation
import IOKit.hid

public extension IOHIDManager {
	/// Various options that can be supplied to `IOHIDManager` functions.
	typealias Options = IOHIDManagerOptions
	
	/// Creates an `IOHIDManager` object.
	///
	/// The IOHIDManager object is meant as a global management system for
	/// communicating with HID devices.
	/// - parameter allocator: Allocator to be used during creation.
	/// - parameter options: supply `kIOHIDManagerOptionUsePersistentProperties`
	/// to load properties from the default persistent property store. Otherwise
	/// supply `kIOHIDManagerOptionNone` (or 0).
	@inlinable class func create(_ allocator: CFAllocator? = kCFAllocatorDefault, options: Options) -> IOHIDManager {
		return IOHIDManagerCreate(allocator, options.rawValue)
	}
	
	/// Opens the `IOHIDManager`.
	///
	/// This will open both current and future devices that are
	/// enumerated. To establish an exclusive link use the
	/// `kIOHIDOptionsTypeSeizeDevice` option.
	/// - parameter options: Option bits to be sent down to the manager and device.
	/// - returns: Returns `kIOReturnSuccess` if successful.
	@inlinable func `open`(options: Options = []) -> IOReturn {
		return IOHIDManagerOpen(self, options.rawValue)
	}
	
	/// Closes the `IOHIDManager`.
	///
	/// This will also close all devices that are currently enumerated.
	/// - parameter options: Option bits to be sent down to the manager and device.
	/// - returns: Returns `kIOReturnSuccess` if successful.
	@inlinable func close(options: Options = []) -> IOReturn {
		return IOHIDManagerClose(self, options.rawValue)
	}
	
	/// Obtains a property of an `IOHIDManager`.
	///
	/// Property keys are prefixed by kIOHIDDevice and declared in
	/// *<IOKit/hid/IOHIDKeys.h>*.
	/// - parameter key: `String` containing key to be used when querying the
	/// manager.
	/// - returns: Returns `Any` containing the property.
	func getProperty(forKey key: String) -> Any? {
		return IOHIDManagerGetProperty(self, key as NSString)
	}
	
	/// Sets a property for an `IOHIDManager`.
	///
	/// Property keys are prefixed by *kIOHIDDevice* and *kIOHIDManager* and
	/// declared in *<IOKit/hid/IOHIDKeys.h>*. This method will propagate
	/// any relevent properties to current and future devices that are
	/// enumerated.
	/// - parameter key: `String` containing key to be used when modifiying the
	/// device property.
	/// - parameter value: `Any` containing the property value to be set.
	/// - returns: Returns `true` if successful.
	func setProperty(_ value: Any, forKey key: String) -> Bool {
		IOHIDManagerSetProperty(self, key as NSString, value as AnyObject)
	}
	
	/// Schedules HID manager with run loop.
	///
	/// Formally associates manager with client's run loop. Scheduling
	/// this device with the run loop is necessary before making use of
	/// any asynchronous APIs.  This will propagate to current and
	/// future devices that are enumerated.
	/// - parameter runLoop: RunLoop to be used when scheduling any asynchronous activity.
	/// - parameter runLoopMode: Run loop mode to be used when scheduling any
	/// asynchronous activity.
	@inlinable func schedule(with runLoop: CFRunLoop, mode runLoopMode: CFString) {
		IOHIDManagerScheduleWithRunLoop(self, runLoop, runLoopMode)
	}
	
	/// Unschedules HID manager with run loop.
	///
	/// Formally disassociates device with client's run loop. This will
	/// propagate to current devices that are enumerated.
	/// - parameter runLoop: RunLoop to be used when unscheduling any asynchronous
	/// activity.
	/// - parameter runLoopMode: Run loop mode to be used when unscheduling any
	/// asynchronous activity.
	@inlinable func unschedule(from runLoop: CFRunLoop, mode runLoopMode: CFString) {
		IOHIDManagerUnscheduleFromRunLoop(self, runLoop, runLoopMode)
	}
	
	/// Sets the dispatch queue to be associated with the `IOHIDManager`.
	/// This is necessary in order to receive asynchronous events from the kernel.
	///
	/// An `IOHIDManager` should not be associated with both a runloop and
	/// dispatch queue. A call to `setDispatchQueue(_:)` should only be made once.
	///
	/// If a dispatch queue is set but never used, a call to `cancel()` followed
	/// by `activate()` should be performed in that order.
	///
	/// After a dispatch queue is set, the IOHIDManager must make a call to activate
	/// via `activate()` and cancel via `cancel()`. All calls to "Register"
	/// functions should be done before activation and not after cancellation.
	/// - parameter queue: The dispatch queue to which the event handler block will be submitted.
	@available(OSX 10.15, *)
	@inlinable func setDispatchQueue(_ queue: DispatchQueue) {
		IOHIDManagerSetDispatchQueue(self, queue)
	}
	
	/// Sets a cancellation handler for the dispatch queue associated with
	/// `setDispatchQueue(_:)`.
	///
	/// The cancellation handler (if specified) will be will be submitted to the
	/// manager's dispatch queue in response to a call to `cancel()` after all
	/// the events have been handled.
	///
	/// `setCancelHandler(_:)` should not be used when scheduling with
	/// a run loop.
	///
	/// The `IOHIDManager` should only be released after the manager has been
	/// cancelled, and the cancel handler has been called. This is to ensure
	/// all asynchronous objects are released. For example:
	///````
	/// let managerRetained = Unmanaged.passRetained(manager)
	/// let cancelHandler = {
	///     managerRetained.release()
	/// }()
	/// manager.setCancelHandler(cancelHandler)
	/// manager.activate()
	/// manager.cancel()
	///````
	/// - parameter handler: The cancellation handler block to be associated
	/// with the dispatch queue.
	@available(OSX 10.15, *)
	@inlinable func setCancelHandler(_ handler: @escaping () -> Void) {
		IOHIDManagerSetCancelHandler(self, handler)
	}
	
	/// Activates the `IOHIDManager` object.
	///
	/// An `IOHIDManager` object associated with a dispatch queue is created
	/// in an inactive state. The object must be activated in order to
	/// receive asynchronous events from the kernel.
	///
	/// A dispatch queue must be set via `setDispatchQueue(_:)` before
	/// activation.
	///
	/// An activated manager must be cancelled via `cancel()`. All calls
	/// to "Register" functions should be done before activation
	/// and not after cancellation.
	///
	/// Calling `activate()` on an active `IOHIDManager` has no effect.
	@available(OSX 10.15, *)
	@inlinable func activate() {
		IOHIDManagerActivate(self)
	}
	
	/// Cancels the `IOHIDManager` preventing any further invocation
	/// of its event handler block.
	///
	/// Cancelling prevents any further invocation of the event handler block for
	/// the specified dispatch queue, but does not interrupt an event handler
	/// block that is already in progress.
	///
	/// Explicit cancellation of the `IOHIDManager` is required, no implicit
	/// cancellation takes place.
	///
	/// Calling `cancel()` on an already cancelled queue has no effect.
	///
	/// The `IOHIDManager` should only be released after the manager has been
	/// cancelled, and the cancel handler has been called. This is to ensure all
	/// asynchronous objects are released.
	@available(OSX 10.15, *)
	@inlinable func cancel() {
		IOHIDManagerCancel(self)
	}
	
	/// Sets matching criteria for device enumeration.
	///
	/// Matching keys are prefixed by *kIOHIDDevice* and declared in
	/// *<IOKit/hid/IOHIDKeys.h>*.  Passing a `nil` dictionary will result
	/// in all devices being enumerated. Any subsequent calls will cause
	/// the hid manager to release previously enumerated devices and
	/// restart the enuerate process using the revised criteria.  If
	/// interested in multiple, specific device classes, please defer to
	/// using `setDeviceMatching(multiple:)`.
	///
	/// If a dispatch queue is set, this call must occur before activation.
	/// - parameter matching: `Dictionary` containg device matching criteria.
	func setDeviceMatching(_ matching: [String: Any]?) {
		IOHIDManagerSetDeviceMatching(self, matching as NSDictionary?)
	}
	
	/// Sets multiple matching criteria for device enumeration.
	///
	/// Matching keys are prefixed by *kIOHIDDevice* and declared in
	/// *<IOKit/hid/IOHIDKeys.h>*.  This method is useful if interested
	/// in multiple, specific device classes.
	///
	/// If a dispatch queue is set, this call must occur before activation.
	///
	/// - parameter multiple: `Array` containing multiple `Dictionary` objects
	/// containg device matching criteria.
	func setDeviceMatching(multiple: [[String: Any]]?) {
		IOHIDManagerSetDeviceMatchingMultiple(self, multiple as NSArray?)
	}
	
	/// Obtains currently enumerated devices.
	var devices: Set<IOHIDDevice>? {
		return IOHIDManagerCopyDevices(self) as? Set<IOHIDDevice>
	}
	
	/// Registers a callback to be used a device is enumerated.
	///
	/// Only device matching the set criteria will be enumerated.
	/// If a dispatch queue is set, this call must occur before activation.
	/// Devices provided in the callback will be scheduled with the same
	/// runloop/dispatch queue as the IOHIDManagerRef, and should not be
	/// rescheduled.
	/// - parameter callback: Pointer to a callback method of type
	/// `IOHIDDeviceCallback`.
	/// - parameter context: Pointer to data to be passed to the callback.
	@inlinable func registerDeviceMatching(callback: IOHIDDeviceCallback?, context: UnsafeMutableRawPointer?) {
		IOHIDManagerRegisterDeviceMatchingCallback(self, callback, context)
	}
	
	/// Registers a callback to be used when any enumerated device is
	/// removed.
	///
	/// In most cases this occurs when a device is unplugged.
	/// If a dispatch queue is set, this call must occur before activation.
	/// - parameter callback: Pointer to a callback method of type
	/// `IOHIDDeviceCallback`.
	/// - parameter context: Pointer to data to be passed to the callback.
	@inlinable func registerDeviceRemoval(callback: IOHIDDeviceCallback?, context: UnsafeMutableRawPointer?) {
		IOHIDManagerRegisterDeviceRemovalCallback(self, callback, context)
	}

	/// Registers a callback to be used when an input report is issued by
	/// any enumerated device.
	///
	/// An input report is an interrupt driver report issued by a device.
	/// If a dispatch queue is set, this call must occur before activation.
	/// - parameter callback: Pointer to a callback method of type `IOHIDReportCallback`.
	/// - parameter context: Pointer to data to be passed to the callback.
	@inlinable func registerInputReport(callback: IOHIDReportCallback?, context: UnsafeMutableRawPointer?) {
		IOHIDManagerRegisterInputReportCallback(self, callback, context)
	}

	/// Registers a callback to be used when an input report is issued by
	/// any enumerated device.
	///
	/// An input report is an interrupt driver report issued by a device.
	///
	/// If a dispatch queue is set, this call must occur before activation.
	/// - parameter callback: Pointer to a callback method of type
	/// `IOHIDReportWithTimeStampCallback`.
	/// - parameter context: Pointer to data to be passed to the callback.
	@available(OSX 10.15, *)
	@inlinable func registerInputReportWithTimeStamp(callback: @escaping IOHIDReportWithTimeStampCallback, context: UnsafeMutableRawPointer?) {
		IOHIDManagerRegisterInputReportWithTimeStampCallback(self, callback, context)
	}

	/// Registers a callback to be used when an input value is issued by
	/// any enumerated device.
	///
	/// An input element refers to any element of type
	/// `kIOHIDElementTypeInput` and is usually issued by interrupt driven
	/// reports.
	///
	/// If a dispatch queue is set, this call must occur before activation.
	/// - parameter callback: Pointer to a callback method of type IOHIDValueCallback.
	/// - parameter context: Pointer to data to be passed to the callback.
	@inlinable func registerInputValue(callback: IOHIDValueCallback?, context: UnsafeMutableRawPointer?) {
		IOHIDManagerRegisterInputValueCallback(self, callback, context)
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
		IOHIDManagerSetInputValueMatching(self, matching as NSDictionary?)
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
	/// containing input element matching criteria.
	func setInputValueMatching(multiple: [[String: Any]]?) {
		IOHIDManagerSetInputValueMatchingMultiple(self, multiple as NSArray?)
	}

	/// Used to write out the current properties to a specific domain.
	///
	/// Using this function will cause the persistent properties to be saved out
	/// replacing any properties that already existed in the specified domain.
	/// - parameter applicationID: Reference to a CFPreferences applicationID.
	/// - parameter userName: Reference to a CFPreferences userName.
	/// - parameter hostName: Reference to a CFPreferences hostName.
	/// - parameter options: Reserved for future use.
	func saveToPropertyDomain(applicationID: String, userName: String, hostName: String, options: IOOptionBits = 0) {
		IOHIDManagerSaveToPropertyDomain(self, applicationID as NSString, userName as NSString, hostName as NSString, options)
	}
}

public extension IOHIDManager {
	/// Unschedules HID manager with run loop.
	///
	/// Formally disassociates device with client's run loop. This will
	/// propagate to current devices that are enumerated.
	/// - parameter runLoop: RunLoop to be used when unscheduling any asynchronous
	/// activity.
	/// - parameter runLoopMode: Run loop mode to be used when unscheduling any
	/// asynchronous activity.
	func unschedule(from runLoop: RunLoop, mode runLoopMode: RunLoop.Mode) {
		unschedule(from: runLoop.getCFRunLoop(), mode: runLoopMode.rawValue as CFString)
	}
	
	/// Schedules HID manager with run loop.
	///
	/// Formally associates manager with client's run loop. Scheduling
	/// this device with the run loop is necessary before making use of
	/// any asynchronous APIs.  This will propagate to current and
	/// future devices that are enumerated.
	/// - parameter runLoop: RunLoop to be used when scheduling any asynchronous activity.
	/// - parameter runLoopMode: Run loop mode to be used when scheduling any
	/// asynchronous activity.
	func schedule(with runLoop: RunLoop, mode runLoopMode: RunLoop.Mode) {
		schedule(with: runLoop.getCFRunLoop(), mode: runLoopMode.rawValue as CFString)
	}
}
