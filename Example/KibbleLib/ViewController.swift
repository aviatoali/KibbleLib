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
    private let testView4 = UIView()
    private let testView5 = UIView()
    private let testView6 = UIView()
    
    override func loadView() {
        super.loadView()
        setupViews()
        
        testView2.AddSingleTapGestureRecognizerWithResponder { [weak self] tap -> Void in
            if let sSelf = self {
                sSelf.testView2.Shake()
            }
        }
        testView.AddSingleTapGestureRecognizerWithResponder(responder: self.shakeView1)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        testView.backgroundColor = .red
        testView2.backgroundColor = .yellow
        testView3.backgroundColor = .green
        testView4.backgroundColor = .blue
        testView5.backgroundColor = .purple
        testView6.backgroundColor = .orange
    }

    private func setupViews() {
        view.AddSubviews(testView, testView2, testView3, testView4, testView5, testView6)
        setupConstraintsFor(view: testView, with: nil)
        setupConstraintsFor(view: testView2, with: testView)
        setupConstraintsFor(view: testView3, with: testView2)
        setupConstraintsFor(view: testView4, with: testView3)
        setupConstraintsFor(view: testView5, with: testView4)
        setupConstraintsFor(view: testView6, with: testView5)
    }
    
    private func setupConstraintsFor(view: UIView, with previousView: UIView?) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = true;
        let topAnchor: NSLayoutAnchor = previousView?.bottomAnchor ?? self.view.safeAreaLayoutGuide.topAnchor
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 55),
            view.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -60),
            view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            view.topAnchor.constraint(equalTo: topAnchor, constant: 20)
            ])
    }
    
    private func shakeView1(_ sender: UITapGestureRecognizer) {
        self.testView.Shake()
    }
}
