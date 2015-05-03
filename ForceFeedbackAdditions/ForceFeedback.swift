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

public enum ForceFeedbackResult: HRESULT {
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
	private static func fromHResult(inResult: HRESULT) -> ForceFeedbackResult {
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
	
	public var typeSpecificParams: (size: UInt32, value: UnsafeMutablePointer<Void>) {
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
	
	/// Returns true if the data sent in is valid
	public mutating func setData(#channels: UInt32, samples: UInt32, forceData: LPLONG) -> Bool {
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
	public var bufferIn: (size: UInt32, data: UnsafeMutablePointer<Void>) {
		get {
			return (cbInBuffer, lpvInBuffer)
		}
		set {
			(cbInBuffer, lpvInBuffer) = newValue
		}
	}
	
	public var bufferOut: (size: UInt32, data: UnsafeMutablePointer<Void>) {
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
public var ForceFeedbackOffsetX : UInt8 {
	return 0
}

public var ForceFeedbackOffsetY : UInt8 {
	return 4
}

public var ForceFeedbackOffsetZ : UInt8 {
	return 8
}

public var ForceFeedbackOffsetRX : UInt8 {
	return 12
}

public var ForceFeedbackOffsetRY : UInt8 {
	return 16
}

public var ForceFeedbackOffsetRZ : UInt8 {
	return 20
}

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
	public struct CapabilityEffectTypes : RawOptionSetType {
		public typealias RawValue = UInt32
		private var value: UInt32 = 0
		public init(_ value: UInt32) { self.value = value }
		public init(rawValue value: UInt32) { self.value = value }
		public init(nilLiteral: ()) { self.value = 0 }
		public static var allZeros: CapabilityEffectTypes { return self(0) }
		public var rawValue: UInt32 { return self.value }
		
		public static var ConstantForce: CapabilityEffectTypes { return CapabilityEffectTypes(1 << 0) }
		public static var RampForce: CapabilityEffectTypes { return CapabilityEffectTypes(1 << 1) }
		public static var Square: CapabilityEffectTypes { return CapabilityEffectTypes(1 << 2) }
		public static var Sine: CapabilityEffectTypes { return CapabilityEffectTypes(1 << 3) }
		public static var Triangle: CapabilityEffectTypes { return CapabilityEffectTypes(1 << 4) }
		public static var SawtoothUp: CapabilityEffectTypes { return CapabilityEffectTypes(1 << 5) }
		public static var SawtoothDown: CapabilityEffectTypes { return CapabilityEffectTypes(1 << 6) }
		public static var Spring: CapabilityEffectTypes { return CapabilityEffectTypes(1 << 7) }
		public static var Damper: CapabilityEffectTypes { return CapabilityEffectTypes(1 << 8) }
		public static var Inertia: CapabilityEffectTypes { return CapabilityEffectTypes(1 << 9) }
		public static var Friction: CapabilityEffectTypes { return CapabilityEffectTypes(1 << 10) }
		public static var CustomForce: CapabilityEffectTypes { return CapabilityEffectTypes(1 << 11) }
	}
	
	public struct CapabilityEffectSubtypes : RawOptionSetType {
		typealias RawValue = UInt32
		private var value: UInt32 = 0
		public init(_ value: UInt32) { self.value = value }
		public init(rawValue value: UInt32) { self.value = value }
		public init(nilLiteral: ()) { self.value = 0 }
		public static var allZeros: CapabilityEffectSubtypes { return self(0) }
		public var rawValue: UInt32 { return self.value }
		
		public static var Kinesthetic: CapabilityEffectSubtypes { return CapabilityEffectSubtypes(1 << 0) }
		public static var Vibration: CapabilityEffectSubtypes { return CapabilityEffectSubtypes(1 << 1) }
	}
	
	public var axes: [UInt8] {
		var axesArray: [UInt8] = getArrayFromMirror(reflect(ffAxes))
		
		return [UInt8](axesArray[0..<min(Int(numFfAxes), axesArray.count)])
	}
	
	public var supportedEffectTypes: CapabilityEffectTypes {
		return CapabilityEffectTypes(supportedEffects)
	}
	
	public var emulatedEffectTypes: CapabilityEffectTypes {
		return CapabilityEffectTypes(emulatedEffects)
	}
	
	public var effectSubType: CapabilityEffectSubtypes {
		return CapabilityEffectSubtypes(subType)
	}
}

public struct ForceFeedbackCooperativeLevel : RawOptionSetType {
	typealias RawValue = UInt32
	private var value: UInt32 = 0
	public init(_ value: UInt32) { self.value = value }
	public init(rawValue value: UInt32) { self.value = value }
	public init(nilLiteral: ()) { self.value = 0 }
	public static var allZeros: ForceFeedbackCooperativeLevel { return self(0) }
	public var rawValue: UInt32 { return self.value }
	
	public static var Exclusive: ForceFeedbackCooperativeLevel { return ForceFeedbackCooperativeLevel(1 << 0) }
	public static var NonExclusive: ForceFeedbackCooperativeLevel { return ForceFeedbackCooperativeLevel(1 << 1) }
	public static var Foreground: ForceFeedbackCooperativeLevel { return ForceFeedbackCooperativeLevel(1 << 2) }
	public static var Background: ForceFeedbackCooperativeLevel { return ForceFeedbackCooperativeLevel(1 << 3) }
}

public struct ForceFeedbackCoordinateSystem : RawOptionSetType {
	typealias RawValue = UInt32
	private var value: UInt32 = 0
	public init(_ value: UInt32) { self.value = value }
	public init(rawValue value: UInt32) { self.value = value }
	public init(nilLiteral: ()) { self.value = 0 }
	public static var allZeros: ForceFeedbackCoordinateSystem { return self(0) }
	public var rawValue: UInt32 { return self.value }
	
	public static var Cartesian: ForceFeedbackCoordinateSystem { return ForceFeedbackCoordinateSystem(0x10) }
	public static var Polar: ForceFeedbackCoordinateSystem { return ForceFeedbackCoordinateSystem(0x20) }
	public static var Spherical: ForceFeedbackCoordinateSystem { return ForceFeedbackCoordinateSystem(0x40) }
}

public struct ForceFeedbackEffectParameter : RawOptionSetType {
	typealias RawValue = UInt32
	private var value: UInt32 = 0
	public init(_ value: UInt32) { self.value = value }
	public init(rawValue value: UInt32) { self.value = value }
	public init(nilLiteral: ()) { self.value = 0 }
	public static var allZeros: ForceFeedbackEffectParameter { return self(0) }
	public var rawValue: UInt32 { return self.value }
	
	public static var Duration: ForceFeedbackEffectParameter { return ForceFeedbackEffectParameter(1 << 0) }
	public static var SamplePeriod: ForceFeedbackEffectParameter { return ForceFeedbackEffectParameter(1 << 1) }
	public static var Gain: ForceFeedbackEffectParameter { return ForceFeedbackEffectParameter(1 << 2) }
	public static var TriggerButton: ForceFeedbackEffectParameter { return ForceFeedbackEffectParameter(1 << 3) }
	public static var TriggerRepeatInterval: ForceFeedbackEffectParameter { return ForceFeedbackEffectParameter(1 << 4) }
	public static var Axes: ForceFeedbackEffectParameter { return ForceFeedbackEffectParameter(1 << 5) }
	public static var Direction: ForceFeedbackEffectParameter { return ForceFeedbackEffectParameter(1 << 6) }
	public static var Envelope: ForceFeedbackEffectParameter { return ForceFeedbackEffectParameter(1 << 7) }
	public static var TypeSpecificParamaters: ForceFeedbackEffectParameter { return ForceFeedbackEffectParameter(1 << 8) }
	public static var StartDelay: ForceFeedbackEffectParameter { return ForceFeedbackEffectParameter(1 << 9) }
	
	public static var AllParamaters: ForceFeedbackEffectParameter { return ForceFeedbackEffectParameter(0x000003FF) }
	
	public static var Start: ForceFeedbackEffectParameter { return ForceFeedbackEffectParameter(0x20000000) }
	public static var NoRestart: ForceFeedbackEffectParameter { return ForceFeedbackEffectParameter(0x40000000) }
	public static var NoDownload: ForceFeedbackEffectParameter { return ForceFeedbackEffectParameter(0x80000000) }
	public static var NoTrigger: ForceFeedbackEffectParameter { return ForceFeedbackEffectParameter(0xFFFFFFFF) }
}

public struct ForceFeedbackEffectStatus : RawOptionSetType {
	typealias RawValue = UInt32
	private var value: UInt32 = 0
	public init(_ value: UInt32) { self.value = value }
	public init(rawValue value: UInt32) { self.value = value }
	public init(nilLiteral: ()) { self.value = 0 }
	public static var allZeros: ForceFeedbackEffectStatus { return self(0) }
	public var rawValue: UInt32 { return self.value }
	
	public static var NotPlaying: ForceFeedbackEffectStatus { return self(0) }
	public static var Playing: ForceFeedbackEffectStatus { return ForceFeedbackEffectStatus(1 << 0) }
	public static var Emulated: ForceFeedbackEffectStatus { return ForceFeedbackEffectStatus(1 << 1) }
}

public final class ForceFeedbackDevice {
	private let rawDevice: FFDeviceObjectReference
	public private(set) var lastReturnValue: ForceFeedbackResult = .OK
	
	public enum Property: UInt32 {
		case Gain = 1
		case Autocenter = 3
	}
	
	public struct Command : RawOptionSetType {
		typealias RawValue = UInt32
		private var value: UInt32 = 0
		public init(_ value: UInt32) { self.value = value }
		public init(rawValue value: UInt32) { self.value = value }
		public init(nilLiteral: ()) { self.value = 0 }
		public static var allZeros: Command { return self(0) }
		public var rawValue: UInt32 { return self.value }
		
		public static var Reset: Command { return Command(1 << 0) }
		public static var StopAll: Command { return Command(1 << 1) }
		public static var Pause: Command { return Command(1 << 2) }
		public static var Continue: Command { return Command(1 << 3) }
		public static var SetActuatorsOn: Command { return Command(1 << 4) }
		public static var SetActuatorsOff: Command { return Command(1 << 5) }
	}
	
	public struct State : RawOptionSetType {
		typealias RawValue = UInt32
		private var value: UInt32 = 0
		public init(_ value: UInt32) { self.value = value }
		public init(rawValue value: UInt32) { self.value = value }
		public init(nilLiteral: ()) { self.value = 0 }
		public static var allZeros: State { return self(0) }
		public var rawValue: UInt32 { return self.value }
		
		public static var Empty: State { return State(1 << 0) }
		public static var Stopped: State { return State(1 << 1) }
		public static var Paused: State { return State(1 << 2) }
		
		public static var ActuatorsOn: State { return State(1 << 4) }
		public static var ActuatorsOff: State { return State(1 << 5) }
		public static var PowerOn: State { return State(1 << 6) }
		public static var PowerOff: State { return State(1 << 7) }
		public static var SafetySwitchOn: State { return State(1 << 8) }
		public static var SafetySwitchOff: State { return State(1 << 9) }
		public static var UserSwitchOn: State { return State(1 << 10) }
		public static var UserSwitchOff: State { return State(1 << 11) }
		public static var DeviceLost: State { return State(0x80000000) }
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
	
	/// Returns true if device is capable of Force feedback.
	/// Returns false if it isn't.
	/// Returns nil if there was an error.
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
	
	public func sendEscape(inout theEscape: FFEFFESCAPE) -> ForceFeedbackResult {
		let aReturn = ForceFeedbackResult.fromHResult(FFDeviceEscape(rawDevice, &theEscape))
		lastReturnValue = aReturn
		return aReturn
	}
	
	public func sendEscape(#command: DWORD, inData: NSData) -> ForceFeedbackResult {
		let curDataSize = inData.length
		var tmpMutBytes = malloc(curDataSize)
		memcpy(&tmpMutBytes, inData.bytes, curDataSize)
		var ourEscape = FFEFFESCAPE(dwSize: DWORD(sizeof(FFEFFESCAPE)), dwCommand: command, lpvInBuffer: tmpMutBytes, cbInBuffer: DWORD(curDataSize), lpvOutBuffer: nil, cbOutBuffer: 0)
		
		let toRet = sendEscape(&ourEscape)
		lastReturnValue = toRet
		
		free(tmpMutBytes)
		
		return toRet
	}
	
	public func sendEscape(#command: DWORD, inData: NSData, inout outDataLength: Int) -> (result: ForceFeedbackResult, outData: NSData) {
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
		let errVal = ForceFeedbackResult.fromHResult(FFDeviceGetForceFeedbackState(rawDevice, &ourState))
		lastReturnValue = errVal
		if lastReturnValue.isSuccess {
			return State(ourState)
		} else {
			return State(0)
		}
	}
	
	public func sendCommand(command: Command) -> ForceFeedbackResult {
		let iErr = ForceFeedbackResult.fromHResult(FFDeviceSendForceFeedbackCommand(rawDevice, command.rawValue))
		lastReturnValue = iErr
		return iErr
	}
	
	/// Calls getProperty/setProperty, which may return failure info.
	/// Use lastReturnValue to check if the getter/setter were successful.
	public var autocenter: Bool {
		get {
			var theVal: UInt32 = 0
			let iErr = getProperty(.Autocenter, value: &theVal, valueSize: IOByteCount(sizeof(UInt32.Type)))
			lastReturnValue = iErr
			return theVal != 0
		}
		set {
			var theVal: UInt32 = newValue == true ? 1 : 0
			lastReturnValue = setProperty(.Autocenter, value: &theVal)
		}
	}
	
	/// Calls getProperty/setProperty, which may return failure info.
	/// Use lastReturnValue to check if the getter/setter were successful.
	public var gain: UInt32 {
		get {
			var theVal: UInt32 = 0
			var iErr = getProperty(.Gain, value: &theVal, valueSize: IOByteCount(sizeof(UInt32.Type)))
			lastReturnValue = iErr
			return theVal
		}
		set {
			var theVal = newValue
			lastReturnValue = setProperty(.Gain, value: &theVal)
		}
	}
	
	/// Function is unimplemented in version 1.0 of Apple's FF API.
	public func setCooperativeLevel(taskIdentifier: UnsafeMutablePointer<Void>, flags: ForceFeedbackCooperativeLevel) -> ForceFeedbackResult {
		let iErr = ForceFeedbackResult.fromHResult(FFDeviceSetCooperativeLevel(rawDevice, taskIdentifier, flags.rawValue))
		lastReturnValue = iErr
		return iErr
	}
	
	public func setProperty(property: Property, value: UnsafeMutablePointer<Void>) -> ForceFeedbackResult {
		let iErr = ForceFeedbackResult.fromHResult(FFDeviceSetForceFeedbackProperty(rawDevice, property.rawValue, value))
		lastReturnValue = iErr
		return iErr
	}
	
	public func getProperty(property: Property, value: UnsafeMutablePointer<Void>, valueSize: IOByteCount) -> ForceFeedbackResult {
		let iErr = ForceFeedbackResult.fromHResult(FFDeviceGetForceFeedbackProperty(rawDevice, property.rawValue, value, valueSize))
		lastReturnValue = iErr
		return iErr
	}
	
	public func setProperty(property: UInt32, value: UnsafeMutablePointer<Void>) -> ForceFeedbackResult {
		let iErr = ForceFeedbackResult.fromHResult(FFDeviceSetForceFeedbackProperty(rawDevice, property, value))
		lastReturnValue = iErr
		return iErr
	}
	
	public func getProperty(property: UInt32, value: UnsafeMutablePointer<Void>, valueSize: IOByteCount) -> ForceFeedbackResult {
		let iErr = ForceFeedbackResult.fromHResult(FFDeviceGetForceFeedbackProperty(rawDevice, property, value, valueSize))
		lastReturnValue = iErr
		return iErr
	}
	
	deinit {
		if rawDevice != nil {
			FFReleaseDevice(rawDevice)
		}
	}
}

public final class ForceFeedbackEffect {
	private let rawEffect: FFEffectObjectReference
	public let deviceReference: ForceFeedbackDevice
	
	public struct EffectStart : RawOptionSetType {
		typealias RawValue = UInt32
		private var value: UInt32 = 0
		public init(_ value: UInt32) { self.value = value }
		public init(rawValue value: UInt32) { self.value = value }
		public init(nilLiteral: ()) { self.value = 0 }
		public static var allZeros: EffectStart { return self(0) }
		public var rawValue: UInt32 { return self.value }
		
		public static var Solo: EffectStart { return EffectStart(0x01) }
		public static var NoDownload: EffectStart { return EffectStart(0x80000000) }
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
	
	/// E559C460-C5CD-11D6-8A1C-00039353BD00
	/// UUID for a constant force effect type
	public static let ConstantForce: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x60, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	/// E559C461-C5CD-11D6-8A1C-00039353BD00
	/// UUID for a ramp force effect type
	public static let RampForce: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x61, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	/// E559C462-C5CD-11D6-8A1C-00039353BD00
	/// UUID for a square wave effect type
	public static let Square: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x62, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	/// E559C463-C5CD-11D6-8A1C-00039353BD00
	/// UUID for a sine wave effect type
	public static let Sine: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x63, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	/// E559C464-C5CD-11D6-8A1C-00039353BD00
	/// UUID for a triangle wave effect type
	public static let Triangle: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x64, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	/// E559C465-C5CD-11D6-8A1C-00039353BD00
	/// UUID for a upwards sawtooth wave effect type
	public static let SawtoothUp: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x65, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	/// E559C466-C5CD-11D6-8A1C-00039353BD00
	/// UUID for a downwards sawtooth wave effect type
	public static let SawtoothDown: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x66, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	/// E559C467-C5CD-11D6-8A1C-00039353BD00
	/// UUID for a spring effect type
	public static let Spring: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x67, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	/// E559C468-C5CD-11D6-8A1C-00039353BD00
	/// UUID for a damper effect type
	public static let Damper: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x68, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	/// E559C469-C5CD-11D6-8A1C-00039353BD00
	/// UUID for an inertia effect type
	public static let Inertia: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x69, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	/// E559C46A-C5CD-11D6-8A1C-00039353BD00
	/// UUID for a friction effect type
	public static let Friction: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x6A, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	/// E559C46B-C5CD-11D6-8A1C-00039353BD00
	/// UUID for a custom force effect type
	public static let CustomForce: CFUUID = CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x6B, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	
	public convenience init?(device: ForceFeedbackDevice, UUID: NSUUID, inout effectDefinition: FFEFFECT) {
		let ourUUID = UUID.cfUUID
		
		self.init(device: device, UUID: ourUUID, effectDefinition: &effectDefinition)
	}
	
	public convenience init?(device: ForceFeedbackDevice, effect: EffectType, inout effectDefinition: FFEFFECT) {
		let ourUUID = effect.UUIDValue
		
		self.init(device: device, UUID: ourUUID, effectDefinition: &effectDefinition)
	}
	
	public init?(device: ForceFeedbackDevice, UUID: CFUUID, inout effectDefinition: FFEFFECT) {
		deviceReference = device
		var tmpEffect: FFEffectObjectReference = nil
		let iErr = FFDeviceCreateEffect(device.rawDevice, UUID, &effectDefinition, &tmpEffect)
		if iErr >= 0 {
			rawEffect = tmpEffect
		} else {
			rawEffect = nil
			return nil
		}
	}
	
	public func start(iterations: UInt32 = 1, flags: EffectStart = EffectStart.Solo) -> ForceFeedbackResult {
		return ForceFeedbackResult.fromHResult(FFEffectStart(rawEffect, iterations, flags.rawValue))
	}
	
	public func stop() -> ForceFeedbackResult {
		return ForceFeedbackResult.fromHResult(FFEffectStop(rawEffect))
	}
	
	public func download() -> ForceFeedbackResult{
		return ForceFeedbackResult.fromHResult(FFEffectDownload(rawEffect))
	}
	
	public func getParameters(inout effect: FFEFFECT, flags: ForceFeedbackEffectParameter) -> ForceFeedbackResult {
		return ForceFeedbackResult.fromHResult(FFEffectGetParameters(rawEffect, &effect, flags.rawValue))
	}
	
	public func setParameters(inout effect: FFEFFECT, flags: ForceFeedbackEffectParameter) -> ForceFeedbackResult {
		return ForceFeedbackResult.fromHResult(FFEffectSetParameters(rawEffect, &effect, flags.rawValue))
	}
	
	deinit {
		if rawEffect != nil {
			FFDeviceReleaseEffect(deviceReference.rawDevice, rawEffect)
		}
	}
}
