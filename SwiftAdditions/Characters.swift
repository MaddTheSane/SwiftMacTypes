//
//  Characters.swift
//  BlastApp
//
//  Created by C.W. Betts on 9/22/15.
//
//

import Foundation

/// Based off of the ASCII code tables
public enum ASCIICharacter: Int8, Comparable, Hashable, @unchecked Sendable {
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

public extension ASCIICharacter {
	/// Takes a Swift `Character` and returns an ASCII character/code.
	/// Returns `nil` if the value can't be represented in ASCII.
	init?(swiftCharacter: Character) {
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
	init?(cCharacter: Int8) {
		guard let aChar = ASCIICharacter(rawValue: cCharacter) else {
			return nil
		}
		self = aChar
	}
	
	/// Takes a C-style char value and maps it to the ASCII table.
	/// Returns `nil` if the value can't be represented as ASCII.
	init?(cCharacter cch: UInt8) {
		self.init(cCharacter: Int8(bitPattern: cch))
	}

	
	/// Returns a Swift `Character` representing the current enum value.
	/// Returns a blank replacement character (**0xFFFD**) if not a valid ASCII value.
	var characterValue: Character {
		let numVal = self.rawValue
		guard numVal >= 0 else {
			return "\u{FFFD}"
		}
		
		return Character(Unicode.Scalar(UInt8(numVal)))
	}
}

public extension String {
	/// Creates a string from a sequence of `ASCIICharacter`s.
	@inlinable init<A: Sequence>(asciiCharacters: A) where A.Element == ASCIICharacter {
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
	func toASCIICharacters(encodeInvalid: Bool = false) -> [ASCIICharacter]? {
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
