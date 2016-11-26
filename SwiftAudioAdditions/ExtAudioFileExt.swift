//
//  ExtAudioFileExt.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 4/18/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Foundation
import AudioToolbox
import SwiftAdditions

public func ExtAudioFileCreate(url inURL: URL, fileType inFileType: AudioFileType, streamDescription inStreamDesc: inout AudioStreamBasicDescription, channelLayout inChannelLayout: UnsafePointer<AudioChannelLayout>? = nil, flags: AudioFileFlags = AudioFileFlags(rawValue: 0), audioFile outAudioFile: inout ExtAudioFileRef?) -> OSStatus {
	return ExtAudioFileCreateWithURL(inURL as NSURL, inFileType.rawValue, &inStreamDesc, inChannelLayout, flags.rawValue, &outAudioFile)
}

public func ExtAudioFileSetProperty(_ inExtAudioFile: ExtAudioFileRef, propertyID inPropertyID: ExtAudioFilePropertyID, dataSize propertyDataSize: UInt32, data propertyData: UnsafeRawPointer) -> OSStatus {
	return ExtAudioFileSetProperty(inExtAudioFile, inPropertyID, propertyDataSize, propertyData)
}

public func ExtAudioFileSetProperty(_ inExtAudioFile: ExtAudioFileRef, propertyID inPropertyID: ExtAudioFilePropertyID, dataSize propertyDataSize: Int, data propertyData: UnsafeRawPointer) -> OSStatus {
	return ExtAudioFileSetProperty(inExtAudioFile, inPropertyID, UInt32(propertyDataSize), propertyData)
}

public func ExtAudioFileGetPropertyInfo(_ inExtAudioFile: ExtAudioFileRef, propertyID inPropertyID: ExtAudioFilePropertyID, size outSize: inout Int, writable outWritable: inout Bool) -> OSStatus {
	var ouSize = UInt32(outSize)
	var ouWritable: DarwinBoolean = false
	let aRet = ExtAudioFileGetPropertyInfo(inExtAudioFile, inPropertyID, &ouSize, &ouWritable)
	outWritable = ouWritable.boolValue
	outSize = Int(ouSize)
	return aRet
}

public func ExtAudioFileGetPropertyInfo(_ inExtAudioFile: ExtAudioFileRef, propertyID inPropertyID: ExtAudioFilePropertyID, size outSize: inout UInt32, writable outWritable: inout Bool) -> OSStatus {
	var ouWritable: DarwinBoolean = false
	let aRet = ExtAudioFileGetPropertyInfo(inExtAudioFile, inPropertyID, &outSize, &ouWritable)
	outWritable = ouWritable.boolValue
	return aRet
}

public func ExtAudioFileGetProperty(_ inExtAudioFile: ExtAudioFileRef, propertyID inPropertyID: ExtAudioFilePropertyID, propertyDataSize ioPropertyDataSize: inout UInt32, propertyData outPropertyData: UnsafeMutableRawPointer) -> OSStatus {
	return ExtAudioFileGetProperty(inExtAudioFile, inPropertyID, &ioPropertyDataSize, outPropertyData)
}
