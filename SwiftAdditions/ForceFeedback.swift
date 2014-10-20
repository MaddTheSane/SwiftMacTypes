//
//  ForceFeedback.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 10/20/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Foundation
import ForceFeedback

public struct ForceFeedbackCommandFlag : RawOptionSetType {
	public typealias RawValue = UInt32
	private var value: RawValue = 0
	public init(_ value: RawValue) { self.value = value }
	public init(rawValue value: RawValue) { self.value = value }
	public init(nilLiteral: ()) { self.value = 0 }
	public static var allZeros: ForceFeedbackCommandFlag { return self(0) }
	public static func fromMask(raw: RawValue) -> ForceFeedbackCommandFlag { return self(raw) }
	public var rawValue: RawValue { return self.value }
	
	public static var Reset: ForceFeedbackCommandFlag { return ForceFeedbackCommandFlag(1 << 0) }
	public static var StopAll: ForceFeedbackCommandFlag { return ForceFeedbackCommandFlag(1 << 1) }
	public static var Pause: ForceFeedbackCommandFlag { return ForceFeedbackCommandFlag(1 << 2) }
	public static var Continue: ForceFeedbackCommandFlag { return ForceFeedbackCommandFlag(1 << 3) }
	public static var SetActuatorsOn: ForceFeedbackCommandFlag { return ForceFeedbackCommandFlag(1 << 4) }
	public static var SetActuatorsOff: ForceFeedbackCommandFlag { return ForceFeedbackCommandFlag(1 << 5) }
}

public struct ForceFeedbackCooperativeLevelFlag : RawOptionSetType {
	public typealias RawValue = UInt32
	private var value: RawValue = 0
	public init(_ value: RawValue) { self.value = value }
	public init(rawValue value: RawValue) { self.value = value }
	public init(nilLiteral: ()) { self.value = 0 }
	public static var allZeros: ForceFeedbackCooperativeLevelFlag { return self(0) }
	public static func fromMask(raw: RawValue) -> ForceFeedbackCooperativeLevelFlag { return self(raw) }
	public var rawValue: RawValue { return self.value }
	
	public static var Exclusive: ForceFeedbackCooperativeLevelFlag { return ForceFeedbackCooperativeLevelFlag(1 << 0) }
	public static var NonExclusive: ForceFeedbackCooperativeLevelFlag { return ForceFeedbackCooperativeLevelFlag(1 << 1) }
	public static var Foreground: ForceFeedbackCooperativeLevelFlag { return ForceFeedbackCooperativeLevelFlag(1 << 2) }
	public static var Background: ForceFeedbackCooperativeLevelFlag { return ForceFeedbackCooperativeLevelFlag(1 << 3) }
}

public struct ForceFeedbackCapabilitiesEffectType : RawOptionSetType {
	public typealias RawValue = UInt32
	private var value: RawValue = 0
	public init(_ value: RawValue) { self.value = value }
	public init(rawValue value: RawValue) { self.value = value }
	public init(nilLiteral: ()) { self.value = 0 }
	public static var allZeros: ForceFeedbackCapabilitiesEffectType { return self(0) }
	public static func fromMask(raw: RawValue) -> ForceFeedbackCapabilitiesEffectType { return self(raw) }
	public var rawValue: RawValue { return self.value }
	
	public static var ConstantForce: ForceFeedbackCapabilitiesEffectType { return ForceFeedbackCapabilitiesEffectType(1 << 0) }
	public static var RampForce: ForceFeedbackCapabilitiesEffectType { return ForceFeedbackCapabilitiesEffectType(1 << 1) }
	public static var Square: ForceFeedbackCapabilitiesEffectType { return ForceFeedbackCapabilitiesEffectType(1 << 2) }
	public static var Sine: ForceFeedbackCapabilitiesEffectType { return ForceFeedbackCapabilitiesEffectType(1 << 3) }
	public static var Triangle: ForceFeedbackCapabilitiesEffectType { return ForceFeedbackCapabilitiesEffectType(1 << 4) }
	public static var SawtoothUp: ForceFeedbackCapabilitiesEffectType { return ForceFeedbackCapabilitiesEffectType(1 << 5) }
	public static var SawtoothDown: ForceFeedbackCapabilitiesEffectType { return ForceFeedbackCapabilitiesEffectType(1 << 6) }
	public static var Spring: ForceFeedbackCapabilitiesEffectType { return ForceFeedbackCapabilitiesEffectType(1 << 7) }
	public static var Damper: ForceFeedbackCapabilitiesEffectType { return ForceFeedbackCapabilitiesEffectType(1 << 8) }
	public static var Inertia: ForceFeedbackCapabilitiesEffectType { return ForceFeedbackCapabilitiesEffectType(1 << 9) }
	public static var Friction: ForceFeedbackCapabilitiesEffectType { return ForceFeedbackCapabilitiesEffectType(1 << 10) }
	public static var CustomForce: ForceFeedbackCapabilitiesEffectType { return ForceFeedbackCapabilitiesEffectType(1 << 11) }
}

public struct ForceFeedbackCapabilitiesEffectSubType : RawOptionSetType {
	public typealias RawValue = UInt32
	private var value: RawValue = 0
	public init(_ value: RawValue) { self.value = value }
	public init(rawValue value: RawValue) { self.value = value }
	public init(nilLiteral: ()) { self.value = 0 }
	public static var allZeros: ForceFeedbackCapabilitiesEffectSubType { return self(0) }
	public static func fromMask(raw: RawValue) -> ForceFeedbackCapabilitiesEffectSubType { return self(raw) }
	public var rawValue: RawValue { return self.value }
	
	public static var Kinesthetic: ForceFeedbackCapabilitiesEffectSubType { return ForceFeedbackCapabilitiesEffectSubType(1 << 0) }
	public static var Vibration: ForceFeedbackCapabilitiesEffectSubType { return ForceFeedbackCapabilitiesEffectSubType(1 << 1) }
}


public struct ForceFeedbackCoordinateSystemFlag : RawOptionSetType {
	public typealias RawValue = UInt32
	private var value: RawValue = 0
	public init(_ value: RawValue) { self.value = value }
	public init(rawValue value: RawValue) { self.value = value }
	public init(nilLiteral: ()) { self.value = 0 }
	public static var allZeros: ForceFeedbackCoordinateSystemFlag { return self(0) }
	public static func fromMask(raw: RawValue) -> ForceFeedbackCoordinateSystemFlag { return self(raw) }
	public var rawValue: RawValue { return self.value }
	
	public static var Cartesian: ForceFeedbackCoordinateSystemFlag { return ForceFeedbackCoordinateSystemFlag(0x10) }
	public static var Polar: ForceFeedbackCoordinateSystemFlag { return ForceFeedbackCoordinateSystemFlag(0x20) }
	public static var Spherical: ForceFeedbackCoordinateSystemFlag { return ForceFeedbackCoordinateSystemFlag(0x40) }
}


public struct ForceFeedbackEffectParameterFlag : RawOptionSetType {
	public typealias RawValue = UInt32
	private var value: RawValue = 0
	public init(_ value: RawValue) { self.value = value }
	public init(rawValue value: RawValue) { self.value = value }
	public init(nilLiteral: ()) { self.value = 0 }
	public static var allZeros: ForceFeedbackEffectParameterFlag { return self(0) }
	public static func fromMask(raw: RawValue) -> ForceFeedbackEffectParameterFlag { return self(raw) }
	public var rawValue: RawValue { return self.value }
	
	public static var Duration: ForceFeedbackEffectParameterFlag { return ForceFeedbackEffectParameterFlag(1 << 0) }
	public static var SamplePeriod: ForceFeedbackEffectParameterFlag { return ForceFeedbackEffectParameterFlag(1 << 1) }
	public static var Gain: ForceFeedbackEffectParameterFlag { return ForceFeedbackEffectParameterFlag(1 << 2) }
	public static var TriggerButton: ForceFeedbackEffectParameterFlag { return ForceFeedbackEffectParameterFlag(1 << 3) }
	public static var TriggerRepeatInterval: ForceFeedbackEffectParameterFlag { return ForceFeedbackEffectParameterFlag(1 << 4) }
	public static var Axes: ForceFeedbackEffectParameterFlag { return ForceFeedbackEffectParameterFlag(1 << 5) }
	public static var Direction: ForceFeedbackEffectParameterFlag { return ForceFeedbackEffectParameterFlag(1 << 6) }
	public static var Envelope: ForceFeedbackEffectParameterFlag { return ForceFeedbackEffectParameterFlag(1 << 7) }
	public static var TypeSpecificParamaters: ForceFeedbackEffectParameterFlag { return ForceFeedbackEffectParameterFlag(1 << 8) }
	public static var StartDelay: ForceFeedbackEffectParameterFlag { return ForceFeedbackEffectParameterFlag(1 << 9) }
	
	public static var AllParamaters: ForceFeedbackEffectParameterFlag { return ForceFeedbackEffectParameterFlag(0x000003FF) }
	
	public static var Start: ForceFeedbackEffectParameterFlag { return ForceFeedbackEffectParameterFlag(0x20000000) }
	public static var NoRestart: ForceFeedbackEffectParameterFlag { return ForceFeedbackEffectParameterFlag(0x40000000) }
	public static var NoDownload: ForceFeedbackEffectParameterFlag { return ForceFeedbackEffectParameterFlag(0x80000000) }
	public static var NoTrigger: ForceFeedbackEffectParameterFlag { return ForceFeedbackEffectParameterFlag(0xFFFFFFFF) }
}


public struct ForceFeedbackEffectStartFlag : RawOptionSetType {
	public typealias RawValue = UInt32
	private var value: RawValue = 0
	public init(_ value: RawValue) { self.value = value }
	public init(rawValue value: RawValue) { self.value = value }
	public init(nilLiteral: ()) { self.value = 0 }
	public static var allZeros: ForceFeedbackEffectStartFlag { return self(0) }
	public static func fromMask(raw: RawValue) -> ForceFeedbackEffectStartFlag { return self(raw) }
	public var rawValue: RawValue { return self.value }
	
	public static var Solo: ForceFeedbackEffectStartFlag { return ForceFeedbackEffectStartFlag(0x01) }
	public static var NoDownload: ForceFeedbackEffectStartFlag { return ForceFeedbackEffectStartFlag(0x80000000) }
}

struct ForceFeedbackEffectStatusFlag : RawOptionSetType {
	typealias RawValue = UInt32
	private var value: RawValue = 0
	init(_ value: RawValue) { self.value = value }
	init(rawValue value: RawValue) { self.value = value }
	init(nilLiteral: ()) { self.value = 0 }
	static var allZeros: ForceFeedbackEffectStatusFlag { return self(0) }
	static func fromMask(raw: RawValue) -> ForceFeedbackEffectStatusFlag { return self(raw) }
	var rawValue: RawValue { return self.value }
	
	static var NotPlaying: ForceFeedbackEffectStatusFlag { return self(0) }
	static var Playing: ForceFeedbackEffectStatusFlag { return ForceFeedbackEffectStatusFlag(1 << 0) }
	static var Emulated: ForceFeedbackEffectStatusFlag { return ForceFeedbackEffectStatusFlag(1 << 1) }
}

public enum ForceFeedbackProperty: UInt32 {
	case Gain = 1
	case Autocenter = 3
}

public struct ForceFeedbackState : RawOptionSetType {
	public typealias RawValue = UInt32
	private var value: RawValue = 0
	public init(_ value: RawValue) { self.value = value }
	public init(rawValue value: RawValue) { self.value = value }
	public init(nilLiteral: ()) { self.value = 0 }
	public static var allZeros: ForceFeedbackState { return self(0) }
	public static func fromMask(raw: RawValue) -> ForceFeedbackState { return self(raw) }
	public var rawValue: RawValue { return self.value }
	
	public static var Empty: ForceFeedbackState { return ForceFeedbackState(1 << 0) }
	public static var Stopped: ForceFeedbackState { return ForceFeedbackState(1 << 1) }
	public static var Paused: ForceFeedbackState { return ForceFeedbackState(1 << 2) }
	
	public static var ActuatorsOn: ForceFeedbackState { return ForceFeedbackState(1 << 4) }
	public static var ActuatorsOff: ForceFeedbackState { return ForceFeedbackState(1 << 5) }
	public static var PowerOn: ForceFeedbackState { return ForceFeedbackState(1 << 6) }
	public static var PowerOff: ForceFeedbackState { return ForceFeedbackState(1 << 7) }
	public static var SafetySwitchOn: ForceFeedbackState { return ForceFeedbackState(1 << 8) }
	public static var SafetySwitchOff: ForceFeedbackState { return ForceFeedbackState(1 << 9) }
	public static var UserSwitchOn: ForceFeedbackState { return ForceFeedbackState(1 << 10) }
	public static var UserSwitchOff: ForceFeedbackState { return ForceFeedbackState(1 << 11) }
	public static var DeviceLost: ForceFeedbackState { return ForceFeedbackState(0x80000000) }
}

public class ForceFeedbackDevice {
	private let rawDevice: FFDeviceObjectReference
	
	public init?(device: io_service_t) {
		var tmpDevice: FFDeviceObjectReference = nil
		var iErr = FFCreateDevice(device, &tmpDevice)
		if iErr > -1 {
			rawDevice = tmpDevice
		} else {
			rawDevice = nil
			return nil
		}
	}
	
	public class func deviceIsForceFeedback(device: io_service_t) -> Bool? {
		let iErr = FFIsForceFeedback(device)
		if iErr == 0 {
			return true
		} else if iErr == -2147483644 {
			return false
		} else {
			return nil
		}
	}
	
	deinit {
		if rawDevice != nil {
		FFReleaseDevice(rawDevice)
		}
	}
}

public class ForceFeedbackEffect {
	private let rawEffect: FFEffectObjectReference
	unowned private let deviceReference: ForceFeedbackDevice
	// E559C460-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined kFFEffectType_ConstantForce_ID
	@discussion UUID for a constant force effect type
 */
	public class var ConstantForce: CFUUID {
		return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x60, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	}
	
	// E559C461-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined kFFEffectType_RampForce_ID
	@discussion UUID for a ramp force effect type
 */
	public class var RampForce: CFUUID {
		return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x61, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	}
	
	// E559C462-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined kFFEffectType_Square_ID
	@discussion UUID for a square wave effect type
 */
	public class var Square: CFUUID {
		return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x62, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	}
	
	// E559C463-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined kFFEffectType_Sine_ID
	@discussion UUID for a sine wave effect type
 */
	public class var Sine: CFUUID {
		return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x63, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	}
	
	// E559C464-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined kFFEffectType_Triangle_ID
	@discussion UUID for a triangle wave effect type
 */
	public class var Triangle: CFUUID {
		return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x64, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	}
	
	// E559C465-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined kFFEffectType_SawtoothUp_ID
	@discussion UUID for a upwards sawtooth wave effect type
 */
	public class var SawtoothUp: CFUUID {
		return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x65, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	}
	
	// E559C466-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined kFFEffectType_SawtoothDown_ID
	@discussion UUID for a downwards sawtooth wave effect type
 */
	public class var SawtoothDown: CFUUID {
		return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x66, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	}
	
	// E559C467-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined kFFEffectType_Spring_ID
	@discussion UUID for a spring effect type
 */
	public class var Spring: CFUUID {
		return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x67, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	}
	
	// E559C468-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined kFFEffectType_Damper_ID
	@discussion UUID for a damper effect type
 */
	public class var Damper: CFUUID {
		return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x68, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	}
	
	// E559C469-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined kFFEffectType_Inertia_ID
	@discussion UUID for an inertia effect type
 */
	public class var Inertia: CFUUID {
		return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x69, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	}
	
	// E559C46A-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined kFFEffectType_Friction_ID
	@discussion UUID for a friction effect type
 */
	public class var Friction: CFUUID {
		return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x6A, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	}
	
	// E559C46B-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined kFFEffectType_CustomForce_ID
	@discussion UUID for a custom force effect type
 */
	public class var CustomForce: CFUUID {
		return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x6B, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	}
	
	public convenience init?(device: ForceFeedbackDevice, UUID: NSUUID, inout effectDefinition: FFEFFECT) {
		let ourUUID = CFUUIDCreateFromString(kCFAllocatorDefault, UUID.UUIDString)!
		
		self.init(device: device, UUID: ourUUID, effectDefinition: &effectDefinition)
	}
	
	public init?(device: ForceFeedbackDevice, UUID: CFUUID, inout effectDefinition: FFEFFECT) {
		deviceReference = device
		var tmpEffect: FFEffectObjectReference = nil
		let iErr = FFDeviceCreateEffect(device.rawDevice, UUID, &effectDefinition, &tmpEffect)
		if iErr == 0 {
			rawEffect = tmpEffect
		} else {
			rawEffect = nil
		}
	}
	
	deinit {
		if rawEffect != nil {
			FFDeviceReleaseEffect(deviceReference.rawDevice, rawEffect)
		}
	}
}

/*
func FFDeviceGetForceFeedbackState(deviceReference: FFDeviceObjectReference) -> (state: ForceFeedbackState, result: HRESULT) {
	var state: FFState = 0
	
	let toRet = FFDeviceGetForceFeedbackState(deviceReference, &state)
	
	return (ForceFeedbackState(state), toRet)
}

func FFEffectGetEffectStatus(effectReference: FFEffectObjectReference) -> (result: HRESULT, status: ForceFeedbackEffectStatusFlag) {
	var status: FFEffectStatusFlag = 0
	
	let toRet = FFEffectGetEffectStatus(effectReference, &status)
	
	return (toRet, ForceFeedbackEffectStatusFlag(status))
}

func FFEffectStart(effectReference: FFEffectObjectReference, iterations: UInt32, flags: ForceFeedbackEffectStartFlag) -> HRESULT {
	return FFEffectStart(effectReference, iterations, flags.rawValue)
}
func FFDeviceGetForceFeedbackProperty(deviceReference: FFDeviceObjectReference, property: ForceFeedbackProperty, pValue: UnsafeMutablePointer<Void>, valueSize: IOByteCount) -> HRESULT {
	return FFDeviceGetForceFeedbackProperty(deviceReference, property.rawValue, pValue, valueSize)
}

func FFDeviceSetForceFeedbackProperty(deviceReference: FFDeviceObjectReference, property: ForceFeedbackProperty, pValue: UnsafeMutablePointer<Void>) -> HRESULT {
	return FFDeviceSetForceFeedbackProperty(deviceReference, property.rawValue, pValue)
}

func FFEffectGetParameters(effectReference: FFEffectObjectReference, pFFEffect: UnsafeMutablePointer<FFEFFECT>, flags: ForceFeedbackEffectParameterFlag) -> HRESULT {
	
}*/
