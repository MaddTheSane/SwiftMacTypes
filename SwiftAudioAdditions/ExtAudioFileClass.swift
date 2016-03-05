//
//  ExtAudioFileClass.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 2/3/16.
//  Copyright © 2016 C.W. Betts. All rights reserved.
//

import Foundation
import AudioToolbox
import SwiftAdditions

final public class ExtAudioFile {
	var internalPtr: ExtAudioFileRef = nil
	private var strongAudioFileClass: AudioFile?
	
	public init(openURL: NSURL) throws {
		let iErr = ExtAudioFileOpenURL(openURL, &internalPtr)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
	}
	
	/// Internally retains `audioFile` so it doesn't get destroyed prematurely.
	public convenience init(wrapAudioFile audioFile: AudioFile, forWriting: Bool) throws {
		try self.init(wrapAudioFileID:audioFile.fileID, forWriting: forWriting)
		strongAudioFileClass = audioFile
	}
	
	/// The
	/// client is responsible for keeping the `AudioFileID` open until the
	/// `ExtAudioFile` is destroyed. Destroying the `ExtAudioFile` object will not close
	/// the `AudioFileID` when this Wrap API call is used, so the client is also
	/// responsible for closing the `AudioFileID` when finished with it.
	public init(wrapAudioFileID audioFile: AudioFileID, forWriting: Bool) throws {
		let iErr = ExtAudioFileWrapAudioFileID(audioFile, forWriting, &internalPtr)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
	}
	
	public init(createURL inURL: NSURL, fileType inFileType: AudioFileType, inout streamDescription inStreamDesc: AudioStreamBasicDescription, channelLayout inChannelLayout: UnsafePointer<AudioChannelLayout> = nil, flags: AudioFileFlags = []) throws {
		let iErr = ExtAudioFileCreate(URL: inURL, fileType: inFileType, streamDescription: &inStreamDesc, channelLayout: inChannelLayout, flags: flags, audioFile: &internalPtr)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
	}
	
	public func write(frames frames: UInt32, data: UnsafePointer<AudioBufferList>) throws {
		let iErr = ExtAudioFileWrite(internalPtr, frames, data)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
	}
	
	/// N.B. Errors may occur after this call has returned. Such errors may be thrown
	/// from subsequent calls to this method.
	public func writeAsync(frames frames: UInt32, data: UnsafePointer<AudioBufferList>) throws {
		let iErr = ExtAudioFileWriteAsync(internalPtr, frames, data)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
	}
	
	public func read(inout frames frames: UInt32, data: UnsafeMutablePointer<AudioBufferList>) throws {
		let iErr = ExtAudioFileRead(internalPtr, &frames, data)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
	}
	
	deinit {
		if internalPtr != nil {
			ExtAudioFileDispose(internalPtr)
		}
	}
	
	public func getPropertyInfo(ID: ExtAudioFilePropertyID) throws -> (size: UInt32, writeable: Bool) {
		var outSize: UInt32 = 0
		var outWritable: DarwinBoolean = false
		
		let iErr = ExtAudioFileGetPropertyInfo(internalPtr, ID, &outSize, &outWritable)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
		
		return (outSize, outWritable.boolValue)
	}
	
	public func getProperty(ID: ExtAudioFilePropertyID, inout dataSize: UInt32, data: UnsafeMutablePointer<Void>) throws {
		let iErr = ExtAudioFileGetProperty(internalPtr, ID, &dataSize, data)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
	}
	
	public func setProperty(ID: ExtAudioFilePropertyID, dataSize: UInt32, data: UnsafePointer<Void>) throws {
		let iErr = ExtAudioFileSetProperty(internalPtr, ID, dataSize, data)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
	}
	
	public var fileDataFormat: AudioStreamBasicDescription {
		get {
			var toRet = AudioStreamBasicDescription()
			var (size, _) = try! getPropertyInfo(kExtAudioFileProperty_FileDataFormat)
			try! getProperty(kExtAudioFileProperty_FileDataFormat, dataSize: &size, data: &toRet)
			return toRet
		}
	}
	
	public var fileChannelLayout: AudioChannelLayout {
		get {
			var toRet = AudioChannelLayout()
			var (size, _) = try! getPropertyInfo(kExtAudioFileProperty_FileChannelLayout)
			try! getProperty(kExtAudioFileProperty_FileChannelLayout, dataSize: &size, data: &toRet)
			return toRet
		}
		/*
		TODO: add throwable setter
		set throws {
		var newVal = newValue
		let (size, writable) = try! getPropertyInfo(kExtAudioFileProperty_ClientDataFormat)
		if !writable {
		//paramErr
		//throw NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil)
		fatalError(NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil).description)
		}
		try! setProperty(kExtAudioFileProperty_ClientDataFormat, dataSize: size, data: &newVal)
		}*/
	}
	
	public var clientDataFormat: AudioStreamBasicDescription {
		get {
			var toRet = AudioStreamBasicDescription()
			var (size, _) = try! getPropertyInfo(kExtAudioFileProperty_ClientDataFormat)
			try! getProperty(kExtAudioFileProperty_ClientDataFormat, dataSize: &size, data: &toRet)
			return toRet
		}
		//TODO: add throwable setter
		set /*throws*/ {
			var newVal = newValue
			let (size, writable) = try! getPropertyInfo(kExtAudioFileProperty_ClientDataFormat)
			if !writable {
				//paramErr
				//throw NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil)
				fatalError(NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil).description)
			}
			try! setProperty(kExtAudioFileProperty_ClientDataFormat, dataSize: size, data: &newVal)
		}
	}
	
	public var clientChannelLayout: AudioChannelLayout {
		get {
			var toRet = AudioChannelLayout()
			var (size, _) = try! getPropertyInfo(kExtAudioFileProperty_ClientChannelLayout)
			try! getProperty(kExtAudioFileProperty_ClientChannelLayout, dataSize: &size, data: &toRet)
			return toRet
		}
		/*
		TODO: add throwable setter
		set throws {
		var newVal = newValue
		let (size, writable) = try! getPropertyInfo(kExtAudioFileProperty_ClientDataFormat)
		if !writable {
		//paramErr
		//throw NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil)
		fatalError(NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil).description)
		}
		try! setProperty(kExtAudioFileProperty_ClientDataFormat, dataSize: size, data: &newVal)
		}*/
	}
	
	public var codecManufacturer: UInt32 {
		get {
			var toRet: UInt32 = 0
			var (size, _) = try! getPropertyInfo(kExtAudioFileProperty_CodecManufacturer)
			try! getProperty(kExtAudioFileProperty_CodecManufacturer, dataSize: &size, data: &toRet)
			return toRet
		}
		/*
		TODO: add throwable setter
		set throws {
		var newVal = newValue
		let (size, writable) = try! getPropertyInfo(kExtAudioFileProperty_ClientDataFormat)
		if !writable {
		//paramErr
		//throw NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil)
		fatalError(NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil).description)
		}
		try! setProperty(kExtAudioFileProperty_ClientDataFormat, dataSize: size, data: &newVal)
		}*/
	}
	
	// MARK: read-only
	
	public var audioConverter: AudioConverterRef {
		var toRet: AudioConverterRef = nil
		var (size, _) = try! getPropertyInfo(kExtAudioFileProperty_AudioConverter)
		try! getProperty(kExtAudioFileProperty_AudioConverter, dataSize: &size, data: &toRet)
		return toRet
	}
	
	public var audioFile: AudioFileID {
		var toRet: AudioFileID = nil
		var (size, _) = try! getPropertyInfo(kExtAudioFileProperty_AudioFile)
		try! getProperty(kExtAudioFileProperty_AudioFile, dataSize: &size, data: &toRet)
		return toRet
	}
	
	public var fileMaxPacketSize: UInt32 {
		var toRet: UInt32 = 0
		var (size, _) = try! getPropertyInfo(kExtAudioFileProperty_FileMaxPacketSize)
		try! getProperty(kExtAudioFileProperty_FileMaxPacketSize, dataSize: &size, data: &toRet)
		return toRet
	}
	
	public var clientMaxPacketSize: UInt32 {
		var toRet: UInt32 = 0
		var (size, _) = try! getPropertyInfo(kExtAudioFileProperty_ClientMaxPacketSize)
		try! getProperty(kExtAudioFileProperty_ClientMaxPacketSize, dataSize: &size, data: &toRet)
		return toRet
	}
	
	public var fileLengthFrames: Int64 {
		var toRet: Int64 = 0
		var (size, _) = try! getPropertyInfo(kExtAudioFileProperty_FileLengthFrames)
		try! getProperty(kExtAudioFileProperty_FileLengthFrames, dataSize: &size, data: &toRet)
		return toRet
	}
	
	//MARK: writable
	
	public func setConverterConfig(newVal: CFPropertyListRef?) throws {
		var cOpaque = COpaquePointer()
		if let newVal = newVal {
			cOpaque = Unmanaged.passUnretained(newVal).toOpaque()
		}
		let (size, writable) = try getPropertyInfo(kExtAudioFileProperty_ConverterConfig)
		if !writable {
			//paramErr
			throw NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil)
		}
		try setProperty(kExtAudioFileProperty_ConverterConfig, dataSize: size, data: &cOpaque)
	}
	
	public func setIOBufferSize(var bytes bytes: UInt32) throws {
		let (size, writable) = try getPropertyInfo(kExtAudioFileProperty_IOBufferSizeBytes)
		if !writable {
			//paramErr
			throw NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil)
		}
		try setProperty(kExtAudioFileProperty_IOBufferSizeBytes, dataSize: size, data: &bytes)
	}
	
	public func setIOBuffer(newVal: UnsafeMutablePointer<Void>) throws {
		let (size, writable) = try getPropertyInfo(kExtAudioFileProperty_IOBuffer)
		if !writable {
			//paramErr
			throw NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil)
		}
		try setProperty(kExtAudioFileProperty_IOBuffer, dataSize: size, data: newVal)
	}
	
	public func setPacketTable(var newVal: AudioFilePacketTableInfo) throws {
		let (size, writable) = try getPropertyInfo(kExtAudioFileProperty_PacketTable)
		if !writable {
			//paramErr
			throw NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil)
		}
		try setProperty(kExtAudioFileProperty_PacketTable, dataSize: size, data: &newVal)
	}
}
