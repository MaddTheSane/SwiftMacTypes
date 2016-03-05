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
			let tmpInfo = (self.rawValue & CGBitmapInfo.AlphaInfoMask.rawValue)
			return CGImageAlphaInfo(rawValue: tmpInfo) ?? .None
		}
		set {
			// why...
			//let safe: CGBitmapInfo = [.FloatComponents, .ByteOrder16Little]
			
			let aRaw = newValue.rawValue
			//Clear the alpha info
			//intersectInPlace([.FloatComponents, .ByteOrderMask])
			
			self.remove(CGBitmapInfo.AlphaInfoMask)
			
			let toMerge = CGBitmapInfo(rawValue: aRaw)
			insert(toMerge)
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

public func ==(lhs: CGAffineTransform, rhs: CGAffineTransform) -> Bool {
	return CGAffineTransformEqualToTransform(lhs, rhs)
}

extension CGAffineTransform: Equatable {
	public static var identityTransform: CGAffineTransform {
		return CGAffineTransformIdentity
	}
	
	public init(translationWithTx tx: CGFloat, ty: CGFloat) {
		self = CGAffineTransformMakeTranslation(tx, ty)
	}
	
	public init(scaleWithSx sx: CGFloat, sy: CGFloat) {
		self = CGAffineTransformMakeScale(sx, sy)
	}
	
	public init(rotationWithAngle angle: CGFloat) {
		self = CGAffineTransformMakeRotation(angle)
	}
	
	public var identity: Bool {
		return CGAffineTransformIsIdentity(self)
	}
	
	public var invert: CGAffineTransform {
		return CGAffineTransformInvert(self)
	}
	
	public mutating func invertInPlace() {
		self = CGAffineTransformInvert(self)
	}
	
	public mutating func concatInPlace(other: CGAffineTransform) {
		self = CGAffineTransformConcat(self, other)
	}
	
	public func concat(other: CGAffineTransform) -> CGAffineTransform {
		return CGAffineTransformConcat(self, other)
	}
	
	public mutating func rotateInPlace(angle: CGFloat) {
		self = CGAffineTransformRotate(self, angle)
	}
	
	public func rotate(angle: CGFloat) -> CGAffineTransform {
		return CGAffineTransformRotate(self, angle)
	}
	
	public mutating func scaleInPlace(sx sx: CGFloat, sy: CGFloat) {
		self = CGAffineTransformScale(self, sx, sy)
	}
	
	public func scale(sx sx: CGFloat, sy: CGFloat) -> CGAffineTransform {
		return CGAffineTransformScale(self, sx, sy)
	}
	
	public mutating func translateInPlace(tx tx: CGFloat, ty: CGFloat) {
		self = CGAffineTransformTranslate(self, tx, ty)
	}
	
	public func translate(tx tx: CGFloat, ty: CGFloat) -> CGAffineTransform {
		return CGAffineTransformTranslate(self, tx, ty)
	}
	
	public func transformPoint(aPoint: CGPoint) -> CGPoint {
		return CGPointApplyAffineTransform(aPoint, self)
	}
	
	public func transformSize(aSize: CGSize) -> CGSize {
		return CGSizeApplyAffineTransform(aSize, self)
	}
	
	public func transformRect(aRect: CGRect) -> CGRect {
		return CGRectApplyAffineTransform(aRect, self)
	}
}
