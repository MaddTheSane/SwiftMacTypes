//
//  Characters.swift
//  BlastApp
//
//  Created by C.W. Betts on 9/22/15.
//
//

import Foundation

/// Based off of the ASCII code tables
public enum ASCIICharacter: Int8, Comparable, Hashable {
	// MARK: non-visible characters
	// TODO: add info for each value.
	case nullCharacter = 0
	case startOfHeader
	case startOfText
	case endOfText
	case endOfTransmission
	case enquiry
	case acknowledgement
	case bell
	case backspace
	case horizontalTab
	/// new-line in Unix files, commonly represented as `'\n'`
	/// in C-like languages.
	///
	/// Hex code: `0x0A`
	case lineFeed = 0x0A
	case verticalTab
	case formFeed
	case carriageReturn
	case shiftOut
	case shiftIn
	case dataLineEscape
	case deviceControl1
	case deviceControl2
	case deviceControl3
	case deviceControl4
	case negativeAcknowledgement
	case synchronousIdle
	case endOfTransmitBlock = 0x17
	case cancel
	case endOfMedium
	case substitute
	case escape
	case fileSeperator
	case groupSeperator
	case recordSeperator
	case unitSeperator
	
	// MARK: visible characters
	/// 0x20
	case space = 0x20
	case exclamationMark = 0x21
	case doubleQuote
	case numberSign
	case dollarSign
	case percentSign
	case apersand
	case singleQuote
	case openParenthesis
	case closeParenthesis
	case asterisk
	case plusSign
	case comma
	case hyphen
	case period
	case slash
	case numberZero = 0x30
	case numberOne
	case numberTwo
	case numberThree
	case numberFour
	case numberFive
	case numberSix
	case numberSeven
	case numberEight
	case numberNine
	case colon = 0x3A
	case semicolon
	case lessThan
	case equals
	case greaterThan
	case questionMark
	case atSymbol
	
	case letterUppercaseA = 0x41
	case letterUppercaseB
	case letterUppercaseC
	case letterUppercaseD
	case letterUppercaseE
	case letterUppercaseF
	case letterUppercaseG
	case letterUppercaseH
	case letterUppercaseI
	case letterUppercaseJ
	case letterUppercaseK
	case letterUppercaseL
	case letterUppercaseM
	case letterUppercaseN
	case letterUppercaseO
	case letterUppercaseP
	case letterUppercaseQ
	case letterUppercaseR
	case letterUppercaseS
	case letterUppercaseT
	case letterUppercaseU
	case letterUppercaseV
	case letterUppercaseW
	case letterUppercaseX
	case letterUppercaseY
	case letterUppercaseZ
	
	case openingBracket
	case backSlashCharacter
	case closingBracket
	case caretCharacter
	case underscoreCharacter
	case graveAccent
	
	case letterLowercaseA = 0x61
	case letterLowercaseB
	case letterLowercaseC
	case letterLowercaseD
	case letterLowercaseE
	case letterLowercaseF
	case letterLowercaseG
	case letterLowercaseH
	case letterLowercaseI
	case letterLowercaseJ
	case letterLowercaseK
	case letterLowercaseL
	case letterLowercaseM
	case letterLowercaseN
	case letterLowercaseO
	case letterLowercaseP
	case letterLowercaseQ
	case letterLowercaseR
	case letterLowercaseS
	case letterLowercaseT
	case letterLowercaseU
	case letterLowercaseV
	case letterLowercaseW
	case letterLowercaseX
	case letterLowercaseY
	case letterLowercaseZ
	
	case openingBrace = 0x7B
	case verticalBar
	case closingBrace
	case tildeCharacter
	case deleteCharacter
	
	/// Value is not valid ASCII
	case invalid = -1
	
	static public func <(lhs: ASCIICharacter, rhs: ASCIICharacter) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}
}

extension ASCIICharacter {
	/// Takes a Swift `Character` and returns an ASCII character/code.
	/// Returns `nil` if the value can't be represented in ASCII.
	public init?(swiftCharacter: Character) {
		let srrChar = swiftCharacter.unicodeScalars
		guard srrChar.count == 1,
			let ourChar = srrChar.last,
			ourChar.isASCII else {
			return nil
		}
		
		self = ASCIICharacter(rawValue: Int8(ourChar.value))!
	}
	
	/// Takes a C-style char value and maps it to the ASCII table.<br>
	/// Returns `nil` if the value can't be represented as ASCII.
	public init?(cCharacter: Int8) {
		guard let aChar = ASCIICharacter(rawValue: cCharacter) else {
			return nil
		}
		self = aChar
	}
	
	/// Takes a C-style char value and maps it to the ASCII table.
	/// Returns `nil` if the value can't be represented as ASCII.
	public init?(cCharacter cch: UInt8) {
		self.init(cCharacter: Int8(bitPattern: cch))
	}

	
	/// Returns a Swift `Character` representing the current enum value.
	/// Returns a blank replacement character (`0xFFFD`) if not a valid ASCII value.
	public var characterValue: Character {
		let numVal = self.rawValue
		if numVal < 0 {
			return "\u{FFFD}"
		}
		
		return Character(UnicodeScalar(UInt8(numVal)))
	}
}

extension String {
	public init<A: Sequence>(asciiCharacters: A) where A.Element == ASCIICharacter {
		let asciiCharMap = asciiCharacters.map { (cha) -> Character in
			return cha.characterValue
		}
		self = String(asciiCharMap)
	}
	
	/// Converts the string to an array of `ASCIICharacter`s.
	/// - parameter encodeInvalid: If `true`, any character that can't be represented as
	/// an ASCII character is instead replaced with `ASCIICharacter.invalid`
	/// instead of stopping and returning `nil`.
	/// - returns: An array of `ASCIICharacter`s, or `nil` if there is a non-ASCII
	/// character and `encodeInvalid` is `false`.
	public func toASCIICharacters(encodeInvalid: Bool = false) -> [ASCIICharacter]? {
		if encodeInvalid {
			return self.map({ (aChar) -> ASCIICharacter in
				return ASCIICharacter(swiftCharacter: aChar) ?? .invalid
			})
		}
		guard var asciis = self.cString(using: String.Encoding.ascii) else {
			return nil
		}
		
		// Remove null termination.
		asciis.removeLast()
		return asciis.map({ (aChar) -> ASCIICharacter in
			return ASCIICharacter(cCharacter: aChar)!
		})
	}
}

//MARK: - Deprecated

extension ASCIICharacter {
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.nullCharacter")
	public static var NullCharacter: ASCIICharacter {
		return .nullCharacter
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.startOfHeader")
	public static var StartOfHeader: ASCIICharacter {
		return .startOfHeader
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.startOfText")
	public static var StartOfText: ASCIICharacter {
		return .startOfText
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.endOfText")
	public static var EndOfText: ASCIICharacter {
		return .endOfText
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.endOfTransmission")
	public static var EndOfTransmission: ASCIICharacter {
		return .endOfTransmission
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.enquiry")
	public static var Enquiry: ASCIICharacter {
		return .enquiry
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.acknowledgement")
	public static var Acknowledgement: ASCIICharacter {
		return .acknowledgement
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.bell")
	public static var Bell: ASCIICharacter {
		return .bell
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.backspace")
	public static var Backspace: ASCIICharacter {
		return .backspace
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.horizontalTab")
	public static var HorizontalTab: ASCIICharacter {
		return .horizontalTab
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.lineFeed")
	public static var LineFeed: ASCIICharacter {
		return .lineFeed
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.verticalTab")
	public static var VerticalTab: ASCIICharacter {
		return .verticalTab
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.formFeed")
	public static var FormFeed: ASCIICharacter {
		return .formFeed
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.carriageReturn")
	public static var CarriageReturn: ASCIICharacter {
		return .carriageReturn
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.shiftOut")
	public static var ShiftOut: ASCIICharacter {
		return .shiftOut
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.shiftIn")
	public static var ShiftIn: ASCIICharacter {
		return .shiftIn
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.dataLineEscape")
	public static var DataLineEscape: ASCIICharacter {
		return .dataLineEscape
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.deviceControl1")
	public static var DeviceControl1: ASCIICharacter {
		return .deviceControl1
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.deviceControl2")
	public static var DeviceControl2: ASCIICharacter {
		return .deviceControl2
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.deviceControl3")
	public static var DeviceControl3: ASCIICharacter {
		return .deviceControl3
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.deviceControl4")
	public static var DeviceControl4: ASCIICharacter {
		return .deviceControl4
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.negativeAcknowledgement")
	public static var NegativeAcknowledgement: ASCIICharacter {
		return .negativeAcknowledgement
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.synchronousIdle")
	public static var SynchronousIdle: ASCIICharacter {
		return .synchronousIdle
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.endOfTransmitBlock")
	public static var EndOfTransmitBlock: ASCIICharacter {
		return .endOfTransmitBlock
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.cancel")
	public static var Cancel: ASCIICharacter {
		return .cancel
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.endOfMedium")
	public static var EndOfMedium: ASCIICharacter {
		return .endOfMedium
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.substitute")
	public static var Substitute: ASCIICharacter {
		return .substitute
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.escape")
	public static var Escape: ASCIICharacter {
		return .escape
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.fileSeperator")
	public static var FileSeperator: ASCIICharacter {
		return .fileSeperator
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.groupSeperator")
	public static var GroupSeperator: ASCIICharacter {
		return .groupSeperator
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.recordSeperator")
	public static var RecordSeperator: ASCIICharacter {
		return .recordSeperator
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.unitSeperator")
	public static var UnitSeperator: ASCIICharacter {
		return .unitSeperator
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.space")
	public static var Space: ASCIICharacter {
		return .space
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.exclamationMark")
	public static var ExclamationMark: ASCIICharacter {
		return .exclamationMark
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.doubleQuote")
	public static var DoubleQuote: ASCIICharacter {
		return .doubleQuote
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.numberSign")
	public static var NumberSign: ASCIICharacter {
		return .numberSign
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.dollarSign")
	public static var DollarSign: ASCIICharacter {
		return .dollarSign
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.percentSign")
	public static var PercentSign: ASCIICharacter {
		return .percentSign
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.apersand")
	public static var Apersand: ASCIICharacter {
		return .apersand
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.singleQuote")
	public static var SingleQuote: ASCIICharacter {
		return .singleQuote
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.openParenthesis")
	public static var OpenParenthesis: ASCIICharacter {
		return .openParenthesis
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.closeParenthesis")
	public static var CloseParenthesis: ASCIICharacter {
		return .closeParenthesis
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.asterisk")
	public static var Asterisk: ASCIICharacter {
		return .asterisk
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.plusSign")
	public static var PlusSign: ASCIICharacter {
		return .plusSign
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.comma")
	public static var Comma: ASCIICharacter {
		return .comma
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.hyphen")
	public static var Hyphen: ASCIICharacter {
		return .hyphen
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.period")
	public static var Period: ASCIICharacter {
		return .period
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.slash")
	public static var Slash: ASCIICharacter {
		return .slash
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.numberZero")
	public static var NumberZero: ASCIICharacter {
		return .numberZero
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.numberOne")
	public static var NumberOne: ASCIICharacter {
		return .numberOne
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.numberTwo")
	public static var NumberTwo: ASCIICharacter {
		return .numberTwo
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.numberThree")
	public static var NumberThree: ASCIICharacter {
		return .numberThree
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.numberFour")
	public static var NumberFour: ASCIICharacter {
		return .numberFour
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.numberFive")
	public static var NumberFive: ASCIICharacter {
		return .numberFive
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.numberSix")
	public static var NumberSix: ASCIICharacter {
		return .numberSix
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.numberSeven")
	public static var NumberSeven: ASCIICharacter {
		return .numberSeven
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.numberEight")
	public static var NumberEight: ASCIICharacter {
		return .numberEight
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.numberNine")
	public static var NumberNine: ASCIICharacter {
		return .numberNine
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.colon")
	public static var Colon: ASCIICharacter {
		return .colon
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.semicolon")
	public static var Semicolon: ASCIICharacter {
		return .semicolon
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.lessThan")
	public static var LessThan: ASCIICharacter {
		return .lessThan
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.equals")
	public static var Equals: ASCIICharacter {
		return .equals
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.greaterThan")
	public static var GreaterThan: ASCIICharacter {
		return .greaterThan
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.questionMark")
	public static var QuestionMark: ASCIICharacter {
		return .questionMark
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.atSymbol")
	public static var AtSymbol: ASCIICharacter {
		return .atSymbol
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseA")
	public static var LetterUppercaseA: ASCIICharacter {
		return .letterUppercaseA
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseB")
	public static var LetterUppercaseB: ASCIICharacter {
		return .letterUppercaseB
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseC")
	public static var LetterUppercaseC: ASCIICharacter {
		return .letterUppercaseC
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseD")
	public static var LetterUppercaseD: ASCIICharacter {
		return .letterUppercaseD
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseE")
	public static var LetterUppercaseE: ASCIICharacter {
		return .letterUppercaseE
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseF")
	public static var LetterUppercaseF: ASCIICharacter {
		return .letterUppercaseF
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseG")
	public static var LetterUppercaseG: ASCIICharacter {
		return .letterUppercaseG
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseH")
	public static var LetterUppercaseH: ASCIICharacter {
		return .letterUppercaseH
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseI")
	public static var LetterUppercaseI: ASCIICharacter {
		return .letterUppercaseI
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseJ")
	public static var LetterUppercaseJ: ASCIICharacter {
		return .letterUppercaseJ
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseK")
	public static var LetterUppercaseK: ASCIICharacter {
		return .letterUppercaseK
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseL")
	public static var LetterUppercaseL: ASCIICharacter {
		return .letterUppercaseL
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseM")
	public static var LetterUppercaseM: ASCIICharacter {
		return .letterUppercaseM
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseN")
	public static var LetterUppercaseN: ASCIICharacter {
		return .letterUppercaseN
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseO")
	public static var LetterUppercaseO: ASCIICharacter {
		return .letterUppercaseO
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseP")
	public static var LetterUppercaseP: ASCIICharacter {
		return .letterUppercaseP
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseQ")
	public static var LetterUppercaseQ: ASCIICharacter {
		return .letterUppercaseQ
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseR")
	public static var LetterUppercaseR: ASCIICharacter {
		return .letterUppercaseR
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseS")
	public static var LetterUppercaseS: ASCIICharacter {
		return .letterUppercaseS
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseT")
	public static var LetterUppercaseT: ASCIICharacter {
		return .letterUppercaseT
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseU")
	public static var LetterUppercaseU: ASCIICharacter {
		return .letterUppercaseU
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseV")
	public static var LetterUppercaseV: ASCIICharacter {
		return .letterUppercaseV
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseW")
	public static var LetterUppercaseW: ASCIICharacter {
		return .letterUppercaseW
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseX")
	public static var LetterUppercaseX: ASCIICharacter {
		return .letterUppercaseX
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseY")
	public static var LetterUppercaseY: ASCIICharacter {
		return .letterUppercaseY
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterUppercaseZ")
	public static var LetterUppercaseZ: ASCIICharacter {
		return .letterUppercaseZ
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.openingBracket")
	public static var OpeningBracket: ASCIICharacter {
		return .openingBracket
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.backSlashCharacter")
	public static var BackSlashCharacter: ASCIICharacter {
		return .backSlashCharacter
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.closingBracket")
	public static var ClosingBracket: ASCIICharacter {
		return .closingBracket
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.caretCharacter")
	public static var CaretCharacter: ASCIICharacter {
		return .caretCharacter
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.underscoreCharacter")
	public static var UnderscoreCharacter: ASCIICharacter {
		return .underscoreCharacter
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.graveAccent")
	public static var GraveAccent: ASCIICharacter {
		return .graveAccent
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseA")
	public static var LetterLowercaseA: ASCIICharacter {
		return .letterLowercaseA
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseB")
	public static var LetterLowercaseB: ASCIICharacter {
		return .letterLowercaseB
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseC")
	public static var LetterLowercaseC: ASCIICharacter {
		return .letterLowercaseC
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseD")
	public static var LetterLowercaseD: ASCIICharacter {
		return .letterLowercaseD
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseE")
	public static var LetterLowercaseE: ASCIICharacter {
		return .letterLowercaseE
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseF")
	public static var LetterLowercaseF: ASCIICharacter {
		return .letterLowercaseF
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseG")
	public static var LetterLowercaseG: ASCIICharacter {
		return .letterLowercaseG
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseH")
	public static var LetterLowercaseH: ASCIICharacter {
		return .letterLowercaseH
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseI")
	public static var LetterLowercaseI: ASCIICharacter {
		return .letterLowercaseI
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseJ")
	public static var LetterLowercaseJ: ASCIICharacter {
		return .letterLowercaseJ
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseK")
	public static var LetterLowercaseK: ASCIICharacter {
		return .letterLowercaseK
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseL")
	public static var LetterLowercaseL: ASCIICharacter {
		return .letterLowercaseL
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseM")
	public static var LetterLowercaseM: ASCIICharacter {
		return .letterLowercaseM
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseN")
	public static var LetterLowercaseN: ASCIICharacter {
		return .letterLowercaseN
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseO")
	public static var LetterLowercaseO: ASCIICharacter {
		return .letterLowercaseO
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseP")
	public static var LetterLowercaseP: ASCIICharacter {
		return .letterLowercaseP
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseQ")
	public static var LetterLowercaseQ: ASCIICharacter {
		return .letterLowercaseQ
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseR")
	public static var LetterLowercaseR: ASCIICharacter {
		return .letterLowercaseR
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseS")
	public static var LetterLowercaseS: ASCIICharacter {
		return .letterLowercaseS
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseT")
	public static var LetterLowercaseT: ASCIICharacter {
		return .letterLowercaseT
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseU")
	public static var LetterLowercaseU: ASCIICharacter {
		return .letterLowercaseU
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseV")
	public static var LetterLowercaseV: ASCIICharacter {
		return .letterLowercaseV
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseW")
	public static var LetterLowercaseW: ASCIICharacter {
		return .letterLowercaseW
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseX")
	public static var LetterLowercaseX: ASCIICharacter {
		return .letterLowercaseX
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseY")
	public static var LetterLowercaseY: ASCIICharacter {
		return .letterLowercaseY
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.letterLowercaseZ")
	public static var LetterLowercaseZ: ASCIICharacter {
		return .letterLowercaseZ
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.openingBrace")
	public static var OpeningBrace: ASCIICharacter {
		return .openingBrace
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.verticalBar")
	public static var VerticalBar: ASCIICharacter {
		return .verticalBar
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.closingBrace")
	public static var ClosingBrace: ASCIICharacter {
		return .closingBrace
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.tildeCharacter")
	public static var TildeCharacter: ASCIICharacter {
		return .tildeCharacter
	}
	
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.deleteCharacter")
	public static var DeleteCharacter: ASCIICharacter {
		return .deleteCharacter
	}
	
	/// Value is not valid ASCII
	@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, renamed: "ASCIICharacter.invalid")
	public static var Invalid: ASCIICharacter {
		return .invalid
	}
}
