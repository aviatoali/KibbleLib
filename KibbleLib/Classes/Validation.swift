import Foundation
/**
 Util class that contains validation helpers
 - Author: Ali H. Shah
 - Date: 10/13/2019
 - Note:
 - Based on ideas demonstrated in https://medium.com/swift2go/a-better-approach-to-text-field-validations-on-ios-81bd87598070
 */
class ValidationError: Error {
    var message: String
    init(_ message: String) {
        self.message = message
    }
}

protocol Validator {
    @discardableResult func validated(_ value: String) throws -> String
}

enum ValidatorType {
    case email
    case requiredField
    case dateOfBirth(calendar: Calendar, currentDate: Date, minAgeRequired: Int, maxAgeAllowed: Int)
    case phoneNumber(digitCount: Int)
    case password
}

enum ValidatorFactory {
    static func validatorFor(type: ValidatorType) -> Validator {
        switch type {
        case .email:
            return EmailValidator()
        case .requiredField:
            return RequiredFieldValidator()
        case .dateOfBirth(let calendar, let currentDate, let minAgeRequired, let maxAgeAllowed):
            return DateOfBirthValidator(calendar: calendar, currentDate: currentDate, minAgeRequired: minAgeRequired, maxAgeAllowed: maxAgeAllowed)
        case .phoneNumber(let digitCount):
            return PhoneNumberValidator(digitCount: digitCount)
        case .password:
            return PasswordValidator()
        }
    }
}

struct EmailValidator: Validator {
    @discardableResult func validated(_ value: String) throws -> String {
        do {
            if try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Invalid e-mail address")
            }
        } catch {
            throw ValidationError("Invalid e-mail address")
        }
        return value
    }
}

struct RequiredFieldValidator: Validator {
    @discardableResult func validated(_ value: String) throws -> String {
        guard !value.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ValidationError("This field is required")
        }
        return value
    }
}

struct DateOfBirthValidator: Validator {
    private let calendar: Calendar
    private let currentDate: Date
    private let minAgeRequired: Int
    private let maxAgeAllowed: Int
    
    init(calendar: Calendar, currentDate: Date, minAgeRequired: Int, maxAgeAllowed: Int) {
        self.calendar = calendar
        self.currentDate = currentDate
        self.minAgeRequired = minAgeRequired
        self.maxAgeAllowed = maxAgeAllowed
    }
    
    @discardableResult func validated(_ value: String) throws -> String {
        var day = ""
        var month = ""
        var year = ""
        if value.count == 8 {
            day = String(value[value.index(value.startIndex, offsetBy: 2)..<value.index(value.endIndex, offsetBy: -4)])
            month = String(value.prefix(2))
            year = String(value.suffix(4))
        }
        var dateComponents = DateComponents()
        dateComponents.day = Int(day)
        dateComponents.month = Int(month)
        dateComponents.year = Int(year)
        guard let userDobDate = self.calendar.date(from: dateComponents) else {
            throw ValidationError("Unable to validate birth date")
        }
        let dayMonthComponent = self.calendar.dateComponents([.day, .month], from: userDobDate)
        guard let dayComp = dayMonthComponent.day, dayComp == Int(day), let monthComp = dayMonthComponent.month, monthComp == Int(month) else {
            throw ValidationError("You must be 18 years of age or older to enroll")
        }
        let ageComponents = self.calendar.dateComponents([.year], from: userDobDate, to: self.currentDate)
        guard let age = ageComponents.year, age >= self.minAgeRequired, age <= self.maxAgeAllowed else {
            throw ValidationError("You must be 18 years of age or older to enroll")
        }
        return "\(month)/\(day)/\(year)"
    }
}

struct PhoneNumberValidator: Validator {
    private let digitCount: Int
    
    init(digitCount: Int) {
        self.digitCount = digitCount
    }
    
    @discardableResult func validated(_ value: String) throws -> String {
        let pureNum = value.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        if pureNum.count != self.digitCount {
            throw ValidationError("Phone number invalid")
        }
        return pureNum
    }
}

struct PasswordValidator: Validator {
    @discardableResult func validated(_ value: String) throws -> String {
        guard !value.isEmpty, value.count >= 8 else {
            throw ValidationError("Password must be at least 8 characters in length")
        }
        let capTest = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*")
        let capCheckPass = capTest.evaluate(with: value)
        if !capCheckPass {
            throw ValidationError("Password must include at least one capital letter")
        }
        let numTest = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*")
        let numCheckPass = numTest.evaluate(with: value)
        if !numCheckPass {
            throw ValidationError("Password must include at least one number")
        }
        return value
    }
}
