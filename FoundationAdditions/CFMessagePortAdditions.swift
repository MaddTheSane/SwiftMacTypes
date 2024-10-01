//
//  CFMessagePortAdditions.swift
//  FoundationAdditions
//
//  Created by C.W. Betts on 9/30/24.
//  Copyright © 2024 C.W. Betts. All rights reserved.
//

#if os(OSX) || os(iOS) || os(tvOS) || targetEnvironment(macCatalyst) || os(visionOS)

import Foundation
import CoreFoundation

// TODO: documentation
public extension CFMessagePort {
	/// A Boolean value that indicates whether this object represents a remote port.
	@inlinable var isRemote: Bool {
		return CFMessagePortIsRemote(self)
	}
	
	/// The name with which a `CFMessagePort` object is registered.
	///
	/// The registered name of the port, `nil` if unnamed.
	var name: String? {
		get {
			return CFMessagePortGetName(self) as String?
		}
	}
	
	/// Sets the name of a local `CFMessagePort` object.
	/// - parameter name: The new name for ms.
	/// - returns: `true` if the name change succeeds, otherwise `false`.
	func setName(_ name: String?) -> Bool {
		return CFMessagePortSetName(self, name as CFString?)
	}
	
	/// Invalidates this `CFMessagePort` object, stopping it from receiving or sending any more messages.
	///
	/// Invalidating a message port prevents the port from ever sending or receiving any more messages; the message
	/// port is not deallocated, though. If the port has not already been invalidated, the port’s invalidation callback function
	/// is invoked, if one has been set with `CFMessagePortSetInvalidationCallBack(_:_:)` or the
	/// `invalidationCallBack` variable. The `CFMessagePortContext` info
	/// information for this object is also released, if a `release` callback was specified in the port’s context structure. Finally, if a run
	/// loop source was created for the message port, the run loop source is also invalidated.
	@inlinable func invalidate() {
		CFMessagePortInvalidate(self)
	}
	
	/// A Boolean value that indicates whether the current `CFMessagePort` object is valid and able to send or receive messages.
	@inlinable var isValid: Bool {
		return CFMessagePortIsValid(self)
	}
	
	/// The invalidation callback function of this `CFMessagePort` object.
	///
	/// When setting, if the message port is already invalid, the invalidation callback is invoked immediately.
	@inlinable var invalidationCallBack: CFMessagePortInvalidationCallBack? {
		get {
			return CFMessagePortGetInvalidationCallBack(self)
		}
		set {
			CFMessagePortSetInvalidationCallBack(self, newValue)
		}
	}
	
	/// `nil` replyMode argument means no return value expected, don't wait for it.
	func sendRequest(messageID: Int32, data: CFData, sendTimeout: TimeInterval, receiveTimeout: TimeInterval, replyMode: String?, returnData: AutoreleasingUnsafeMutablePointer<NSData?>?) -> Int32 {
		let toRet: Int32
		if let returnData {
			var theDat: Unmanaged<CFData>? = nil
			toRet = CFMessagePortSendRequest(self, messageID, data, sendTimeout, receiveTimeout, replyMode as CFString?, &theDat)
			returnData.pointee = theDat?.takeRetainedValue()
		} else {
			toRet = CFMessagePortSendRequest(self, messageID, data, sendTimeout, receiveTimeout, replyMode as CFString?, nil)
		}
		
		return toRet
	}
	
	@inlinable func createRunLoopSource(allocator: CFAllocator = kCFAllocatorDefault, order: CFIndex = 0) -> CFRunLoopSource {
		return CFMessagePortCreateRunLoopSource(allocator, self, order)
	}
	
	/// Schedules callbacks for the specified message port on the specified dispatch queue.
	/// - parameter queue: The libdispatch queue.
	@inlinable func setDispatchQueue(_ queue: DispatchQueue) {
		CFMessagePortSetDispatchQueue(self, queue)
	}
	
	var context: CFMessagePortContext {
		var context: CFMessagePortContext = .init()
		CFMessagePortGetContext(self, &context)
		return context
	}
	
	/// Returns a local `CFMessagePort` object.
	/// - parameter allocator: The allocator to use to allocate memory for the new object. Pass `kCFAllocatorDefault` to use the current default allocator. Default is `kCFAllocatorDefault`.
	/// - parameter name: The name with which to register the port. name can be `nil`.
	/// - parameter callout: The callback function invoked when a message is received on the message port.
	/// - parameter context: A structure holding contextual information for the message port. The function copies the information out of the structure, so the memory pointed to by context does not need to persist beyond the function call.
	/// - parameter shouldFreeInfo: A flag set by the function to indicate whether the info member of context should be freed. The flag is set to `true` on failure or if a local port named `name` already exists, `false` otherwise. `shouldFreeInfo` can be `nil`.
	/// - returns: The new `CFMessagePort` object, or `nil` on failure. If a local port is already named `name`, the function returns that port instead of creating a new object; the `context` and `callout` parameters are ignored in this case.
	@inlinable static func createLocal(allocator: CFAllocator = kCFAllocatorDefault, name: String?, callout: CFMessagePortCallBack, context: UnsafeMutablePointer<CFMessagePortContext>, shouldFreeInfo:  UnsafeMutablePointer<DarwinBoolean>?) -> CFMessagePort? {
		return CFMessagePortCreateLocal(allocator, name as CFString?, callout, context, shouldFreeInfo)
	}
	
	/// Returns a `CFMessagePort` object connected to a remote port.
	/// - parameter allocator: The allocator to use to allocate memory for the new object. Pass `kCFAllocatorDefault` to use the current default allocator. Default is `kCFAllocatorDefault`.
	/// - parameter name: The name of the remote message port to which to connect.
	/// - returns: The new `CFMessagePort` object, or `nil` on failure.
	/// If a message port has already been created for the remote port, the pre-existing object is returned.
	@inlinable static func createRemote(allocator: CFAllocator = kCFAllocatorDefault, name: String) -> CFMessagePort? {
		return CFMessagePortCreateRemote(allocator, name as CFString)
	}
}

#endif
