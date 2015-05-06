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
	///The alpha info of the current `CGBitmapInfo`.
	public var alphaInfo: CGImageAlphaInfo {
		get {
			let tmpInfo = self & .AlphaInfoMask
			return CGImageAlphaInfo(rawValue: tmpInfo.rawValue) ?? .None
		}
		set {
			let aRaw = newValue.rawValue
			//Clear the alpha info
			self &= ~CGBitmapInfo.AlphaInfoMask
			let toMerge = CGBitmapInfo(rawValue: aRaw)
			
			self |= toMerge
		}
	}
	
	/// Inits a `CGBitmapInfo` value from a `CGImageAlphaInfo`.
	public init(alphaInfo: CGImageAlphaInfo) {
		let ordValue = alphaInfo.rawValue
		self = CGBitmapInfo(rawValue: ordValue)
	}
	
	/// The native 16-bit byte order format.
	public static var ByteOrder16Host: CGBitmapInfo {
		if isLittleEndian {
			return .ByteOrder16Little
		} else {
			return .ByteOrder16Big
		}
	}
	
	/// The native 32-bit byte order format.
	public static var ByteOrder32Host: CGBitmapInfo {
		if isLittleEndian {
			return .ByteOrder32Little
		} else {
			return .ByteOrder32Big
		}
	}
}
