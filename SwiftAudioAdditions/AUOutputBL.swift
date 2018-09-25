//
//  AUOutputBL.swift
//  PlaySequenceSwift
//
//  Created by C.W. Betts on 2/6/18.
//

import Foundation
import AudioToolbox

class AUOutputBL {
	var format: AudioStreamBasicDescription
	var bufferMemory: UnsafeMutableRawPointer? = nil
	var bufferList: UnsafeMutableAudioBufferListPointer
	var bufferCount: Int
	var bufferSize: Int
	var frames: UInt32
	
	init(streamDescription inDesc: AudioStreamBasicDescription, frameCount inDefaultNumFrames: UInt32 = 512) {
		format = inDesc
		bufferSize = 0
		bufferCount = format.isInterleaved ? 1 : Int(format.mChannelsPerFrame)
		frames = inDefaultNumFrames
		let mem1 = malloc(MemoryLayout<AudioBufferList>.alignment + bufferCount * MemoryLayout<AudioBuffer>.alignment).assumingMemoryBound(to: AudioBufferList.self)
		bufferList = UnsafeMutableAudioBufferListPointer(mem1)
	}
	
	func prepare() throws {
		try prepare(frames: frames)
	}
	
	/// this version can throw if this is an allocted ABL and `inNumFrames` is `> allocatedFrames`
	/// you can set the bool to true if you want a `nil` buffer list even if allocated
	/// `inNumFrames` must be a valid number (will throw if inNumFrames is 0)
	func prepare(frames inNumFrames: UInt32, wantNullBufferIfAllocated inWantNullBufferIfAllocated: Bool = false) throws {
		let channelsPerBuffer = format.isInterleaved ? format.mChannelsPerFrame : 1;
		
		if bufferMemory == nil || inWantNullBufferIfAllocated {
			bufferList.count = bufferCount
			for i in 0 ..< bufferCount {
				bufferList[i].mNumberChannels = channelsPerBuffer
				bufferList[i].mDataByteSize = format.framesToBytes(inNumFrames)
				bufferList[i].mData = nil
			}
		} else {
			let nBytes = format.framesToBytes(inNumFrames);
			if ((Int(nBytes) * bufferCount) > allocatedBytes) {
				throw SAACoreAudioError(.tooManyFramesToProcess)
			}
			bufferList.count = bufferCount
			var p = bufferMemory!
			
			for i in 0 ..< bufferCount {
				bufferList[i].mNumberChannels = channelsPerBuffer
				bufferList[i].mDataByteSize = nBytes
				bufferList[i].mData = p
				p += bufferSize
			}
		}
	}
	
	var ABL: UnsafeMutablePointer<AudioBufferList> {
		return bufferList.unsafeMutablePointer
	}
	
	private var allocatedBytes: Int {
		return bufferSize * bufferCount
	}
	
	deinit {
		free(bufferList.unsafeMutablePointer)
	}
}
