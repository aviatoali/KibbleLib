import UIKit
/**
 A customization of Chris Byatt's CBPinEntryView to change its functionality
 - Author: Ali H. Shah
 - Date: 02/09/2019
 - Note:
 - Original source: https://github.com/Fawxy/CBPinEntryView
 */
@available(iOS 11.0, *)
class PinEntryView: UIView {
    
    var length: Int = 6 {
        didSet {
            self.commonInit()
        }
    }
    
    var spacing: CGFloat = 4.4
    
    var entryCornerRadius: CGFloat = 3.0 {
        didSet {
            if oldValue != self.entryCornerRadius {
                self.updateButtonStyles()
            }
        }
    }
    
    var entryBorderWidth: CGFloat = 0 {
        didSet {
            if oldValue != self.entryBorderWidth {
                self.updateButtonStyles()
            }
        }
    }
    
    var entryDefaultBorderColor: UIColor = .clear {
        didSet {
            if oldValue != self.entryDefaultBorderColor {
                self.updateButtonStyles()
            }
        }
    }
    
    var entryBorderColor: UIColor = UIColor(red: 69/255, green: 78/255, blue: 86/255, alpha: 1.0) {
        didSet {
            if oldValue != self.entryBorderColor {
                self.updateButtonStyles()
            }
        }
    }
    
    var entryEditingBackgroundColor: UIColor = UIColor(red: 67/255, green: 115/255, blue: 205/255, alpha: 1.0) {
        didSet {
            if oldValue != self.entryEditingBackgroundColor {
                self.updateButtonStyles()
            }
        }
    }
    
    var entryErrorBorderColor: UIColor = .red
    
    var entryBackgroundColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4) {
        didSet {
            if oldValue != self.entryBackgroundColor {
                self.updateButtonStyles()
            }
        }
    }
    
    var entryTextColor: UIColor = .white {
        didSet {
            if oldValue != self.entryTextColor {
                self.updateButtonStyles()
            }
        }
    }
    
    var entryFont: UIFont = UIFont.systemFont(ofSize: 38) {
        didSet {
            if oldValue != self.entryFont {
                self.updateButtonStyles()
            }
        }
    }
    
    var isSecure: Bool = false
    
    var secureCharacter: String = "●"
    
    var keyboardType: Int = 4
    
    var textContentType: UITextContentType? {
        didSet {
            if let contentType = self.textContentType {
                self.textField.textContentType = contentType
            }
        }
    }
    
    var textFieldCapitalization: UITextAutocapitalizationType? {
        didSet {
            if let capitalization = self.textFieldCapitalization {
                self.textField.autocapitalizationType = capitalization
            }
        }
    }
    
    public enum AllowedEntryTypes: String {
        case any, numerical, alphanumeric, letters
    }
    
    var allowedEntryTypes: AllowedEntryTypes = .numerical
    
    var stackView: UIStackView?
    var textField: UITextField!
    
    var errorMode: Bool = false
    
    var entryButtons: [UIButton] = [UIButton]()
    
    var allowEmptyValues: Bool = true
    
    weak var delegate: PinEntryViewDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func commonInit() {
        self.setupStackView()
        self.setupTextField()
        
        self.createButtons()
    }
    
    private func setupStackView() {
        if self.stackView != nil {
            self.stackView?.removeFromSuperview()
            self.stackView = nil
        }
        self.stackView = UIStackView(frame: bounds)
        self.stackView!.alignment = .fill
        self.stackView!.axis = .horizontal
        self.stackView!.distribution = .fillEqually
        self.stackView!.spacing = self.spacing
        self.stackView!.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.stackView!)
        
        self.stackView!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        self.stackView!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        self.stackView!.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        self.stackView!.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
    private func setupTextField() {
        self.textField = UITextField(frame: bounds)
        self.textField.delegate = self
        self.textField.keyboardType = UIKeyboardType(rawValue: self.keyboardType) ?? .numberPad
        self.textField.addTarget(self, action: #selector(textfieldChanged(_:)), for: .editingChanged)
        
        self.addSubview(self.textField)
        
        self.textField.isHidden = true
    }
    
    private func createButtons() {
        for i in 0..<self.length {
            let button = UIButton()
            button.backgroundColor = self.entryBackgroundColor
            button.setTitleColor(self.entryTextColor, for: .normal)
            button.titleLabel?.font = self.entryFont
            
            button.layer.cornerRadius = self.entryCornerRadius
            button.layer.borderColor = self.entryDefaultBorderColor.cgColor
            button.layer.borderWidth = self.entryBorderWidth
            
            button.tag = i + 1
            
            button.addTarget(self, action: #selector(didPressCodeButton(_:)), for: .touchUpInside)
            
            self.entryButtons.append(button)
            self.stackView?.addArrangedSubview(button)
        }
    }
    
    private func updateButtonStyles() {
        for button in self.entryButtons {
            button.backgroundColor = self.entryBackgroundColor
            button.setTitleColor(self.entryTextColor, for: .normal)
            button.titleLabel?.font = self.entryFont
            
            button.layer.cornerRadius = self.entryCornerRadius
            button.layer.borderColor = self.entryDefaultBorderColor.cgColor
            button.layer.borderWidth = self.entryBorderWidth
        }
    }
    
    @objc private func didPressCodeButton(_ sender: UIButton) {
        self.errorMode = false
        
        let entryIndex = self.textField.text!.count + 1
        for button in self.entryButtons {
            button.layer.borderColor = self.entryBorderColor.cgColor
            
            if button.tag == entryIndex {
                button.layer.borderColor = self.entryBorderColor.cgColor
                button.backgroundColor = self.entryEditingBackgroundColor
            } else {
                button.layer.borderColor = self.entryDefaultBorderColor.cgColor
                button.backgroundColor = self.entryBackgroundColor
            }
        }
        
        self.textField.becomeFirstResponder()
    }
    
    func setError(isError: Bool) {
        if isError {
            self.errorMode = true
            for button in self.entryButtons {
                button.layer.borderColor = self.entryErrorBorderColor.cgColor
                button.layer.borderWidth = self.entryBorderWidth
            }
        } else {
            self.errorMode = false
            for button in self.entryButtons {
                button.layer.borderColor = self.entryDefaultBorderColor.cgColor
                button.backgroundColor = self.entryBackgroundColor
            }
        }
    }
    
    func clearEntry() {
        self.setError(isError: false)
        self.textField.text = ""
        for button in self.entryButtons {
            button.setTitle("", for: .normal)
        }
        
        if let firstButton = self.entryButtons.first {
            self.didPressCodeButton(firstButton)
        }
    }
    
    func getPinAsInt() -> Int? {
        if let intOutput = Int(self.textField.text!) {
            return intOutput
        }
        
        return nil
    }
    
    func getPinAsString() -> String {
        return self.textField.text!
    }
    
    func addCustomSpacing(spacing: CGFloat, at indices: [Int]? = nil) {
        if let ind = indices {
            for i in 0 ..< ind.count {
                if let view = self.stackView?.arrangedSubviews[ind[i]] {
                    self.stackView?.setCustomSpacing(spacing, after: view)
                }
            }
        } else {
            if let subViews = self.stackView?.arrangedSubviews {
                for index in 0..<subViews.count - 1 {
                    self.stackView?.setCustomSpacing(spacing, after: subViews[index])
                }
            }
        }
    }
    
    @discardableResult override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        
        if let firstButton = self.entryButtons.first {
            self.didPressCodeButton(firstButton)
        }
        
        return true
    }
    
    @discardableResult override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        
        self.setError(isError: false)
        
        return self.textField.resignFirstResponder()
    }
    
    @discardableResult func validatedText(validationType: ValidatorType) throws -> String {
        let validator = ValidatorFactory.validatorFor(type: validationType)
        return try validator.validated(self.getPinAsString())
    }
}

@available(iOS 11.0, *)
extension PinEntryView: UITextFieldDelegate {
    @objc func textfieldChanged(_ textField: UITextField) {
        let complete: Bool = textField.text!.count == self.length
        self.delegate?.entryChanged(complete)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.errorMode = false
        for button in self.entryButtons {
            button.layer.borderColor = self.entryBorderColor.cgColor
            button.backgroundColor = self.entryBackgroundColor
        }
        
        let deleting = (range.location == textField.text!.count - 1 && range.length == 1 && string == "")
        if string.isEmpty && !self.allowEmptyValues {
            var allowed = true
            switch allowedEntryTypes {
            case .numerical: allowed = Scanner(string: string).scanInt(nil)
            case .letters: allowed = Scanner(string: string).scanCharacters(from: CharacterSet.letters, into: nil)
            case .alphanumeric: allowed = Scanner(string: string).scanCharacters(from: CharacterSet.alphanumerics, into: nil)
            case .any: break
            }
            if !allowed {
                return false
            }
        }
        let oldLength = textField.text!.count
        let replacementLength = string.count
        let rangeLength = range.length
        let newLength = oldLength - rangeLength + replacementLength
        if !deleting {
            for button in self.entryButtons {
                if button.tag == newLength {
                    button.layer.borderColor = self.entryDefaultBorderColor.cgColor
                    UIView.setAnimationsEnabled(false)
                    if !self.isSecure {
                        button.setTitle(string, for: .normal)
                    } else {
                        button.setTitle(self.secureCharacter, for: .normal)
                    }
                    UIView.setAnimationsEnabled(true)
                } else if button.tag == newLength + 1 {
                    button.layer.borderColor = self.entryBorderColor.cgColor
                    button.backgroundColor = self.entryEditingBackgroundColor
                } else {
                    button.layer.borderColor = self.entryDefaultBorderColor.cgColor
                    button.backgroundColor = self.entryBackgroundColor
                }
            }
        } else {
            for button in self.entryButtons {
                if button.tag == oldLength {
                    button.layer.borderColor = self.entryBorderColor.cgColor
                    button.backgroundColor = self.entryEditingBackgroundColor
                    UIView.setAnimationsEnabled(false)
                    button.setTitle("", for: .normal)
                    UIView.setAnimationsEnabled(true)
                } else {
                    button.layer.borderColor = self.entryDefaultBorderColor.cgColor
                    button.backgroundColor = self.entryBackgroundColor
                }
            }
        }
        return newLength <= self.length
    }
}

protocol PinEntryViewDelegate: NSObjectProtocol {
    func entryChanged(_ completed: Bool)
}
