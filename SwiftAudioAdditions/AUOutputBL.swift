//
//  AUOutputBL.swift
//  PlaySequenceSwift
//
//  Created by C.W. Betts on 2/6/18.
//

import Foundation
import AudioToolbox

/// Simple Buffer List wrapper targetted to use with retrieving AU output.
///
/// Simple Buffer List wrapper targetted to use with retrieving AU output.
/// Works in one of two ways (both adjustable)... Can use it with `nil` pointers, or allocate
/// memory to receive the data in.
///
/// Before using this with any call to `AudioUnitRender`, it needs to be Prepared
/// as some calls to `AudioUnitRender` can reset the ABL.
public class AUOutputBL {
	public private(set) var format: AudioStreamBasicDescription
	private var bufferMemory: UnsafeMutableRawPointer? = nil
	private var bufferList: UnsafeMutableAudioBufferListPointer
	private var bufferCount: Int
	private var bufferSize: Int
	public private(set) var frames: UInt32
	
	/// This is the constructor that you use.
	/// It can't be reset once you've constructed it.
	public init(streamDescription inDesc: AudioStreamBasicDescription, frameCount inDefaultNumFrames: UInt32 = 512) {
		format = inDesc
		bufferSize = 0
		bufferCount = format.isInterleaved ? 1 : Int(format.mChannelsPerFrame)
		frames = inDefaultNumFrames
		bufferList = AudioBufferList.allocate(maximumBuffers: bufferCount)
	}
	
	/// You only need to call this if you want to allocate a buffer list.
	/// If you want an empty buffer list, just call `prepare()`.
	/// If you want to dispose previously allocted memory, pass in `0`,
	/// then you either have an empty buffer list, or you can re-allocate.
	/// Memory is kept around if an allocation request is less than what is currently allocated.
	public func allocate(frames inNumFrames: UInt32) {
		if inNumFrames != 0 {
			var nBytes = format.framesToBytes(inNumFrames)
			
			guard nBytes > allocatedBytes else {
				return
			}
			
			// align successive buffers for Altivec and to take alternating
			// cache line hits by spacing them by odd multiples of 16
			if bufferCount > 1 {
				nBytes = (nBytes + (0x10 - (nBytes & 0xF))) | 0x10
			}
			
			bufferSize = Int(nBytes)
			
			let memorySize = bufferSize * bufferCount
			let newMemory = malloc(memorySize)
			memset(newMemory, 0, memorySize)	// make buffer "hot"
			
			let oldMemory = bufferMemory
			bufferMemory = newMemory
			free(oldMemory)
			
			frames = inNumFrames
		} else {
			if let mBufferMemory = bufferMemory {
				free(mBufferMemory)
				self.bufferMemory = nil
			}
			bufferSize = 0
			frames = 0
		}
	}
	
	public func prepare() {
		try! prepare(frames: frames)
	}
	
	/// this version can throw if this is an allocted ABL and `inNumFrames` is `> allocatedFrames`
	/// you can set the bool to true if you want a `nil` buffer list even if allocated
	/// `inNumFrames` must be a valid number (will throw if inNumFrames is 0)
	public func prepare(frames inNumFrames: UInt32, wantNullBufferIfAllocated inWantNullBufferIfAllocated: Bool = false) throws {
		let channelsPerBuffer = format.isInterleaved ? format.mChannelsPerFrame : 1
		
		if bufferMemory == nil || inWantNullBufferIfAllocated {
			bufferList.count = bufferCount
			for i in 0 ..< bufferCount {
				bufferList[i].mNumberChannels = channelsPerBuffer
				bufferList[i].mDataByteSize = format.framesToBytes(inNumFrames)
				bufferList[i].mData = nil
			}
		} else {
			let nBytes = format.framesToBytes(inNumFrames)
			if (Int(nBytes) * bufferCount) > allocatedBytes {
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
	
	public var ABL: UnsafeMutablePointer<AudioBufferList> {
		return bufferList.unsafeMutablePointer
	}
	
	private var allocatedBytes: Int {
		return bufferSize * bufferCount
	}
	
	deinit {
		bufferList.unsafeMutablePointer.deallocate()
		if let bufferMemory = bufferMemory {
			free(bufferMemory)
		}
	}
}

extension AUOutputBL: CustomDebugStringConvertible {
	public var debugDescription: String {
		var output = format.description
		output += "\n"
		output += "Num Buffers:\(bufferList.count), mFrames:\(frames), allocatedMemory:\(bufferMemory != nil ? "T" : "F")\n"
		for (i, buf) in bufferList.enumerated() {
			output += "\tBuffer:\(i), Size:\(buf.mDataByteSize), Chans:\(buf.mNumberChannels), Buffer:\(buf.mData?.debugDescription ?? "nil")\n"
		}
		
		return output
	}
}
