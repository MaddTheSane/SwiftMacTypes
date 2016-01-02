//
//  ALDevice.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 5/28/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Foundation
import OpenAL.al
import OpenAL.alc


final public class ALDevice {
	private(set) var device: ALCdevice
	
	public init(deviceName: String) {
		device = alcOpenDevice(deviceName)
	}
}
