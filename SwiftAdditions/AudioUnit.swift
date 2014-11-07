//
//  AudioUnit.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 11/6/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Foundation
import AudioUnit

public enum AudioUnitType: OSType {
	case Output = 0x61756F75
	case MusicDevice = 0x61756D75
	case MusicEffect = 0x61756D66
	case FormatConverter = 0x61756663
	case Effect = 0x61756678
	case Mixer = 0x61756D78
	case Panner = 0x6175706E
	case Generator = 0x6175676E
	case OfflineEffect = 0x61756F6C
	case MIDIProcessor = 0x61756D69
}

extension AudioComponentDescription {
	
}
