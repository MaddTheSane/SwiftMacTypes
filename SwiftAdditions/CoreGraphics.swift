//
//  CoreGraphics.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 11/3/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Foundation
import CoreGraphics
import FoundationAdditions

public extension CGBitmapInfo {
	/// The alpha info of the current `CGBitmapInfo`.
	var alphaInfo: CGImageAlphaInfo {
		get {
			let tmpInfo = (self.rawValue & CGBitmapInfo.alphaInfoMask.rawValue)
			return CGImageAlphaInfo(rawValue: tmpInfo) ?? .none
		}
		set {
			let aRaw = newValue.rawValue
			
			//Clear the alpha info
			self.remove(CGBitmapInfo.alphaInfoMask)
			
			let toMerge = CGBitmapInfo(rawValue: aRaw)
			insert(toMerge)
		}
	}
	
	/// Inits a `CGBitmapInfo` value from a `CGImageAlphaInfo`.
	init(alphaInfo: CGImageAlphaInfo) {
		let ordValue = alphaInfo.rawValue
		self = CGBitmapInfo(rawValue: ordValue)
	}
	
	/// The native 16-bit byte order format.
	@inlinable static var byteOrder16Host: CGBitmapInfo {
#if _endian(little)
		return .byteOrder16Little
#elseif _endian(big)
		return .byteOrder16Big
#else
		fatalError("Unknown endianness")
#endif
	}
	
	/// The native 32-bit byte order format.
	@inlinable static var byteOrder32Host: CGBitmapInfo {
#if _endian(little)
		return .byteOrder32Little
#elseif _endian(big)
		return .byteOrder32Big
#else
		fatalError("Unknown endianness")
#endif
	}
}

extension CGFont: @retroactive CFTypeProtocol {}
extension CGImage: @retroactive CFTypeProtocol {}
extension CGLayer: @retroactive CFTypeProtocol {}
extension CGPath: @retroactive CFTypeProtocol {}
extension CGPattern: @retroactive CFTypeProtocol {}
extension CGShading: @retroactive CFTypeProtocol {}
extension CGColor: @retroactive CFTypeProtocol {}
extension CGColorConversionInfo: @retroactive CFTypeProtocol {}
extension CGColorSpace: @retroactive CFTypeProtocol {}
extension CGContext: @retroactive CFTypeProtocol {}
extension CGDataConsumer: @retroactive CFTypeProtocol {}
extension CGDataProvider: @retroactive CFTypeProtocol {}
extension CGFunction: @retroactive CFTypeProtocol {}
extension CGGradient: @retroactive CFTypeProtocol {}
extension CGPDFPage: @retroactive CFTypeProtocol {}
extension CGPDFDocument: @retroactive CFTypeProtocol {}

#if os(OSX)
extension CGPSConverter: @retroactive CFTypeProtocol {}
extension CGEventSource: @retroactive CFTypeProtocol {}
extension CGDisplayMode: @retroactive CFTypeProtocol {}
extension CGDisplayStream: @retroactive CFTypeProtocol {}
extension CGEvent: @retroactive CFTypeProtocol {}
#endif
