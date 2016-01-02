//
//  ALBuffer.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 5/28/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Foundation
import OpenAL
//import OpenAL.AL

public final class ALBuffer {
	private(set) var buffer: ALuint = 0
	
	public init() {
		alGenBuffers(1, &buffer)
	}
	
	public enum Format: ALenum {
		case Mono8 = 0x1100
		case Mono16
		case Stereo8
		case Stereo16
	}
	
	private enum Parameter: ALenum {
		case Frequency = 0x2001
		case Bits
		case Channels
		case Size
	}
	
	public convenience init?(data: NSData, format: Format, frequency: ALsizei)  {
		self.init()
		
		if data.length > Int(ALsizei.max) {
			return nil
		}
		
		alBufferData(buffer, format.rawValue, data.bytes, ALsizei(data.length), frequency)
	}
	
	deinit {
		alDeleteBuffers(1, &buffer)
	}
	
	private func parameter(param: Parameter) -> ALint {
		var toRet: ALint = 0
		alGetBufferi(buffer, param.rawValue, &toRet)
		return toRet
	}
	
	public var frequency: ALint {
		return parameter(.Frequency)
	}
	
	public var bits: ALint {
		return parameter(.Bits)
	}
	
	public var channels: ALint {
		return parameter(.Channels)
	}
	
	public var size: ALint {
		return parameter(.Size)
	}
}
