//
//  misc.swift
//  SwiftIOKitAdditions
//
//  Created by C.W. Betts on 6/14/21.
//  Copyright © 2021 C.W. Betts. All rights reserved.
//

import Foundation
import SwiftAdditions
import IOKit.hid

extension IOHIDDevice: CFTypeProtocol {
	/// The type identifier of all `IOHIDDevice` instances.
	@inlinable public class var typeID: CFTypeID {
		return IOHIDDeviceGetTypeID()
	}
}

extension IOHIDElement: CFTypeProtocol {
	/// Returns the type identifier of all `IOHIDElement` instances.
	@inlinable public class var typeID: CFTypeID {
		return IOHIDElementGetTypeID()
	}
}

extension IOHIDManager: CFTypeProtocol {
	/// The type identifier of all `IOHIDManager` instances.
	@inlinable public class var typeID: CFTypeID {
		return IOHIDManagerGetTypeID()
	}
}

extension IOHIDQueue: CFTypeProtocol {
	/// The type identifier of all IOHIDQueue instances.
	@inlinable public class var typeID: CFTypeID {
		return IOHIDQueueGetTypeID()
	}
}

extension IOHIDTransaction: CFTypeProtocol {
	/// The type identifier of all `IOHIDTransaction` instances.
	@inlinable public class var typeID: CFTypeID {
		return IOHIDTransactionGetTypeID()
	}
}

extension IOHIDValue: CFTypeProtocol {
	/// The type identifier of all `IOHIDValue` instances.
	@inlinable public class var typeID: CFTypeID {
		return IOHIDValueGetTypeID()
	}
}
