//
//  CATransform3DAdditions.swift
//  CoreAnimationTextSwift
//
//  Created by C.W. Betts on 10/20/17.
//

import Foundation
import QuartzCore.CATransform3D

public extension CATransform3D {
	/// Creates a transform with the same effect as affine transform `m`.
	@inlinable
	init(affineTransform m: CGAffineTransform) {
		self = CATransform3DMakeAffineTransform(m)
	}
	
	/// The identity transform: `[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]`.
	@inlinable
	static var identity: CATransform3D  {
		return CATransform3DIdentity
	}
	
	/// Is `true` if this transform is the identity transformation.
	@inlinable
	var isIdentity: Bool {
		return CATransform3DIsIdentity(self)
	}
	
	/// Is `true` if this transform can be represented exactly by an affine transform.
	@inlinable
	var isAffine: Bool {
		return CATransform3DIsAffine(self)
	}
	
	/// The affine transform represented by this transform.
	///
	/// If this transform cannot be
	/// represented exactly by an affine transform, the value is
	/// `nil`.
	@inlinable
	var affine: CGAffineTransform? {
		guard isAffine else {
			return nil
		}
		return CATransform3DGetAffineTransform(self)
	}
	
	/// Returns a transform that translates by `(tx, ty, tz)`:
	/// **t' =  [1 0 0 0; 0 1 0 0; 0 0 1 0; tx ty tz 1]**.
	@inlinable
	init(translateTx tx: CGFloat, ty: CGFloat, tz: CGFloat) {
		self = CATransform3DMakeTranslation(tx, ty, tz)
	}
	
	/// Creates a transform that scales by `(sx, sy, sz)`.
	///
	/// `self = [sx 0 0 0; 0 sy 0 0; 0 0 sz 0; 0 0 0 1]`.
	@inlinable
	init(scaleSx sx: CGFloat, sy: CGFloat, sz: CGFloat) {
		self = CATransform3DMakeScale(sx, sy, sz)
	}
	
	/// Creates a transform that rotates by `angle` radians about the vector
	/// `(x, y, z)`.
	///
	/// If the vector has length zero, the identity transform is
	/// created.
	@inlinable
	init(rotateAngle angle: CGFloat, x: CGFloat, y: CGFloat, z: CGFloat) {
		self = CATransform3DMakeRotation(angle, x, y, z)
	}
	
	/// Translate this transform by `(tx, ty, tz)`:
	/// **self = translate(tx, ty, tz) * self**.
	@inlinable
	mutating func translate(tx: CGFloat, ty: CGFloat, tz: CGFloat) {
		self = CATransform3DTranslate(self, tx, ty, tz)
	}
	
	/// Translate this transform by `(tx, ty, tz)` and return the result:
	/// **self' = translate(tx, ty, tz) * self**.
	@inlinable func translated(tx: CGFloat, ty: CGFloat, tz: CGFloat) -> CATransform3D {
		return CATransform3DTranslate(self, tx, ty, tz)
	}
	
	/// Scales this transform by `(sx, sy, sz)`:
	/// **self = scale(sx, sy, sz) * self**.
	@inlinable
	mutating func scale(sx: CGFloat, sy: CGFloat, sz: CGFloat) {
		self = CATransform3DScale(self, sx, sy, sz)
	}
	
	/// Scales this transform by `(sx, sy, sz)` and return the result:
	/// **self' = scale(sx, sy, sz) * self**.
	@inlinable
	func scaled(sx: CGFloat, sy: CGFloat, sz: CGFloat) -> CATransform3D {
		return CATransform3DScale(self, sx, sy, sz)
	}

	
	/// Rotates this transform by `angle` radians about the vector `(x, y, z)`.
	///
	/// If the vector has zero length the behavior is undefined:
	/// **self = rotation(angle, x, y, z) * self**.
	@inlinable
	mutating func rotate(angle: CGFloat, x: CGFloat, y: CGFloat, z: CGFloat) {
		self = CATransform3DRotate(self, angle, x, y, z)
	}
	
	/// Rotate this transform by `angle` radians about the vector `(x, y, z)` and
	/// return the result.
	///
	/// If the vector has zero length the behavior is undefined:
	/// **self' = rotation(angle, x, y, z) * self**.
	@inlinable
	func rotated(angle: CGFloat, x: CGFloat, y: CGFloat, z: CGFloat) -> CATransform3D {
		return CATransform3DRotate(self, angle, x, y, z)
	}

	
	/// Inverts this transform.
	///
	/// Does nothing if there's no inverse.
	@inlinable
	mutating func invert() {
		self = CATransform3DInvert(self)
	}
	
	/// Inverts this transform and return the result.
	///
	/// Returns `self` if there's no inverse.
	@inlinable
	var inverted: CATransform3D {
		return CATransform3DInvert(self)
	}
}

extension CATransform3D: Equatable {
	/// Concatenate `rhs` to `lhs` and sets `lhs` to the result: **lhs = lhs * rhs**.
	@inlinable public static func +=(lhs: inout CATransform3D, rhs: CATransform3D) {
		lhs = CATransform3DConcat(lhs, rhs)
	}
	
	/// Concatenate `rhs` to `lhs` and return the result: **t' = lhs * rhs**.
	@inlinable public static func +(lhs: CATransform3D, rhs: CATransform3D) -> CATransform3D {
		return CATransform3DConcat(lhs, rhs)
	}
	
	@inlinable public static func ==(lhs: CATransform3D, rhs: CATransform3D) -> Bool {
		return CATransform3DEqualToTransform(lhs, rhs)
	}
}
