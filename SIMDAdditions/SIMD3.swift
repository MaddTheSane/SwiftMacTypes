//
//  SIMD3.swift
//  SIMDAdditions
//
//  Created by C.W. Betts on 9/24/20.
//  Copyright © 2020 C.W. Betts. All rights reserved.
//

import Foundation
import simd

public extension SIMD3 where Scalar: Numeric {
    @inlinable func allZero() -> Bool {
        return x == 0 && y == 0 && z == 0
    }
    
    @inlinable static func ==(left: SIMD3<Scalar>, right: SIMD3<Scalar>) -> simd_int3 {
        return simd_int3(left.x == right.x ? -1: 0, left.y == right.y ? -1: 0, left.z == right.z ? -1: 0)
    }
    @inlinable static func !=(left: SIMD3<Scalar>, right: SIMD3<Scalar>) -> simd_int3 {
        return simd_int3(left.x != right.x ? -1: 0, left.y != right.y ? -1: 0, left.z != right.z ? -1: 0)
    }
}

public extension SIMD3 {
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
