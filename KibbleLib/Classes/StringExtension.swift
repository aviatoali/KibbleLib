import Foundation
/**
 Public extension for the String class for adding convenience methods and behavior
 - author: Ali H. Shah
 - date: 07/03/2019
 */
public extension String {
    func Localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}
