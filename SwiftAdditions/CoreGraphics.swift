//
//  CoreGraphics.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 11/3/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGBitmapInfo {
	public var alphaInfo: CGImageAlphaInfo? {
		let tmpInfo = self & .AlphaInfoMask
		return CGImageAlphaInfo(rawValue: tmpInfo.rawValue)
	}
	
	public init(alphaInfo: CGImageAlphaInfo, additionalInfo: CGBitmapInfo = nil) {
		let ordValue = alphaInfo.rawValue | additionalInfo.rawValue
		self = CGBitmapInfo(rawValue: ordValue)
	}
	
	public static var ByteOrder16Host: CGBitmapInfo {
		if isLittleEndian {
			return .ByteOrder16Little
		} else {
			return .ByteOrder16Big
		}
	}
	
	public static var ByteOrder32Host: CGBitmapInfo {
		if isLittleEndian {
			return .ByteOrder32Little
		} else {
			return .ByteOrder32Big
		}
	}
}

