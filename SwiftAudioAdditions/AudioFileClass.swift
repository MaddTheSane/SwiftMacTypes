//
//  AudioFile.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 2/3/16.
//  Copyright © 2016 C.W. Betts. All rights reserved.
//

import Foundation
import AudioToolbox
import CoreAudio
import SwiftAdditions

public final class AudioFile {
	private var fileID: AudioFileID = nil
	
	public init(createWithURL url: NSURL, fileType: AudioFileTypeID, inout format: AudioStreamBasicDescription, flags: AudioFileFlags = []) throws {
		let iErr = AudioFileCreateWithURL(url, fileType, &format, flags, &fileID)
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
	}
	
	public init(openURL: NSURL, permissions: AudioFilePermissions = .ReadPermission, fileTypeHint fileHint: AudioFileTypeID) throws {
		let iErr = AudioFileOpenURL(openURL, permissions, fileHint, &fileID)
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
	}
	
	public func optimize() throws {
		let iErr = AudioFileOptimize(fileID)
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
	}
	
	deinit {
		if fileID != nil {
			AudioFileClose(fileID)
		}
	}
}


