//
//  IOHIDQueue.swift
//  SwiftIOKitAdditions
//
//  Created by C.W. Betts on 12/17/19.
//  Copyright © 2019 C.W. Betts. All rights reserved.
//

import Foundation
import IOKit.hid

public extension IOHIDQueue {
	/// Creates an IOHIDQueue object for the specified device.
	///
	/// Take care in specifying an appropriate depth to prevent dropping
	/// events.
	/// - parameter allocator: Allocator to be used during creation.
	/// - parameter device: `IOHIDDevice` object
	/// - parameter depth: The number of values that can be handled by the queue.
	/// - parameter options: Reserved for future use.
	/// - returns: Returns a new `IOHIDQueue`.
	@inlinable class func create(_ allocator: CFAllocator? = kCFAllocatorDefault, device: IOHIDDevice, depth: CFIndex, options: IOOptionBits = 0) -> IOHIDQueue? {
		return IOHIDQueueCreate(allocator, device, depth, options)
	}
	
	/// The device associated with the queue.
	@inlinable var device: IOHIDDevice {
		return IOHIDQueueGetDevice(self)
	}
	
	/// The depth of the queue
	///
	/// Set the appropriate depth value based on the number of elements
	/// contained in a queue.
	@inlinable var depth: CFIndex {
		get {
			return IOHIDQueueGetDepth(self)
		}
		set {
			IOHIDQueueSetDepth(self, newValue)
		}
	}
	
	/// Adds an element to the queue
	/// - parameter element: Element to be added to the queue.
	@inlinable func add(_ element: IOHIDElement) {
		IOHIDQueueAddElement(self, element)
	}
	
	/// Removes an element from the queue
	/// - parameter element: Element to be removed from the queue.
	@inlinable func remove(_ element: IOHIDElement) {
		IOHIDQueueRemoveElement(self, element)
	}
	
	/// Queries the queue to determine if elemement has been added.
	/// - parameter element: Element to be queried.
	/// - returns: Returns `true` or `false` depending if element is present.
	@inlinable func contains(_ element: IOHIDElement) -> Bool {
		return IOHIDQueueContainsElement(self, element)
	}
	
	/// Starts element value delivery to the queue.
	///
	/// When a dispatch queue is assocaited with the `IOHIDQueue`
	/// via IOHIDQueueSetDispatchQueue, the queue does not need
	/// to be explicity started, this will be done during activation
	/// when `activate()` is called.
	@inlinable func start() {
		IOHIDQueueStart(self)
	}
	
	/// Stops element value delivery to the queue.
	///
	/// When a dispatch queue is assocaited with the `IOHIDQueue`
	/// via IOHIDQueueSetDispatchQueue, the queue does not need
	/// to be explicity stopped, this will be done during cancellation
	/// when `cancel()` is called.
	@inlinable func stop() {
		IOHIDQueueStop(self)
	}
	
	/// Schedules queue with run loop.
	///
	/// Formally associates queue with client's run loop. Scheduling
	/// this queue with the run loop is necessary before making
	/// use of any asynchronous APIs.
	/// - parameter runLoop: RunLoop to be used when scheduling any asynchronous
	/// activity.
	/// - parameter runLoopMode: Run loop mode to be used when scheduling any
	/// asynchronous activity.
	@inlinable func schedule(with runLoop: CFRunLoop, mode runLoopMode: CFString) {
		IOHIDQueueScheduleWithRunLoop(self, runLoop, runLoopMode)
	}
	
	/// Unschedules queue with run loop.
	///
	/// Formally disassociates queue with client's run loop.
	/// - parameter runLoop: RunLoop to be used when scheduling any asynchronous
	/// activity.
	/// - parameter runLoopMode: Run loop mode to be used when scheduling any
	/// asynchronous activity.
	@inlinable func unschedule(from runLoop: CFRunLoop, mode runLoopMode: CFString) {
		IOHIDQueueUnscheduleFromRunLoop(self, runLoop, runLoopMode)
	}

	/// Sets the dispatch queue to be associated with the IOHIDQueue.
	/// This is necessary in order to receive asynchronous events from the kernel.
	///
	/// An `IOHIDQueue` should not be associated with both a runloop and
	/// dispatch queue. A call to `setDispatchQueue(_:)` should only be made once.
	///
	/// If a dispatch queue is set but never used, a call to `cancel()` followed
	/// by `activate()` should be performed in that order.
	///
	/// After a dispatch queue is set, the `IOHIDQueue` must make a call to activate
	/// via `activate()` and cancel via `cancel()`. All calls to "Register"
	/// functions should be done before activation and not after cancellation.
	/// - parameter dispatchQueue: The dispatch queue to which the event handler block will be submitted.
	@available(OSX 10.15, *)
	@inlinable func setDispatchQueue(_ dispatchQueue: DispatchQueue) {
		IOHIDQueueSetDispatchQueue(self, dispatchQueue)
	}
	
	/// Sets a cancellation handler for the dispatch queue associated with
	/// `setDispatchQueue(_:)`.
	///
	/// The cancellation handler (if specified) will be will be submitted to the
	/// queue's dispatch queue in response to a call to `cancel()` after all
	/// the events have been handled.
	///
	/// `setCancelHandler(_:)` should not be used when scheduling with
	/// a run loop.
	///
	/// The `IOHIDQueue` should only be released after the queue has been
	/// cancelled, and the cancel handler has been called. This is to ensure all
	/// asynchronous objects are released. For example:
	///````
	/// let queueRetained = Unmanaged.passRetained(queue)
	/// let cancelHandler = {
	///     queueRetained.release()
	/// }()
	/// queue.setCancelHandler(cancelHandler)
	/// queue.activate()
	/// queue.cancel()
	///````
	/// - parameter handler: The cancellation handler block to be associated with the dispatch queue.
	@available(OSX 10.15, *)
	@inlinable func setCancelHandler(_ handler: @escaping () -> Void) {
		IOHIDQueueSetCancelHandler(self, handler)
	}
	
	/// Activates the `IOHIDQueue` object.
	///
	/// An `IOHIDQueue` object associated with a dispatch queue is created
	/// in an inactive state. The object must be activated in order to
	/// receive asynchronous events from the kernel.
	///
	/// A dispatch queue must be set via `setDispatchQueue(_:)` before
	/// activation.
	///
	/// An activated queue must be cancelled via `cancel()`. All calls
	/// to "Register" functions should be done before activation
	/// and not after cancellation.
	///
	/// Calling `activate()` on an active IOHIDQueue has no effect.
	@available(OSX 10.15, *)
	@inlinable func activate() {
		IOHIDQueueActivate(self)
	}
	
	/// Cancels the `IOHIDQueue` preventing any further invocation
	/// of its event handler block.
	///
	/// Cancelling prevents any further invocation of the event handler block for
	/// the specified dispatch queue, but does not interrupt an event handler
	/// block that is already in progress.
	///
	/// Explicit cancellation of the `IOHIDQueue` is required, no implicit
	/// cancellation takes place.
	///
	/// Calling `cancel()` on an already cancelled queue has no effect.
	///
	/// The `IOHIDQueue` should only be released after the queue has been
	/// cancelled, and the cancel handler has been called. This is to ensure all
	/// asynchronous objects are released.
	@available(OSX 10.15, *)
	@inlinable func cancel() {
		IOHIDQueueCancel(self)
	}
	
	/// Sets callback to be used when the queue transitions to non-empty.
	///
	/// In order to make use of asynchronous behavior, the queue needs
	/// to be scheduled with the run loop or dispatch queue.
	///
	/// If a dispatch queue is set, this call must occur before activation.
	/// - parameter callback: Callback of type `IOHIDCallback` to be used when data is
	/// placed on the queue.
	/// - parameter context: Pointer to data to be passed to the callback.
	@inlinable func registerValueAvailable(callback: @escaping IOHIDCallback, context: UnsafeMutableRawPointer?) {
		IOHIDQueueRegisterValueAvailableCallback(self, callback, context)
	}
	
	/// Dequeues a copy of an element value from the head of an
	/// `IOHIDQueue`.
	///
	/// Use with setValueCallback to avoid polling the queue for data.
	/// - returns: Returns valid `IOHIDValue` if data is available.
	@inlinable func nextValue() -> IOHIDValue? {
		return IOHIDQueueCopyNextValue(self)
	}
	
	/// Dequeues a copy of an element value from the head of an
	/// `IOHIDQueue`.  This method will block until either a value is
	/// available or it times out.
	///
	/// Use with setValueCallback to avoid polling the queue for data.
	/// - parameter timeout: Timeout before aborting an attempt to dequeue a value from the head of a queue.
	/// - returns: Returns valid `IOHIDValue` if data is available.
	@inlinable func nextValue(timeout: CFTimeInterval)  -> IOHIDValue? {
		return IOHIDQueueCopyNextValueWithTimeout(self, timeout)
	}
}

public extension IOHIDQueue {
	/// Schedules queue with run loop.
	///
	/// Formally associates queue with client's run loop. Scheduling
	/// this queue with the run loop is necessary before making
	/// use of any asynchronous APIs.
	/// - parameter runLoop: RunLoop to be used when scheduling any asynchronous
	/// activity.
	/// - parameter runLoopMode: Run loop mode to be used when scheduling any
	/// asynchronous activity.
	func schedule(with runLoop: RunLoop, mode runLoopMode: RunLoop.Mode) {
		schedule(with: runLoop.getCFRunLoop(), mode: runLoopMode.rawValue as CFString)
	}
	
	/// Unschedules queue with run loop.
	///
	/// Formally disassociates queue with client's run loop.
	/// - parameter runLoop: RunLoop to be used when scheduling any asynchronous
	/// activity.
	/// - parameter runLoopMode: Run loop mode to be used when scheduling any
	/// asynchronous activity.
	func unschedule(from runLoop: RunLoop, mode runLoopMode: RunLoop.Mode) {
		unschedule(from: runLoop.getCFRunLoop(), mode: runLoopMode.rawValue as CFString)
	}
}
