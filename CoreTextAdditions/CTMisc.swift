//
//  CTMisc.swift
//  CoreTextAdditions
//
//  Created by C.W. Betts on 5/29/21.
//  Copyright © 2021 C.W. Betts. All rights reserved.
//

import Foundation
import SwiftAdditions
import CoreText

extension CTFont: CFTypeProtocol {
	/// Returns the Core Foundation type identifier for for the opaque type `CTFont`.
	@inlinable public class var typeID: CFTypeID {
		return CTFontGetTypeID()
	}
}

extension CTFontCollection: CFTypeProtocol {
	/// The Core Foundation type identifier for the opaque type `CTFontCollection`.
	@inlinable public class var typeID: CFTypeID {
		return CTFontCollectionGetTypeID()
	}
}

extension CTFontDescriptor: CFTypeProtocol {
	/// Returns the Core Foundation type identifier for the opaque type `CTFontDescriptor`.
	@inlinable public class var typeID: CFTypeID {
		return CTFontDescriptorGetTypeID()
	}
}

extension CTFrame: CFTypeProtocol {
	/// Returns the Core Foundation type identifier for the opaque type `CTFrame`.
	@inlinable public class var typeID: CFTypeID {
		return CTFrameGetTypeID()
	}
}

extension CTFramesetter: CFTypeProtocol {
	/// Returns the Core Foundation type identifier the opaque type `CTFramesetter`.
	@inlinable public class var typeID: CFTypeID {
		return CTFramesetterGetTypeID()
	}
}

extension CTLine: CFTypeProtocol {
	/// Returns the Core Foundation type identifier for the opaque type `CTLineRef`.
	@inlinable public class var typeID: CFTypeID {
		return CTLineGetTypeID()
	}
}

extension CTParagraphStyle: CFTypeProtocol {
	/// Returns the Core Foundation type identifier of the paragraph style object.
	@inlinable public class var typeID: CFTypeID {
		return CTParagraphStyleGetTypeID()
	}
}

extension CTRubyAnnotation: CFTypeProtocol {
	/// Returns the Core Foundation type identifier for the opaque type `CTRubyAnnotation`.
	@inlinable public class var typeID: CFTypeID {
		return CTRubyAnnotationGetTypeID()
	}
}

extension CTRun: CFTypeProtocol {
	/// Returns the Core Foundation type identifier for the opaque type `CTRun`.
	@inlinable public class var typeID: CFTypeID {
		return CTRunGetTypeID()
	}
}

extension CTTextTab: CFTypeProtocol {
	/// Returns the Core Foundation type identifier for the opaque type `CTTextTab`.
	@inlinable public class var typeID: CFTypeID {
		return CTTextTabGetTypeID()
	}
}
