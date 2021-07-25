//
//  IOHIDValue.swift
//  SwiftIOKitAdditions
//
//  Created by C.W. Betts on 12/9/19.
//  Copyright © 2019 C.W. Betts. All rights reserved.
//

import Foundation
import IOKit.hid
import Darwin.Mach.mach_time

public extension IOHIDValue {
	/// Creates a new element value using an integer value.
	///
	/// `timeStamp` should represent OS AbsoluteTime, not `CFAbsoluteTime`.
	/// To obtain the OS AbsoluteTime, please reference the APIs declared in *<mach/mach_time.h>*
	/// - parameter allocator: The `CFAllocator` which should be used to allocate memory for the value.
	/// - parameter element: `IOHIDElement` associated with this value.
	/// - parameter timeStamp: OS absolute time timestamp for this value.
	/// - parameter value: Integer value to be copied to this object.
	/// - returns: a reference to a new IOHIDValueRef.
	@inlinable class func create(allocator: CFAllocator? = kCFAllocatorDefault, element: IOHIDElement, timeStamp: UInt64 = mach_absolute_time(), with value: Int) -> IOHIDValue {
		return IOHIDValueCreateWithIntegerValue(allocator, element, timeStamp, value)
	}
	
	/// Creates a new element value using byte data.
	///
	/// `timeStamp` should represent OS AbsoluteTime, not `CFAbsoluteTime`.
	/// To obtain the OS AbsoluteTime, please reference the APIs declared in *<mach/mach_time.h>*
	/// - parameter allocator: The `CFAllocator` which should be used to allocate memory for the value.
	/// - parameter element: `IOHIDElement` associated with this value.
	/// - parameter timeStamp: OS absolute time timestamp for this value.
	/// - parameter bytes: Pointer to a buffer of uint8_t to be copied to this object.
	/// - parameter length: Number of bytes in the passed buffer.
	/// - returns: Returns a reference to a new `IOHIDValue`.
	@inlinable class func create(allocator: CFAllocator? = kCFAllocatorDefault, element: IOHIDElement, timeStamp: UInt64 = mach_absolute_time(), bytes: UnsafePointer<UInt8>, length: CFIndex) -> IOHIDValue? {
		return IOHIDValueCreateWithBytes(allocator, element, timeStamp, bytes, length)
	}
	
	/// Creates a new element value using byte data without performing a copy.
	///
	/// `timeStamp` should represent OS AbsoluteTime, not `CFAbsoluteTime`.
	/// To obtain the OS AbsoluteTime, please reference the APIs declared in *<mach/mach_time.h>*
	/// - parameter allocator: The `CFAllocator` which should be used to allocate memory for the value.
	/// - parameter element: `IOHIDElement` associated with this value.
	/// - parameter timeStamp: OS absolute time timestamp for this value.
	/// - parameter bytes: Pointer to a buffer of uint8_t to be copied to this object.
	/// - parameter length: Number of bytes in the passed buffer.
	/// - returns: Returns a reference to a new `IOHIDValue`.
	@inlinable class func create(allocator: CFAllocator? = kCFAllocatorDefault, element: IOHIDElement, timeStamp: UInt64 = mach_absolute_time(), bytesNoCopy bytes: UnsafePointer<UInt8>, length: CFIndex) -> IOHIDValue? {
		return IOHIDValueCreateWithBytesNoCopy(allocator, element, timeStamp, bytes, length)
	}
	
	/// The element value associated with this `IOHIDValue`.
	@inlinable var element: IOHIDElement {
		return IOHIDValueGetElement(self)
	}
	
	/// The timestamp value contained in this `IOHIDValue`.
	@inlinable var timeStamp: UInt64 {
		return IOHIDValueGetTimeStamp(self)
	}
	
	/// The size, in bytes, of the value contained in this `IOHIDValue`.
	@inlinable var length: Int {
		return IOHIDValueGetLength(self)
	}
	
	/// A byte pointer to the value contained in this `IOHIDValue`.
	@inlinable var bytePtr: UnsafePointer<UInt8> {
		return IOHIDValueGetBytePtr(self)
	}
	
	/// an integer representaion of the value contained in this `IOHIDValue`.
	///
	/// The value is based on the logical element value contained in the report returned by the device.
	@inlinable var integer: Int {
		return IOHIDValueGetIntegerValue(self)
	}
	
	/// Returns an scaled representaion of the value contained in this `IOHIDValue` based on the scale type.
	///
	/// The scaled value is based on the range described by the scale type's min and max, such that:
	/// ````
	/// scaledValue = ((value - min) * (scaledMax - scaledMin) / (max - min)) + scaledMin
	/// ````
	/// **Note:**
	///
	/// There are currently two types of scaling that can be applied:
	/// - **kIOHIDValueScaleTypePhysical**: Scales element value using the physical bounds of the device such that *scaledMin = physicalMin* and *scaledMax = physicalMax*.
	/// - **kIOHIDValueScaleTypeCalibrated**: Scales element value such that *scaledMin = -1* and *scaledMax = 1*.  This value will also take into account the calibration properties associated with this element.
	/// - parameter type: The type of scaling to be performed.
	/// - returns: Returns an scaled floating point representation of the value.
	@inlinable func scaledValue(type: IOHIDValueScaleType) -> double_t {
		return IOHIDValueGetScaledValue(self, type)
	}
}

public extension IOHIDValue {
	var data: Data {
		return Data(bytes: bytePtr, count: length)
	}
	
	/// Creates a new element value using byte data.
	///
	/// `timeStamp` should represent OS AbsoluteTime, not `CFAbsoluteTime`.
	/// To obtain the OS AbsoluteTime, please reference the APIs declared in *<mach/mach_time.h>*
	/// - parameter allocator: The `CFAllocator` which should be used to allocate memory for the value.
	/// - parameter element: `IOHIDElement` associated with this value.
	/// - parameter timeStamp: OS absolute time timestamp for this value.
	/// - parameter data: Data object to be copied to this object.
	/// - returns: Returns a reference to a new `IOHIDValue`.
	class func create(allocator: CFAllocator? = kCFAllocatorDefault, element: IOHIDElement, timeStamp: UInt64 = mach_absolute_time(), data: Data) -> IOHIDValue? {
		return data.withUnsafeBytes { (bufPtr) -> IOHIDValue? in
			return IOHIDValueCreateWithBytes(allocator, element, timeStamp, bufPtr.bindMemory(to: UInt8.self).baseAddress!, bufPtr.count)
		}
	}

}
