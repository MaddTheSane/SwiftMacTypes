//
//  CoreGraphics.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 11/3/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Foundation
import CoreGraphics

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
			_ = insert(toMerge)
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

extension CGFont: CFTypeProtocol {}
extension CGImage: CFTypeProtocol {}
extension CGLayer: CFTypeProtocol {}
extension CGPath: CFTypeProtocol {}
extension CGPattern: CFTypeProtocol {}
extension CGShading: CFTypeProtocol {}
extension CGPSConverter: CFTypeProtocol {}
extension CGColor: CFTypeProtocol {}
extension CGColorConversionInfo: CFTypeProtocol {}
extension CGColorSpace: CFTypeProtocol {}
extension CGContext: CFTypeProtocol {}
extension CGDataConsumer: CFTypeProtocol {}
extension CGDataProvider: CFTypeProtocol {}
extension CGDisplayMode: CFTypeProtocol {}
extension CGDisplayStream: CFTypeProtocol {}
extension CGEvent: CFTypeProtocol {}
extension CGEventSource: CFTypeProtocol {}
extension CGGradient: CFTypeProtocol {}
