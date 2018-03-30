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
import os.log

/// The error domain of `ForceFeedbackResult`
public let ForceFeedbackResultErrorDomain =
"com.github.maddthesane.ForceFeedbackAdditions.ForceFeedbackResult"

public enum ForceFeedbackResult: HRESULT, Error {
	/// The operation completed successfully.
	case ok = 0
	/// The operation did not complete successfully.
	case `false` = 1
	/// The parameters of the effect were successfully updated by
	/// `ForceFeedbackEffect.setParameters(_:flags:)`, but the effect was not
	/// downloaded because the `ForceFeedbackEffect.EffectStart.noDownload` 
	/// flag was passed.
	case downloadSkipped = 3
	/// The parameters of the effect were successfully updated by
	/// `ForceFeedbackEffect.setParameters(_:flags:)`, but in order to change
	/// the parameters, the effect needed to be restarted.
	case effectRestarted = 4
	/// The parameters of the effect were successfully updated by
	/// `ForceFeedbackEffect.setParameters(_:flags:)`, but some of them were
	/// beyond the capabilities of the device and were truncated.
	case truncated = 8
	/// Equal to `ForceFeedbackResult([.effectRestarted, .truncated])`
	case truncatedAndRestarted = 12
	/// An invalid parameter was passed to the returning function,
	/// or the object was not in a state that admitted the function
	/// to be called.
	case invalidParameter = -2147483645
	/// The specified interface is not supported by the object.
	case noInterface = -2147483644
	/// An undetermined error occurred.
	case generic = -2147483640
	/// Couldn't allocate sufficient memory to complete the caller's request.
	case outOfMemory = -2147483646
	/// The function called is not supported at this time
	case unsupported = -2147483647
	/// Data is not yet available.
	case pending = -2147483638
	/// The device is full.
	case deviceFull = -2147220991
	/// The device or device instance or effect is not registered.
	case deviceNotRegistered = -2147221164
	/// Not all the requested information fit into the buffer.
	case moreData = -2147220990
	/// The effect is not downloaded.
	case notDownloaded = -2147220989
	/// The device cannot be reinitialized because there are still effects
	/// attached to it.
	case hasEffects = -2147220988
	/// The effect could not be downloaded because essential information
	/// is missing.  For example, no axes have been associated with the
	/// effect, or no type-specific information has been created.
	case incompleteEffect = -2147220986
	/// An attempt was made to modify parameters of an effect while it is
	/// playing.  Not all hardware devices support altering the parameters
	/// of an effect while it is playing.
	case effectPlaying = -2147220984
	/// The operation could not be completed because the device is not
	/// plugged in.
	case unplugged = -2147220983
	// MARK: Mac OS X-specific
	/// The effect index provided by the API in downloadID is not recognized by the
	/// **IOForceFeedbackLib** driver.
	case invalidDownloadID = -2147220736
	/// When the device is paused via a call to `ForceFeedbackDevice.sendCommand(_:)`,
	/// other operations such as modifying existing effect parameters and creating
	/// new effects are not allowed.
	case devicePaused = -2147220735
	/// The **IOForceFededbackLib** driver has detected an internal fault.  Often this
	/// occurs because of an unexpected internal code path.
	case `internal` = -2147220734
	/// The **IOForceFededbackLib** driver has received an effect modification request
	/// whose basic type does not match the defined effect type for the given effect.
	case effectTypeMismatch = -2147220733
	/// The effect includes one or more axes that the device does not support.
	case unsupportedAxis = -2147220732
	/// This object has not been initialized.
	case notInitialized = -2147220731
	/// The device has been released.
	case deviceReleased = -2147220729
	/// The effect type requested is not explicitly supported by the particular device.
	case effectTypeNotSupported = -2147220730
	
	fileprivate static func from(result inResult: HRESULT) -> ForceFeedbackResult {
		if let unwrapped = ForceFeedbackResult(rawValue: inResult) {
			return unwrapped
		} else {
			if inResult > 0 {
				return .ok
			} else {
				return .generic
			}
		}
	}
	
	/// is `true` if the raw value is greater than or equal to `0`.
	public var isSuccess: Bool {
		return rawValue >= 0
	}
	
	/// is `true` if the raw value is less than `0`.
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
	/// Different coordinates used by the Force Feedback framework.
	public struct CoordinateSystem : OptionSet {
		public let rawValue: UInt32
		private init(_ value: UInt32) { self.rawValue = value }
		public init(rawValue value: UInt32) { self.rawValue = value }
		
		/// Cartesian coordinates
		public static var cartesian: CoordinateSystem {
			return CoordinateSystem(0x10)
		}
		/// Polar coordinates
		public static var polar: CoordinateSystem {
			return CoordinateSystem(0x20)
		}
		/// Sperical coordinates
		public static var spherical: CoordinateSystem {
			return CoordinateSystem(0x40)
		}
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
	
	public var typeSpecificParameters: (size: UInt32, value: UnsafeMutableRawPointer?) {
		get {
			return (cbTypeSpecificParams, lpvTypeSpecificParams)
		}
		set {
			cbTypeSpecificParams = newValue.size
			lpvTypeSpecificParams = newValue.value
		}
	}
	
	public var envelope: PFFENVELOPE? {
		get {
			return lpEnvelope
		}
		set {
			lpEnvelope = newValue
		}
	}
	
	public var axes: [UInt32] {
		guard let rgdwAxes = rgdwAxes else {
			return []
		}
		return Array(UnsafeBufferPointer(start: rgdwAxes, count: min(Int(cAxes), 32)))
	}
	
	public var directions: [Int32] {
		guard let rglDirection = rglDirection else {
			return []
		}
		return Array(UnsafeBufferPointer(start: rglDirection, count: min(Int(cAxes), 32)))
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
	/// Magnitude of the effect, in the range from `0` through `10,000`. If an envelope
	/// is applied to this effect, the value represents the magnitude of the sustain. 
	/// If no envelope is applied, the value represents the amplitude of the entire effect.
	public var magnitude: UInt32 {
		get {
			return dwMagnitude
		}
		set {
			dwMagnitude = newValue
		}
	}
	
	/// Offset of the effect. The range of forces generated by the effect 
	/// is `offset` minus `magnitude` to `offset` plus `magnitude`. The value 
	/// of the `offset` member is also the baseline for any envelope that is
	/// applied to the effect.
	public var offset: Int32 {
		get {
			return lOffset
		}
		set {
			lOffset = newValue
		}
	}
	
	/// Position in the cycle of the periodic effect at which playback begins, 
	/// in the range from `0` through `35,999`.
	public var phase: UInt32 {
		get {
			return dwPhase
		}
		set {
			dwPhase = newValue
		}
	}
	
	/// Period of the effect, in microseconds.
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
	public var bufferIn: (size: UInt32, data: UnsafeMutableRawPointer?) {
		get {
			return (cbInBuffer, lpvInBuffer)
		}
		set {
			cbInBuffer = newValue.size
			lpvInBuffer = newValue.data
		}
	}
	
	public var bufferOut: (size: UInt32, data: UnsafeMutableRawPointer?) {
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

extension FFCAPABILITIES {
	/// Axis and Button field offsets, used in `FFEFFECT.dwTriggerButton` and `FFEFFECT.rgdwAxes[`*n*`]`.
	public enum Axis {
		case x(offset: UInt8)
		case y(offset: UInt8)
		case z(offset: UInt8)
		case rx(offset: UInt8)
		case ry(offset: UInt8)
		case rz(offset: UInt8)
		case slider(number: UInt8, offset: UInt8)
		case POV(number: UInt8, offset: UInt8)
		case button(UInt8)
		case unknown(UInt8)
		
		public var rawValue: UInt8 {
			switch self {
			case let .x(o):
				return 0 + o
				
			case let .y(o):
				return 4 + o
				
			case let .z(o):
				return 8 + o
				
			case let .rx(o):
				return 12 + o
				
			case let .ry(o):
				return 16 + o
				
			case let .rz(o):
				return 20 + o
				
			case let .slider(n, o):
				return UInt8(24 + Int(n) * MemoryLayout<LONG>.size) + o
				
			case let .POV(n, o):
				return UInt8(32 + Int(n) * MemoryLayout<DWORD>.size) + o
				
			case let .button(n):
				return 48 + n
				
			case let .unknown(n):
				return n
			}
		}
		
		public init(rawValue rv: UInt8) {
			switch rv {
			case 0..<4:
				self = Axis.x(offset: rv % 4)
				
			case 4..<8:
				self = Axis.y(offset: rv % 4)
				
			case 8..<12:
				self = Axis.z(offset: rv % 4)
				
			case 12..<16:
				self = Axis.rx(offset: rv % 4)
				
			case 16..<20:
				self = Axis.ry(offset: rv % 4)
				
			case 20..<24:
				self = Axis.rz(offset: rv % 4)
				
			case 24..<32:
				self = Axis.slider(number: (rv - 24) / UInt8(MemoryLayout<LONG>.size), offset: rv - ((rv - 24) / UInt8(MemoryLayout<LONG>.size)))
				
			case 32..<48:
				self = Axis.POV(number: (rv - 32) / UInt8(MemoryLayout<DWORD>.size), offset: rv - ((rv - 32) / UInt8(MemoryLayout<DWORD>.size)))
				
			case 48..<70:
				self = Axis.button(rv - 48)
				
			default:
				self = Axis.unknown(rv)
			}
		}
		
		public static var button0: Axis {
			return button(0)
		}
		
		public static var button1: Axis {
			return button(1)
		}
		
		public static var button2: Axis {
			return button(2)
		}
		
		public static var button3: Axis {
			return button(3)
		}
		
		public static var button4: Axis {
			return button(4)
		}
		
		public static var button5: Axis {
			return button(5)
		}
		
		public static var button6: Axis {
			return button(6)
		}
		
		public static var button7: Axis {
			return button(7)
		}
		
		public static var button8: Axis {
			return button(8)
		}
		
		public static var button9: Axis {
			return button(9)
		}
		
		public static var button10: Axis {
			return button(10)
		}
		
		public static var button11: Axis {
			return button(11)
		}
		
		public static var button12: Axis {
			return button(12)
		}
		
		public static var button13: Axis {
			return button(13)
		}
		
		public static var button14: Axis {
			return button(14)
		}
		
		public static var button15: Axis {
			return button(15)
		}
		
		public static var button16: Axis {
			return button(16)
		}
		
		public static var button17: Axis {
			return button(17)
		}
		
		public static var button18: Axis {
			return button(18)
		}
		
		public static var button19: Axis {
			return button(19)
		}
		
		public static var button20: Axis {
			return button(20)
		}
		
		public static var button21: Axis {
			return button(21)
		}
		
		public static var button22: Axis {
			return button(22)
		}
		
		public static var button23: Axis {
			return button(23)
		}
		
		public static var button24: Axis {
			return button(24)
		}
		
		public static var button25: Axis {
			return button(25)
		}
		
		public static var button26: Axis {
			return button(26)
		}
		
		public static var button27: Axis {
			return button(27)
		}
		
		public static var button28: Axis {
			return button(28)
		}
		
		public static var button29: Axis {
			return button(29)
		}
		
		public static var button30: Axis {
			return button(30)
		}
		
		public static var button31: Axis {
			return button(31)
		}
	}
	
	public struct EffectTypes : OptionSet {
		public let rawValue: UInt32
		private init(_ value: UInt32) { self.rawValue = value }
		public init(rawValue value: UInt32) { self.rawValue = value }
		
		public static var constantForce: EffectTypes {
			return EffectTypes(1 << 0)
		}
		public static var rampForce: EffectTypes {
			return EffectTypes(1 << 1)
		}
		public static var square: EffectTypes {
			return EffectTypes(1 << 2)
		}
		public static var sine: EffectTypes {
			return EffectTypes(1 << 3)
		}
		public static var triangle: EffectTypes {
			return EffectTypes(1 << 4)
		}
		public static var sawtoothUp: EffectTypes {
			return EffectTypes(1 << 5)
		}
		public static var sawtoothDown: EffectTypes {
			return EffectTypes(1 << 6)
		}
		public static var spring: EffectTypes {
			return EffectTypes(1 << 7)
		}
		public static var damper: EffectTypes {
			return EffectTypes(1 << 8)
		}
		public static var inertia: EffectTypes {
			return EffectTypes(1 << 9)
		}
		public static var friction: EffectTypes {
			return EffectTypes(1 << 10)
		}
		public static var customForce: EffectTypes {
			return EffectTypes(1 << 11)
		}
	}
	
	public enum SubType : UInt32 {
		case kinesthetic = 1
		case vibration = 2
	}
	
	public var axes: [Axis] {
		var axesArray: [UInt8] = try! arrayFromObject(reflecting: ffAxes)
		
		return ([UInt8](axesArray[0..<min(Int(numFfAxes), axesArray.count)])).map({ (aVal) -> Axis in
			let ax = Axis(rawValue: aVal)
			switch ax {
			case let .unknown(n):
				if #available(OSX 10.12, *) {
					os_log("Unknown axis number '%ld'", type: .error, Int(n))
				} else {
					print("Unknown axis number '\(n)'")
				}
			default:
				break
			}
			return ax
		})
	}
	
	public var supportedEffectTypes: EffectTypes {
		return EffectTypes(rawValue: supportedEffects)
	}
	
	public var emulatedEffectTypes: EffectTypes {
		return EffectTypes(rawValue: emulatedEffects)
	}
	
	public var effectSubType: SubType {
		return SubType(rawValue: subType)!
	}
}

public final class ForceFeedbackDevice {
	public typealias Escape = FFEFFESCAPE
	fileprivate let rawDevice: FFDeviceObjectReference
	public private(set) var lastReturnValue: ForceFeedbackResult = .ok
	
	public enum Property: UInt32 {
		case Gain = 1
		case Autocenter = 3
	}
	
	public struct CooperativeLevel : OptionSet {
		public let rawValue: UInt32
		private init(_ value: UInt32) { self.rawValue = value }
		public init(rawValue value: UInt32) { self.rawValue = value }
		
		public static var exclusive: CooperativeLevel {
			return CooperativeLevel(1 << 0)
		}
		public static var nonExclusive: CooperativeLevel {
			return CooperativeLevel(1 << 1)
		}
		public static var foreground: CooperativeLevel {
			return CooperativeLevel(1 << 2)
		}
		public static var background: CooperativeLevel {
			return CooperativeLevel(1 << 3)
		}
	}
	
	public struct Command : OptionSet {
		public let rawValue: UInt32
		private init(_ value: UInt32) { self.rawValue = value }
		public init(rawValue value: UInt32) { self.rawValue = value }
		
		public static var reset: Command {
			return Command(1 << 0)
		}
		public static var stopAll: Command {
			return Command(1 << 1)
		}
		public static var pause: Command {
			return Command(1 << 2)
		}
		public static var continueCommand: Command {
			return Command(1 << 3)
		}
		public static var setActuatorsOn: Command {
			return Command(1 << 4)
		}
		public static var setActuatorsOff: Command {
			return Command(1 << 5)
		}
	}
	
	public struct State : OptionSet {
		public let rawValue: UInt32
		private init(_ value: UInt32) { self.rawValue = value }
		public init(rawValue value: UInt32) { self.rawValue = value }
		
		public static var empty: State {
			return State(1 << 0)
		}
		public static var stopped: State {
			return State(1 << 1)
		}
		public static var paused: State {
			return State(1 << 2)
		}
		// following line intentionally left blank
		
		public static var actuatorsOn: State {
			return State(1 << 4)
		}
		public static var actuatorsOff: State {
			return State(1 << 5)
		}
		public static var powerOn: State {
			return State(1 << 6)
		}
		public static var powerOff: State {
			return State(1 << 7)
		}
		public static var safetySwitchOn: State {
			return State(1 << 8)
		}
		public static var safetySwitchOff: State {
			return State(1 << 9)
		}
		public static var userSwitchOn: State {
			return State(1 << 10)
		}
		public static var userSwitchOff: State {
			return State(1 << 11)
		}
		public static var deviceLost: State {
			return State(0x80000000)
		}
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
		guard iErr == ForceFeedbackResult.ok.rawValue else {
			throw ForceFeedbackResult.from(result: iErr)
		}
		rawDevice = tmpDevice!
	}
	
	/// - parameter device: the device to check if there's a force 
	/// feedback driver for.
	/// - returns: `true` if device is capable of Force feedback,
	/// `false` if it isn't, or `nil` if there was an error.
	public class func isForceFeedback(device: io_service_t) -> Bool? {
		let iErr = FFIsForceFeedback(device)
		if iErr >= 0 {
			return true
		} else if iErr == ForceFeedbackResult.noInterface.rawValue {
			return false
		} else {
			return nil
		}
	}
	
	public func sendEscape(_ theEscape: inout Escape) -> ForceFeedbackResult {
		let aReturn = ForceFeedbackResult.from(result: FFDeviceEscape(rawDevice, &theEscape))
		lastReturnValue = aReturn
		return aReturn
	}
	
	public func sendEscape(command: DWORD, data inData: Data) -> ForceFeedbackResult {
		let curDataSize = inData.count
		var tmpMutBytes = inData
		let toRet = tmpMutBytes.withUnsafeMutableBytes { (aMutBytes: UnsafeMutablePointer<Int8>) -> ForceFeedbackResult in
			var ourEscape = Escape(dwSize: DWORD(MemoryLayout<FFEFFESCAPE>.size), dwCommand: command, lpvInBuffer: aMutBytes, cbInBuffer: DWORD(curDataSize), lpvOutBuffer: nil, cbOutBuffer: 0)
			
			return sendEscape(&ourEscape)
		}
		lastReturnValue = toRet
		
		return toRet
	}
	
	public func sendEscape(command: DWORD, data inData: Data, outDataLength: inout Int) -> (result: ForceFeedbackResult, outData: Data) {
		var ourMutableData = Data(count: outDataLength)
		let curDataSize = inData.count
		var tmpMutBytes = inData
		let toRet = tmpMutBytes.withUnsafeMutableBytes { (aMutBytes: UnsafeMutablePointer<UInt8>) -> ForceFeedbackResult in
			let theNewRet = ourMutableData.withUnsafeMutableBytes({ (ourMutBytes: UnsafeMutablePointer<UInt8>) -> ForceFeedbackResult in
				var ourEscape = Escape(dwSize: DWORD(MemoryLayout<Escape>.size), dwCommand: command, lpvInBuffer: aMutBytes, cbInBuffer: DWORD(curDataSize), lpvOutBuffer: ourMutBytes, cbOutBuffer: DWORD(outDataLength))
				
				let ret1 = sendEscape(&ourEscape)
				outDataLength = Int(ourEscape.cbOutBuffer)
				return ret1
				
			})
			
			ourMutableData.count = outDataLength

			return theNewRet
		}
		
		lastReturnValue = toRet
		
		return (toRet, ourMutableData)
	}
	
	public var state: State {
		var ourState: FFState = 0
		let errVal = ForceFeedbackResult.from(result: FFDeviceGetForceFeedbackState(rawDevice, &ourState))
		lastReturnValue = errVal
		if lastReturnValue.isSuccess {
			return State(rawValue: ourState)
		} else {
			return []
		}
	}
	
	public func sendCommand(_ command: Command) -> ForceFeedbackResult {
		let iErr = ForceFeedbackResult.from(result: FFDeviceSendForceFeedbackCommand(rawDevice, command.rawValue))
		lastReturnValue = iErr
		return iErr
	}
	
	/// Calls `getProperty`/`setProperty`, which may return failure info.
	/// Use `lastReturnValue` to check if the getter/setter were successful.
	public var autocenter: Bool {
		get {
			var theVal: UInt32 = 0
			let iErr = get(property: .Autocenter, value: &theVal, valueSize: IOByteCount(MemoryLayout<UInt32>.size))
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
			let iErr = get(property: .Gain, value: &theVal, valueSize: IOByteCount(MemoryLayout<UInt32>.size))
			lastReturnValue = iErr
			return theVal
		}
		set {
			var theVal = newValue
			lastReturnValue = set(property: .Gain, value: &theVal)
		}
	}
	
	/// Function is unimplemented in version 1.0 of Apple's FF API.
	public func setCooperativeLevel(taskIdentifier: UnsafeMutableRawPointer, flags: CooperativeLevel) -> ForceFeedbackResult {
		let iErr = ForceFeedbackResult.from(result: FFDeviceSetCooperativeLevel(rawDevice, taskIdentifier, flags.rawValue))
		lastReturnValue = iErr
		return iErr
	}
	
	public func set(property: Property, value: UnsafeMutableRawPointer) -> ForceFeedbackResult {
		let iErr = ForceFeedbackResult.from(result: FFDeviceSetForceFeedbackProperty(rawDevice, property.rawValue, value))
		lastReturnValue = iErr
		return iErr
	}
	
	public func get(property: Property, value: UnsafeMutableRawPointer, valueSize: IOByteCount) -> ForceFeedbackResult {
		let iErr = ForceFeedbackResult.from(result: FFDeviceGetForceFeedbackProperty(rawDevice, property.rawValue, value, valueSize))
		lastReturnValue = iErr
		return iErr
	}
	
	public func set(property: UInt32, value: UnsafeMutableRawPointer) -> ForceFeedbackResult {
		let iErr = ForceFeedbackResult.from(result: FFDeviceSetForceFeedbackProperty(rawDevice, property, value))
		lastReturnValue = iErr
		return iErr
	}
	
	public func get(property: UInt32, size: IOByteCount) throws -> Data {
		var toRet = Data(count: Int(size))
		try toRet.withUnsafeMutableBytes({ (datPtr: UnsafeMutablePointer<UInt8>) -> Void in
			let iErr = FFDeviceGetForceFeedbackProperty(rawDevice, property, datPtr, size)
			let bErr = ForceFeedbackResult.from(result: iErr)
			lastReturnValue = bErr
			if bErr != .ok {
				throw bErr
			}
		})
		return toRet
	}
	
	deinit {
		FFReleaseDevice(rawDevice)
	}
}

public final class ForceFeedbackEffect {
	public typealias Effect = FFEFFECT
	private let rawEffect: FFEffectObjectReference
	public let deviceReference: ForceFeedbackDevice
	
	public struct Status : OptionSet {
		public let rawValue: UInt32
		private init(_ value: UInt32) { self.rawValue = value }
		public init(rawValue value: UInt32) { self.rawValue = value }
		
		//public static var notPlaying: Status {
		//	return Status(0)
		//}
		public static var playing: Status {
			return Status(1 << 0)
		}
		public static var emulated: Status {
			return Status(1 << 1)
		}
	}
	
	public struct Parameter : OptionSet {
		public let rawValue: UInt32
		private init(_ value: UInt32) { self.rawValue = value }
		public init(rawValue value: UInt32) { self.rawValue = value }
		
		public static var duration: Parameter {
			return Parameter(1 << 0)
		}
		public static var samplePeriod: Parameter {
			return Parameter(1 << 1)
		}
		public static var gain: Parameter {
			return Parameter(1 << 2)
		}
		public static var triggerButton: Parameter {
			return Parameter(1 << 3)
		}
		public static var triggerRepeatInterval: Parameter {
			return Parameter(1 << 4)
		}
		public static var axes: Parameter {
			return Parameter(1 << 5)
		}
		/// Indicates the `cAxes` and `rglDirection` members of the `FFEFFECT` structure
		/// are being downloaded for the first time or have changed since their last
		/// download. (The `dwFlags` member of the `FFEFFECT` structure specifies,
		/// through `FFEFFECT.CoordinateSystem.cartesian` or
		/// `FFEFFECT.CoordinateSystem.polar`, the coordinate system in which
		/// the values should be interpreted.)
		public static var direction: Parameter {
			return Parameter(1 << 6)
		}
		public static var envelope: Parameter {
			return Parameter(1 << 7)
		}
		public static var typeSpecificParameters: Parameter {
			return Parameter(1 << 8)
		}
		public static var startDelay: Parameter {
			return Parameter(1 << 9)
		}
		
		public static var allParamaters: Parameter {
			return Parameter(0x000003FF)
		}
		
		public static var start: Parameter {
			return Parameter(0x20000000)
		}
		public static var noRestart: Parameter {
			return Parameter(0x40000000)
		}
		public static var noDownload: Parameter {
			return Parameter(0x80000000)
		}
		public static var noTrigger: Parameter {
			return Parameter(0xFFFFFFFF)
		}
	}
	
	public struct EffectStart : OptionSet {
		public let rawValue: UInt32
		private init(_ value: UInt32) { self.rawValue = value }
		public init(rawValue value: UInt32) { self.rawValue = value }
		
		public static var solo: EffectStart {
			return EffectStart(0x01)
		}
		public static var noDownload: EffectStart {
			return EffectStart(0x80000000)
		}
	}
	
	public enum EffectType {
		case constantForce
		case rampForce
		case square
		case sine
		case triangle
		case sawtoothUp
		case sawtoothDown
		case spring
		case damper
		case inertia
		case friction
		case custom
		
		/// Returns an `EffectType` matching the supplied UUID.
		/// Returns `nil` if there isn't a matching `EffectType`.
		public init?(uuid: UUID) {
			switch uuid {
			case ForceFeedbackEffect.constantForce:
				self = .constantForce
				
			case ForceFeedbackEffect.rampForce:
				self = .rampForce

			case ForceFeedbackEffect.square:
				self = .square
				
			case ForceFeedbackEffect.sine:
				self = .sine
				
			case ForceFeedbackEffect.triangle:
				self = .triangle
				
			case ForceFeedbackEffect.sawtoothUp:
				self = .sawtoothUp
				
			case ForceFeedbackEffect.sawtoothDown:
				self = .sawtoothDown
				
			case ForceFeedbackEffect.spring:
				self = .spring
				
			case ForceFeedbackEffect.damper:
				self = .damper
				
			case ForceFeedbackEffect.inertia:
				self = .inertia
				
			case ForceFeedbackEffect.friction:
				self = .friction
				
			case ForceFeedbackEffect.customForce:
				self = .custom

			default:
				return nil
			}
		}
		
		public var uuidValue: UUID {
			switch self {
			case .constantForce:
				return ForceFeedbackEffect.constantForce
				
			case .rampForce:
				return ForceFeedbackEffect.rampForce
				
			case .square:
				return ForceFeedbackEffect.square
				
			case .sine:
				return ForceFeedbackEffect.sine
				
			case .triangle:
				return ForceFeedbackEffect.triangle
				
			case .sawtoothUp:
				return ForceFeedbackEffect.sawtoothUp

			case .sawtoothDown:
				return ForceFeedbackEffect.sawtoothDown

			case .spring:
				return ForceFeedbackEffect.spring

			case .damper:
				return ForceFeedbackEffect.damper

			case .inertia:
				return ForceFeedbackEffect.inertia
				
			case .friction:
				return ForceFeedbackEffect.friction

			case .custom:
				return ForceFeedbackEffect.customForce
			}
		}
	}
	
	/// E559C460-C5CD-11D6-8A1C-00039353BD00
	///
	/// UUID for a constant force effect type
	public static let constantForce: UUID = UUID(uuid:(
			0xE5, 0x59, 0xC4, 0x60, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00))
	
	/// E559C461-C5CD-11D6-8A1C-00039353BD00
	///
	/// UUID for a ramp force effect type
	public static let rampForce: UUID = UUID(uuid:(
			0xE5, 0x59, 0xC4, 0x61, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00))
	
	/// E559C462-C5CD-11D6-8A1C-00039353BD00
	///
	/// UUID for a square wave effect type
	public static let square: UUID = UUID(uuid:(
			0xE5, 0x59, 0xC4, 0x62, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00))
	
	/// E559C463-C5CD-11D6-8A1C-00039353BD00
	///
	/// UUID for a sine wave effect type
	public static let sine: UUID = UUID(uuid:(
			0xE5, 0x59, 0xC4, 0x63, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00))
	
	/// E559C464-C5CD-11D6-8A1C-00039353BD00
	///
	/// UUID for a triangle wave effect type
	public static let triangle: UUID = UUID(uuid:(
			0xE5, 0x59, 0xC4, 0x64, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00))
	
	/// E559C465-C5CD-11D6-8A1C-00039353BD00
	///
	/// UUID for a upwards sawtooth wave effect type
	public static let sawtoothUp: UUID = UUID(uuid:(
			0xE5, 0x59, 0xC4, 0x65, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00))
	
	/// E559C466-C5CD-11D6-8A1C-00039353BD00
	///
	/// UUID for a downwards sawtooth wave effect type
	public static let sawtoothDown: UUID = UUID(uuid:(
			0xE5, 0x59, 0xC4, 0x66, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00))
	
	/// E559C467-C5CD-11D6-8A1C-00039353BD00
	///
	/// UUID for a spring effect type
	public static let spring: UUID = UUID(uuid:(
			0xE5, 0x59, 0xC4, 0x67, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00))
	
	/// E559C468-C5CD-11D6-8A1C-00039353BD00
	///
	/// UUID for a damper effect type
	public static let damper: UUID = UUID(uuid:(
			0xE5, 0x59, 0xC4, 0x68, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00))
	
	/// E559C469-C5CD-11D6-8A1C-00039353BD00
	///
	/// UUID for an inertia effect type
	public static let inertia: UUID = UUID(uuid:(
			0xE5, 0x59, 0xC4, 0x69, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00))
	
	/// E559C46A-C5CD-11D6-8A1C-00039353BD00
	///
	/// UUID for a friction effect type
	public static let friction: UUID = UUID(uuid:(
			0xE5, 0x59, 0xC4, 0x6A, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00))
	
	/// E559C46B-C5CD-11D6-8A1C-00039353BD00
	///
	/// UUID for a custom force effect type
	public static let customForce: UUID = UUID(uuid:(
			0xE5, 0x59, 0xC4, 0x6B, 0xC5, 0xCD, 0x11, 0xD6,
			0x8A, 0x1C, 0x00, 0x03, 0x93, 0x53, 0xBD, 0x00))
	
	public convenience init(device: ForceFeedbackDevice, uuid UUID: Foundation.UUID, effectDefinition: inout Effect) throws {
		let ourUUID = UUID.cfUUID
		
		try self.init(device: device, uuid: ourUUID, effectDefinition: &effectDefinition)
	}
	
	public convenience init(device: ForceFeedbackDevice, effect: EffectType, effectDefinition: inout Effect) throws {
		let ourUUID = effect.uuidValue
		
		try self.init(device: device, uuid: ourUUID, effectDefinition: &effectDefinition)
	}
	
	public init(device: ForceFeedbackDevice, uuid UUID: CFUUID, effectDefinition: inout Effect) throws {
		deviceReference = device
		var tmpEffect: FFEffectObjectReference? = nil
		let iErr = FFDeviceCreateEffect(device.rawDevice, UUID, &effectDefinition, &tmpEffect)
		if iErr == ForceFeedbackResult.ok.rawValue {
			rawEffect = tmpEffect!
		} else {
			throw ForceFeedbackResult.from(result: iErr)
		}
	}
	
	public func start(iterations: UInt32 = 1, flags: EffectStart = EffectStart.solo) -> ForceFeedbackResult {
		return ForceFeedbackResult.from(result: FFEffectStart(rawEffect, iterations, flags.rawValue))
	}
	
	public func stop() -> ForceFeedbackResult {
		return ForceFeedbackResult.from(result: FFEffectStop(rawEffect))
	}
	
	public func download() -> ForceFeedbackResult {
		return ForceFeedbackResult.from(result: FFEffectDownload(rawEffect))
	}
	
	public func getParameters(_ effect: inout Effect, flags: Parameter) -> ForceFeedbackResult {
		return ForceFeedbackResult.from(result: FFEffectGetParameters(rawEffect, &effect, flags.rawValue))
	}
	
	public func setParameters(_ effect: inout Effect, flags: Parameter) -> ForceFeedbackResult {
		return ForceFeedbackResult.from(result: FFEffectSetParameters(rawEffect, &effect, flags.rawValue))
	}
	
	/// Returns a `Status` bit mask, or `nil` on error.
	public var status: Status? {
		var statFlag: FFEffectStatusFlag = 0
		let retVal = FFEffectGetEffectStatus(rawEffect, &statFlag)
		if retVal == 0 {
			return Status(rawValue: statFlag)
		} else {
			return nil
		}
	}
	
	deinit {
		FFDeviceReleaseEffect(deviceReference.rawDevice, rawEffect)
	}
}
