//
//  ViewController.swift
//  TestCustomInputViewCallingUITextFieldDelegate
//
//  Created by Bart van Kuik on 26/03/2018.
//  Copyright © 2018 DutchVirtual. All rights reserved.
//

import UIKit

class NoCursorTextField: UITextField {
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect()
    }
}

class ViewController: UIViewController, UITextFieldDelegate {
    private let textField = NoCursorTextField()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let inverseSet = NSCharacterSet(charactersIn: "0123456789").inverted
        let components = string.components(separatedBy: inverseSet)
        let filtered = components.joined(separator: "")
        return (string == filtered)
    }
    
    @objc func textFieldWasEdited() {
        NSLog("Text is now " + (self.textField.text ?? "nil"))
    }

    override func viewDidLoad() {
        self.view.backgroundColor = .lightGray
        self.textField.delegate = self
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.backgroundColor = UIColor.white
        self.textField.placeholder = "Type something"
        self.textField.font = UIFont.preferredFont(forTextStyle: .title2)
        let inputView = VINumpadInputView()
        inputView.activeTextField = self.textField
        self.textField.inputView = inputView
        self.textField.addTarget(self, action: #selector(textFieldWasEdited), for: .editingChanged)
        
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
