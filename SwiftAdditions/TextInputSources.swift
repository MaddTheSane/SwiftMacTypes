//
//  TextInputSources.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 5/26/21.
//  Copyright © 2021 C.W. Betts. All rights reserved.
//

#if os(OSX)

import Foundation
import Carbon.HIToolbox

extension TISInputSource: CFTypeProtocol {
	/// Returns the Core Foundation type identifier for TISInputSource.
	@inlinable public class var typeID: CFTypeID {
		return TISInputSourceGetTypeID()
	}
}

public extension TISInputSource {
	
	/// Property value constants for input source type
	enum SourceType: RawRepresentable, Hashable {
		/// The property value constant for one input source type value
		/// associated with the property key `TISInputSource.Properties.sourceType`.
		///
		/// This type belongs to the category `TISInputSource.SourceCategory.keyboard`.
		case keyboardLayout
		
		/// The property value constant for one input source type value
		/// associated with the property key `TISInputSource.Properties.sourceType`.
		///
		/// This type belongs to the category `TISInputSource.SourceCategory.keyboard`.
		case keyboardInputMethodWithoutModes
		
		/// The property value constant for one input source type value
		/// associated with the property key `TISInputSource.Properties.sourceType`.
		///
		/// This type belongs to the category `TISInputSource.SourceCategory.keyboard`.
		case keyboardInputMethodModeEnabled
		
		/// The property value constant for one input source type value
		/// associated with the property key `TISInputSource.Properties.sourceType`.
		///
		/// This type belongs to the category `TISInputSource.SourceCategory.keyboard`.
		case keyboardInputMode
		
		/// The property value constant for one input source type value
		/// associated with the property key `TISInputSource.Properties.sourceType`.
		///
		/// This type belongs to the category `TISInputSource.SourceCategory.palette`.
		case characterPalette
		
		/// The property value constant for one input source type value
		/// associated with the property key `TISInputSource.Properties.sourceType`.
		///
		/// This type belongs to the category `TISInputSource.SourceCategory.palette`.
		case keyboardViewer
		
		/// The property value constant for one input source type value
		/// associated with the property key `TISInputSource.Properties.sourceType`.
		///
		/// This type belongs to the category `TISInputSource.SourceCategory.ink`.
		/// Even though it is the only type in that category, a type is
		/// provided so that clients who don't need category information can
		/// just check input source type.
		case ink

		
		public init?(rawValue: CFString) {
			switch rawValue {
			case kTISTypeKeyboardLayout:
				self = .keyboardLayout
				
			case kTISTypeKeyboardInputMethodWithoutModes:
				self = .keyboardInputMethodWithoutModes
				
			case kTISTypeKeyboardInputMethodModeEnabled:
				self = .keyboardInputMethodModeEnabled
				
			case kTISTypeKeyboardInputMode:
				self = .keyboardInputMode
				
			case kTISTypeCharacterPalette:
				self = .characterPalette
				
			case kTISTypeKeyboardViewer:
				self = .keyboardViewer
				
			case kTISTypeInk:
				self = .ink
				
			default:
				return nil
			}
		}
		
		public var rawValue: CFString {
			switch self {
			case .keyboardLayout:
				return kTISTypeKeyboardLayout
				
			case .keyboardInputMethodWithoutModes:
				return kTISTypeKeyboardInputMethodWithoutModes
				
			case .keyboardInputMethodModeEnabled:
				return kTISTypeKeyboardInputMethodModeEnabled
				
			case .keyboardInputMode:
				return kTISTypeKeyboardInputMode
				
			case .characterPalette:
				return kTISTypeCharacterPalette
				
			case .keyboardViewer:
				return kTISTypeKeyboardViewer
				
			case .ink:
				return kTISTypeInk
			}
		}
		
		public typealias RawValue = CFString
	}
	
	/// Property key constants,
	///
	/// Input sources may have additional properties beyond those listed here,
	/// and some input sources do not have values for some of the properties
	/// listed here. The property value for a particular input source can be
	/// obtained using `TISGetInputSourceProperty`. A set of specific property
	/// key-value pairs can also be used as a filter when creating a list of
	/// input sources using `TISCreateInputSourceList`.
	enum Properties: RawRepresentable, Hashable {

		/// The property key constant for a CFStringRef value that indicates
		/// the category of input source.
		///
		/// The possible values are specified by property value constants
		/// `kTISCategoryKeyboardInputSource`, `kTISCategoryPaletteInputSource`,
		/// `kTISCategoryInkInputSource`.
		case category
		
		/// The property key constant for a value that indicates
		/// the specific type of input source.
		case sourceType

		/// `IconRef`s are the normal icon format for keyboard layouts and
		/// input methods. If an `IconRef` is not available for the specified
		/// input source, the value is `nil`.
		///
		/// NOTE: This key (and a corresponding value) may not be used in the
		/// filter dictionary passed to `TISCreateInputSourceList`.
		case iconRef
		
		/// The property key constant for a `CFBooleanRef` value that indicates
		/// whether the input source can ever (given the right conditions) be
		/// programmatically enabled using `TISEnableInputSource`.
		///
		/// This is a static property of an input source, and does not depend
		/// on any current state.
		///
		/// Most input sources can be programmatically enabled at any time;
		/// `kTISPropertyInputSourceIsEnableCapable` is true for these.
		///
		///
		/// Some input sources can never be programmatically enabled. These
		/// are mainly input method private keyboard layouts that are used by
		/// the input method via `TISSetInputMethodKeyboardLayoutOverride`, but
		/// which cannot be directly enabled and used as keyboard layout
		/// input sources. `kTISPropertyInputSourceIsEnableCapable` is false
		/// for these.
		///
		/// Some input sources can only be programmatically enabled under the
		/// correct conditions. These are mainly input modes, which can only
		/// be changed from disabled to enabled if their parent input method
		/// is enabled (however, they can already be in the enabled state -
		/// but not currently selectable - if their parent input method is
		/// disabled). `kTISPropertyInputSourceIsEnableCapable` is true for
		/// these.
		case isEnableCapable
		
		/// The property key constant for a `CFBooleanRef` value that indicates
		/// whether the input source can ever (given the right conditions) be
		/// programmatically selected using `TISSelectInputSource`.
		///
		/// This is a static property of an input source, and does not depend
		/// on any current state.
		///
		/// Most input sources can be programmatically selected if they are
		/// enabled; `kTISPropertyInputSourceIsSelectCapable` is `true` for
		/// these.
		///
		/// Some input sources can never be programmatically selected even if
		/// they are enabled. These are mainly input methods that have modes
		/// (parent input methods); only their modes can be selected.
		/// `kTISPropertyInputSourceIsSelectCapable` is `false` for these.
		///
		///
		/// Some input sources which are enabled can only be programmatically
		/// selected under the correct conditions. These are mainly input
		/// modes, which can only be selected if both they and their parent
		/// input method are enabled.  `kTISPropertyInputSourceIsSelectCapable`
		/// is `true` for these.
		///
		/// Input source which can never be enabled - i.e. for which
		/// `kTISPropertyInputSourceIsEnableCapable` is `false` - can also never
		/// be selected. `kTISPropertyInputSourceIsSelectCapable` is `false` for
		/// these.
		case isSelectCapable
		
		/// The property key constant for a `CFBooleanRef` value that indicates
		/// whether the input source is currently enabled.
		case isEnabled
		
		/// The property key constant for a `CFBooleanRef` value that indicates
		/// whether the input source is currently selected.
		case isSelected
		
		/// The property key constant for a `CFStringRef` value for the unique
		/// reverse DNS name associated with the input source.
		///
		/// 1. For keyboard input methods and for input sources of the
		/// palette or ink category, this is typically the bundle ID, e.g.
		/// "com.apple.Kotoeri".
		///
		/// 2. For keyboard input modes, this is typically the bundle ID of
		/// the parent input method plus a suffix that uniquely identifies
		/// the input mode, e.g. "com.apple.Kotoeri.Katakana" (it is not the
		/// generic input mode name used across input methods, e.g.
		/// "com.apple.inputmethod.Japanese.Katakana").
		///
		/// 3. For keyboard layouts this is a new identification mechanism
		/// typically structured as "com.company.keyboardlayout.name", e.g.
		/// "com.apple.keyboardlayout.US".
		case inputSourceID
		
		/// The property key constant for a `CFStringRef` value for the reverse
		/// DNS BundleID associated with the input source.
		///
		/// Not valid for all input sources (especially some keyboard
		/// layouts).
		case bundleID
		
		/// The property key constant for a `CFStringRef` value that identifies
		/// a particular usage class for input modes.
		///
		/// For example, "com.apple.inputmethod.Japanese.Katakana" identifies
		/// a standard Katakana-input usage class that may be associated with
		/// input modes from several different input methods.
		///
		/// This InputModeID can be attached to a `TSMDocument` using
		/// `TSMSetDocumentProperty` with the tag
		/// `kTSMDocumentInputModePropertyTag`, in order to control which input
		/// mode usage class should be used with that `TSMDocument`.
		case inputModeID
		
		/// The property key constant for a `CFStringRef` value for the input
		/// source's localized name for UI purposes.
		///
		/// Uses the best match (determined by `CFBundle`) between the
		/// localization being used by the caller and the available
		/// localizations of the input source name. In some cases this may
		/// fall back to an unlocalized name.
		case localizedName
		
		/// The property key constant for a `CFURLRef` value indicating the
		/// file containing the image (typically *TIFF*) to be used as the
		/// input source icon.
		///
		/// *TIFF* files are the normal icon format for input modes. If an
		/// image file URL is not available for the specified input source,
		/// the value will be `nil`. Note that other image formats (e.g. *JPEG*,
		/// *PNG*, *PDF*) may also be supported.
		///
		/// Clients should be prepared for a URL to be unreachable, such as when
		/// an Input Method Info.plist mis-declares its icon path extension in its Info.plist.
		/// In this case, the client should try other path extensions, by using, for example,
		/// a combination of `CFURLResourceIsReachable`, `CFURLCopyPathExtension`,
		/// `CFURLCreateCopyDeletingPathExtension`, and `CFURLCreateCopyAppendingPathExtension`.
		///     For example, if the URL indicates **".png"**, be prepared to look for a **".tiff"**.
		/// TIS uses `[NSBundle(NSBundleImageExtension) imageForResource:]`,
		/// where possible, to obtain an input source image, so the path extension (i.e. ".png")
		/// is not critical for the System to find and display the image properly.
		///
		/// NOTE: This key (and a corresponding value) may not be used in the
		/// filter dictionary passed to `TISCreateInputSourceList`.
		case imageURL
		
		/// The property key constant for a `CFBooleanRef` value that indicates
		/// whether the input source identifies itself as ASCII-capable.
		case isASCIICapable
		
		/// The property key constant for a value which is a `CFArrayRef` of
		/// `CFStringRef`s, where each `CFString` is the language code for a
		/// language that can be input using the input source.
		///
		/// Languages codes are in the same BCP 47 format as returned by
		/// `CFLocaleCreateCanonicalLanguageIdentifierFromString`. The first
		/// language code in the array is the language for which the input
		/// source is intended. If there is no such language (e.g. for the
		/// Unicode Hex Input keyboard layout), the first language code is an
		/// empty string.
		///
		/// NOTE: This key (and a corresponding value) may not be used in the
		/// filter dictionary passed to `TISCreateInputSourceList`.
		case languages
		
		/// The property key constant for a value which is a `CFData` that
		/// refers to the '`uchr`' keyboard layout data for a keyboard layout
		/// input source.
		///
		/// The `uchr` data is in native-endian order. If the input source is
		/// not a keyboard layout, or is a keyboard layout for which only
		/// '`KCHR` data' is available, the value is `nil`.
		///
		/// NOTE: This key (and a corresponding value) may not be used in the
		/// filter dictionary passed to `TISCreateInputSourceList`.
		case unicodeKeyLayoutData
		
		/// catch-all for non-default and/or non-documented values.
		case other(CFString)

		public init?(rawValue: CFString) {
			switch rawValue {
			case kTISPropertyInputSourceCategory:
				self = .category
				
			case kTISPropertyIconRef:
				self = .iconRef
				
			case kTISPropertyInputSourceIsEnableCapable:
				self = .isEnableCapable
				
			case kTISPropertyInputSourceIsSelectCapable:
				self = .isSelectCapable
				
			case kTISPropertyInputSourceIsEnabled:
				self = .isEnabled
				
			case kTISPropertyInputSourceIsSelected:
				self = .isSelected
				
			case kTISPropertyIconImageURL:
				self = .imageURL
				
			case kTISPropertyLocalizedName:
				self = .localizedName
				
			case kTISPropertyBundleID:
				self = .bundleID
				
			case kTISPropertyInputModeID:
				self = .inputModeID
				
			case kTISPropertyInputSourceID:
				self = .inputSourceID
				
			case kTISPropertyInputSourceIsASCIICapable:
				self = .isASCIICapable
				
			case kTISPropertyInputSourceLanguages:
				self = .languages
				
			case kTISPropertyUnicodeKeyLayoutData:
				self = .unicodeKeyLayoutData
				
			case kTISPropertyInputSourceType:
				self = .sourceType
				
			default:
				self = .other(rawValue)
			}
		}
		
		public var rawValue: CFString {
			switch self {
			case .other(let val):
				return val
				
			case .category:
				return kTISPropertyInputSourceCategory
				
			case .iconRef:
				return kTISPropertyIconRef
				
			case .isEnableCapable:
				return kTISPropertyInputSourceIsEnableCapable
				
			case .isSelectCapable:
				return kTISPropertyInputSourceIsSelectCapable
				
			case .isEnabled:
				return kTISPropertyInputSourceIsEnabled
				
			case .isSelected:
				return kTISPropertyInputSourceIsSelected
				
			case .inputSourceID:
				return kTISPropertyInputSourceID
				
			case .bundleID:
				return kTISPropertyBundleID
				
			case .inputModeID:
				return kTISPropertyInputModeID
				
			case .localizedName:
				return kTISPropertyLocalizedName
				
			case .imageURL:
				return kTISPropertyIconImageURL
				
			case .isASCIICapable:
				return kTISPropertyInputSourceIsASCIICapable
				
			case .languages:
				return kTISPropertyInputSourceLanguages
				
			case .unicodeKeyLayoutData:
				return kTISPropertyUnicodeKeyLayoutData
				
			case .sourceType:
				return kTISPropertyInputSourceType
			}
		}
		
		public typealias RawValue = CFString
	}
	
	/// Property value constants for input source category
	enum SourceCategory: RawRepresentable, Hashable {
		/// The property value constant for one input source category value
		/// associated with the property key `Properties.category`.
		///
		/// This category includes keyboard layouts, keyboard input methods
		/// (both with modes and without), and keyboard input modes. At least
		/// one input source in this category is installed. Of all input
		/// sources in this category, exactly one is selected; selecting a
		/// new one deselects the previous one.
		case keyboard
		
		/// The property value constant for one input source category value
		/// associated with the property key `Properties.category`.
		///
		/// This category includes character palettes and keyboard viewers.
		/// Zero or more of these can be selected.
		case palette
		
		/// The property value constant for one input source category value
		/// associated with the property key `Properties.category`.
		///
		/// Zero or one ink input sources can be installed and selected.
		case ink
		
		public init?(rawValue: CFString) {
			switch rawValue {
			case kTISCategoryKeyboardInputSource:
				self = .keyboard
				
			case kTISCategoryPaletteInputSource:
				self = .palette
				
			case kTISCategoryInkInputSource:
				self = .ink
				
			default:
				return nil
			}
		}
		
		public var rawValue: CFString {
			switch self {
			case .keyboard:
				return kTISCategoryKeyboardInputSource
				
			case .palette:
				return kTISCategoryPaletteInputSource
				
			case .ink:
				return kTISCategoryInkInputSource
			}
		}
		
		public typealias RawValue = CFString
	}

	/// Creates a list of input sources that match specified properties.
	///
	/// This list represents a snapshot of input sources that matched the
	/// specified properties at the time the call was made. If the caller
	/// desires to include input sources that are installed but not
	/// currently enabled, the includeAllInstalled parameter may be set
	/// true. Typically this is done in order to obtain a
	/// `TISInputSource` for a newly-installed input source; in this
	/// case the properties parameter would include very specific
	/// criteria limiting the matching input sources.
	///
	/// **Warning:** Calling this with `includeAllInstalled: true` can have
	/// significant memory impact on the calling application if the
	/// properties parameter is `nil` (match all) or if it specifies
	/// criteria that may match many installed input sources, since this
	/// may force caching of data for all matching input sources (which
	/// can result in allocation of up to 120K). If
	/// `inputSourceList(matching:includeAllInstalled:)`
	/// is being called in order to find a
	/// specific input source or sources from among the sources included
	/// in the list, then it is best to first call
	/// `inputSourceList(matching:includeAllInstalled:)`
	/// with `includeAllInstalled: false` and
	/// check whether the returned array includes the desired input
	/// source(s); if not, then call
	/// `inputSourceList(matching:includeAllInstalled:)` again with
	/// `includeAllInstalled: true`.
	/// - parameter properties:
	/// Dictionary of property keys and corresponding values to filter
	/// the input source list. May be `nil`, in which case no filtering
	/// is performed.
	/// - parameter includeAllInstalled:
	/// Normally `false` so that only enabled input sources will be
	/// included; set `true` to include all installed input sources that
	/// match the filter (see discussion).
	/// - returns: Returns an `Array` for a list of `TISInputSource`s that match
	/// the specified properties.
	static func inputSourceList(matching properties: [Properties: Any]?, includeAllInstalled: Bool = false) -> [TISInputSource] {
		if let props = properties {
			var prop2: [CFString: Any] = [:]
			prop2.reserveCapacity(props.count)
			for (key, val) in props {
				if key == .category, let aVal = val as? SourceCategory {
					prop2[kTISPropertyInputSourceCategory] = aVal.rawValue
				} else if key == .sourceType, let aVal = val as? SourceType {
					prop2[kTISPropertyInputSourceType] = aVal.rawValue
				} else {
					prop2[key.rawValue] = val
				}
			}
			return TISCreateInputSourceList(prop2 as CFDictionary, includeAllInstalled).takeRetainedValue() as! [TISInputSource]
		}
		return TISCreateInputSourceList(nil, includeAllInstalled).takeRetainedValue() as! [TISInputSource]
	}
	
	// MARK: - Get specific input sources
	
	/// Returns a `TISInputSource` for the currently-selected keyboard
	/// input source; convenience function.
	@inlinable static var currentKeyboard: TISInputSource {
		return TISCopyCurrentKeyboardInputSource().takeRetainedValue()
	}

	/// Returns a `TISInputSource` for the keyboard layout currently
	/// being used. If the currently-selected keyboard input source is a
	/// keyboard layout, the `TISInputSource` refers to that layout; if
	/// the currently-selected keyboard input source is an input method
	/// or mode, the `TISInputSource` refers to the keyboard layout
	/// being used by that input method or mode.
	@inlinable static var currentKeyboardLayout: TISInputSource {
		return TISCopyCurrentKeyboardLayoutInputSource().takeRetainedValue()
	}

	/// Returns a `TISInputSource` for the most-recently-used
	/// ASCII-capable keyboard input source.
	///
	/// If no ASCII-capable keyboard input source has been used yet,
	/// returns the default ASCII-capable keyboard layout (chosen by
	/// Setup Assistant).
	@inlinable static var currentASCIICapableKeyboard: TISInputSource {
		return TISCopyCurrentASCIICapableKeyboardInputSource().takeRetainedValue()
	}

	/// Returns a `TISInputSource` for the most-recently-used
	/// ASCII-capable keyboard layout.
	///
	/// If no ASCII-capable keyboard input source has been used yet,
	/// returns the default ASCII-capable keyboard layout (chosen by
	/// Setup Assistant).
	///
	/// This is used by input methods to get the keyboard layout that
	/// will be used for key translation if there is no specific keyboard
	/// layout override.
	///
	/// Note the similar `.currentASCIICapableKeyboard`,
	/// which can return input sources that are not keyboard layouts.
	@inlinable static var currentASCIICapableKeyboardLayout: TISInputSource {
		return TISCopyCurrentASCIICapableKeyboardLayoutInputSource().takeRetainedValue()
	}

	/// Returns a `TISInputSource` for the input source that should be
	/// used to input the specified language.
	///
	/// Sample usage: If a text field is expected to have input in a
	/// particular language, an application can call
	/// `TISCopyInputSourceForLanguage` and then `TISSelectInputSource` to
	/// select an input source that would be appropriate for that
	/// language.
	///
	/// This is intended to provide a replacement for one way in which
	/// the now-deprecated KeyScript API was used: Selection of the
	/// default input source associated with a particular ScriptCode.
	///
	/// - parameter language:
	/// A language tag in BCP 47 format (i.e. in the same form as
	/// returned by
	/// `CFLocaleCreateCanonicalLanguageIdentifierFromString`) that
	/// represents the language for which an input source should be
	/// returned.
	///
	/// - returns: `TISInputSource` for an enabled input source that can input the
	/// specified language. If there is more than one such input source
	/// and at least one has previously been used, then the
	/// most-recently-used one will be chosen. If none of them has
	/// previously been used, one will be chosen based on the intended
	/// languages of the input sources. If there is no enabled input
	/// source that can input the specified language, the function will
	/// return `nil`.
	@inlinable static func inputSource(forLanguage language: String) -> TISInputSource? {
		return TISCopyInputSourceForLanguage(language as NSString)?.takeRetainedValue()
	}

	/// Returns a list of ASCII capable keyboard input sources.
	///
	/// This list represents a snapshot of ASCII capable keyboard input
	/// sources that were enabled at the time the call was made.
	/// Successive calls to `asciiCapableList` may
	/// return different results because, for example, in between the
	/// calls the user may enable or disable an input source in the
	/// International Preferences pane. When a keyboard input source is
	/// enabled or disabled, whether by the user or programmatically, the
	/// `kTISNotifyEnabledKeyboardInputSourcesChanged` CF distributed
	/// notification is posted.
	static var asciiCapableList: [TISInputSource] {
		return TISCreateASCIICapableInputSourceList().takeRetainedValue() as! [TISInputSource]
	}

	// MARK: - Manipulate input sources

	/// Selects the specified input source.
	///
	/// Calling `select()` on a keyboard input source that can
	/// be selected makes the specified input source the new current
	/// keyboard input source, and deselects the previous one. Calling
	/// `select()` on a palette input source usually results in
	/// the palette being displayed and available for input. Ink input
	/// sources are typically enabled and selected at the same time.
	/// Calling `select()` on a palette or ink input source has
	/// no effect on other input sources. Calling `select()`
	/// for an already-selected input source has no effect.
	///
	/// For `select()` to succeed, the input source must be
	/// capable of being selected (`.isSelectCapable`
	/// must be `true`) and the input source must be enabled
	/// (`.isEnabled` must be `true`). Furthermore, if
	/// if the input source is an input mode, its parent must be enabled
	/// for it to be selected.
	///
	/// - throws: `paramErr` if the input source is not selectable.
	func select() throws {
		let err = TISSelectInputSource(self)
		guard err == noErr else {
			throw SAMacError.osStatus(err)
		}
	}

	/// Deselects the specified input source.
	///
	/// `deselect()` is only intended for use with palette or
	/// ink input sources; calling it has no effect on other input
	/// sources. When palette input sources are disabled, the palette
	/// disappears. Ink input sources are usually deselected and disabled
	/// at the same time.
	/// - throws: `paramErr` if the input source is not deselectable.
	func deselect() throws {
		let err = TISDeselectInputSource(self)
		guard err == noErr else {
			throw SAMacError.osStatus(err)
		}
	}

	/// Enables the specified input source.
	///
	/// `enable()` is mainly intended for input methods, or for
	/// applications that supply their own input sources (e.g.
	/// applications that provide keyboard layouts or palette input
	/// methods, and keyboard input methods that provide their own
	/// keyboard layouts and/or input modes). It makes the specified
	/// input source available in UI for selection.
	///
	/// For `enable()` to succeed, the input source must be
	/// capable of being enabled (`.isEnableCapable`
	/// must be `true`). Furthermore, if the input source is an input mode,
	/// its parent must already be enabled for the mode to become enabled.
	///
	/// - throws: `paramErr` if the input source cannot be enabled.
	func enable() throws {
		let err = TISEnableInputSource(self)
		guard err == noErr else {
			throw SAMacError.osStatus(err)
		}
	}

	/// Disables the specified input source.
	///
	/// `disable()` is mainly intended for input methods, or
	/// for applications that supply their own input sources (e.g.
	/// applications that provide keyboard layouts or palette input
	/// methods, and keyboard input methods that provide their own
	/// keyboard layouts and/or input modes). It makes the specified
	/// input source unavailable for selection, and removes it from
	/// system UI.
	///
	/// - throws: `paramErr` if the input source cannot be disabled.
	func disable() throws {
		let err = TISDisableInputSource(self)
		guard err == noErr else {
			throw SAMacError.osStatus(err)
		}
	}

	// MARK: -Allow input method to override keyboard layout

	/// Sets the keyboard layout override for an input method or mode.
	///
	/// When an input method or mode is the selected input source, TSM
	/// will by default use the most-recently-used ASCII-capable keyboard
	/// layout to translate key events* (this keyboard layout is also the
	/// one that will appear in Keyboard Viewer); an input source for
	/// this keyboard layout is returned by
	/// `TISInputSource.keyboardLayoutOverride`. If a different keyboard
	/// layout should be used for a particular input method or mode, then
	/// when that input method/mode is activated it should call
	/// `setAsOverride()` to specify the desired
	/// keyboard layout.
	///
	/// For example, when a Kotoeri user selects kana layout for kana
	/// input, Kotoeri should call
	/// `setAsOverride()` to set the kana keyboard
	/// as the override for the appropriate input modes.
	///
	/// The keyboard layout set in this way will be used for the final
	/// stage of key translation in the Window Server - the connection or
	/// application-specific key translation.
	///
	/// The override setting is lost when the input method that set it is
	/// deactivated.
	///
	/// The keyboardLayout to be used for overriding need not be enabled
	/// or explicitly selectable. It can be a non-selectable layout that
	/// is included in an input method bundle and automatically
	/// registered.
	///
	/// *The default behavior is new for Mac OS X 10.5, and is meant to
	/// eliminate the necessity for input methods to have UI for setting
	/// which ASCII-capable keyboard to use for latin-character-based
	/// phonetic input.
	///
	/// - throws: `paramErr` if the current keyboard input
	/// source is not an input method/mode or if this layout does not
	/// designate a keyboard layout.
	func setAsOverride() throws {
		let err = TISSetInputMethodKeyboardLayoutOverride(self)
		guard err == noErr else {
			throw SAMacError.osStatus(err)
		}
	}

	/// Returns a `TISInputSource` for the currently-selected input
	/// method's keyboard layout override, if any.
	///
	/// If the current keyboard input source is an input method or mode
	/// that has a keyboard layout override, then a `TISInputSource` for
	/// that keyboard layout is returned; otherwise, `nil` is returned.
	@inlinable static var keyboardLayoutOverride: TISInputSource? {
		return TISCopyInputMethodKeyboardLayoutOverride()?.takeRetainedValue()
	}

	// MARK: - Install/register an input source
	
	/// Registers the new input source(s) in a file or bundle so that a
	/// `TISInputSource` can immediately be obtained for each of the new
	/// input source(s).
	///
	/// This allows an installer for an input method bundle or a keyboard
	/// layout file or bundle to notify the system that these new input
	/// sources should be registered. The system can then locate the
	/// specified file or bundle and perform any necessary cache rebuilds
	/// so that the installer can immediately call
	/// `TISCreateInputSourceList` with appropriate properties (e.g.
	/// `BundleID` or `InputSourceID`) in order to get `TISInputSource`s for
	/// one or more of the newly registered input sources.
	///
	/// This can only be used to register the following:
	///
	/// - Keyboard layout files or bundles in "/Library/Keyboard
	/// Layouts/" or "~/Library/Keyboard Layouts/" (available to all
	/// users or current user, respectively). Such keyboard layouts, once
	/// enabled, are selectable.
	///
	/// - Input method bundles in the new "/Library/Input Methods/" or
	/// "~/Library/Input Methods/" directories (available to all users or
	/// current user, respectively).
	///
	/// Note: Input method bundles can include private non-selectable
	/// keyboard layouts for use with
	/// `TISSetInputMethodKeyboardLayoutOverride`. These are registered
	/// automatically when the input method is registered, and do not
	/// need to be separately registered.
	///
	/// Security: Any code that calls `registerInputSource(at:)` is part of
	/// an application or service that has already been validated in some
	/// way (e.g. by the user).
	/// - parameter location: `URL` for the location of the input source(s), a
	/// file or bundle.
	/// - throws: `paramErr` if location is invalid or the input
	/// source(s) in the specified location cannot be registered.
	static func registerInputSource(at location: URL) throws {
		let err = TISRegisterInputSource(location as NSURL)
		guard err == noErr else {
			throw SAMacError.osStatus(err)
		}
	}
	
	/// Gets value of specified property for this input source.
	///
	/// - parameter key:
	/// The property key constant specifying the desired property value.
	///
	/// Returns a pointer type appropriate for value object associated
	/// with the property key. The specific pointer type is specified for
	/// each key. Typically it is a `CFTypeRef` of some sort, but in one
	/// case it is `IconRef`. The function may return `nil` if the specified
	/// property is missing or invalid for the specified input source.
	func value(for key: Properties) -> Any? {
		return TISGetInputSourceProperty(self, key.rawValue)
	}
}

public extension CFNotificationName {
	/// The name of the CF distributed notification for a change to the
	/// selected keyboard input source.
	@inlinable static var TISSelectedKeyboardInputSourceChanged: CFNotificationName {
		return CFNotificationName(kTISNotifySelectedKeyboardInputSourceChanged)
	}
	
	/// The name of the CF distributed notification for a change to the
	/// set of enabled keyboard input sources.
	@inlinable static var TISEnabledKeyboardInputSourcesChanged: CFNotificationName {
		return CFNotificationName(kTISNotifyEnabledKeyboardInputSourcesChanged)
	}
}

public extension TISInputSource {
	/// The value that indicates the category of input source.
	///
	/// The possible values are specified by the Swift enum `TISInputSource.SourceCategory`.
	var category: SourceCategory {
		let rawDat = TISGetInputSourceProperty(self, kTISPropertyInputSourceCategory)!
		let theDat = Unmanaged<CFString>.fromOpaque(rawDat).takeUnretainedValue()
		return SourceCategory(rawValue: theDat)!
	}
	
	/// IconRefs are the normal icon format for keyboard layouts and
	/// input methods. If an IconRef is not available for the specified
	/// input source, the value is `nil`.
	var iconRef: IconRef? {
		guard let val = TISGetInputSourceProperty(self, kTISPropertyIconRef) else {
			return nil
		}
		return OpaquePointer(val)
	}
	
	/// The value that indicates
	/// whether the input source can ever (given the right conditions) be
	/// programmatically enabled using `TISEnableInputSource`.
	///
	/// This is a static property of an input source, and does not depend
	/// on any current state.
	///
	/// Most input sources can be programmatically enabled at any time;
	/// `kTISPropertyInputSourceIsEnableCapable` is true for these.
	///
	///
	/// Some input sources can never be programmatically enabled. These
	/// are mainly input method private keyboard layouts that are used by
	/// the input method via `TISSetInputMethodKeyboardLayoutOverride`, but
	/// which cannot be directly enabled and used as keyboard layout
	/// input sources. `kTISPropertyInputSourceIsEnableCapable` is `false`
	/// for these.
	///
	/// Some input sources can only be programmatically enabled under the
	/// correct conditions. These are mainly input modes, which can only
	/// be changed from disabled to enabled if their parent input method
	/// is enabled (however, they can already be in the enabled state -
	/// but not currently selectable - if their parent input method is
	/// disabled). `kTISPropertyInputSourceIsEnableCapable` is `true` for
	/// these.
	var isEnableCapable: Bool {
		guard let rawDat = TISGetInputSourceProperty(self, kTISPropertyInputSourceIsEnableCapable) else {
			return false
		}
		let theDat = Unmanaged<CFBoolean>.fromOpaque(rawDat).takeUnretainedValue()
		return CFBooleanGetValue(theDat)
	}
	
	/// The value that indicates
	/// whether the input source can ever (given the right conditions) be
	/// programmatically selected using `TISSelectInputSource`.
	///
	/// This is a static property of an input source, and does not depend
	/// on any current state.
	///
	/// Most input sources can be programmatically selected if they are
	/// enabled; `kTISPropertyInputSourceIsSelectCapable` is `true` for
	/// these.
	///
	/// Some input sources can never be programmatically selected even if
	/// they are enabled. These are mainly input methods that have modes
	/// (parent input methods); only their modes can be selected.
	/// `kTISPropertyInputSourceIsSelectCapable` is `false` for these.
	///
	///
	/// Some input sources which are enabled can only be programmatically
	/// selected under the correct conditions. These are mainly input
	/// modes, which can only be selected if both they and their parent
	/// input method are enabled.  `kTISPropertyInputSourceIsSelectCapable`
	/// is `true` for these.
	///
	/// Input source which can never be enabled - i.e. for which
	/// `kTISPropertyInputSourceIsEnableCapable` is `false` - can also never
	/// be selected. `kTISPropertyInputSourceIsSelectCapable` is `false` for
	/// these.
	var isSelectCapable: Bool {
		guard let rawDat = TISGetInputSourceProperty(self, kTISPropertyInputSourceIsSelectCapable) else {
			return false
		}
		let theDat = Unmanaged<CFBoolean>.fromOpaque(rawDat).takeUnretainedValue()
		return CFBooleanGetValue(theDat)
	}
	
	/// The value that indicates whether the input source is currently enabled.
	var isEnabled: Bool {
		guard let rawDat = TISGetInputSourceProperty(self, kTISPropertyInputSourceIsEnabled) else {
			return false
		}
		let theDat = Unmanaged<CFBoolean>.fromOpaque(rawDat).takeUnretainedValue()
		return CFBooleanGetValue(theDat)
	}
	
	/// The value that indicates whether the input source is currently selected.
	var isSelected: Bool {
		guard let rawDat = TISGetInputSourceProperty(self, kTISPropertyInputSourceIsSelected) else {
			return false
		}
		let theDat = Unmanaged<CFBoolean>.fromOpaque(rawDat).takeUnretainedValue()
		return CFBooleanGetValue(theDat)
	}

	/// The value that indicates whether the input source identifies itself as ASCII-capable.
	var isASCIICapable: Bool {
		guard let rawDat = TISGetInputSourceProperty(self, kTISPropertyInputSourceIsASCIICapable) else {
			return false
		}
		let theDat = Unmanaged<CFBoolean>.fromOpaque(rawDat).takeUnretainedValue()
		return CFBooleanGetValue(theDat)
	}

	/// The `Data` that refers to the '`uchr`' keyboard layout data for a keyboard layout
	/// input source.
	///
	/// The `uchr` data is in native-endian order. If the input source is
	/// not a keyboard layout, or is a keyboard layout for which only
	/// '`KCHR` data' is available, the value is `nil`.
	var unicodeKeyLayout: Data? {
		guard let rawDat = TISGetInputSourceProperty(self, kTISPropertyUnicodeKeyLayoutData) else {
			return nil
		}
		let theDat = Unmanaged<CFData>.fromOpaque(rawDat).takeUnretainedValue()
		return theDat as Data
	}
	
	/// The value indicating the
	/// file containing the image (typically *TIFF*) to be used as the
	/// input source icon.
	///
	/// *TIFF* files are the normal icon format for input modes. If an
	/// image file URL is not available for the specified input source,
	/// the value will be `nil`. Note that other image formats (e.g. *JPEG*,
	/// *PNG*, *PDF*) may also be supported.
	///
	/// Clients should be prepared for a URL to be unreachable, such as when
	/// an Input Method Info.plist mis-declares its icon path extension in its Info.plist.
	/// In this case, the client should try other path extensions, by using, for example,
	/// a combination of `CFURLResourceIsReachable`, `CFURLCopyPathExtension`,
	/// `CFURLCreateCopyDeletingPathExtension`, and `CFURLCreateCopyAppendingPathExtension`.
	/// For example, if the URL indicates **".png"**, be prepared to look for a **".tiff"**.
	/// TIS uses `[NSBundle(NSBundleImageExtension) imageForResource:]`,
	/// where possible, to obtain an input source image, so the path extension (i.e. ".png")
	/// is not critical for the System to find and display the image properly.
	var imageURL: URL? {
		guard let rawDat = TISGetInputSourceProperty(self, kTISPropertyIconImageURL) else {
			return nil
		}
		let theDat = Unmanaged<CFURL>.fromOpaque(rawDat).takeUnretainedValue()
		return theDat as URL
	}
	
	/// The value for the reverse DNS BundleID associated with the input source.
	///
	/// Not valid for all input sources (especially some keyboard
	/// layouts).
	var bundleID: String? {
		guard let rawDat = TISGetInputSourceProperty(self, kTISPropertyBundleID) else {
			return nil
		}
		let theDat = Unmanaged<CFString>.fromOpaque(rawDat).takeUnretainedValue()
		return theDat as String
	}

	/// The value for the input source's localized name for UI purposes.
	///
	/// Uses the best match (determined by `CFBundle`) between the
	/// localization being used by the caller and the available
	/// localizations of the input source name. In some cases this may
	/// fall back to an unlocalized name.
	var localizedName: String? {
		guard let rawDat = TISGetInputSourceProperty(self, kTISPropertyLocalizedName) else {
			return nil
		}
		let theDat = Unmanaged<CFString>.fromOpaque(rawDat).takeUnretainedValue()
		return theDat as String
	}

	/// A value which is an `Array` of `String`s, where each `String` is the
	/// language code for a language that can be input using the input source.
	///
	/// Languages codes are in the same BCP 47 format as returned by
	/// `CFLocaleCreateCanonicalLanguageIdentifierFromString`. The first
	/// language code in the array is the language for which the input
	/// source is intended. If there is no such language (e.g. for the
	/// Unicode Hex Input keyboard layout), the first language code is an
	/// empty string.
	var languages: [String]? {
		guard let rawDat = TISGetInputSourceProperty(self, kTISPropertyInputSourceLanguages) else {
			return nil
		}
		let theDat = Unmanaged<CFArray>.fromOpaque(rawDat).takeUnretainedValue()
		return theDat as? [String]
	}

	/// The value for the unique reverse DNS name associated with the input source.
	///
	/// 1. For keyboard input methods and for input sources of the
	/// palette or ink category, this is typically the bundle ID, e.g.
	/// "com.apple.Kotoeri".
	///
	/// 2. For keyboard input modes, this is typically the bundle ID of
	/// the parent input method plus a suffix that uniquely identifies
	/// the input mode, e.g. "com.apple.Kotoeri.Katakana" (it is not the
	/// generic input mode name used across input methods, e.g.
	/// "com.apple.inputmethod.Japanese.Katakana").
	///
	/// 3. For keyboard layouts this is a new identification mechanism
	/// typically structured as "com.company.keyboardlayout.name", e.g.
	/// "com.apple.keyboardlayout.US".
	var inputSourceID: String? {
		guard let rawDat = TISGetInputSourceProperty(self, kTISPropertyInputSourceID) else {
			return nil
		}
		let theDat = Unmanaged<CFString>.fromOpaque(rawDat).takeUnretainedValue()
		return theDat as String
	}
	
	/// The value that identifies a particular usage class for input modes.
	///
	/// For example, "com.apple.inputmethod.Japanese.Katakana" identifies
	/// a standard Katakana-input usage class that may be associated with
	/// input modes from several different input methods.
	///
	/// This InputModeID can be attached to a `TSMDocument` using
	/// `TSMSetDocumentProperty` with the tag
	/// `kTSMDocumentInputModePropertyTag`, in order to control which input
	/// mode usage class should be used with that `TSMDocument`.
	var inputModeID: String? {
		guard let rawDat = TISGetInputSourceProperty(self, kTISPropertyInputModeID) else {
			return nil
		}
		let theDat = Unmanaged<CFString>.fromOpaque(rawDat).takeUnretainedValue()
		return theDat as String
	}

	/// The value that indicates the specific type of input source.
	///
	/// See `TISInputSource.SourceType` for the available values.
	var sourceType: SourceType {
		let rawDat = TISGetInputSourceProperty(self, kTISPropertyInputSourceType)!
		let theDat = Unmanaged<CFString>.fromOpaque(rawDat).takeUnretainedValue()
		return SourceType(rawValue: theDat)!
	}
}

#endif
