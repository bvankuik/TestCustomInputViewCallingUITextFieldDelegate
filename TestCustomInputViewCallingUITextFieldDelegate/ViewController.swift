//
//  ViewController.swift
//  TestCustomInputViewCallingUITextFieldDelegate
//
//  Created by Bart van Kuik on 26/03/2018.
//  Copyright © 2018 DutchVirtual. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let textField = UITextField()

    override func viewDidLoad() {
        self.view.backgroundColor = .lightGray
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.backgroundColor = UIColor.white
        self.textField.placeholder = "Type something"
        self.textField.font = UIFont.preferredFont(forTextStyle: .title2)
        let inputView = VINumpadInputView()
        inputView.activeTextField = self.textField
        self.textField.inputView = inputView
        
        self.view.addSubview(self.textField)
        
        let constraints = [
            self.textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.textField.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 100),
            self.textField.widthAnchor.constraint(greaterThanOrEqualToConstant: 150)
        ]
        self.view.addConstraints(constraints)
        self.textField.becomeFirstResponder()
    }

}
