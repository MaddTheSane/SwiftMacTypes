//
//  CTTextTabAdditions.swift
//  CoreTextAdditions
//
//  Created by C.W. Betts on 11/1/17.
//  Copyright © 2017 C.W. Betts. All rights reserved.
//

import Foundation
import CoreText.CTTextTab

extension CTTextTab {
	/// The tab's text alignment value.
	public var alignment: CTTextAlignment {
		return CTTextTabGetAlignment(self)
	}
	
	/// The tab's ruler location relative to the back margin.
	public var location: Double {
		return CTTextTabGetLocation(self)
	}
	
	/// The dictionary of attributes associated with the tab or `nil` if
	/// no dictionary is present.
	public var options: [String: Any]? {
		return CTTextTabGetOptions(self) as NSDictionary? as? [String: Any]
	}
}
