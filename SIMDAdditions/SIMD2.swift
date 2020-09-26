//
//  SIMD2.swift
//  SIMDAdditions
//
//  Created by C.W. Betts on 9/24/20.
//  Copyright © 2020 C.W. Betts. All rights reserved.
//

import Foundation
import simd

public extension SIMD2 where Scalar: Numeric {
    @inlinable func allZero() -> Bool {
        return x == 0 && y == 0
    }
	
    @inlinable static func ==(left: SIMD2<Scalar>, right: SIMD2<Scalar>) -> simd_int2 {
        return simd_int2(left.x == right.x ? -1: 0, left.y == right.y ? -1: 0)
    }
	
    @inlinable static func !=(left: SIMD2<Scalar>, right: SIMD2<Scalar>) -> simd_int2 {
        return simd_int2(left.x != right.x ? -1: 0, left.y != right.y ? -1: 0)
    }
}

