//
//  CFTypeProtocol.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 5/29/21.
//  Copyright © 2021 C.W. Betts. All rights reserved.
//

import Foundation

/// For classes that are Core Foundation objects (Can be passed to `CFRetain`, `CFRelease`, etc.)
/// and have a `*GetTypeID()` function.
public protocol CFTypeProtocol: AnyObject {
	/// The type identifier of the specified opaque type.
	static var typeID: CFTypeID {get}
}

extension CFString: CFTypeProtocol {
	/// The type identifier for the `CFString` opaque type.
	///
	/// `CFMutableString` objects have the same type identifier as
	/// `CFString` objects.
	@inlinable public static var typeID: CFTypeID {
		return CFStringGetTypeID()
	}
}

extension CFNumber: CFTypeProtocol {
	/// The type identifier for the `CFNumber` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFNumberGetTypeID()
	}
}

extension CFBoolean: CFTypeProtocol {
	/// Core Foundation type identifier for the `CFBoolean` opaque type.
	@inlinable public static var typeID: CFTypeID {
		CFBooleanGetTypeID()
	}
}

extension CFURL: CFTypeProtocol {
	/// The type identifier for the `CFURL` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFURLGetTypeID()
	}
}

extension CFArray: CFTypeProtocol {
	/// The type identifier for the CFArray opaque type.
	///
	/// `CFMutableArray` objects have the same type identifier as
	/// `CFArray` objects.
	@inlinable public static var typeID: CFTypeID {
		return CFArrayGetTypeID()
	}
}

extension CFDictionary: CFTypeProtocol {
	/// The type identifier for the `CFDictionary` opaque type.
	///
	/// `CFMutableDictionary` objects have the same type identifier as
	/// `CFDictionary` objects.
	@inlinable public static var typeID: CFTypeID {
		return CFDictionaryGetTypeID()
	}
}

extension CFBag: CFTypeProtocol {
	/// The type identifier for the `CFBag` opaque type.
	///
	/// `CFMutableBag` objects have the same type identifier as
	/// `CFBag` objects.
	@inlinable public static var typeID: CFTypeID {
		return CFBagGetTypeID()
	}
}

extension CFBitVector: CFTypeProtocol {
	/// The type identifier for the `CFBitVector` opaque type.
	///
	/// `CFMutableBitVector` objects have the same type identifier as `CFBitVector` objects.
	@inlinable public class var typeID: CFTypeID {
		return CFBitVectorGetTypeID()
	}
}

extension CFBinaryHeap: CFTypeProtocol {
	/// The type identifier for the `CFBinaryHeap` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFBinaryHeapGetTypeID()
	}
}

extension CFBundle: CFTypeProtocol {
	/// The type identifier for the `CFBundle` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFBundleGetTypeID()
	}
}

extension CFCalendar: CFTypeProtocol {
	/// The type identifier for the `CFCalendar` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFCalendarGetTypeID()
	}
}

extension CFFileDescriptor: CFTypeProtocol {
	/// The type identifier for the `CFFileDescriptor` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFFileDescriptorGetTypeID()
	}
}

extension CFFileSecurity: CFTypeProtocol {
	/// The type identifier for the `CFFileSecurity` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFFileSecurityGetTypeID()
	}
}

extension CFLocale: CFTypeProtocol {
	/// The type identifier for the `CFLocale` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFLocaleGetTypeID()
	}
}

extension CFMachPort: CFTypeProtocol {
	/// The type identifier for the `CFMachPort` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFMachPortGetTypeID()
	}
}

extension CFMessagePort: CFTypeProtocol {
	/// The type identifier for the `CFMessagePort` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFMessagePortGetTypeID()
	}
}

extension CFNotificationCenter: CFTypeProtocol {
	/// The type identifier for the `CFNotificationCenter` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFNotificationCenterGetTypeID()
	}
}

extension CFNumberFormatter: CFTypeProtocol {
	/// The type identifier for the `CFNumberFormatter` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFNumberFormatterGetTypeID()
	}
}

extension CFPlugIn: CFTypeProtocol {
	/// The type identifier for the `CFPlugIn` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFPlugInGetTypeID()
	}
}

extension CFRunLoop: CFTypeProtocol {
	/// The type identifier for the `CFRunLoop` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFRunLoopGetTypeID()
	}
}

extension CFSet: CFTypeProtocol {
	/// The type identifier for the `CFSet` opaque type.
	///
	/// `CFMutableSet` has the same type identifier as `CFSet`.
	@inlinable public static var typeID: CFTypeID {
		return CFSetGetTypeID()
	}
}

extension CFSocket: CFTypeProtocol {
	/// The type identifier for the `CFSocket` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFSocketGetTypeID()
	}
}

extension CFReadStream: CFTypeProtocol {
	/// The type identifier for the `CFReadStream` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFReadStreamGetTypeID()
	}
}

extension CFWriteStream: CFTypeProtocol {
	/// The type identifier for the `CFWriteStream` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFWriteStreamGetTypeID()
	}
}

extension CFStringTokenizer: CFTypeProtocol {
	/// The type identifier for the `CFStringTokenizer` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFStringTokenizerGetTypeID()
	}
}

extension CFTimeZone: CFTypeProtocol {
	/// The type identifier for the `CFTimeZone` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFTimeZoneGetTypeID()
	}
}

extension CFTree: CFTypeProtocol {
	/// The type identifier for the `CFTree` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFTreeGetTypeID()
	}
}

extension CFURLEnumerator: CFTypeProtocol {
	/// The type identifier for the `CFURLEnumerator` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFURLEnumeratorGetTypeID()
	}
}

extension CFUserNotification: CFTypeProtocol {
	/// The type identifier for the `CFUserNotification` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFUserNotificationGetTypeID()
	}
}

extension CFUUID: CFTypeProtocol {
	/// The type identifier for the `CFUUID` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFUUIDGetTypeID()
	}
}

extension CFCharacterSet: CFTypeProtocol {
	/// The type identifier for the `CFCharacterSet` opaque type.
	///
	/// `CFMutableCharacterSet` objects have the same type identifier
	/// as `CFCharacterSet` objects.
	@inlinable public static var typeID: CFTypeID {
		return CFCharacterSetGetTypeID()
	}
}

extension CFDateFormatter: CFTypeProtocol {
	/// The type identifier for the `CFDateFormatter` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFDateFormatterGetTypeID()
	}
}

extension CFError: CFTypeProtocol {
	/// The type identifier for the `CFError` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFErrorGetTypeID()
	}
}

extension CFData: CFTypeProtocol {
	/// The type identifier for the `CFData` opaque type.
	///
	/// `CFMutableData` objects have the same type identifier as
	/// `CFData` objects.
	@inlinable public static var typeID: CFTypeID {
		return CFDataGetTypeID()
	}
}

extension CFDate: CFTypeProtocol {
	/// The type identifier for the `CFDate` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFDateGetTypeID()
	}
}

extension CFAttributedString: CFTypeProtocol {
	/// The type identifier for the `CFAttributedString` opaque type.
	@inlinable public static var typeID: CFTypeID {
		return CFAttributedStringGetTypeID()
	}
}

/// Checks to see if the passed in object is a CoreFoundation of type `aType`.
/// - parameter theType: The object to test.
/// - parameter aType: The class to test against.
/// - returns: `true` if `theType` is of type `aType`, `false` otherwise.
public func cfType<A: CFTypeProtocol>(_ theType: AnyObject, isOf aType: A.Type) -> Bool {
	return CFGetTypeID(theType) == aType.typeID
}

/// Dynamically cast the type `theType` to `aType`, returning `nil` if it can't be done.
/// - parameter theType: The object to cast.
/// - parameter aType: The class to cast to.
/// - returns: `theType` cast to `aType`, if it is of `aType`, `nil` otherwise.
public func castCFType<A: CFTypeProtocol>(_ theType: AnyObject, to aType: A.Type) -> A? {
	guard cfType(theType, isOf: aType) else {
		return nil
	}
	return (theType as! A)
}
