//
//  IOHIDTransaction.swift
//  SwiftIOKitAdditions
//
//  Created by C.W. Betts on 12/17/19.
//  Copyright © 2019 C.W. Betts. All rights reserved.
//

import Foundation
import IOKit.hid

public extension IOHIDTransaction {
	/// Direction for an `IOHIDDeviceTransactionInterface`.
	typealias DirectionType = IOHIDTransactionDirectionType
	
	/// Various options that can be supplied to `IOHIDTransaction` functions.
	typealias Options = IOHIDTransactionOptions
	
	/// Creates an `IOHIDTransaction` object for the specified device.
	///
	/// `IOHIDTransaction` objects can be used to either send or receive
	/// multiple element values.  As such the direction used should
	/// represent they type of objects added to the transaction.
	/// - parameter allocator: Allocator to be used during creation.
	/// - parameter device: `IOHIDDevice` object
	/// - parameter direction: The direction, either in or out, for the transaction.
	/// - parameter options: Reserved for future use.
	/// - returns: Returns a new `IOHIDTransaction`.
	@inlinable class func create(_ allocator: CFAllocator? = kCFAllocatorDefault, device: IOHIDDevice, direction: DirectionType, options: IOOptionBits = 0) -> IOHIDTransaction? {
		return IOHIDTransactionCreate(allocator, device, direction, options)
	}
	
	/// The device associated with the transaction.
	@inlinable var device: IOHIDDevice {
		return IOHIDTransactionGetDevice(self)
	}
	
	/// The direction of the transaction.
	///
	/// This method is useful for manipulating bi-direction (feature)
	/// elements such that you can set or get element values without
	/// creating an additional transaction object.
	@inlinable var direction: DirectionType {
		get {
			return IOHIDTransactionGetDirection(self)
		}
		set {
			IOHIDTransactionSetDirection(self, newValue)
		}
	}
	
	/// Adds an element to the transaction
	///
	/// To minimize device traffic it is important to add elements that
	/// share a common report type and report id.
	/// - parameter element: Element to be added to the transaction.
	@inlinable func add(_ element: IOHIDElement) {
		IOHIDTransactionAddElement(self, element)
	}
	
	/// Removes an element to the transaction
	/// - parameter element: Element to be removed to the transaction.
	@inlinable func remove(_ element: IOHIDElement) {
		IOHIDTransactionRemoveElement(self, element)
	}
	
	/// Queries the transaction to determine if elemement has been added.
	/// - parameter element: Element to be queried.
	/// - returns: Returns `true` or `false` depending if element is present.
	@inlinable func contains(_ element: IOHIDElement) -> Bool {
		return IOHIDTransactionContainsElement(self, element)
	}
	
	/// Schedules transaction with run loop.
	///
	/// Formally associates transaction with client's run loop.
	/// Scheduling this transaction with the run loop is necessary
	/// before making use of any asynchronous APIs.
	/// - parameter runLoop: RunLoop to be used when scheduling any asynchronous
	/// activity.
	/// - parameter runLoopMode: Run loop mode to be used when scheduling any
	/// asynchronous activity.
	@inlinable func schedule(with runLoop: CFRunLoop, mode runLoopMode: CFString) {
		IOHIDTransactionScheduleWithRunLoop(self, runLoop, runLoopMode)
	}
	
	/// Unschedules transaction with run loop.
	///
	/// Formally disassociates transaction with client's run loop.
	/// - parameter runLoop: RunLoop to be used when scheduling any asynchronous
	/// activity.
	/// - parameter runLoopMode: Run loop mode to be used when scheduling any
	/// asynchronous activity.
	@inlinable func unschedule(from runLoop: CFRunLoop, mode runLoopMode: CFString) {
		IOHIDTransactionUnscheduleFromRunLoop(self, runLoop, runLoopMode)
	}
	
	/// Sets the value for a transaction element.
	///
	/// The value set is pended until the transaction is committed and
	/// is only used if the transaction direction is
	/// `kIOHIDTransactionDirectionTypeOutput`.  Use the
	/// `kIOHIDTransactionOptionDefaultOutputValue` option to set the
	/// default element value.
	/// - parameter value: Value to be set for the given element.
	/// - parameter element: Element to be modified after a commit.
	/// - parameter options: See `IOHIDTransactionOption`.
	@inlinable func setValue(_ value: IOHIDValue, for element: IOHIDElement, options: Options = []) {
		IOHIDTransactionSetValue(self, element, value, options.rawValue)
	}
	
	/// Obtains the value for a transaction element.
	///
	/// If the transaction direction is
	/// `kIOHIDTransactionDirectionTypeInput` the value represents what
	/// was obtained from the device from the transaction.  Otherwise,
	/// if the transaction direction is
	/// `kIOHIDTransactionDirectionTypeOutput` the value represents the
	/// pending value to be sent to the device.  Use the
	/// `kIOHIDTransactionOptionDefaultOutputValue` option to get the
	/// default element value.
	/// - parameter element: Element to be queried.
	/// - parameter options: See `IOHIDTransactionOption`.
	/// - returns: Returns `IOHIDValue` for the given element.
	@inlinable func value(for element: IOHIDElement, options: Options = []) -> IOHIDValue? {
		return IOHIDTransactionGetValue(self, element, options.rawValue)
	}
	
	/// Synchronously commits element transaction to the device.
	///
	/// In regards to `kIOHIDTransactionDirectionTypeOutput` direction,
	/// default element values will be used if element values are not
	/// set.  If neither are set, that element will be omitted from the
	/// commit. After a transaction is committed, transaction element
	/// values will be cleared and default values preserved.
	/// - returns: Returns `kIOReturnSuccess` if successful or a kern_return_t if
	/// unsuccessful.
	@inlinable func commit() -> IOReturn {
		return IOHIDTransactionCommit(self)
	}
	
	/// Commits element transaction to the device.
	///
	/// In regards to `kIOHIDTransactionDirectionTypeOutput` direction,
	/// default element values will be used if element values are not
	/// set.  If neither are set, that element will be omitted from the
	/// commit. After a transaction is committed, transaction element
	/// values will be cleared and default values preserved.
	///
	/// **Note:** It is possible for elements from different reports
	/// to be present in a given transaction causing a commit to
	/// transcend multiple reports. Keep this in mind when setting a
	/// appropriate timeout.
	/// - parameter timeout: Timeout for issuing the transaction.
	///- parameter callback: Callback of type `IOHIDCallback` to be used when
	/// transaction has been completed.  If `nil`, this method will
	/// behave synchronously.
	/// - parameter context: Pointer to data to be passed to the callback.
	/// - returns: Returns `kIOReturnSuccess` if successful or a `kern_return_t` if
	/// unsuccessful.
	@inlinable func commit(timeout: CFTimeInterval, callback: IOHIDCallback?, context: UnsafeMutableRawPointer?) -> IOReturn {
		return IOHIDTransactionCommitWithCallback(self, timeout, callback, context)
	}
	
	/// Clears element transaction values.
	///
	/// In regards to `kIOHIDTransactionDirectionTypeOutput` direction,
	/// default element values will be preserved.
	@inlinable func clear() {
		IOHIDTransactionClear(self)
	}
}

public extension IOHIDTransaction {
	/// Schedules transaction with run loop.
	///
	/// Formally associates transaction with client's run loop.
	/// Scheduling this transaction with the run loop is necessary
	/// before making use of any asynchronous APIs.
	/// - parameter runLoop: RunLoop to be used when scheduling any asynchronous
	/// activity.
	/// - parameter runLoopMode: Run loop mode to be used when scheduling any
	/// asynchronous activity.
	func schedule(with runLoop: RunLoop, mode runLoopMode: RunLoop.Mode) {
		schedule(with: runLoop.getCFRunLoop(), mode: runLoopMode.rawValue as CFString)
	}

	/// Unschedules transaction with run loop.
	///
	/// Formally disassociates transaction with client's run loop.
	/// - parameter runLoop: RunLoop to be used when scheduling any asynchronous
	/// activity.
	/// - parameter runLoopMode: Run loop mode to be used when scheduling any
	/// asynchronous activity.
	func unschedule(from runLoop: RunLoop, mode runLoopMode: RunLoop.Mode) {
		unschedule(from: runLoop.getCFRunLoop(), mode: runLoopMode.rawValue as CFString)
	}
}
