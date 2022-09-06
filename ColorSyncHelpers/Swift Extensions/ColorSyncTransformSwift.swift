//
//  ColorSyncTransformSwift.swift
//  ColorSyncHelpers
//
//  Created by C.W. Betts on 9/19/18.
//  Copyright © 2018 C.W. Betts. All rights reserved.
//

import Foundation
import ApplicationServices
import ColorSync
import FoundationAdditions

public extension ColorSyncTransform {
	/// The color depth of the data.
	typealias Depth = ColorSyncDataDepth
	
	/// The data layout of the data that will be read/written by the
	/// transform.
	typealias Layout = CSTransform.Layout
	
	/// Transform the data from the source color space to the destination.
	/// - parameter width: width of the image in pixels
	/// - parameter height: height of the image in pixels
	/// - parameter dst: a pointer to the destination where the results will be written.
	/// - parameter dstDepth: describes the bit depth and type of the destination color components
	/// - parameter dstFormat: describes the format and byte packing of the destination pixels
	/// - parameter dstBytesPerRow: number of bytes in the row of data
	/// - parameter src: a pointer to the data to be converted.
	/// - parameter srcDepth: describes the bit depth and type of the source color components
	/// - parameter srcFormat: describes the format and byte packing of the source pixels
	/// - parameter srcBytesPerRow: number of bytes in the row of data
	/// - parameter options: additional options. Default is `nil`.
	/// - returns: `true` if conversion was successful or `false` otherwise.
	func transform(width: Int, height: Int, dst: UnsafeMutableRawPointer, dstDepth: Depth, dstLayout: Layout, dstBytesPerRow: Int, src: UnsafeRawPointer, srcDepth: Depth, srcLayout: Layout, srcBytesPerRow: Int, options: [String: Any]? = nil) -> Bool {
		return ColorSyncTransformConvert(self, width, height, dst, dstDepth, dstLayout.rawValue, dstBytesPerRow, src, srcDepth, srcLayout.rawValue, srcBytesPerRow, sanitize(options: options) as NSDictionary?)
	}
	
	/// Transform the data from the source color space to the destination.
	/// - parameter width: width of the image in pixels
	/// - parameter height: height of the image in pixels
	/// - parameter destination: information about the destination data, including a pointer to the destination where the results will be written.
	/// - parameter source: information about the data to be converted.
	/// - parameter options: additional options. Default is `nil`.
	/// - returns: `true` if conversion was successful or `false` otherwise.
	func transform(width: Int, height: Int, destination: (data: UnsafeMutableRawPointer, depth: Depth, layout: Layout, bytesPerRow: Int), source: (data: UnsafeRawPointer, depth: Depth, layout: Layout, bytesPerRow: Int), options: [String: Any]? = nil) -> Bool {
		
		return transform(width: width, height: height, dst: destination.data, dstDepth: destination.depth, dstLayout: destination.layout, dstBytesPerRow: destination.bytesPerRow, src: source.data, srcDepth: source.depth, srcLayout: source.layout, srcBytesPerRow: source.bytesPerRow, options: options)
	}
	
	/// Gets the property of the specified key.
	/// - parameter key: `CFTypeRef` to be used as a key to identify the property
	func property(forKey key: AnyObject, options: [String: Any]? = nil) -> Any? {
		return ColorSyncTransformCopyProperty(self, key, sanitize(options: options) as NSDictionary?)?.takeRetainedValue()
	}
	
	/// Sets the property.
	/// - parameter key: `CFTypeRef` to be used as a key to identify the property
	/// - parameter property: `CFTypeRef` to be set as the property
	@inlinable func setProperty(key: AnyObject, property: Any?) {
		ColorSyncTransformSetProperty(self, key, property as CFTypeRef?)
	}
	
	/// Gets and sets the properties.
	subscript (key: AnyObject) -> Any? {
		get {
			return property(forKey: key)
		}
		set {
			ColorSyncTransformSetProperty(self, key, newValue as AnyObject?)
		}
	}
}

extension ColorSyncTransform: CFTypeProtocol {
	/// The type identifier of all `ColorSyncTransform` instances.
	@inlinable public static var typeID: CFTypeID {
		return ColorSyncTransformGetTypeID()
	}
}

public extension ColorSyncTransform {
	enum RenderingIntent: RawRepresentable {
		case perceptual
		
		case relative
		
		case saturation
		
		case absolute
		
		case useProfileHeader
		
		public typealias RawValue = CFString
		
		public init?(rawValue: CFString) {
			switch rawValue {
			case kColorSyncRenderingIntentPerceptual.takeUnretainedValue():
				self = .perceptual
			case kColorSyncRenderingIntentRelative.takeUnretainedValue():
				self = .relative
			case kColorSyncRenderingIntentSaturation.takeUnretainedValue():
				self = .saturation
			case kColorSyncRenderingIntentAbsolute.takeUnretainedValue():
				self = .absolute
			case kColorSyncRenderingIntentUseProfileHeader.takeUnretainedValue():
				self = .useProfileHeader
			default:
				return nil
			}
		}
		
		public var rawValue: CFString {
			switch self {
			case .perceptual:
				return kColorSyncRenderingIntentPerceptual.takeUnretainedValue()
			case .relative:
				return kColorSyncRenderingIntentRelative.takeUnretainedValue()
			case .saturation:
				return kColorSyncRenderingIntentSaturation.takeUnretainedValue()
			case .absolute:
				return kColorSyncRenderingIntentAbsolute.takeUnretainedValue()
			case .useProfileHeader:
				return kColorSyncRenderingIntentUseProfileHeader.takeUnretainedValue()
			}
		}
	}
	
	enum TransformTag: RawRepresentable {
		case deviceToPCS
		case PCSToPCS
		case PCSToDevice
		case deviceToDevice
		case gamutCheck
		
		public typealias RawValue = CFString
		
		public init?(rawValue: CFString) {
			switch rawValue {
			case kColorSyncTransformDeviceToPCS.takeUnretainedValue():
				self = .deviceToPCS
			case kColorSyncTransformPCSToPCS.takeUnretainedValue():
				self = .PCSToPCS
			case kColorSyncTransformPCSToDevice.takeUnretainedValue():
				self = .PCSToDevice
			case kColorSyncTransformDeviceToDevice.takeUnretainedValue():
				self = .deviceToDevice
			case kColorSyncTransformGamutCheck.takeUnretainedValue():
				self = .gamutCheck
			default:
				return nil
			}
		}
		
		public var rawValue: CFString {
			switch self {
			case .deviceToPCS:
				return kColorSyncTransformDeviceToPCS.takeUnretainedValue()
			case .PCSToPCS:
				return kColorSyncTransformPCSToPCS.takeUnretainedValue()
			case .PCSToDevice:
				return kColorSyncTransformPCSToDevice.takeUnretainedValue()
			case .deviceToDevice:
				return kColorSyncTransformDeviceToDevice.takeUnretainedValue()
			case .gamutCheck:
				return kColorSyncTransformGamutCheck.takeUnretainedValue()
			}
		}
	}
	
	enum ConvertQuality: RawRepresentable {
		/// do not coalesce profile transforms (default)
		case best
		
		/// coalesce all transforms
		case normal
		
		/// coalesce all transforms, do not interpolate
		case draft
		
		public typealias RawValue = CFString
		
		public init?(rawValue: CFString) {
			switch rawValue {
			case kColorSyncBestQuality.takeUnretainedValue():
				self = .best
			case kColorSyncNormalQuality.takeUnretainedValue():
				self = .normal
			case kColorSyncDraftQuality.takeUnretainedValue():
				self = .draft

			default:
				return nil
			}
		}
		
		public var rawValue: CFString {
			switch self {
			case .best:
				return kColorSyncBestQuality.takeUnretainedValue()
			case .normal:
				return kColorSyncNormalQuality.takeUnretainedValue()
			case .draft:
				return kColorSyncDraftQuality.takeUnretainedValue()
			}
		}
	}
	
	enum TranformInfoKey: RawRepresentable {
		/// Name of the CMM that created the transform
		case creator
		
		case sourceSpace
		
		case destinationSpace
		
		public typealias RawValue = CFString
		
		public init?(rawValue: CFString) {
			switch rawValue {
			case kColorSyncTransformCreator.takeUnretainedValue():
				self = .creator
			case kColorSyncTransformSrcSpace.takeUnretainedValue():
				self = .sourceSpace
			case kColorSyncTransformDstSpace.takeUnretainedValue():
				self = .destinationSpace

			default:
				return nil
			}
		}
		
		public var rawValue: CFString {
			switch self {
			case .creator:
				return kColorSyncTransformCreator.takeUnretainedValue()
			case .sourceSpace:
				return kColorSyncTransformSrcSpace.takeUnretainedValue()
			case .destinationSpace:
				return kColorSyncTransformDstSpace.takeUnretainedValue()
			}
		}
	}
	
	/// Code Fragment Support
	///
	/// ColorSync can return parameters for standard components of color conversion,
	/// i.e. tone rendering curves (TRCs), 3x4 matrices (3x3 + 3x1), multi-dimensional
	/// interpolation tables and Black Point Compensation.
	/// The parameters are wrapped in `CFArray` or `CFData` objects specific to the
	/// component type and placed in a `CFDictionary` under a key that identifies the
	/// type of the component. The complete code fragment is a `CFArray` of component
	/// dictionaries that are placed in the in the order they have to be executed.
	///
	/// A code fragment is created by calling `ColorSyncTransformCopyProperty` with the key
	/// specifying the type of the code fragment to be created. `nil` pointer will be
	/// returned if the requested code fragment cannot be created.
	///
	/// Types of Code Fragments:
	///
	///  1. Full conversion: all non-`nil` components based on all the tags from the
	///                      sequence of profiles passed to create the ColorSyncTransform with
	///                      an exception of adjacent matrices that can be collapsed to
	///                      one matrix.
	///  2. Parametric:      same as above, except that the returned code fragment consists
	///                      only of parametric curves, matrices and BPC components.
	///  3. Simplified:      Full conversion is collapsed to one
	///                      multi-dimensional table with N inputs and M outputs.
	enum TransformCodeFragmentConversionDataType: RawRepresentable {
		/// all non-`nil` components based on all the tags from the
		/// sequence of profiles passed to create the ColorSyncTransform with
		/// an exception of adjacent matrices that can be collapsed to
		/// one matrix.
		case full
		
		/// Full conversion is collapsed to one
		/// multi-dimensional table with N inputs and M outputs.
		case simplified
		
		/// Same as `.full`, except that the returned code fragment consists
		/// only of parametric curves, matrices and BPC components.
		case parametric
		
		public typealias RawValue = CFString
		
		public init?(rawValue: CFString) {
			switch rawValue {
			case kColorSyncTransformFullConversionData.takeUnretainedValue():
				self = .full
			case kColorSyncTransformSimplifiedConversionData.takeUnretainedValue():
				self = .simplified
			case kColorSyncTransformParametricConversionData.takeUnretainedValue():
				self = .parametric

			default:
				return nil
			}
		}
		
		public var rawValue: CFString {
			switch self {
			case .full:
				return kColorSyncTransformFullConversionData.takeUnretainedValue()
			case .simplified:
				return kColorSyncTransformSimplifiedConversionData.takeUnretainedValue()
			case .parametric:
				return kColorSyncTransformParametricConversionData.takeUnretainedValue()
			}
		}
	}
	
	/// Keys for profile specific info and options
	enum OptionKeys: RawRepresentable {
		case profile
		
		case renderingIntent
		
		case transformTag
		
		case blackPointCompensation
		
		case extendedRange
		
		/// ColorSyncCMMRef of the preferred CMM
		case preferredCMM
		
		case convertQuality
		
		/// applies to large amounts of data; `CFBooleanRef` value; default `true`
		case convertUseExtendedRange
		
		case transformInfo
		
		case transformCodeFragmentType
		
		case transformCodeFragmentMD5
		
		/// Represented as a `CFArray` of three `CFArrays` of four `CFNumbers` (`Float32`)
		/// each, performin the following matrix operation:
		/// `y[3] = 3x3 matrix *x[3] + 3x1 vector` (last column)
		case conversionMatrix
		
		public init?(rawValue: CFString) {
			switch rawValue {
			case kColorSyncProfile.takeUnretainedValue():
				self = .profile
			case kColorSyncRenderingIntent.takeUnretainedValue():
				self = .renderingIntent
			case kColorSyncTransformTag.takeUnretainedValue():
				self = .transformTag
			case kColorSyncBlackPointCompensation.takeUnretainedValue():
				self = .blackPointCompensation
			case kColorSyncExtendedRange.takeUnretainedValue():
				self = .extendedRange
			case kColorSyncPreferredCMM.takeUnretainedValue():
				self = .preferredCMM
			case kColorSyncConvertQuality.takeUnretainedValue():
				self = .convertQuality
			case kColorSyncConvertUseExtendedRange.takeUnretainedValue():
				self = .convertUseExtendedRange
			case kColorSyncTransformInfo.takeUnretainedValue():
				self = .transformInfo
			case kColorSyncTransformCodeFragmentType.takeUnretainedValue():
				self = .transformCodeFragmentType
			case kColorSyncTransformCodeFragmentMD5.takeUnretainedValue():
				self = .transformCodeFragmentMD5
			case kColorSyncConversionMatrix.takeUnretainedValue():
				self = .conversionMatrix
			default:
				return nil
			}
		}
		
		public var rawValue: CFString {
			switch self {
			case .profile:
				return kColorSyncProfile.takeUnretainedValue()
			case .renderingIntent:
				return kColorSyncRenderingIntent.takeUnretainedValue()
			case .transformTag:
				return kColorSyncTransformTag.takeUnretainedValue()
			case .blackPointCompensation:
				return kColorSyncBlackPointCompensation.takeUnretainedValue()
			case .extendedRange:
				return kColorSyncExtendedRange.takeUnretainedValue()
			case .preferredCMM:
				return kColorSyncPreferredCMM.takeUnretainedValue()
			case .convertQuality:
				return kColorSyncConvertQuality.takeUnretainedValue()
			case .convertUseExtendedRange:
				return kColorSyncConvertUseExtendedRange.takeUnretainedValue()
			case .transformInfo:
				return kColorSyncTransformInfo.takeUnretainedValue()
			case .transformCodeFragmentType:
				return kColorSyncTransformCodeFragmentType.takeUnretainedValue()
			case .transformCodeFragmentMD5:
				return kColorSyncTransformCodeFragmentMD5.takeUnretainedValue()
			case .conversionMatrix:
				return kColorSyncConversionMatrix.takeUnretainedValue()
			}
		}
	}
}
