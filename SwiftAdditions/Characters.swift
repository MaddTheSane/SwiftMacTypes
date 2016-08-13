//
//  Characters.swift
//  BlastApp
//
//  Created by C.W. Betts on 9/22/15.
//
//

import Foundation

public func <(lhs: ASCIICharacter, rhs: ASCIICharacter) -> Bool {
	return lhs.rawValue < rhs.rawValue
}

/// Based off of the ASCII code tables
public enum ASCIICharacter: Int8, Comparable {
	//MARK: non-visible characters
	case NullCharacter = 0
	case StartOfHeader
	case StartOfText
	case EndOfText
	case EndOfTransmission
	case Enquiry
	case Acknowledgement
	case Bell
	case Backspace
	case HorizontalTab
	/// new-line in Unix files, commonly represented as `'\n'`
	/// in C-like languages.
	///
	/// Hex code: `0x0A`
	case LineFeed = 0x0A
	case VerticalTab
	case FormFeed
	case CarriageReturn
	case ShiftOut
	case ShiftIn
	case DataLineEscape
	case DeviceControl1
	case DeviceControl2
	case DeviceControl3
	case DeviceControl4
	case NegativeAcknowledgement
	case SynchronousIdle
	case EndOfTransmitBlock = 0x17
	case Cancel
	case EndOfMedium
	case Substitute
	case Escape
	case FileSeperator
	case GroupSeperator
	case RecordSeperator
	case UnitSeperator
	
	/// 0x20
	case Space = 0x20
	case ExclamationMark = 0x21
	case DoubleQuote
	case NumberSign
	case DollarSign
	case PercentSign
	case Apersand
	case SingleQuote
	case OpenParenthesis
	case CloseParenthesis
	case Asterisk
	case PlusSign
	case Comma
	case Hyphen
	case Period
	case Slash
	case NumberZero = 0x30
	case NumberOne
	case NumberTwo
	case NumberThree
	case NumberFour
	case NumberFive
	case NumberSix
	case NumberSeven
	case NumberEight
	case NumberNine
	case Colon = 0x3A
	case Semicolon
	case LessThan
	case Equals
	case GreaterThan
	case QuestionMark
	case AtSymbol
	
	case LetterUppercaseA = 0x41
	case LetterUppercaseB
	case LetterUppercaseC
	case LetterUppercaseD
	case LetterUppercaseE
	case LetterUppercaseF
	case LetterUppercaseG
	case LetterUppercaseH
	case LetterUppercaseI
	case LetterUppercaseJ
	case LetterUppercaseK
	case LetterUppercaseL
	case LetterUppercaseM
	case LetterUppercaseN
	case LetterUppercaseO
	case LetterUppercaseP
	case LetterUppercaseQ
	case LetterUppercaseR
	case LetterUppercaseS
	case LetterUppercaseT
	case LetterUppercaseU
	case LetterUppercaseV
	case LetterUppercaseW
	case LetterUppercaseX
	case LetterUppercaseY
	case LetterUppercaseZ
	
	case OpeningBracket
	case BackSlashCharacter
	case ClosingBracket
	case CaretCharacter
	case UnderscoreCharacter
	case GraveAccent
	
	case LetterLowercaseA = 0x61
	case LetterLowercaseB
	case LetterLowercaseC
	case LetterLowercaseD
	case LetterLowercaseE
	case LetterLowercaseF
	case LetterLowercaseG
	case LetterLowercaseH
	case LetterLowercaseI
	case LetterLowercaseJ
	case LetterLowercaseK
	case LetterLowercaseL
	case LetterLowercaseM
	case LetterLowercaseN
	case LetterLowercaseO
	case LetterLowercaseP
	case LetterLowercaseQ
	case LetterLowercaseR
	case LetterLowercaseS
	case LetterLowercaseT
	case LetterLowercaseU
	case LetterLowercaseV
	case LetterLowercaseW
	case LetterLowercaseX
	case LetterLowercaseY
	case LetterLowercaseZ
	
	case OpeningBrace = 0x7B
	case VerticalBar
	case ClosingBrace
	case TildeCharacter
	case DeleteCharacter
	
	/// Value is not valid ASCII
	case Invalid = -1
	
	/// Takes a Swift `Character` and returns an ASCII character/code.
	/// Returns `nil` if the value can't be represented in ASCII
	public init?(swiftCharacter: Character) {
		//This function is a big mess, far more than it needs to be.
		//The Character type doesn't have any way to get the raw value from itself.
		let srrChar = String(swiftCharacter)
		let utfEnc = srrChar.unicodeScalars
		
		let ourCharScalar = utfEnc.first!
		
		var utf8Scalars = [UInt8]()
		
		UTF8.encode(ourCharScalar) { (cu) -> () in
			utf8Scalars.append(cu)
		}
		if utf8Scalars.count > 1 {
			return nil
		}
		
		let ourChar = utf8Scalars.last!
		
		guard (ourChar & 0x80) == 0 else {
			return nil
		}
		
		self = ASCIICharacter(rawValue: Int8(ourChar))!
	}
	
	/// Takes a C-style char value and maps it to the ASCII table.<br>
	/// Returns `nil` if the value can't be represented as ASCII.
	public init?(CCharacter: Int8) {
		guard let aChar = ASCIICharacter(rawValue: CCharacter) else {
			return nil
		}
		self = aChar
	}
	
	/// Takes a C-style char value and maps it to the ASCII table.
	/// Returns `nil` if the value can't be represented as ASCII.
	public init?(CCharacter cch: UInt8) {
		self.init(CCharacter: Int8(bitPattern: cch))
	}

	
	/// Returns a Swift `Character` representing the current enum value.
	/// Returns a blank replacement character (`0xFFFD`) if not a valid ASCII value.
	public var characterValue: Character {
		let numVal = self.rawValue
		if numVal < 0 {
			return "\u{FFFD}"
		}
		let preUTF8 = [UInt8(numVal)]
		var preScalar = [UnicodeScalar]()
		
		
		_ = transcode(preUTF8.makeIterator(), from: UTF8.self, to: UTF32.self, stoppingOnError: false, into: ({
			preScalar.append(UnicodeScalar($0))
		}))

		return Character(preScalar.first!)
	}
}

extension String {
	public init(asciiCharacters: [ASCIICharacter]) {
		let asciiCharMap = asciiCharacters.map { (cha) -> Character in
			return cha.characterValue
		}
		self = String(asciiCharMap)
	}
	
	public func toASCIICharacters() -> [ASCIICharacter]? {
		guard let asciis = self.cString(using: String.Encoding.ascii) else {
			return nil
		}
		
		return asciis.map({ (aChar) -> ASCIICharacter in
			return ASCIICharacter(CCharacter: aChar)!
		})
	}
}
