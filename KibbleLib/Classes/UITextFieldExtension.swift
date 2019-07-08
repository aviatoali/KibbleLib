import UIKit
/**
 Custom extensions to UITextField
 - Author: Ali H. Shah
 - Date: 03/12/2019
 */
extension UITextField {
    /// Moves the caret to the correct position by removing the trailing whitespace
    func FixCaretPosition() {
        // Moving the caret to the correct position by removing the trailing whitespace
        // http://stackoverflow.com/questions/14220187/uitextfield-has-trailing-whitespace-after-securetextentry-toggle
        let beginning = self.beginningOfDocument
        self.selectedTextRange = self.textRange(from: beginning, to: beginning)
        let end = self.endOfDocument
        self.selectedTextRange = self.textRange(from: end, to: end)
    }
    
    @discardableResult func ValidatedText(validationType: ValidatorType) throws -> String {
        let validator = ValidatorFactory.validatorFor(type: validationType)
        return try validator.validated(self.text!)
    }
}
