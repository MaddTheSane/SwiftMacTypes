//
//  ForceFeedback.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 10/20/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import CoreFoundation
import Foundation
import ForceFeedback
import SwiftAdditions

public let ForceFeedbackResultErrorDomain =
"com.github.maddthesane.ForceFeedbackAdditions.ForceFeedbackResult"

public enum ForceFeedbackResult: HRESULT, ErrorProtocol {
	case OK = 0
	case False = 1
	case DownloadSkipped = 3
	case EffectRestarted = 4
	case Truncated = 8
	case TruncatedAndRestarted = 12
	case InvalidParam = -2147483645
	case NoInterface = -2147483644
	case Generic = -2147483640
	case OutOfMemory = -2147483646
	case Unsupported = -2147483647
	case DeviceFull = -2147220991
	case MoreData = -2147220990
	case NotDownloaded = -2147220989
	case HasEffects = -2147220988
	case IncompleteEffect = -2147220986
	case EffectPlaying = -2147220984
	case Unplugged = -2147220983
	// MARK: Mac OS X-specific
	case InvalidDownloadID = -2147220736
	case DevicePaused = -2147220735
	case Internal = -2147220734
	case EffectTypeMismatch = -2147220733
	case UnsupportedAxis = -2147220732
	case NotInitialized = -2147220731
	case DeviceReleased = -2147220729
	case EffectTypeNotSupported = -2147220730
	private static func from(result inResult: HRESULT) -> ForceFeedbackResult {
		if let unwrapped = ForceFeedbackResult(rawValue: inResult) {
			return unwrapped
		} else {
			if inResult > 0 {
				return .OK
			} else {
				return .Generic
			}
		}
	}
	
	public var isSuccess: Bool {
		return rawValue >= 0
	}
	
	public var isFailure: Bool {
		return rawValue < 0
	}
	
	public var _code: Int {
		return Int(rawValue)
	}
	
	public var _domain: String {
		return ForceFeedbackResultErrorDomain
	}
}

extension FFCONSTANTFORCE {
	public var magnitude: Int32 {
		get {
			return lMagnitude
		}
		set {
			lMagnitude = newValue
		}
	}
}

extension FFRAMPFORCE {
	public var start: Int32 {
		get {
			return lStart
		}
		set {
			lStart = newValue
		}
	}
	
	public var end: Int32 {
		get {
			return lEnd
		}
		set {
			lEnd = newValue
		}
	}
}

extension FFEFFECT {
	// MARK: More name-friendly getters/setters
	public var size: UInt32 {
		get {
			return dwSize
		}
		set {
			dwSize = newValue
		}
	}
	
	public var flags: UInt32 {
		get {
			return dwFlags
		}
		set {
			dwFlags = newValue
		}
	}
	
	public var duration: UInt32 {
		get {
			return dwDuration
		}
		set {
			dwDuration = newValue
		}
	}
	
	public var samplePeriod: UInt32 {
		get {
			return dwSamplePeriod;
		}
		set {
			dwSamplePeriod = newValue
		}
	}
	
	public var gain: UInt32 {
		get {
			return dwGain
		}
		set {
			dwGain = newValue
		}
	}
	
	public var triggerButton: UInt32 {
		get {
			return dwTriggerButton
		}
		set {
			dwTriggerButton = newValue
		}
	}
	
	public var typeSpecificParams: (size: UInt32, value: ImplicitlyUnwrappedOptional<UnsafeMutablePointer<Void>>) {
		get {
			return (cbTypeSpecificParams, lpvTypeSpecificParams)
		}
		set {
			(cbTypeSpecificParams, lpvTypeSpecificParams) = newValue
		}
	}
	
	public var envelope: PFFENVELOPE {
		get {
			return lpEnvelope
		}
		set {
			lpEnvelope = newValue
		}
	}
	
	public var axes: [UInt32] {
		var retAxes = [UInt32]()
		for i in 0..<cAxes {
			retAxes.append(rgdwAxes[Int(i)])
		}
		
		return retAxes
	}
	
	public var startDelay: UInt32 {
		get {
			return dwStartDelay
		}
		set {
			dwStartDelay = newValue
		}
	}
}

extension FFENVELOPE {
	public var size: UInt32 {
		get {
			return dwSize
		}
		set {
			dwSize = newValue
		}
	}
	
	public var attack: (level: UInt32, time: UInt32) {
		get {
			return (dwAttackLevel, dwAttackTime)
		}
		set {
			(dwAttackLevel, dwAttackTime) = newValue
		}
	}
	
	public var attackLevel: UInt32 {
		get {
			return dwAttackLevel
		}
		set {
			dwAttackLevel = newValue
		}
	}
	
	public var attackTime: UInt32 {
		get {
			return dwAttackTime
		}
		set {
			dwAttackTime = newValue
		}
	}
	
	public var fade: (level: UInt32, time: UInt32) {
		get {
			return (dwFadeLevel, dwFadeTime)
		}
		set {
			(dwFadeLevel, dwFadeTime) = newValue
		}
	}
	
	public var fadeLevel: UInt32 {
		get {
			return dwFadeLevel
		}
		set {
			dwFadeLevel = newValue
		}
	}
	
	public var fadeTime: UInt32 {
		get {
			return dwFadeTime
		}
		set {
			dwFadeTime = newValue
		}
	}
}

extension FFCONDITION {
	public var offset: Int32 {
		get {
			return lOffset
		}
		set {
			lOffset = newValue
		}
	}
	
	public var coefficients: (positive: Int32, negative: Int32) {
		get {
			return (lPositiveCoefficient, lNegativeCoefficient)
		}
		set {
			(lPositiveCoefficient, lNegativeCoefficient) = newValue
		}
	}
	
	public var saturation: (positive: UInt32, negative: UInt32) {
		get {
			return (dwPositiveSaturation, dwNegativeSaturation)
		}
		set {
			(dwPositiveSaturation, dwNegativeSaturation) = newValue
		}
	}
	
	public var deadBand: Int32 {
		get {
			return lDeadBand
		}
		set {
			lDeadBand = newValue
		}
	}
}

extension FFCUSTOMFORCE {
	public var samplePeriod: UInt32 {
		get {
			return dwSamplePeriod
		}
		set {
			dwSamplePeriod = newValue
		}
	}
	
	/// Returns `true` if the data sent in is valid, `false` otherwise.
	public mutating func setData(channels: UInt32, samples: UInt32, forceData: LPLONG) -> Bool {
		if channels == 1 {
			cChannels = channels
			cSamples = samples
			rglForceData = forceData
			return true
		} else if channels == 0 {
			cChannels = channels
			cSamples = samples
			rglForceData = forceData
			return true
		} else if (samples % channels) == 0 {
			cChannels = channels
			cSamples = samples
			rglForceData = forceData
			return true
		}
		
		return false
	}
}

extension FFPERIODIC {
	public var magnitude: UInt32 {
		get {
			return dwMagnitude
		}
		set {
			dwMagnitude = newValue
		}
	}
	
	public var offset: Int32 {
		get {
			return lOffset
		}
		set {
			lOffset = newValue
		}
	}
	
	public var phase: UInt32 {
		get {
			return dwPhase
		}
		set {
			dwPhase = newValue
		}
	}
	
	public var period: UInt32 {
		get {
			return dwPeriod
		}
		set {
			dwPeriod = newValue
		}
	}
}

extension FFEFFESCAPE {
	public var bufferIn: (size: UInt32, data: ImplicitlyUnwrappedOptional<UnsafeMutablePointer<Void>>) {
		get {
			return (cbInBuffer, lpvInBuffer)
		}
		set {
			(cbInBuffer, lpvInBuffer) = newValue
		}
	}
	
	public var bufferOut: (size: UInt32, data: ImplicitlyUnwrappedOptional<UnsafeMutablePointer<Void>>) {
		get {
			return (cbOutBuffer, lpvOutBuffer)
		}
		set {
			(cbOutBuffer, lpvOutBuffer) = newValue
		}
	}
	
	public var command: UInt32 {
		get {
			return dwCommand
		}
		set {
			dwCommand = newValue
		}
	}
}

// TODO: put these in an enum, or struct, or something...
public let ForceFeedbackOffsetX : UInt8 = 0
public let ForceFeedbackOffsetY : UInt8 = 4
public let ForceFeedbackOffsetZ : UInt8 = 8
public let ForceFeedbackOffsetRX : UInt8 = 12
public let ForceFeedbackOffsetRY : UInt8 = 16
public let ForceFeedbackOffsetRZ : UInt8 = 20

public func ForceFeedbackOffsetSlider(n: UInt8) -> UInt8 {
	return UInt8(24 + Int(n) * sizeof(LONG))
}

public func ForceFeedbackOffsetPOV(n: UInt8) -> UInt8 {
	return UInt8(32 + Int(n) * sizeof(DWORD))
}

public func ForceFeedbackOffsetButton(n: UInt8) -> UInt8 {
	return (48 + (n))
}

extension FFCAPABILITIES {
	public struct EffectTypes : OptionSet {
		public let rawValue: UInt32
		private init(_ value: UInt32) { self.rawValue = value }
		public init(rawValue value: UInt32) { self.rawValue = value }
		
		public static let ConstantForce	= EffectTypes(1 << 0)
		public static let RampForce		= EffectTypes(1 << 1)
		public static let Square		= EffectTypes(1 << 2)
		public static let Sine			= EffectTypes(1 << 3)
		public static let Triangle		= EffectTypes(1 << 4)
		public static let SawtoothUp	= EffectTypes(1 << 5)
		public static let SawtoothDown	= EffectTypes(1 << 6)
		public static let Spring		= EffectTypes(1 << 7)
		public static let Damper		= EffectTypes(1 << 8)
		public static let Inertia		= EffectTypes(1 << 9)
		public static let Friction		= EffectTypes(1 << 10)
		public static let CustomForce	= EffectTypes(1 << 11)
	}
	
	public struct EffectSubtypes : OptionSet {
		public let rawValue: UInt32
		private init(_ value: UInt32) { self.rawValue = value }
		public init(rawValue value: UInt32) { self.rawValue = value }
		
		public static let Kinesthetic	= EffectSubtypes(1 << 0)
		public static let Vibration		= EffectSubtypes(1 << 1)
	}
	
	public var axes: [UInt8] {
		var axesArray: [UInt8] = try! arrayFromObject(reflecting: ffAxes)
		
		return [UInt8](axesArray[0..<min(Int(numFfAxes), axesArray.count)])
	}
	
	public var supportedEffectTypes: EffectTypes {
		return EffectTypes(supportedEffects)
	}
	
	public var emulatedEffectTypes: EffectTypes {
		return EffectTypes(emulatedEffects)
	}
	
	public var effectSubType: EffectSubtypes {
		return EffectSubtypes(subType)
	}
}

public struct ForceFeedbackCoordinateSystem : OptionSet {
	public let rawValue: UInt32
	private init(_ value: UInt32) { self.rawValue = value }
	public init(rawValue value: UInt32) { self.rawValue = value }
	
	public static let Cartesian	= ForceFeedbackCoordinateSystem(0x10)
	public static let Polar		= ForceFeedbackCoordinateSystem(0x20)
	public static let Spherical	= ForceFeedbackCoordinateSystem(0x40)
}

public final class ForceFeedbackDevice {
	private let rawDevice: ImplicitlyUnwrappedOptional<FFDeviceObjectReference>
	public private(set) var lastReturnValue: ForceFeedbackResult = .OK
	
	public enum Property: UInt32 {
		case Gain = 1
		case Autocenter = 3
	}
	
	public struct Command : OptionSet {
		public let rawValue: UInt32
		private init(_ value: UInt32) { self.rawValue = value }
		public init(rawValue value: UInt32) { self.rawValue = value }
		
		public static let Reset				= Command(1 << 0)
		public static let StopAll			= Command(1 << 1)
		public static let Pause				= Command(1 << 2)
		public static let Continue			= Command(1 << 3)
		public static let SetActuatorsOn	= Command(1 << 4)
		public static let SetActuatorsOff	= Command(1 << 5)
	}
	
	public struct State : OptionSet {
		public let rawValue: UInt32
		private init(_ value: UInt32) { self.rawValue = value }
		public init(rawValue value: UInt32) { self.rawValue = value }
		
		public static let Empty		= State(1 << 0)
		public static let Stopped	= State(1 << 1)
		public static let Paused	= State(1 << 2)
		
		public static let ActuatorsOn		= State(1 << 4)
		public static let ActuatorsOff		= State(1 << 5)
		public static let PowerOn			= State(1 << 6)
		public static let PowerOff			= State(1 << 7)
		public static let SafetySwitchOn	= State(1 << 8)
		public static let SafetySwitchOff	= State(1 << 9)
		public static let UserSwitchOn		= State(1 << 10)
		public static let UserSwitchOff		= State(1 << 11)
		public static let DeviceLost		= State(0x80000000)
	}
	
	public class var infinite: UInt32 {
		return 0xFFFFFFFF
	}
	
	public class var degrees: Int {
		return 100
	}
	
	public class var nominalMax: Int {
		return 10000
	}
	
	public class var seconds: Int {
		return 1000000
	}
	
	public init(device: io_service_t) throws {
		var tmpDevice: FFDeviceObjectReference? = nil
		let iErr = FFCreateDevice(device, &tmpDevice)
		guard iErr == ForceFeedbackResult.OK.rawValue else {
			rawDevice = nil
			throw ForceFeedbackResult.from(result: iErr)
		}
		rawDevice = tmpDevice!
	}
	
	/// Returns `true` if device is capable of Force feedback.<br>
	/// Returns `false` if it isn't.<br>
	/// Returns `nil` if there was an error.
	public class func deviceIsForceFeedback(device: io_service_t) -> Bool? {
		let iErr = FFIsForceFeedback(device)
		if iErr >= 0 {
			return true
		} else if iErr == ForceFeedbackResult.NoInterface.rawValue {
			return false
		} else {
			return nil
		}
	}
	
	public func sendEscape(_ theEscape: inout FFEFFESCAPE) -> ForceFeedbackResult {
		let aReturn = ForceFeedbackResult.from(result: FFDeviceEscape(rawDevice, &theEscape))
		lastReturnValue = aReturn
		return aReturn
	}
	
	public func sendEscape(command: DWORD, inData: NSData) -> ForceFeedbackResult {
		let curDataSize = inData.length
		var tmpMutBytes = malloc(curDataSize)
		memcpy(&tmpMutBytes, inData.bytes, curDataSize)
		var ourEscape = FFEFFESCAPE(dwSize: DWORD(sizeof(FFEFFESCAPE)), dwCommand: command, lpvInBuffer: tmpMutBytes, cbInBuffer: DWORD(curDataSize), lpvOutBuffer: nil, cbOutBuffer: 0)
		
		let toRet = sendEscape(&ourEscape)
		lastReturnValue = toRet
		
		free(tmpMutBytes)
		
		return toRet
	}
	
	public func sendEscape(command: DWORD, inData: NSData, outDataLength: inout Int) -> (result: ForceFeedbackResult, outData: NSData) {
		if let ourMutableData = NSMutableData(length: outDataLength) {
			let curDataSize = inData.length
			var tmpMutBytes = malloc(curDataSize)
			memcpy(&tmpMutBytes, inData.bytes, curDataSize)
			var ourEscape = FFEFFESCAPE(dwSize: DWORD(sizeof(FFEFFESCAPE)), dwCommand: command, lpvInBuffer: tmpMutBytes, cbInBuffer: DWORD(curDataSize), lpvOutBuffer: ourMutableData.mutableBytes, cbOutBuffer: DWORD(outDataLength))
			
			let toRet = sendEscape(&ourEscape)
			
			free(tmpMutBytes)
			ourMutableData.length = Int(ourEscape.cbOutBuffer)
			lastReturnValue = toRet
			
			return (toRet, NSData(data: ourMutableData))
		} else {
			lastReturnValue = .OutOfMemory
			return (.OutOfMemory, NSData())
		}
	}
	
	public var state: State {
		var ourState: FFState = 0
		let errVal = ForceFeedbackResult.from(result: FFDeviceGetForceFeedbackState(rawDevice, &ourState))
		lastReturnValue = errVal
		if lastReturnValue.isSuccess {
			return State(ourState)
		} else {
			return State(0)
		}
	}
	
	public func sendCommand(command: Command) -> ForceFeedbackResult {
		let iErr = ForceFeedbackResult.from(result: FFDeviceSendForceFeedbackCommand(rawDevice, command.rawValue))
		lastReturnValue = iErr
		return iErr
	}
	
	/// Calls `getProperty`/`setProperty`, which may return failure info.
	/// Use `lastReturnValue` to check if the getter/setter were successful.
	public var autocenter: Bool {
		get {
			var theVal: UInt32 = 0
			let iErr = get(property: .Autocenter, value: &theVal, valueSize: IOByteCount(sizeof(UInt32)))
			lastReturnValue = iErr
			return theVal != 0
		}
		set {
			var theVal: UInt32 = newValue == true ? 1 : 0
			lastReturnValue = set(property: .Autocenter, value: &theVal)
		}
	}
	
	/// Calls `getProperty`/`setProperty`, which may return failure info.
	/// Use `lastReturnValue` to check if the getter/setter were successful.
	public var gain: UInt32 {
		get {
			var theVal: UInt32 = 0
			let iErr = get(property: .Gain, value: &theVal, valueSize: IOByteCount(sizeof(UInt32)))
			lastReturnValue = iErr
			return theVal
		}
		set {
			var theVal = newValue
			lastReturnValue = set(property: .Gain, value: &theVal)
		}
	}
	
	/// Function is unimplemented in version 1.0 of Apple's FF API.
	public func setCooperativeLevel(taskIdentifier: UnsafeMutablePointer<Void>, flags: CooperativeLevel) -> ForceFeedbackResult {
		let iErr = ForceFeedbackResult.from(result: FFDeviceSetCooperativeLevel(rawDevice, taskIdentifier, flags.rawValue))
		lastReturnValue = iErr
		return iErr
	}
	
	public func set(property: Property, value: UnsafeMutablePointer<Void>) -> ForceFeedbackResult {
		let iErr = ForceFeedbackResult.from(result: FFDeviceSetForceFeedbackProperty(rawDevice, property.rawValue, value))
		lastReturnValue = iErr
		return iErr
	}
	
	public func get(property: Property, value: UnsafeMutablePointer<Void>, valueSize: IOByteCount) -> ForceFeedbackResult {
		let iErr = ForceFeedbackResult.from(result: FFDeviceGetForceFeedbackProperty(rawDevice, property.rawValue, value, valueSize))
		lastReturnValue = iErr
		return iErr
	}
	
	public func set(property: UInt32, value: UnsafeMutablePointer<Void>) -> ForceFeedbackResult {
		let iErr = ForceFeedbackResult.from(result: FFDeviceSetForceFeedbackProperty(rawDevice, property, value))
		lastReturnValue = iErr
		return iErr
	}
	
	public func get(property: UInt32, value: UnsafeMutablePointer<Void>, valueSize: IOByteCount) -> ForceFeedbackResult {
		let iErr = ForceFeedbackResult.from(result: FFDeviceGetForceFeedbackProperty(rawDevice, property, value, valueSize))
		lastReturnValue = iErr
		return iErr
	}
	
	deinit {
		if rawDevice != nil {
			FFReleaseDevice(rawDevice)
		}
	}
	
	public struct CooperativeLevel : OptionSet {
		public let rawValue: UInt32
		private init(_ value: UInt32) { self.rawValue = value }
		public init(rawValue value: UInt32) { self.rawValue = value }
		
		public static let Exclusive		= CooperativeLevel(1 << 0)
		public static let NonExclusive	= CooperativeLevel(1 << 1)
		public static let Foreground	= CooperativeLevel(1 << 2)
		public static let Background	= CooperativeLevel(1 << 3)
	}
}

public final class ForceFeedbackEffect {
	private let rawEffect: ImplicitlyUnwrappedOptional<FFEffectObjectReference>
	public let deviceReference: ForceFeedbackDevice
	
	public struct EffectStart : OptionSet {
		public let rawValue: UInt32
		private init(_ value: UInt32) { self.rawValue = value }
		public init(rawValue value: UInt32) { self.rawValue = value }
		
		public static let Solo			= EffectStart(0x01)
		public static let NoDownload	= EffectStart(0x80000000)
	}
	
	public enum EffectType {
		case ConstantForce
		case RampForce
		case Square
		case Sine
		case Triangle
		case SawtoothUp
		case SawtoothDown
		case Spring
		case Damper
		case Inertia
		case Friction
		case Custom
		
		/// Returns an `EffectType` matching the supplied UUID.
		/// Returns `nil` if there isn't a matching `EffectType`.
		public init?(UUID: CFUUID) {
			if CFEqual(UUID, ForceFeedbackEffect.ConstantForce) {
				self = .ConstantForce
			} else if CFEqual(UUID, ForceFeedbackEffect.RampForce) {
				self = .RampForce
			} else if CFEqual(UUID, ForceFeedbackEffect.Square) {
				self = .Square
			} else if CFEqual(UUID, ForceFeedbackEffect.Sine) {
				self = .Sine
			} else if CFEqual(UUID, ForceFeedbackEffect.Triangle) {
				self = .Triangle
			} else if CFEqual(UUID, ForceFeedbackEffect.SawtoothUp) {
				self = .SawtoothUp
			} else if CFEqual(UUID, ForceFeedbackEffect.SawtoothDown) {
				self = .SawtoothDown
			} else if CFEqual(UUID, ForceFeedbackEffect.Spring) {
				self = .Spring
			} else if CFEqual(UUID, ForceFeedbackEffect.Damper) {
				self = .Damper
			} else if CFEqual(UUID, ForceFeedbackEffect.Inertia) {
				self = .Inertia
			} else if CFEqual(UUID, ForceFeedbackEffect.Friction) {
				self = .Friction
			} else if CFEqual(UUID, ForceFeedbackEffect.CustomForce) {
				self = .Custom
			} else {
				return nil
			}
		}
		
		public var UUIDValue: CFUUID {
			switch self {
			case .ConstantForce:
				return ForceFeedbackEffect.ConstantForce
				
			case .RampForce:
				return ForceFeedbackEffect.RampForce
				
			case .Square:
				return ForceFeedbackEffect.Square
				
			case .Sine:
				return ForceFeedbackEffect.Sine
				
			case .Triangle:
				return ForceFeedbackEffect.Triangle
				
			case .SawtoothUp:
				return ForceFeedbackEffect.SawtoothUp

			case .SawtoothDown:
				return ForceFeedbackEffect.SawtoothDown

			case .Spring:
				return ForceFeedbackEffect.Spring

			case .Damper:
				return ForceFeedbackEffect.Damper

			case .Inertia:
				return ForceFeedbackEffect.Inertia
				
			case .Friction:
				return ForceFeedbackEffect.Friction

			case .Custom:
				return ForceFeedbackEffect.CustomForce
			}
		}
	}
	
	/// E559C460-C5CD-11D6-8A1C-00039353BD00<br>
	/// UUID for a constant force effect type
	public static let ConstantForce: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x60, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	/// E559C461-C5CD-11D6-8A1C-00039353BD00<br>
	/// UUID for a ramp force effect type
	public static let RampForce: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x61, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	/// E559C462-C5CD-11D6-8A1C-00039353BD00<br>
	/// UUID for a square wave effect type
	public static let Square: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x62, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	/// E559C463-C5CD-11D6-8A1C-00039353BD00<br>
	/// UUID for a sine wave effect type
	public static let Sine: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x63, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	/// E559C464-C5CD-11D6-8A1C-00039353BD00<br>
	/// UUID for a triangle wave effect type
	public static let Triangle: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x64, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	/// E559C465-C5CD-11D6-8A1C-00039353BD00<br>
	/// UUID for a upwards sawtooth wave effect type
	public static let SawtoothUp: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x65, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	/// E559C466-C5CD-11D6-8A1C-00039353BD00<br>
	/// UUID for a downwards sawtooth wave effect type
	public static let SawtoothDown: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x66, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	/// E559C467-C5CD-11D6-8A1C-00039353BD00<br>
	/// UUID for a spring effect type
	public static let Spring: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x67, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	/// E559C468-C5CD-11D6-8A1C-00039353BD00<br>
	/// UUID for a damper effect type
	public static let Damper: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x68, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	/// E559C469-C5CD-11D6-8A1C-00039353BD00<br>
	/// UUID for an inertia effect type
	public static let Inertia: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x69, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	/// E559C46A-C5CD-11D6-8A1C-00039353BD00<br>
	/// UUID for a friction effect type
	public static let Friction: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x6A, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	/// E559C46B-C5CD-11D6-8A1C-00039353BD00<br>
	/// UUID for a custom force effect type
	public static let CustomForce: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x6B, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	public convenience init(device: ForceFeedbackDevice, UUID: NSUUID, effectDefinition: inout FFEFFECT) throws {
		let ourUUID = UUID.CFUUID
		
		try self.init(device: device, UUID: ourUUID, effectDefinition: &effectDefinition)
	}
	
	public convenience init(device: ForceFeedbackDevice, effect: EffectType, effectDefinition: inout FFEFFECT) throws {
		let ourUUID = effect.UUIDValue
		
		try self.init(device: device, UUID: ourUUID, effectDefinition: &effectDefinition)
	}
	
	public init(device: ForceFeedbackDevice, UUID: CFUUID, effectDefinition: inout FFEFFECT) throws {
		deviceReference = device
		var tmpEffect: FFEffectObjectReference? = nil
		let iErr = FFDeviceCreateEffect(device.rawDevice, UUID, &effectDefinition, &tmpEffect)
		if iErr == ForceFeedbackResult.OK.rawValue {
			rawEffect = tmpEffect
		} else {
			rawEffect = nil
			throw ForceFeedbackResult.from(result: iErr)
		}
	}
	
	public func start(iterations: UInt32 = 1, flags: EffectStart = EffectStart.Solo) -> ForceFeedbackResult {
		return ForceFeedbackResult.from(result: FFEffectStart(rawEffect, iterations, flags.rawValue))
	}
	
	public func stop() -> ForceFeedbackResult {
		return ForceFeedbackResult.from(result: FFEffectStop(rawEffect))
	}
	
	public func download() -> ForceFeedbackResult {
		return ForceFeedbackResult.from(result: FFEffectDownload(rawEffect))
	}
	
	public func getParameters(_ effect: inout FFEFFECT, flags: EffectParamater) -> ForceFeedbackResult {
		return ForceFeedbackResult.from(result: FFEffectGetParameters(rawEffect, &effect, flags.rawValue))
	}
	
	public func setParameters(_ effect: inout FFEFFECT, flags: EffectParamater) -> ForceFeedbackResult {
		return ForceFeedbackResult.from(result: FFEffectSetParameters(rawEffect, &effect, flags.rawValue))
	}
	
	///- returns: A `Status` bit mask, or `nil` on error.
	public var status: Status? {
		var statFlag: FFEffectStatusFlag = 0
		let retVal = FFEffectGetEffectStatus(rawEffect, &statFlag)
		if retVal == 0 {
			return Status(statFlag)
		} else {
			return nil
		}
	}
	
	deinit {
		if rawEffect != nil {
			FFDeviceReleaseEffect(deviceReference.rawDevice, rawEffect)
		}
	}
	
	public struct Status : OptionSet {
		public let rawValue: UInt32
		private init(_ value: UInt32) { self.rawValue = value }
		public init(rawValue value: UInt32) { self.rawValue = value }
		
		public static let NotPlaying	= Status(0)
		public static let Playing		= Status(1 << 0)
		public static let Emulated		= Status(1 << 1)
	}
	
	public struct EffectParamater : OptionSet {
		public let rawValue: UInt32
		private init(_ value: UInt32) { self.rawValue = value }
		public init(rawValue value: UInt32) { self.rawValue = value }
		
		public static let Duration					= EffectParamater(1 << 0)
		public static let SamplePeriod				= EffectParamater(1 << 1)
		public static let Gain						= EffectParamater(1 << 2)
		public static let TriggerButton				= EffectParamater(1 << 3)
		public static let TriggerRepeatInterval		= EffectParamater(1 << 4)
		public static let Axes						= EffectParamater(1 << 5)
		public static let Direction					= EffectParamater(1 << 6)
		public static let Envelope					= EffectParamater(1 << 7)
		public static let TypeSpecificParamaters	= EffectParamater(1 << 8)
		public static let StartDelay				= EffectParamater(1 << 9)
		
		public static let AllParamaters		= EffectParamater(0x000003FF)
		
		public static let Start			= EffectParamater(0x20000000)
		public static let NoRestart		= EffectParamater(0x40000000)
		public static let NoDownload	= EffectParamater(0x80000000)
		public static let NoTrigger		= EffectParamater(0xFFFFFFFF)
	}
}
