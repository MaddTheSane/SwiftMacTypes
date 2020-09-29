//
//  SIMD4.swift
//  SIMDAdditions
//
//  Created by C.W. Betts on 9/24/20.
//  Copyright © 2020 C.W. Betts. All rights reserved.
//

import Foundation
import simd

public extension SIMD4 where Scalar: Numeric {
    @inlinable func allZero() -> Bool {
        return x == 0 && y == 0 && z == 0 && w == 0
    }

    @inlinable static func ==(left: SIMD4<Scalar>, right: SIMD4<Scalar>) -> simd_int4 {
        return simd_int4(left.x == right.x ? -1: 0, left.y == right.y ? -1: 0, left.z == right.z ? -1: 0, left.w == right.w ? -1: 0)
    }
	
    @inlinable static func !=(left: SIMD4<Scalar>, right: SIMD4<Scalar>) -> simd_int4 {
        return simd_int4(left.x != right.x ? -1: 0, left.y != right.y ? -1: 0, left.z != right.z ? -1: 0, left.w != right.w ? -1: 0)
    }
}

public extension SIMD4 {
	@inlinable var xyz: SIMD3<Scalar> {
        get {
            return SIMD3<Scalar>(x, y, z)
        }
        set {
            x = newValue.x
            y = newValue.y
            z = newValue.z
        }
    }
	
	@inlinable var xyw: SIMD3<Scalar> {
        get {
            return SIMD3<Scalar>(x, y, w)
        }
        set {
            x = newValue.x
            y = newValue.y
            w = newValue.z
        }
    }

	@inlinable var wzyx: SIMD4<Scalar> {
        get {
            return SIMD4<Scalar>(w, z, y, x)
        }
        set {
            w = newValue.x
            z = newValue.y
            y = newValue.z
			x = newValue.w
        }
    }

	@inlinable var xzyz: SIMD4<Scalar> {
        get {
            return SIMD4<Scalar>(x, z, y, z)
        }
    }
	
	@inlinable var xy: SIMD2<Scalar> {
        get {
            return SIMD2<Scalar>(x, y)
        }
        set {
            x = newValue.x
            y = newValue.y
        }
    }
	
	@inlinable var yz: SIMD2<Scalar> {
        get {
            return SIMD2<Scalar>(y, z)
        }
        set {
            y = newValue.x
            z = newValue.y
        }
    }

	@inlinable var xz: SIMD2<Scalar> {
        get {
            return SIMD2<Scalar>(x, z)
        }
        set {
            x = newValue.x
            z = newValue.y
        }
    }

	@inlinable var zyx: SIMD3<Scalar> {
        get {
            return SIMD3<Scalar>(z, y, x)
        }
        set {
            x = newValue.z
            y = newValue.y
            z = newValue.x
        }
    }
}

