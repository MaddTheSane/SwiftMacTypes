//
//  IOHIDElement.swift
//  SwiftIOKitAdditions
//
//  Created by C.W. Betts on 12/9/19.
//  Copyright © 2019 C.W. Betts. All rights reserved.
//

import Foundation
import IOKit.hid

public extension IOHIDElement {
	typealias CollectionType = IOHIDElementCollectionType
	
	/// Represent a unique identifier for an element within a device.
	typealias Cookie = IOHIDElementCookie
	
	/// Describes different types of HID elements.
	///
	/// Used by the IOHIDFamily to identify the type of element processed. Represented by the key `kIOHIDElementTypeKey` in the dictionary describing the element.
	typealias ElementType = IOHIDElementType
	
	/// Creates an element from a dictionary.
	///
	/// The dictionary should contain keys defined in *IOHIDKeys.h* and start with *kIOHIDElement*.  This call is meant be used by a `IOHIDDeviceDeviceInterface` object.
	/// - parameter allocator: Allocator to be used during creation.
	/// - parameter dictionary: dictionary containing values in which to create element.
	/// - returns: Returns a new `IOHIDElement`.
	@inlinable class func create(_ allocator: CFAllocator? = kCFAllocatorDefault, with dictionary: [String: Any]) -> IOHIDElement {
		return IOHIDElementCreateWithDictionary(allocator, dictionary as NSDictionary)
	}
	
	/// The device associated with the element.
	@inlinable var device: IOHIDDevice {
		return IOHIDElementGetDevice(self)
	}
	
	/// The parent for the element.
	///
	/// The parent element can be an element of type `kIOHIDElementTypeCollection`.
	@inlinable var parent: IOHIDElement? {
		return IOHIDElementGetParent(self)
	}
	
	/// The children for the element.
	///
	/// An element of type `kIOHIDElementTypeCollection` usually contains children.
	var children: [IOHIDElement]? {
		return IOHIDElementGetChildren(self) as? [IOHIDElement]
	}
	
	/// Establish a relationship between one or more elements.
	///
	/// This is useful for grouping HID elements with related functionality.
	/// - parameter toAttach: The element to be attached.
	@inlinable func attach(_ toAttach: IOHIDElement) {
		IOHIDElementAttach(self, toAttach)
	}
	
	/// Remove a relationship between one or more elements.
	///
	/// This is useful for grouping HID elements with related functionality.
	/// - parameter toDetach: The element to be detached.
	@inlinable func detatch(_ toDetach: IOHIDElement) {
		return IOHIDElementDetach(self, toDetach)
	}
	
	/// Obtain attached elements.
	///
	/// Attached elements are those that have been grouped via `attach(_:)`.
	var attached: [IOHIDElement]? {
		return IOHIDElementCopyAttached(self) as? [IOHIDElement]
	}
	
	/// Retrieves the cookie for the element.
	///
	/// The `Cookie` represent a unique identifier for an element within a device.
	@inlinable var cookie: Cookie {
		return IOHIDElementGetCookie(self)
	}
	
	/// The type for the element.
	@inlinable var elementType: ElementType {
		return IOHIDElementGetType(self)
	}
	
	/// The collection type for the element.
	///
	/// The value returned by this method only makes sense if the element type is `kIOHIDElementTypeCollection`.
	@inlinable var collectionType: CollectionType {
		return IOHIDElementGetCollectionType(self)
	}
	
	/// The usage page for the element.
	@inlinable var usagePage: UInt32 {
		return IOHIDElementGetUsagePage(self)
	}
	
	/// The usage for the element.
	@inlinable var usage: UInt32 {
		return IOHIDElementGetUsage(self)
	}
	
	/// The virtual property for the element.
	///
	/// Indicates whether the element is a virtual element.
	@inlinable var isVirtual: Bool {
		return IOHIDElementIsVirtual(self)
	}

	/// The relative property for the element.
	///
	/// Indicates whether the data is relative (indicating the change in value from the last report) or absolute
	/// (based on a fixed origin).
	///
	/// Is `true` if relative or `false` if absolute.
	@inlinable var isRelative: Bool {
		return IOHIDElementIsRelative(self)
	}
	
	/// The wrap property for the element.
	///
	/// Wrap indicates whether the data "rolls over" when reaching either the extreme high or low value.
	@inlinable var isWrapping: Bool {
		return IOHIDElementIsWrapping(self)
	}
	
	/// The array property for the element.
	///
	/// Indicates whether the element represents variable or array data values. Variable values represent data from a
	/// physical control.  An array returns an index in each field that corresponds to the pressed button
	/// (like keyboard scan codes).
	///
	/// **Note:** The HID Manager will represent most elements as "variable" including the possible usages of an array.
	/// Array indices will remain as "array" elements with a usage of `0xffffffff`.
	@inlinable var isArray: Bool {
		return IOHIDElementIsArray(self)
	}
	
	/// Returns the linear property for the element.
	///
	/// Indicates whether the value for the element has been processed in some way, and no longer represents a linear
	/// relationship between what is measured and the value that is reported.
	@inlinable var isNonLinear: Bool {
		return IOHIDElementIsNonLinear(self)
	}
	
	/// The preferred state property for the element.
	///
	/// Indicates whether the element has a preferred state to which it will return when the user is not physically
	/// interacting with the control.
	@inlinable var hasPreferredState: Bool {
		return IOHIDElementHasPreferredState(self)
	}
	
	/// The null state property for the element.
	///
	/// Indicates whether the element has a state in which it is not sending meaningful data.
	@inlinable var hasNullState: Bool {
		return IOHIDElementHasNullState(self)
	}
	
	/// The name for the element.
	var name: String {
		return IOHIDElementGetName(self) as String
	}
	
	/// The report ID for the element.
	///
	/// The report ID represents what report this particular element belongs to.
	@inlinable var reportID: UInt32 {
		return IOHIDElementGetReportID(self)
	}
	
	/// The report size in bits for the element.
	@inlinable var reportSize: UInt32 {
		return IOHIDElementGetReportSize(self)
	}
	
	/// The report count for the element.
	@inlinable var reportCount: UInt32 {
		return IOHIDElementGetReportCount(self)
	}
	
	/// The unit property for the element.
	///
	/// The unit property is described in more detail in Section 6.2.2.7 of the
	/// "Device Class Definition for Human Interface Devices(HID)" Specification, Version 1.11.
	@inlinable var unit: UInt32 {
		return IOHIDElementGetUnit(self)
	}
	
	/// The unit exponenet in base 10 for the element.
	///
	/// The unit exponent property is described in more detail in Section 6.2.2.7 of the
	/// "Device Class Definition for Human Interface Devices(HID)" Specification, Version 1.11.
	@inlinable var unitExponent: UInt32 {
		return IOHIDElementGetUnitExponent(self)
	}

	/// The minimum value possible for the element.
	///
	/// This corresponds to the logical minimun, which indicates the lower bounds of a variable element.
	@inlinable var logicalMin: CFIndex {
		return IOHIDElementGetLogicalMin(self)
	}
	
	/// The maximum value possible for the element.
	///
	/// This corresponds to the logical maximum, which indicates the upper bounds of a variable element.
	@inlinable var logicalMax: CFIndex {
		return IOHIDElementGetLogicalMax(self)
	}
	
	/// The scaled minimum value possible for the element.
	///
	/// Minimum value for the physical extent of a variable element. This represents the value for the logical minimum with units applied to it.
	@inlinable var physicalMin: CFIndex {
		return IOHIDElementGetPhysicalMin(self)
	}
	
	/// The scaled maximum value possible for the element.
	///
	/// Maximum value for the physical extent of a variable element.  This represents the value for the logical maximum with units applied to it.
	@inlinable var physicalMax: CFIndex {
		return IOHIDElementGetPhysicalMax(self)
	}
	
	/// Returns the an element property.
	///
	/// Property keys are prefixed by *kIOHIDElement* and declared in *IOHIDKeys.h*.
	/// - parameter key: The key to be used when querying the element.
	/// - returns: Returns the property.
	func getProperty(forKey key: String) -> Any? {
		return IOHIDElementGetProperty(self, key as NSString)
	}
	
	/// Sets an element property.
	///
	/// This method can be used to set arbitrary element properties, such as application specific references.
	/// - parameter key: The key to be used when querying the element.
	/// - returns: Returns `true` if successful.
	func setProperty(_ property: Any, forKey key: String) -> Bool {
		return IOHIDElementSetProperty(self, key as NSString, property as AnyObject)
	}
}
