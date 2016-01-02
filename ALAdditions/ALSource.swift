//
//  OpenAL.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 5/28/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Foundation
import OpenAL.al

final public class ALSource {
	private(set) var source: ALuint = 0
	public var buffer: ALBuffer? {
		didSet {
			
		}
	}
	
	init() {
		alGenSources(1, &source)
	}
	
	deinit {
		alDeleteSources(1, &source)
	}
	
	public enum Parameter: ALenum {
		case Gain = 0x100A
		case MinimumGain = 0x100D
		case MaximumGain
		case Position = 0x1004
		case Direction
		case Velocity
		case Relative = 0x202
		case ReferenceDistance = 0x1020
		case MaximumDistance = 0x1023
		case RolloffFactor = 0x1021
		case ConeInnerAngle = 0x1001
		case ConeOuterAngle = 0x1002
		case ConeOuterGain = 0x1022
		case Pitch = 0x1003
		case Looping = 0x1007
		case SecondOffset = 0x1024
		case SampleOffset
		case ByteOffset
		case Buffer = 0x1009
		case SourceState = 0x1010
		case BuffersQueued = 0x1015
		case BuffersProcessed
	}
	
	/// Play, replay, or resume
	public func play() {
		alSourcePlay(source)
	}
	
	public func stop() {
		alSourceStop(source)
	}
	
	public func rewind() {
		alSourceRewind(source)
	}
	
	public func pause() {
		alSourcePause(source)
	}
	
	public func setParameter(param: Parameter, value: ALfloat) {
		alSourcef(source, param.rawValue, value)
	}
	
	public func setParameter(param: Parameter, value: (ALfloat, ALfloat, ALfloat)) {
		alSource3f(source, param.rawValue, value.0, value.1, value.2)
	}
	
	public func setParameter(param: Parameter, value: UnsafePointer<ALfloat>) {
		alSourcefv(source, param.rawValue, value)
	}
	
	public func setParameter(param: Parameter, value: ALint) {
		alSourcei(source, param.rawValue, value)
	}

	public func setParameter(param: Parameter, value: (ALint, ALint, ALint)) {
		alSource3i(source, param.rawValue, value.0, value.1, value.2)
	}
	
	public func setParameter(param: Parameter, value: UnsafePointer<ALint>) {
		alSourceiv(source, param.rawValue, value)
	}
	
	public func parameter(param: Parameter) -> ALfloat {
		var toRet: ALfloat = 0
		alGetSourcef(source, param.rawValue, &toRet)
		return toRet
	}
	
	public func parameter(param: Parameter) -> (ALfloat, ALfloat, ALfloat) {
		var toRet: (ALfloat, ALfloat, ALfloat) = (0, 0, 0)
		alGetSource3f(source, param.rawValue, &toRet.0, &toRet.1, &toRet.2)
		return toRet
	}
	
	public func getParameter(param: Parameter, values: UnsafeMutablePointer<ALfloat>) {
		alGetSourcefv(source, param.rawValue, values)
	}
	
	public func parameter(param: Parameter) -> ALint {
		var toRet: ALint = 0
		alGetSourcei(source, param.rawValue, &toRet)
		return toRet
	}
	
	public func parameter(param: Parameter) -> (ALint, ALint, ALint) {
		var toRet: (ALint, ALint, ALint) = (0, 0, 0)
		alGetSource3i(source, param.rawValue, &toRet.0, &toRet.1, &toRet.2)
		return toRet
	}

	public func getParameter(param: Parameter, values: UnsafeMutablePointer<ALint>) {
		alGetSourceiv(source, param.rawValue, values)
	}
}

