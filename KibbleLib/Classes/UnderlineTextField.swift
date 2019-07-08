import UIKit
/**
 Custom view containing a textfield that has a colored underline, error state and optional title.
 - Author: Ali H. Shah
 - Date: 03/12/2019
 */
@available(iOS 11.0, *)
class UnderlineTextField: UITextField {
    private var viewUnderline: UIView = UIView()
    private var savedHighlightState: Bool = false
    private var hasTitle: Bool = false
    
    override var textColor: UIColor? {
        get {
            return self.baseTextColor
        }
        set {
            self.updateFieldViews()
        }
    }
    
    override var isHighlighted: Bool {
        get {
            return self.savedHighlightState
        }
        set {
            self.savedHighlightState = newValue
            self.updateUnderline()
        }
    }
    
    override var isSecureTextEntry: Bool {
        get {
            return super.isSecureTextEntry
        }
        set {
            super.isSecureTextEntry = newValue
            self.FixCaretPosition()
        }
    }
    
    var underlineColor: UIColor = UIColor(red: 119/255, green: 159/255, blue: 219/255, alpha: 1.0) {
        didSet {
            self.updateUnderline()
        }
    }
    
    override var text: String? {
        didSet {
            self.updateFieldViews()
        }
    }
    
    override var placeholder: String? {
        didSet {
            self.setNeedsDisplay()
            self.updatePlaceholder()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.updateFieldViews()
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            self.updateFieldViews()
            self.updatePlaceholder()
        }
    }
    
    var errorUnderlineColor: UIColor = UIColor(red: 255/255, green: 113/255, blue: 113/255, alpha: 1.0)
    var errorTextColor: UIColor = UIColor(red: 255/255, green: 113/255, blue: 113/255, alpha: 1.0)
    
    var baseTextColor: UIColor = .white {
        didSet {
            super.textColor = self.baseTextColor
        }
    }
    
    var baseUnderlineColor: UIColor = UIColor(red: 119/255, green: 159/255, blue: 219/255, alpha: 1.0) {
        didSet {
            self.underlineColor = self.baseUnderlineColor
        }
    }
    
    var placeholderColor: UIColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0) {
        didSet {
            self.updatePlaceholder()
        }
    }
    
    var placeholderFont: UIFont = UIFont.systemFont(ofSize: 18) {
        didSet {
            self.updatePlaceholder()
        }
    }
    
    // Note: This will set the line and placeholder to this color.
    var disabledColor: UIColor = UIColor.white.withAlphaComponent(0.88) {
        didSet {
            self.updateFieldViews()
            self.updatePlaceholder()
        }
    }
    
    var selectedUnderlineColor: UIColor = UIColor(red: 119/255, green: 159/255, blue: 219/255, alpha: 1.0) {
        didSet {
            self.updateUnderline()
        }
    }
    
    // Note: Height of bottom line in base state
    var underlineHeight: CGFloat = 0.5 {
        didSet {
            self.updateUnderline()
            self.setNeedsDisplay()
        }
    }
    
    // Note: Height of the bottom line when editing
    var selectedUnderlineHeight: CGFloat = 1.0 {
        didSet {
            self.updateUnderline()
            self.setNeedsDisplay()
        }
    }
    
    var hasError: Bool = false {
        didSet {
            var underlineColor = self.baseUnderlineColor
            var textColor = self.textColor
            if self.hasError {
                underlineColor = self.errorUnderlineColor
                textColor = self.errorTextColor
                self.Shake()
            }
            self.underlineColor = underlineColor
            self.selectedUnderlineColor = underlineColor
            super.textColor = textColor
        }
    }
    
    var editingSelected: Bool {
        return super.isEditing || self.isSelected
    }
    
    var rectInset: UIEdgeInsets? {
        didSet {
            self.updateUnderline()
            self.setNeedsDisplay()
        }
    }
    
    weak var fieldDelegate: UnderlineTextFieldDelegate?
    
    init() {
        super.init(frame: CGRect.zero)
        
        self.delegate = self
        self.borderStyle = .none
        self.viewUnderline.isUserInteractionEnabled = false
        let onePixel: CGFloat = 1.0 / UIScreen.main.scale
        self.underlineHeight = 2.0 * onePixel
        self.selectedUnderlineHeight = 2.0 * self.underlineHeight
        self.viewUnderline.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        self.baseUnderlineColor = UIColor(red: 119/255, green: 159/255, blue: 219/255, alpha: 1.0)
        
        self.addSubview(self.viewUnderline)
        
        self.updateColors()
        self.addTarget(self, action: #selector(UnderlineTextField.editingChanged), for: .editingChanged)
        self.textAlignment = .left
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.viewUnderline.frame = self.underlineRect(bounds, editing: self.editingSelected)
    }
    
    @discardableResult override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        self.updateFieldViews()
        return result
    }
    
    @discardableResult override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        self.updateFieldViews()
        return result
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.textRect(forBounds: bounds)
        let rect = CGRect(x: superRect.origin.x, y: 0, width: superRect.size.width, height: superRect.size.height - self.selectedUnderlineHeight)
        if let inset = self.rectInset {
            return rect.inset(by: inset)
        }
        return rect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.editingRect(forBounds: bounds)
        let rect = CGRect(x: superRect.origin.x, y: 0, width: superRect.size.width, height: superRect.size.height - self.selectedUnderlineHeight)
        if let inset = self.rectInset {
            return rect.inset(by: inset)
        }
        return rect
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height - self.selectedUnderlineHeight)
        return rect
    }
    
    private func underlineRect(_ bounds: CGRect, editing: Bool) -> CGRect {
        let height = editing ? self.selectedUnderlineHeight : self.underlineHeight
        return CGRect(x: 0, y: bounds.size.height - height, width: bounds.size.width, height: height)
    }
    
    private func updatePlaceholder() {
        guard let placeholder = self.placeholder else {
            return
        }
        let color = self.isEnabled ? self.placeholderColor : self.disabledColor
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: self.font ?? .systemFont(ofSize: 18)])
    }
    
    private func updateFieldViews() {
        self.updateColors()
        self.updateUnderline()
    }
    
    private func updateUnderline() {
        self.viewUnderline.frame = self.underlineRect(self.bounds, editing: self.editingSelected)
        self.updateUnderlineColor()
    }
    
    private func updateUnderlineColor() {
        if !self.isEnabled {
            self.viewUnderline.backgroundColor = self.disabledColor
        } else {
            self.viewUnderline.backgroundColor = self.editingSelected ? self.selectedUnderlineColor : self.underlineColor
        }
    }
    
    private func updateTextColor() {
        super.textColor = self.isEnabled ? self.baseTextColor : self.disabledColor
    }
    
    private func updateColors() {
        self.updateUnderlineColor()
        self.updateTextColor()
    }
    
    func setTitle(with text: String, font: UIFont, and textColor: UIColor, paddingRight: CGFloat = 15.0) {
        if !self.hasTitle {
            let textSize = text.size(withAttributes: [.font: font])
            let width = textSize.width + paddingRight
            self.rectInset = UIEdgeInsets(top: 0, left: width, bottom: 0, right: 0)
            let labelTitle: UILabel = UILabel()
            labelTitle.font = font
            labelTitle.textColor = textColor
            labelTitle.text = text
            self.addSubview(labelTitle)
            labelTitle.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                labelTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                labelTitle.heightAnchor.constraint(equalToConstant: textSize.height),
                labelTitle.widthAnchor.constraint(equalToConstant: width),
                labelTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
                ])
            self.hasTitle = true
        }
    }
    
    @objc func editingChanged() {
        self.updateFieldViews()
        self.fieldDelegate?.textFieldChanged(self)
    }
}

@available(iOS 11.0, *)
extension UnderlineTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let delegate = self.fieldDelegate {
            return delegate.textFieldShouldReturn(textField)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let delegate = self.fieldDelegate {
            return delegate.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        }
        return true
    }
}

protocol UnderlineTextFieldDelegate: NSObjectProtocol {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    func textFieldChanged(_ textField: UITextField)
}

extension UnderlineTextFieldDelegate {
    func textFieldChanged(_ textField: UITextField) {}
}
