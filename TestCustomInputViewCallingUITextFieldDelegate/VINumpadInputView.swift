//
//  VINumpadInputView.swift
//  sayboltbase
//
//  Created by Bart van Kuik on 09/03/2018.
//  Copyright © 2018 Saybolt. All rights reserved.
//

import UIKit


class VINumpadInputView: VIBaseInputView {
    private let decimalSeparator: String

    // MARK: - Public functions
    
    override public func addButtons(row buttonRow: [VIBaseInputViewButton]) {
        super.addButtons(row: buttonRow)
        for button in buttonRow {
            switch button.keyType {
            case .next:
                button.addTarget(self, action: #selector(nextButtonTappedInFormField(_:)), for: .touchUpInside)
            default:
                break
            }
            
        }
    }
    
    // MARK: - Actions
    
    @objc func nextButtonTappedInFormField(_ control: UIButton) {
    }
    
    @objc func lessOrGreaterThanButtonTapped(_ control: UIButton) {
        guard let text = self.activeTextField?.text, let firstCharacter = text.first, let buttonText = control.titleLabel?.text?.first else {
            return
        }
        
        let newText: String
        if firstCharacter == buttonText {
            // Remove if already present
            newText = text.dropFirst().trimmingCharacters(in: CharacterSet.whitespaces)
        } else if firstCharacter == "<" || firstCharacter == ">" {
            newText = String(buttonText) + " " + text.dropFirst().trimmingCharacters(in: CharacterSet.whitespaces)
        } else {
            newText = String(buttonText) + " " + text
        }
        
        self.activeTextField?.text = newText
    }
    
    @objc func plusMinusButtonTapped(_ control: UIButton) {
        guard let text = self.activeTextField?.text else {
            return
        }
        
        // Text contains minus, remove it and be done
        if text.contains("-") {
            let components = text.split(separator: "-", maxSplits: 1, omittingEmptySubsequences: false)
            self.activeTextField?.text =  components.joined()
            return
        }
        
        // Text doesn't contain minus, insert at correct place
        if let firstCharacter = text.first, firstCharacter == "<" || firstCharacter == ">" {
            self.activeTextField?.text = String(firstCharacter) + " -" + text.dropFirst().trimmingCharacters(in: CharacterSet.whitespaces)
        } else {
            self.activeTextField?.text = "-" + text
        }
    }
    
    @objc func separatorButtonTapped(_ control: UIButton) {
        guard let textField = self.activeTextField, let text = textField.text else {
            return
        }
        
        if text.count == 0 {
            textField.text = "0" + self.decimalSeparator
        } else {
            textField.text = text + self.decimalSeparator
        }
    }

    @objc func abcButtonTapped(_ control: UIButton) {
        self.activeTextField?.inputView = nil
        self.activeTextField?.resignFirstResponder()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.activeTextField?.becomeFirstResponder()
            self.activeTextField?.inputView = self
        }
    }

    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        let locale = Locale(identifier: "en_US_POSIX")
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = locale
        self.decimalSeparator = numberFormatter.decimalSeparator

        super.init(frame: frame)
        
        let greaterThanButton = VIBaseInputViewButton(.custom(caption: ">"))
        greaterThanButton.addTarget(self, action: #selector(lessOrGreaterThanButtonTapped(_:)), for: .touchUpInside)
        let lessThanButton = VIBaseInputViewButton(.custom(caption: "<"))
        lessThanButton.addTarget(self, action: #selector(lessOrGreaterThanButtonTapped(_:)), for: .touchUpInside)
        let plusMinusButton = VIBaseInputViewButton(.custom(caption: "+/-"))
        plusMinusButton.addTarget(self, action: #selector(plusMinusButtonTapped(_:)), for: .touchUpInside)
        let separatorButton = VIBaseInputViewButton(.custom(caption: self.decimalSeparator))
        separatorButton.addTarget(self, action: #selector(separatorButtonTapped(_:)), for: .touchUpInside)
        let abcButton = VIBaseInputViewButton(.custom(caption: "ABC"))
        abcButton.addTarget(self, action: #selector(abcButtonTapped(_:)), for: .touchUpInside)

        self.addButtons(row: [
            VIBaseInputViewButton(.normal(caption: "7")),
            VIBaseInputViewButton(.normal(caption: "8")),
            VIBaseInputViewButton(.normal(caption: "9")),
            VIBaseInputViewButton(.delete)
        ])
        self.addButtons(row: [
            VIBaseInputViewButton(.normal(caption: "4")),
            VIBaseInputViewButton(.normal(caption: "5")),
            VIBaseInputViewButton(.normal(caption: "6")),
            lessThanButton
        ])
        self.addButtons(row: [
            VIBaseInputViewButton(.normal(caption: "1")),
            VIBaseInputViewButton(.normal(caption: "2")),
            VIBaseInputViewButton(.normal(caption: "3")),
            greaterThanButton
        ])
        self.addButtons(row: [
            VIBaseInputViewButton(.normal(caption: "0")),
            separatorButton,
            plusMinusButton,
            VIBaseInputViewButton(.normal(caption: "%"))
        ])
        self.addButtons(row: [
            abcButton,
            VIBaseInputViewButton(.none),
            VIBaseInputViewButton(.next),
            VIBaseInputViewButton(.dismiss)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
