//
//  CFBitVector.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 6/12/20.
//  Copyright © 2020 C.W. Betts. All rights reserved.
//

import Foundation

public extension CFBitVector {
	/// The number of bit values.
	@inlinable var count: Int {
		return CFBitVectorGetCount(self)
	}
	
	/// Counts the number of times a certain bit value occurs within a range of bits in
	/// a bit vector.
	/// - parameter range: The range of bits to search.
	/// - parameter value: The bit value to count.
	/// - Returns: The number of occurrences of value in the specified range.
	@inlinable func countOfBit(in range: CFRange, _ value: CFBit) -> Int {
		return CFBitVectorGetCountOfBit(self, range, value)
	}
	
	/// Returns whether a bit vector contains a particular bit value.
	/// - parameter range: The range of bits to search.
	/// - parameter value: The bit value for which to search.
	/// - returns: `true` if the specified range of bits contains `value`, otherwise `false`.
	@inlinable func containsBit(in range: CFRange, _ value: CFBit) -> Bool {
		return CFBitVectorContainsBit(self, range, value)
	}
	
	/// Returns the bit value at a given index in a bit vector.
	/// - parameter idx: The index of the bit value in bv to return.
	/// - returns: The bit value at index `idx`.
	@inlinable func bit(at idx: Int) -> CFBit {
		return CFBitVectorGetBitAtIndex(self, idx)
	}
	
	/// Returns the bit values in a range of indices in a bit vector.
	/// - parameter range: The range of bit values to return.
	/// - parameter bytes: On return, contains the requested bit values. This argument
	/// must point to enough memory to hold the number of bits requested. The requested
	/// bits are left-aligned with the first requested bit stored in the left-most, or
	/// most-significant, bit of the byte stream.
	@inlinable func getBits(in range: CFRange, _ bytes: UnsafeMutablePointer<UInt8>) {
		CFBitVectorGetBits(self, range, bytes)
	}
	
	/// Locates the first occurrence of a certain bit value within a range of bits in a
	/// bit vector.
	/// - parameter range: The range of bits to search.
	/// - parameter value: The bit value for which to search.
	/// - returns: The index of the first occurrence of value in the specified range,
	/// or `nil` if value is not present.
	func firstIndex(in range: CFRange, of value: CFBit) -> Int? {
		let retVal = CFBitVectorGetFirstIndexOfBit(self, range, value)
		if retVal == kCFNotFound {
			return nil
		}
		return retVal
	}
	
	/// Locates the last occurrence of a certain bit value within a range of bits in a
	/// bit vector.
	/// - parameter range: The range of bits to search.
	/// - parameter value: The bit value for which to search.
	/// - returns: The index of the last occurrence of value in the specified range,
	/// or `nil` if value is not present.
	func lastIndex(in range: CFRange, of value: CFBit) -> Int? {
		let retVal = CFBitVectorGetLastIndexOfBit(self, range, value)
		if retVal == kCFNotFound {
			return nil
		}
		return retVal
	}
	
	/// Creates an immutable bit vector that is a copy of another bit vector.
	/// - parameter allocator: The allocator to use to allocate memory for the new bit vector. Pass `nil` or kCFAllocatorDefault to use the current default allocator.
	/// - returns: A new bit vector holding the same bit values.
	@inlinable func copy(allocator: CFAllocator? = kCFAllocatorDefault) -> CFBitVector {
		return CFBitVectorCreateCopy(allocator, self)
	}
	
	/// Creates a new mutable bit vector from a pre-existing bit vector.
	/// - parameter allocator: The allocator to use to allocate memory for the new bit vector. Pass `nil` or kCFAllocatorDefault to use the current default allocator.
	/// - parameter capacity: The maximum number of values that can be contained by the new bit vector. The bit vector starts with the same number of values as bv and can grow to this number of values (it can have less).
	/// Pass `0` to specify that the maximum capacity is not limited. If non-`0`, `capacity` must be large enough to hold all bit values.
	/// - returns: A new bit vector holding the same bit values.
	@inlinable func mutableCopy(allocator: CFAllocator? = kCFAllocatorDefault, capacity: Int) -> CFMutableBitVector {
		return CFBitVectorCreateMutableCopy(allocator, capacity, self)
	}
}

public extension CFMutableBitVector {
//	override var count: Int {
//		get {
//			super.count
//		}
//		set {
//			CFBitVectorSetCount(self, newValue)
//		}
//	}
	
	/// Changes the size of a mutable bit vector.
	///
	/// If this vector was created with a fixed capacity, you cannot increase its
	/// size beyond that capacity.
	/// - parameter count: The new size for this vector. If `count` is greater than
	/// the current size, the additional bit values are set to `0`.
	@inlinable func setCount(_ count: Int) {
		CFBitVectorSetCount(self, count)
	}
	
	/// Flips a bit value in a bit vector.
	/// - parameter idx: The index of the bit value to flip. The index must be in the
	/// range `0…N-1`, where `N` is the count of the vector.
	@inlinable func flipBit(at idx: Int) {
		CFBitVectorFlipBitAtIndex(self, idx)
	}
	
	/// Flips a range of bit values in a bit vector.
	/// - parameter range: The range of bit values in bv to flip. The range must
	/// not exceed `0…N-1`, where `N` is the count of the vector.
	@inlinable func flipBits(in range: CFRange) {
		CFBitVectorFlipBits(self, range)
	}
	
	/// Sets the value of a particular bit in a bit vector.
	/// - parameter idx: The index of the bit value to set. The index must be in
	/// the range `0…N-1`, where `N` is the count of the vector.
	/// - parameter value: The bit value to which to set the bit at index idx.
	@inlinable func setBit(at idx: Int, to value: CFBit) {
		CFBitVectorSetBitAtIndex(self, idx, value)
	}
	
	/// Sets a range of bits in a bit vector to a particular value.
	/// - parameter range: The range of bits to set. The range must not exceed
	/// `0…N-1`, where `N` is the count of the vector.
	/// - parameter value: The bit value to which to set the range of bits.
	@inlinable func setBits(in range: CFRange, to value: CFBit) {
		CFBitVectorSetBits(self, range, value)
	}
	
	/// Sets all bits in a bit vector to a particular value.
	/// - parameter value: The bit value to which to set all bits.
	@inlinable func setAllBits(to value: CFBit) {
		CFBitVectorSetAllBits(self, value)
	}
}
