import UIKit
/**
 View to display a curved edge, titled button that can be enabled/disabled
 - Author: Ali H. Shah
 - Date: 02/07/2019
 - Note:
 - Used in: SignUpViewController
 */
@available(iOS 11.0, *)
class FormActionView: UIView {
    private let SHADOW_RADIUS: CGFloat = 2
    private let viewInner: UIView = UIView()
    private let labelTitle: UILabel = UILabel()
    private let imageView: UIImageView = UIImageView()
    
    var isEnabled: Bool? {
        didSet {
            var color = UIColor(red: 196/255, green: 205/255, blue: 210/255, alpha: 1.0)
            var userInteraction = false
            if self.isEnabled ?? true {
                userInteraction = true
                color = buttonColor
            }
            self.isUserInteractionEnabled = userInteraction
            self.viewInner.backgroundColor = color
            self.viewInner.layer.borderColor = color.cgColor
        }
    }
    
    var buttonColor: UIColor {
        didSet {
            self.viewInner.backgroundColor = self.buttonColor
            self.viewInner.layer.borderColor = self.buttonColor.cgColor
        }
    }
    
    weak var delegate: FormActionViewDelegate?
    
    init(frame: CGRect, image: UIImage? = nil, title: String = "", titleColor: UIColor = .white, titleFont: UIFont = UIFont.systemFont(ofSize: 16.0), buttonColor: UIColor, enabledByDefault: Bool = false) {
        self.buttonColor = buttonColor
        self.isEnabled = enabledByDefault
        super.init(frame: frame)
        
        let initButtonColor = enabledByDefault ? buttonColor : UIColor(red: 196/255, green: 205/255, blue: 210/255, alpha: 1.0)
        self.isUserInteractionEnabled = enabledByDefault
        self.layer.shadowColor = UIColor(red: 30/255, green: 39/255, blue: 43/255, alpha: 1.0).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 0.6
        self.layer.shadowRadius = self.SHADOW_RADIUS
        self.layer.cornerRadius = 5
        self.viewInner.backgroundColor = initButtonColor
        self.viewInner.layer.borderColor = initButtonColor.cgColor
        self.viewInner.layer.cornerRadius = 4
        self.viewInner.layer.borderWidth = 0.5
        self.viewInner.clipsToBounds = true
        
        let longPressReco = UILongPressGestureRecognizer(target: self, action: #selector(self.actionTapped))
        longPressReco.minimumPressDuration = 0.0
        self.addGestureRecognizer(longPressReco)
        
        var actionViewContent: UIView
        if image == nil {
            self.labelTitle.text = title
            self.labelTitle.textColor = titleColor
            self.labelTitle.font = titleFont
            self.labelTitle.textAlignment = .center
            actionViewContent = self.labelTitle
        } else {
            self.imageView.image = image
            self.imageView.contentMode = .scaleAspectFit
            actionViewContent = self.imageView
        }
        self.addSubview(self.viewInner)
        self.viewInner.addSubview(actionViewContent)
        self.viewInner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.viewInner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.viewInner.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.viewInner.heightAnchor.constraint(equalTo: self.heightAnchor),
            self.viewInner.widthAnchor.constraint(equalTo: self.widthAnchor)
            ])
        actionViewContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actionViewContent.centerXAnchor.constraint(equalTo: self.viewInner.centerXAnchor),
            actionViewContent.centerYAnchor.constraint(equalTo: self.viewInner.centerYAnchor)
            ])
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    convenience init(image: UIImage? = nil, title: String = "", titleColor: UIColor = .white, titleFont: UIFont = UIFont.systemFont(ofSize: 16.0), buttonColor: UIColor, enabledByDefault: Bool = false) {
        self.init(frame: CGRect.zero, image: image, title: title, titleColor: titleColor, titleFont: titleFont, buttonColor: buttonColor, enabledByDefault: enabledByDefault)
    }
    
    @objc private func actionTapped(gesture: UILongPressGestureRecognizer) {
        if self.isEnabled ?? true {
            let gestureLocation = gesture.location(in: self)
            switch gesture.state {
            case .began:
                self.animateActionPressBegan()
            case .changed:
                if self.bounds.contains(gestureLocation) {
                    if self.layer.shadowRadius == self.SHADOW_RADIUS {
                        self.animateActionPressBegan()
                    }
                } else {
                    if self.layer.shadowRadius != self.SHADOW_RADIUS {
                        self.animateActionPressEnded()
                    }
                }
            default:
                self.animateActionPressEnded(actionComplete: self.bounds.contains(gestureLocation))
            }
        }
    }
    
    private func animateActionPressBegan() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] () -> Void in
            self?.layer.shadowOffset = CGSize.zero
            self?.layer.shadowRadius = 0
        })
    }
    
    private func animateActionPressEnded(actionComplete: Bool = false) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] () -> Void in
            if let myself = self {
                myself.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                myself.layer.shadowRadius = myself.SHADOW_RADIUS
            }
            }, completion: { [weak self] _ -> Void in
                if let myself = self {
                    if actionComplete {
                        myself.delegate?.actionTapped(view: myself)
                    }
                }
        })
    }
}

protocol FormActionViewDelegate: NSObjectProtocol {
    func actionTapped(view: UIView)
}
