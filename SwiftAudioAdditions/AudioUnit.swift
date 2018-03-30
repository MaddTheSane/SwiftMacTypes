//
//  AudioUnit.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 11/6/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Foundation
import AudioUnit

public enum AudioComponentType {
	case output(AUOutput)
	case musicDevice(AUInstrument)
	case musicEffect(OSType)
	case formatConverter(AUConverter)
	case effect(AUEffect)
	case mixer(AUMixer)
	case panner(AUPanner)
	case generator(AUGenerator)
	case offlineEffect(AUEffect)
	case MIDIProcessor(OSType)
	case unknown(type: OSType, subType: OSType)
	
	public init(type rawType: OSType, subType AUSubtype: OSType) {
		switch rawType {
		case AUType.output.rawValue:
			if let aOut = AUOutput(rawValue: AUSubtype) {
				self = .output(aOut)
				return
			}
			
		case AUType.musicDevice.rawValue:
			if let aDevice = AUInstrument(rawValue: AUSubtype) {
				self = .musicDevice(aDevice)
				return
			}
			
		case AUType.musicEffect.rawValue:
			self = .musicEffect(AUSubtype)
			return
			
		case AUType.formatConverter.rawValue:
			if let aForm = AUConverter(rawValue: AUSubtype) {
				self = .formatConverter(aForm)
				return
			}
			
		case AUType.effect.rawValue:
			if let aEffect = AUEffect(rawValue: AUSubtype) {
				self = .effect(aEffect)
				return
			}
			
		case AUType.mixer.rawValue:
			if let aMix = AUMixer(rawValue: AUSubtype) {
				self = .mixer(aMix)
				return
			}
			
		case AUType.panner.rawValue:
			if let aPann = AUPanner(rawValue: AUSubtype) {
				self = .panner(aPann)
				return
			}
			
		case AUType.generator.rawValue:
			if let aGen = AUGenerator(rawValue: AUSubtype) {
				self = .generator(aGen)
				return
			}
			
		case AUType.offlineEffect.rawValue:
			if let aEffect = AUEffect(rawValue: AUSubtype) {
				self = .offlineEffect(aEffect)
				return
			}
			
		case AUType.MIDIProcessor.rawValue:
			self = .MIDIProcessor(AUSubtype)
			return
			
		default:
			break;
		}
		
		
		self = .unknown(type: rawType, subType: AUSubtype)
	}
	
	public enum AUType: OSType {
		case output = 0x61756F75
		case musicDevice = 0x61756D75
		case musicEffect = 0x61756D66
		case formatConverter = 0x61756663
		case effect = 0x61756678
		case mixer = 0x61756D78
		case panner = 0x6175706E
		case generator = 0x6175676E
		case offlineEffect = 0x61756F6C
		case MIDIProcessor = 0x61756D69
	}
	
	public enum AUOutput: OSType {
		case generic = 0x67656E72
		case HAL = 0x6168616C
		case `default` = 0x64656620
		case system = 0x73797320
		case voiceProcessingIO = 0x7670696F
	}
	
	public enum AUInstrument: OSType {
		#if os(OSX)
		case DLS = 0x646C7320
		#endif
		case sampler = 0x73616D70
		case MIDI = 0x6D73796E
	}
	
	public enum AUConverter: OSType {
		case AUConverter = 0x636F6E76
		#if os(OSX)
		case timePitch = 0x746D7074
		#endif
		#if os(iOS)
		case iPodTime = 0x6970746D
		#endif
		case varispeed = 0x76617269
		case deferredRenderer = 0x64656672
		case splitter = 0x73706C74
		case merger = 0x6D657267
		case newTimePitch = 0x6E757470
		case iPodTimeOther = 0x6970746F
	}
	
	public enum AUEffect: OSType {
		case delay = 0x64656C79
		case lowPassFilter = 0x6C706173
		case highPassFilter = 0x68706173
		case bandPassFilter = 0x62706173
		case highShelfFilter = 0x68736866
		case lowShelfFilter = 0x6C736866
		case parametricEQ = 0x706D6571
		case peakLimiter = 0x6C6D7472
		case dynamicsProcessor = 0x64636D70
		case sampleDelay = 0x73646C79
		case distortion = 0x64697374
		case NBandEQ = 0x6E626571
		
		#if os(OSX)
		case graphicEQ = 0x67726571
		case multiBandCompressor = 0x6D636D70
		case matrixReverb = 0x6D726576
		case pitch = 0x746D7074
		case AUFilter = 0x66696C74
		case netSend = 0x6E736E64
		case rogerBeep = 0x726F6772
		#elseif os(iOS)
		case reverb2 = 0x72766232
		case iPodEQ = 0x69706571
		#endif
	}
	
	public enum AUMixer: OSType {
		case multiChannel = 0x6D636D78
		case spatial = 0x3364656D
		case stereo = 0x736D7872
		case matrix = 0x6D786D78
	}
	
	public enum AUPanner: OSType {
		case sphericalHead = 0x73706872
		case vector = 0x76626173
		case soundField = 0x616D6269
		case HRTF = 0x68727466
	}
	
	public enum AUGenerator: OSType {
		case netReceive = 0x6E726376
		case scheduledSoundPlayer = 0x7373706C
		case audioFilePlayer = 0x6166706C
	}
	
	public var types: (type: OSType, subtype: OSType) {
		switch self {
		case let .output(aType):
			return (AUType.output.rawValue, aType.rawValue)
			
		case let .musicDevice(aType):
			return (AUType.musicDevice.rawValue, aType.rawValue)
			
		case let .musicEffect(aType):
			return (AUType.musicEffect.rawValue, aType)
			
		case let .formatConverter(aType):
			return (AUType.formatConverter.rawValue, aType.rawValue)
			
		case let .effect(aType):
			return (AUType.effect.rawValue, aType.rawValue)
			
		case let .mixer(aType):
			return (AUType.mixer.rawValue, aType.rawValue)
			
		case let .panner(aType):
			return (AUType.panner.rawValue, aType.rawValue)
			
		case let .generator(aType):
			return (AUType.generator.rawValue, aType.rawValue)
			
		case let .offlineEffect(aType):
			return (AUType.offlineEffect.rawValue, aType.rawValue)
			
		case let .MIDIProcessor(aType):
			return (AUType.MIDIProcessor.rawValue, aType)
			
		case let .unknown(type: aType, subType: aSubtype):
			return (aType, aSubtype)
		}
	}
}

extension AudioComponentDescription {	
	public init(component: AudioComponentType, manufacturer: OSType = kAudioUnitManufacturer_Apple) {
		self.init()
		(componentType, componentSubType) = component.types
		componentManufacturer = manufacturer
		componentFlags = 0
		componentFlagsMask = 0
	}
	
	public var flag: AudioComponentFlags {
		get {
			return AudioComponentFlags(rawValue: componentFlags)
		}
		set {
			componentFlags = newValue.rawValue
		}
	}
	
	public var flagMask: AudioComponentFlags {
		get {
			return AudioComponentFlags(rawValue: componentFlagsMask)
		}
		set {
			componentFlagsMask = newValue.rawValue
		}
	}
	
	public var component: AudioComponentType {
		get {
			return AudioComponentType(type: componentType, subType: componentSubType)
		}
		set {
			(componentType, componentSubType) = newValue.types
		}
	}
}
