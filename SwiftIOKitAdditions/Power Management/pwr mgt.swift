//
//  pwr mgt.swift
//  SwiftIOKitAdditions
//
//  Created by C.W. Betts on 3/2/22.
//  Copyright © 2022 C.W. Betts. All rights reserved.
//

import Foundation
import IOKit.pwr_mgt
import FoundationAdditions

public enum PowerManagement {
	
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
	
	public enum SystemLoadAdvisoryLevelKey: RawRepresentable, @unchecked Sendable {
		/// Indicates user activity constraints on the current SystemLoadAdvisory level.
		case user
		
		/// Indicates battery constraints on the current SystemLoadAdvisory level.
		case battery
		
		/// Indicates thermal constraints on the current SystemLoadAdvisory level.
		case thermal
		
		/// Provides a combined level based on UserLevel, BatteryLevel,
		/// and ThermalLevels; the combined level is the minimum of these levels.
		///
		/// In the future, this combined level may represent new levels as well.
		///
		/// The combined level is identical to the value returned by `IOGetSystemLoadAdvisory()`.
		case combined
		
		public init?(rawValue: String) {
			switch rawValue {
			case kIOSystemLoadAdvisoryUserLevelKey:
				self = .user
				
			case kIOSystemLoadAdvisoryBatteryLevelKey:
				self = .battery
				
			case kIOSystemLoadAdvisoryThermalLevelKey:
				self = .thermal
				
			case kIOSystemLoadAdvisoryCombinedLevelKey:
				self = .combined
				
			default:
				return nil
			}
		}
		
		public var rawValue: String {
			switch self {
			case .user:
				return kIOSystemLoadAdvisoryUserLevelKey
			case .battery:
				return kIOSystemLoadAdvisoryBatteryLevelKey
			case .thermal:
				return kIOSystemLoadAdvisoryThermalLevelKey
			case .combined:
				return kIOSystemLoadAdvisoryCombinedLevelKey
			}
		}
	}
	
	public enum SystemLoadAdvisoryLevel: IOSystemLoadAdvisoryLevel {
		/// A Bad time to perform time-insensitive work.
		case bad = 1
		/// An OK time to perform time-insensitive work.
		case ok = 2
		/// A Good time to perform time-insensitive work.
		case great = 3
	}
	
	/// Indicates how user activity, battery level, and thermal level each
	/// contribute to the overall "SystemLoadAdvisory" level. In the future,
	/// this combined level may represent new levels as well.
	static func detailedSystemLoadAdvisory() -> [SystemLoadAdvisoryLevelKey: SystemLoadAdvisoryLevel]? {
		guard let dict1 = IOCopySystemLoadAdvisoryDetailed()?.takeRetainedValue() as? [String: IOSystemLoadAdvisoryLevel] else {
			return nil
		}
		
		let preDict2 = dict1.compactMap { (k, v) -> (SystemLoadAdvisoryLevelKey, SystemLoadAdvisoryLevel)? in
			guard let k2 = SystemLoadAdvisoryLevelKey(rawValue: k), let v2 = SystemLoadAdvisoryLevel(rawValue: v) else {
				return nil
			}
			return (k2, v2)
		}
		
		return Dictionary(uniqueKeysWithValues: preDict2)
	}
	
	/// Returns a hint about whether now would be a good time to perform time-insensitive
	/// work.
	///
	/// Based on user and system load, IOGetSystemLoadAdvisory determines "better" and "worse"
	/// times to run optional or time-insensitive CPU or disk work.
	///
	/// Applications may use this result to avoid degrading the user experience. If it is a
	/// "Bad" or "OK" time to perform work, applications should slow down and perform work
	/// less aggressively.
	///
	/// There is no guarantee that the system will ever be in "Great" condition to perform work -
	/// all essential work must still be performed even in "Bad", or "OK" times.
	/// Completely optional work, such as updating caches, may be postponed indefinitely.
	///
	/// Note: You may more efficiently read the SystemLoadAdvisory level using `notify_get_state()` instead
	/// of `systemLoadAdvisory`. The results are identical. `notify_get_state()` requires that you
	/// pass the token argument received by registering for *SystemLoadAdvisory* notifications.
	static func systemLoadAdvisory() -> SystemLoadAdvisoryLevel {
		return SystemLoadAdvisoryLevel(rawValue: IOGetSystemLoadAdvisory())!
	}
	
	/// Copy status of all current CPU power levels.
	///
	/// The returned dictionary may define some of these keys,
	/// as defined in IOPM.h:
	/// - kIOPMCPUPowerLimitProcessorSpeedKey
	/// - kIOPMCPUPowerLimitProcessorCountKey
	/// - kIOPMCPUPowerLimitSchedulerTimeKey
	/// - parameter cpuPowerStatus: Upon success, a pointer to a dictionary defining CPU power;
	/// otherwise `nil`. Pointer will be populated with a newly created dictionary
	/// upon successful return.
	/// - returns: `kIOReturnSuccess`, or other error report. Returns `kIOReturnNotFound` if
	/// CPU PowerStatus has not been published.
	static func getCPUPowerStatus(_ cpuPowerStatus: UnsafeMutablePointer<CFDictionary?>?) -> IOReturn {
		var toRet: Unmanaged<CFDictionary>? = nil
		
		let status = IOPMCopyCPUPowerStatus(&toRet)
		if let toRet2 = toRet?.takeRetainedValue() {
			cpuPowerStatus?.pointee = toRet2
		}
		return status
	}
	
//	func getThermalLevel() throws -> UInt32 {
//		var toRet: UInt32 = 0
//		let err = IOPMGetThermalWarningLevel(&toRet)
//		guard err == kIOReturnSuccess else {
//			throw err
//		}
//		return toRet
//	}
}
