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
			let tmpInfo = (self.rawValue & CGBitmapInfo.alphaInfoMask.rawValue)
			return CGImageAlphaInfo(rawValue: tmpInfo) ?? .none
		}
		set {
			// why...
			//let safe: CGBitmapInfo = [.FloatComponents, .ByteOrder16Little]
			
			let aRaw = newValue.rawValue
			//Clear the alpha info
			//intersectInPlace([.FloatComponents, .ByteOrderMask])
			
			self.remove(CGBitmapInfo.alphaInfoMask)
			
			let toMerge = CGBitmapInfo(rawValue: aRaw)
			_ = insert(toMerge)
		}
	}
	
	/// Inits a `CGBitmapInfo` value from a `CGImageAlphaInfo`.
	public init(alphaInfo: CGImageAlphaInfo) {
		let ordValue = alphaInfo.rawValue
		self = CGBitmapInfo(rawValue: ordValue)
	}
	
	/// The native 16-bit byte order format.
	public static var byteOrder16Host: CGBitmapInfo {
		if isLittleEndian {
			return .byteOrder16Little
		} else {
			return .byteOrder16Big
		}
	}
	
	/// The native 32-bit byte order format.
	public static var byteOrder32Host: CGBitmapInfo {
		if isLittleEndian {
			return .byteOrder32Little
		} else {
			return .byteOrder32Big
		}
	}
}

public func ==(lhs: CGAffineTransform, rhs: CGAffineTransform) -> Bool {
	return lhs.equalTo(rhs)
}

extension CGAffineTransform: Equatable {
}
