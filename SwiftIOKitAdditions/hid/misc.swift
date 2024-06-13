//
//  misc.swift
//  SwiftIOKitAdditions
//
//  Created by C.W. Betts on 6/14/21.
//  Copyright © 2021 C.W. Betts. All rights reserved.
//

import Foundation
import FoundationAdditions
import IOKit.hid

extension IOHIDDevice: @retroactive CFTypeProtocol {
	/// The type identifier of all `IOHIDDevice` instances.
	@inlinable public class var typeID: CFTypeID {
		return IOHIDDeviceGetTypeID()
	}
}

extension IOHIDElement: @retroactive CFTypeProtocol {
	/// Returns the type identifier of all `IOHIDElement` instances.
	@inlinable public class var typeID: CFTypeID {
		return IOHIDElementGetTypeID()
	}
}

extension IOHIDManager: @retroactive CFTypeProtocol {
	/// The type identifier of all `IOHIDManager` instances.
	@inlinable public class var typeID: CFTypeID {
		return IOHIDManagerGetTypeID()
	}
}

extension IOHIDQueue: @retroactive CFTypeProtocol {
	/// The type identifier of all IOHIDQueue instances.
	@inlinable public class var typeID: CFTypeID {
		return IOHIDQueueGetTypeID()
	}
}

extension IOHIDTransaction: @retroactive CFTypeProtocol {
	/// The type identifier of all `IOHIDTransaction` instances.
	@inlinable public class var typeID: CFTypeID {
		return IOHIDTransactionGetTypeID()
	}
}

extension IOHIDValue: @retroactive CFTypeProtocol {
	/// The type identifier of all `IOHIDValue` instances.
	@inlinable public class var typeID: CFTypeID {
		return IOHIDValueGetTypeID()
	}
}
