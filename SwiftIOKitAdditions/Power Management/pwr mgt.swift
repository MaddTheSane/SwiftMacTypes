//
//  pwr mgt.swift
//  SwiftIOKitAdditions
//
//  Created by C.W. Betts on 3/2/22.
//  Copyright © 2022 C.W. Betts. All rights reserved.
//

import Foundation
import IOKit.pwr_mgt

/// Bits are used in defining `capabilityFlags`, `inputPowerRequirements`, and
/// `outputPowerCharacter` in the `IOPMPowerState` structure.
/// @discussion These bits may be bitwise-OR'd together in the `IOPMPowerState` `capabilityFlags`
/// field, the `outputPowerCharacter` field, and/or the `inputPowerRequirement` field.
///
/// The comments clearly mark whether each flag should be used in the `capabilityFlags` field,
/// `outputPowerCharacter` field, and `inputPowerRequirement` field, or all three.
///
/// The value of `capabilityFlags`, `inputPowerRequirement` or `outputPowerCharacter` may be *0*. Most
/// drivers implement their 'OFF' state, used when asleep, by defining each of the 3 fields as *0*.
///
/// The bits listed below are only the most common bits used to define a device's power states. Your device's
/// IO family may require that your device specify other input or output power flags to interact properly. Consult
/// family-specific documentation to determine if your IOPower plane parents or children require other power flags;
/// they probably don't.
public struct PowerFlags: OptionSet {
	private(set) public var rawValue: UInt
	
	public init(rawValue: UInt) {
		self.rawValue = rawValue
	}
	
	/// Indicates the device is on, requires power, and provides power. Useful as a: *Capability*,
	/// *InputPowerRequirement*, *OutputPowerCharacter*.
	public static var powerOn: PowerFlags {
		return PowerFlags(rawValue: 0x00000002)
	}
	
	/// Indicates the device is usable in this state. Useful only as a *Capability*.
	public static var deviceUsable: PowerFlags {
		return PowerFlags(rawValue: 0x00008000)
	}
	
	/// Indicates device is in a low power state. May be bitwise-OR'd together
	/// with `.deviceUsable` flag, to indicate the device is still usable.
	///
	/// A device with a capability of `.lowPower` may:
	/// - Require either `[]` or `.powerOn` from its power parent
	/// - Offer either `.lowPower`, `.powerOn`, or `[]` (no power at all)
	///      to its power plane children.
	///
	/// Useful only as a *Capability*, although USB drivers should consult USB family documentation for
	/// other valid circumstances to use the `.lowPower` bit.
	public static var lowPower: PowerFlags {
		return PowerFlags(rawValue: 0x00010000)
	}
	
	/// In the capability field of a power state, disallows idle system sleep while the device is in that state.
	///
	/// For example, displays and disks set this capability for their ON power state; since the system may
	/// not idle sleep while the display (and thus keyboard or mouse) or the disk is active.
	///
	/// Useful only as a *Capability*.
	public static var preventIdleSleep: PowerFlags {
		return PowerFlags(rawValue: 0x00000040)
	}
	
	/// Used only by certain IOKit Families (USB). Not defined or used by generic Power Management.
	/// Read your family documentation to see if you should define a powerstate using these capabilities.
	public static var sleepCapability: PowerFlags {
		return PowerFlags(rawValue: 0x00000004)
	}
	
	/// Used only by certain IOKit Families (USB). Not defined or used by generic Power Management.
	/// Read your family documentation to see if you should define a powerstate using these capabilities.
	public static var restartCapability: PowerFlags {
		return PowerFlags(rawValue: 0x00000080)
	}
	
	/// Used only by certain IOKit Families (USB). Not defined or used by generic Power Management.
	/// Read your family documentation to see if you should define a powerstate using these capabilities.
	public static var sleep: PowerFlags {
		return PowerFlags(rawValue: 0x00000001)
	}
	
	/// Used only by certain IOKit Families (USB). Not defined or used by generic Power Management.
	/// Read your family documentation to see if you should define a powerstate using these capabilities.
	public static var restart: PowerFlags {
		return PowerFlags(rawValue: 0x00000080)
	}
	
	/// Indicates the initial power state for the device. If `initialPowerStateForDomainState()` returns
	/// a power state with this flag set in the capability field, then the initial power change is performed
	/// without calling the driver's `setPowerState()`.
	public static var initialDeviceState: PowerFlags {
		return PowerFlags(rawValue: 0x00000100)
	}
	
	/// An indication that the power flags represent the state of the root power
	/// domain. This bit must not be set in the `IOPMPowerState` structure.
	/// Power Management may pass this bit to `initialPowerStateForDomainState()`
	/// to map from a global system state to the desired device state.
	public static var rootDomainState: PowerFlags {
		return PowerFlags(rawValue: 0x00000200)
	}
}
