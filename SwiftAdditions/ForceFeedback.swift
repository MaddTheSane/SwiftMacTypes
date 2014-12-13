//
//  ForceFeedback.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 10/20/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

#if os(OSX)
import CoreFoundation
import Foundation
import ForceFeedback

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
	
	public func isSuccess() -> Bool {
		return rawValue >= 0
	}
	
	public func isFailure() -> Bool {
		return rawValue < 0
	}
}

extension FFCONSTANTFORCE {
	public init() {
		lMagnitude = 0
	}
	
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
	public init() {
		lStart = 0
		lEnd = 0
	}
	
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
	public init() {
		dwSize = 0
		dwFlags = 0
		dwDuration = 0
		dwSamplePeriod = 0
		dwGain = 0
		dwTriggerButton = 0
		dwTriggerRepeatInterval = 0
		cAxes = 0
		rgdwAxes = nil
		rglDirection = nil
		cbTypeSpecificParams = 0
		lpvTypeSpecificParams = nil
		dwStartDelay = 0
		lpEnvelope = nil
	}
	
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
			cbTypeSpecificParams = newValue.size
			lpvTypeSpecificParams = newValue.value
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
	
	//TODO: all axes values
	var axes: UInt32 {
		get {
			return cAxes
		}
		set {
			cAxes = newValue
		}
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
	public init() {
		dwSize = 0
		dwAttackLevel = 0
		dwAttackTime = 0
		dwFadeLevel = 0
		dwFadeTime = 0
	}
	
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
	public init() {
		lOffset = 0
		lPositiveCoefficient = 0
		lNegativeCoefficient = 0
		dwPositiveSaturation = 0
		dwNegativeSaturation = 0
		lDeadBand = 0
	}
	
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
			lPositiveCoefficient = newValue.positive
			lNegativeCoefficient = newValue.negative
		}
	}
	
	public var saturation: (positive: UInt32, negative: UInt32) {
		get {
			return (dwPositiveSaturation, dwNegativeSaturation)
		}
		set {
			dwPositiveSaturation = newValue.positive
			dwNegativeSaturation = newValue.negative
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
	public init() {
		cChannels = 0
		dwSamplePeriod = 0
		cSamples = 0
		rglForceData = nil
	}
	
	public var samplePeriod: UInt32 {
		get {
			return dwSamplePeriod
		}
		set {
			dwSamplePeriod = newValue
		}
	}
	
	/// Returns true if the data sent in is valid
	public mutating func setData(#channels: DWORD, samples: DWORD, forceData: LPLONG) -> Bool {
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
	public init() {
		dwMagnitude = 0
		lOffset = 0
		dwPhase = 0
		dwPeriod = 0
	}
	
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
	public init() {
		dwSize = 0
		dwCommand = 0
		lpvInBuffer = nil
		cbInBuffer = 0
		lpvOutBuffer = nil
		cbOutBuffer = 0
	}
	
	public var inBuffer: (size: UInt32, data: UnsafeMutablePointer<Void>) {
		get {
			return (cbInBuffer, lpvInBuffer)
		}
		set {
			cbInBuffer = newValue.size
			lpvInBuffer = newValue.data
		}
	}
	
	public var outBuffer: (size: UInt32, data: UnsafeMutablePointer<Void>) {
		get {
			return (cbOutBuffer, lpvOutBuffer)
		}
		set {
			cbOutBuffer = newValue.size
			lpvOutBuffer = newValue.data
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
	public init() {
		ffSpecVer = NumVersion()
		supportedEffects = 0
		emulatedEffects = 0
		subType = 0
		numFfAxes = 0
		storageCapacity = 0
		playbackCapacity = 0
		firmwareVer = NumVersion()
		hardwareVer = NumVersion()
		driverVer = NumVersion()
		ffAxes = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
	}
	
	public var axes: [UInt8] {
		var axesArray: [UInt8] = GetArrayFromMirror(reflect(ffAxes))!
		if Int(numFfAxes) < axesArray.count {
			axesArray.removeRange(Int(numFfAxes)..<axesArray.count)
		}
		return axesArray
	}
	
	public var supportedEffectTypes: ForceFeedbackCapabilitiesEffectType {
		return ForceFeedbackCapabilitiesEffectType(supportedEffects)
	}
	
	public var emulatedEffectTypes: ForceFeedbackCapabilitiesEffectType {
		return ForceFeedbackCapabilitiesEffectType(emulatedEffects)
	}
	
	public var effectSubType: ForceFeedbackCapabilitiesEffectSubType {
		return ForceFeedbackCapabilitiesEffectSubType(subType)
	}
}
	
public struct ForceFeedbackCommand : RawOptionSetType {
	public typealias RawValue = UInt32
	private var value: RawValue = 0
	public init(_ value: RawValue) { self.value = value }
	public init(rawValue value: RawValue) { self.value = value }
	public init(nilLiteral: ()) { self.value = 0 }
	public static var allZeros: ForceFeedbackCommand { return self(0) }
	public static func fromMask(raw: RawValue) -> ForceFeedbackCommand { return self(raw) }
	public var rawValue: RawValue { return self.value }
	
	public static var Reset: ForceFeedbackCommand { return ForceFeedbackCommand(1 << 0) }
	public static var StopAll: ForceFeedbackCommand { return ForceFeedbackCommand(1 << 1) }
	public static var Pause: ForceFeedbackCommand { return ForceFeedbackCommand(1 << 2) }
	public static var Continue: ForceFeedbackCommand { return ForceFeedbackCommand(1 << 3) }
	public static var SetActuatorsOn: ForceFeedbackCommand { return ForceFeedbackCommand(1 << 4) }
	public static var SetActuatorsOff: ForceFeedbackCommand { return ForceFeedbackCommand(1 << 5) }
}

public struct ForceFeedbackCooperativeLevel : RawOptionSetType {
	public typealias RawValue = UInt32
	private var value: RawValue = 0
	public init(_ value: RawValue) { self.value = value }
	public init(rawValue value: RawValue) { self.value = value }
	public init(nilLiteral: ()) { self.value = 0 }
	public static var allZeros: ForceFeedbackCooperativeLevel { return self(0) }
	public static func fromMask(raw: RawValue) -> ForceFeedbackCooperativeLevel { return self(raw) }
	public var rawValue: RawValue { return self.value }
	
	public static var Exclusive: ForceFeedbackCooperativeLevel { return ForceFeedbackCooperativeLevel(1 << 0) }
	public static var NonExclusive: ForceFeedbackCooperativeLevel { return ForceFeedbackCooperativeLevel(1 << 1) }
	public static var Foreground: ForceFeedbackCooperativeLevel { return ForceFeedbackCooperativeLevel(1 << 2) }
	public static var Background: ForceFeedbackCooperativeLevel { return ForceFeedbackCooperativeLevel(1 << 3) }
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

public struct ForceFeedbackCoordinateSystem : RawOptionSetType {
	public typealias RawValue = UInt32
	private var value: RawValue = 0
	public init(_ value: RawValue) { self.value = value }
	public init(rawValue value: RawValue) { self.value = value }
	public init(nilLiteral: ()) { self.value = 0 }
	public static var allZeros: ForceFeedbackCoordinateSystem { return self(0) }
	public static func fromMask(raw: RawValue) -> ForceFeedbackCoordinateSystem { return self(raw) }
	public var rawValue: RawValue { return self.value }
	
	public static var Cartesian: ForceFeedbackCoordinateSystem { return ForceFeedbackCoordinateSystem(0x10) }
	public static var Polar: ForceFeedbackCoordinateSystem { return ForceFeedbackCoordinateSystem(0x20) }
	public static var Spherical: ForceFeedbackCoordinateSystem { return ForceFeedbackCoordinateSystem(0x40) }
}

public struct ForceFeedbackEffectParameter : RawOptionSetType {
	public typealias RawValue = UInt32
	private var value: RawValue = 0
	public init(_ value: RawValue) { self.value = value }
	public init(rawValue value: RawValue) { self.value = value }
	public init(nilLiteral: ()) { self.value = 0 }
	public static var allZeros: ForceFeedbackEffectParameter { return self(0) }
	public static func fromMask(raw: RawValue) -> ForceFeedbackEffectParameter { return self(raw) }
	public var rawValue: RawValue { return self.value }
	
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
	public typealias RawValue = UInt32
	private var value: RawValue = 0
	public init(_ value: RawValue) { self.value = value }
	public init(rawValue value: RawValue) { self.value = value }
	public init(nilLiteral: ()) { self.value = 0 }
	public static var allZeros: ForceFeedbackEffectStatus { return self(0) }
	public static func fromMask(raw: RawValue) -> ForceFeedbackEffectStatus { return self(raw) }
	public var rawValue: RawValue { return self.value }
	
	public static var NotPlaying: ForceFeedbackEffectStatus { return self(0) }
	public static var Playing: ForceFeedbackEffectStatus { return ForceFeedbackEffectStatus(1 << 0) }
	public static var Emulated: ForceFeedbackEffectStatus { return ForceFeedbackEffectStatus(1 << 1) }
}

public class ForceFeedbackDevice {
	private let rawDevice: FFDeviceObjectReference
	
	public enum Property: UInt32 {
		case Gain = 1
		case Autocenter = 3
	}
	
	public struct State : RawOptionSetType {
		public typealias RawValue = UInt32
		private var value: RawValue = 0
		public init(_ value: RawValue) { self.value = value }
		public init(rawValue value: RawValue) { self.value = value }
		public init(nilLiteral: ()) { self.value = 0 }
		public static var allZeros: State { return self(0) }
		public static func fromMask(raw: RawValue) -> State { return self(raw) }
		public var rawValue: RawValue { return self.value }
		
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
	
	public class var Infinite: UInt32 {
		return 0xFFFFFFFF
	}
	
	public class var Degrees: Int {
		return 100
	}
	
	public class var NominalMax: Int {
		return 10000
	}
	
	private class var Seconds: Int {
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
		return ForceFeedbackResult.fromHResult(FFDeviceEscape(rawDevice, &theEscape))
	}
	
	public func sendEscape(#command: DWORD, inData: NSData) -> ForceFeedbackResult {
		let curDataSize = inData.length
		var tmpMutBytes = malloc(UInt(curDataSize))
		memcpy(&tmpMutBytes, inData.bytes, UInt(curDataSize))
		var ourEscape = FFEFFESCAPE(dwSize: DWORD(sizeof(FFEFFESCAPE.Type)), dwCommand: command, lpvInBuffer: tmpMutBytes, cbInBuffer: DWORD(curDataSize), lpvOutBuffer: nil, cbOutBuffer: 0)
		
		let toRet = sendEscape(&ourEscape)
		
		free(tmpMutBytes)
		
		return toRet
	}
	
	public func sendEscape(#command: DWORD, inData: NSData, inout outDataLength: Int) -> (result: ForceFeedbackResult, outData: NSData) {
		if let ourMutableData = NSMutableData(length: outDataLength) {
			let curDataSize = inData.length
			var tmpMutBytes = malloc(UInt(curDataSize))
			memcpy(&tmpMutBytes, inData.bytes, UInt(curDataSize))
			var ourEscape = FFEFFESCAPE(dwSize: DWORD(sizeof(FFEFFESCAPE.Type)), dwCommand: command, lpvInBuffer: tmpMutBytes, cbInBuffer: DWORD(curDataSize), lpvOutBuffer: ourMutableData.mutableBytes, cbOutBuffer: DWORD(outDataLength))
			
			let toRet = sendEscape(&ourEscape)
			
			free(tmpMutBytes)
			ourMutableData.length = Int(ourEscape.cbOutBuffer)
			
			return (toRet, NSData(data: ourMutableData))
		} else {
			return (.OutOfMemory, NSData())
		}
	}
	
	public var state: State {
		var ourState: FFState = 0
		if FFDeviceGetForceFeedbackState(rawDevice, &ourState) >= 0 {
			return State(ourState)
		} else {
			return State(0)
		}
	}
	
	public func sendForceFeedbackCommand(command: ForceFeedbackCommand) -> ForceFeedbackResult {
		return ForceFeedbackResult.fromHResult(FFDeviceSendForceFeedbackCommand(rawDevice, command.rawValue))
	}
	
	public var autocenter: Bool {
		get {
			var theVal: UInt32 = 0
			var iErr = getProperty(.Autocenter, value: &theVal, valueSize: IOByteCount(sizeof(UInt32.Type)))
			return theVal == 1
		}
		set {
			var theVal: UInt32 = newValue == true ? 1 : 0
			var iErr = setProperty(.Autocenter, value: &theVal)
		}
	}
	
	public var gain: UInt32 {
		get {
			var theVal: UInt32 = 0
			var iErr = getProperty(.Gain, value: &theVal, valueSize: IOByteCount(sizeof(UInt32.Type)))
			return theVal
		}
		set {
			var theVal = newValue
			var iErr = setProperty(.Gain, value: &theVal)
		}
	}
	
	/// function is unimplemented in version 1.0 of Apple's FF API.
	public func setCooperativeLevel(taskIdentifier: UnsafeMutablePointer<Void>, flags: ForceFeedbackCooperativeLevel) -> ForceFeedbackResult {
		return ForceFeedbackResult.fromHResult(FFDeviceSetCooperativeLevel(rawDevice, taskIdentifier, flags.rawValue))
	}
	
	private func setProperty(property: Property, value: UnsafeMutablePointer<Void>) -> ForceFeedbackResult {
		return ForceFeedbackResult.fromHResult(FFDeviceSetForceFeedbackProperty(rawDevice, property.rawValue, value))
	}
	
	private func getProperty(property: Property, value: UnsafeMutablePointer<Void>, valueSize: IOByteCount) -> ForceFeedbackResult {
		return ForceFeedbackResult.fromHResult(FFDeviceGetForceFeedbackProperty(rawDevice, property.rawValue, value, valueSize))
	}
	
	public func setProperty(property: UInt32, value: UnsafeMutablePointer<Void>) -> ForceFeedbackResult {
		return ForceFeedbackResult.fromHResult(FFDeviceSetForceFeedbackProperty(rawDevice, property, value))
	}
	
	public func getProperty(property: UInt32, value: UnsafeMutablePointer<Void>, valueSize: IOByteCount) -> ForceFeedbackResult {
		return ForceFeedbackResult.fromHResult(FFDeviceGetForceFeedbackProperty(rawDevice, property, value, valueSize))
	}
	
	deinit {
		if rawDevice != nil {
			FFReleaseDevice(rawDevice)
		}
	}
}

public class ForceFeedbackEffect {
	private let rawEffect: FFEffectObjectReference
	public unowned let deviceReference: ForceFeedbackDevice
	
	public struct EffectStart : RawOptionSetType {
		public typealias RawValue = UInt32
		private var value: RawValue = 0
		public init(_ value: RawValue) { self.value = value }
		public init(rawValue value: RawValue) { self.value = value }
		public init(nilLiteral: ()) { self.value = 0 }
		public static var allZeros: EffectStart { return self(0) }
		public static func fromMask(raw: RawValue) -> EffectStart { return self(raw) }
		public var rawValue: RawValue { return self.value }
		
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
	
	// E559C460-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined ConstantForce
	@discussion UUID for a constant force effect type
 */
	public class var ConstantForce: CFUUID {
		return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x60, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	}
	
	// E559C461-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined RampForce
	@discussion UUID for a ramp force effect type
 */
	public class var RampForce: CFUUID {
		return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x61, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	}
	
	// E559C462-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined Square
	@discussion UUID for a square wave effect type
 */
	public class var Square: CFUUID {
		return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x62, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	}
	
	// E559C463-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined Sine
	@discussion UUID for a sine wave effect type
 */
	public class var Sine: CFUUID {
		return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x63, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	}
	
	// E559C464-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined Triangle
	@discussion UUID for a triangle wave effect type
 */
	public class var Triangle: CFUUID {
		return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x64, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	}
	
	// E559C465-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined SawtoothUp
	@discussion UUID for a upwards sawtooth wave effect type
 */
	public class var SawtoothUp: CFUUID {
		return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x65, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	}
	
	// E559C466-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined SawtoothDown
	@discussion UUID for a downwards sawtooth wave effect type
 */
	public class var SawtoothDown: CFUUID {
		return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x66, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	}
	
	// E559C467-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined Spring
	@discussion UUID for a spring effect type
 */
	public class var Spring: CFUUID {
		return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x67, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	}
	
	// E559C468-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined Damper
	@discussion UUID for a damper effect type
 */
	public class var Damper: CFUUID {
		return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x68, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	}
	
	// E559C469-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined Inertia
	@discussion UUID for an inertia effect type
 */
	public class var Inertia: CFUUID {
		return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x69, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	}
	
	// E559C46A-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined Friction
	@discussion UUID for a friction effect type
 */
	public class var Friction: CFUUID {
		return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorDefault,
			0xE5, 0x59, 0xC4, 0x6A, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00)
	}
	
	// E559C46B-C5CD-11D6-8A1C-00039353BD00
	/*!
	@defined CustomForce
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
	
	public func start(iterations: Int = 1, flags: EffectStart = EffectStart.Solo) -> ForceFeedbackResult {
		return ForceFeedbackResult.fromHResult(FFEffectStart(rawEffect, UInt32(iterations), flags.rawValue))
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
#endif
