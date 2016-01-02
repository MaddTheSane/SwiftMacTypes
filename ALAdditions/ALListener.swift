//
//  ALListener.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 6/14/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Foundation
import OpenAL
//import OpenAL.AL

public final class ALListener {
	private enum Parameter: ALenum {
		case Gain = 0x100A
		case Position = 0x1004
		case Velocity = 0x1006
		case Orientation = 0x100F
	}
	
	private class func value(flag: Parameter) -> (ALfloat, ALfloat, ALfloat) {
		var toRet: (ALfloat, ALfloat, ALfloat) = (0,0,0)
		alGetListener3f(flag.rawValue, &toRet.0, &toRet.1, &toRet.2)
		return toRet
	}
	
	private class func setValue(flag: Parameter, value: (ALfloat, ALfloat, ALfloat)) {
		alListener3f(flag.rawValue, value.0, value.1, value.2)
	}
	
	public class var gain: ALfloat {
		get {
			var toRet: ALfloat = 0
			alGetListenerf(Parameter.Gain.rawValue, &toRet)
			return toRet
		}
		set {
			alListenerf(Parameter.Gain.rawValue, newValue)
		}
	}
	
	public class var position: (ALfloat, ALfloat, ALfloat) {
		get {
			return value(.Position)
		}
		set {
			setValue(.Position, value: newValue)
		}
	}
	
	public class var velocity: (ALfloat, ALfloat, ALfloat) {
		get {
			return value(.Velocity)
		}
		set {
			setValue(.Velocity, value: newValue)
		}
	}
	//TODO: Orientation:
	//TODO: Orientation  AL_ORIENTATION  ALfloat[6] (Forward then Up vectors)

}
