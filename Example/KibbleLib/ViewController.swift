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
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        setupViews()
        testView.AddSingleTapRecoWith(action: self.shakeView)
        testView2.AddDoubleTapRecoWith(action: self.shakeView)
        testView3.AddLongPressRecoWith { [weak self] longPress -> Void in
            if let sSelf = self {
                sSelf.testView3.Shake()
            }
        }
        testActionView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        testView.backgroundColor = .red
        testView2.backgroundColor = .yellow
        testView3.backgroundColor = .green
    }

    private func setupViews() {
        view.AddSubviews(testView, testView2, testView3, testActionView)
        setupTestView(view: testView, with: nil)
        setupTestView(view: testView2, with: testView)
        setupTestView(view: testView3, with: testView2)
        setupConstraintsFor(view: testActionView, with: testView3)
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
}

extension ViewController: FormActionViewDelegate {
    func actionTapped(view: UIView) {
        testActionView.Shake()
    }
}
