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
    weak var testView: UIView!
    weak var testView2: UIView!
    
    override func loadView() {
        super.loadView()
        let testView = UIView()
        testView.translatesAutoresizingMaskIntoConstraints = false
        let testView2 = UIView()
        testView2.translatesAutoresizingMaskIntoConstraints = false
        view.AddSubviews(testView, testView2)
        NSLayoutConstraint.activate([
            testView.heightAnchor.constraint(equalToConstant: 64),
            testView.widthAnchor.constraint(equalTo: testView.heightAnchor),
            testView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        self.testView = testView
        NSLayoutConstraint.activate([
            testView2.heightAnchor.constraint(equalTo: testView.heightAnchor),
            testView2.widthAnchor.constraint(equalTo: testView.widthAnchor),
            testView2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testView2.bottomAnchor.constraint(equalTo: testView.topAnchor)
            ])
        let tapReco = UITapGestureRecognizer(target: self, action: #selector(self.shakeView (_:)))
        testView2.addGestureRecognizer(tapReco)
        self.testView2 = testView2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        testView.backgroundColor = .yellow
        testView2.backgroundColor = .green
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func shakeView(_ sender: UITapGestureRecognizer) {
        self.testView2.Shake()
    }
}

