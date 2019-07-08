//
//  ViewController.swift
//  KibbleLib
//
//  Created by Ali H. Shah on 07/02/2019.
//  Copyright (c) 2019 Ali H. Shah. All rights reserved.
//

import KibbleLib
import UIKit

class ViewController: UIViewController {
    private let testView = UIView()
    private let testView2 = UIView()
    private let testView3 = UIView()
    private let testActionView = FormActionView(title: "FormActionView", buttonColor: .cyan, enabledByDefault: true)
    private let testPinEntryView = PinEntryView()
    private let testUnderlineTextField = UnderlineTextField()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .purple
        setupViews()
        testView.AddSingleTapRecoWith(action: self.shakeView)
        testView2.AddDoubleTapRecoWith(action: self.shakeView)
        testView3.AddLongPressRecoWith { [weak self] longPress -> Void in
            if let sSelf = self {
                sSelf.testView3.Shake()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        testView.backgroundColor = .red
        testView2.backgroundColor = .yellow
        testView3.backgroundColor = .green
        testActionView.delegate = self
        testPinEntryView.delegate = self
        testPinEntryView.length = 6
        testUnderlineTextField.fieldDelegate = self
        testUnderlineTextField.setTitle(with: "Email", font: .systemFont(ofSize: 20), and: .white)
        testUnderlineTextField.font = .systemFont(ofSize: 20)
        testUnderlineTextField.autocorrectionType = .no
        testUnderlineTextField.returnKeyType = .done
        testUnderlineTextField.keyboardType = .emailAddress
    }

    private func setupViews() {
        view.AddSubviews(testView, testView2, testView3, testActionView, testPinEntryView, testUnderlineTextField)
        setupTestView(view: testView, with: nil)
        setupTestView(view: testView2, with: testView)
        setupTestView(view: testView3, with: testView2)
        setupConstraintsFor(view: testActionView, with: testView3)
        setupConstraintsFor(view: testPinEntryView, with: testActionView)
        setupConstraintsFor(view: testUnderlineTextField, with: testPinEntryView)
    }
    
    private func setupTestView(view: UIView, with previousView: UIView?) {
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = true;
        setupConstraintsFor(view: view, with: previousView)
    }
    
    private func setupConstraintsFor(view: UIView, with previousView: UIView?) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let topAnchor: NSLayoutAnchor = previousView?.bottomAnchor ?? self.view.safeAreaLayoutGuide.topAnchor
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 55),
            view.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -60),
            view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            view.topAnchor.constraint(equalTo: topAnchor, constant: 20)
            ])
    }
    
    private func shakeView(_ sender: UITapGestureRecognizer) {
        if let view = sender.view {
            view.Shake()
        }
    }
    
    private func shakeLongPressView(_ sender: UILongPressGestureRecognizer) {
        if let view = sender.view {
            view.Shake()
        }
    }
    
    private func setUnderlineFieldError(_ error: String?) {
        testUnderlineTextField.hasError = error != nil
    }
    
    @discardableResult private func validateUnderlineField(withErrors: Bool) -> Bool {
        do {
            try testUnderlineTextField.ValidatedText(validationType: ValidatorType.email)
            setUnderlineFieldError(nil)
            return true
        } catch let error {
            if (withErrors) {
               setUnderlineFieldError((error as? ValidationError)?.message)
            }
            return false
        }
    }
}

extension ViewController: FormActionViewDelegate {
    func actionTapped(view: UIView) {
        testActionView.Shake()
    }
}

extension ViewController: PinEntryViewDelegate {
    func entryChanged(_ completed: Bool) {
        if completed {
            testUnderlineTextField.becomeFirstResponder()
        }
    }
}

extension ViewController: UnderlineTextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let fieldValid = validateUnderlineField(withErrors: true)
        if fieldValid {
            testUnderlineTextField.endEditing(true)
        }
        return fieldValid
    }
    
    func textFieldChanged(_ textField: UITextField) {
        validateUnderlineField(withErrors: false)
    }
}
