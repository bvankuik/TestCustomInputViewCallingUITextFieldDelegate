//
//  VIBaseInputView.swift
//  sayboltbase
//
//  Created by Bart van Kuik on 01/03/2018.
//  Copyright © 2018 DutchVirtual. All rights reserved.
//

import UIKit


open class VIBaseInputView: UIView {
    override open class var requiresConstraintBasedLayout: Bool { return true }
    
    private let viewBackground = UIColor(red: 86/255.0, green: 88/255.0, blue: 86/255.0, alpha: 1.0)
    private var allButtons: [VIBaseInputViewButton] = []
    private let mainStackView = UIStackView()
    private var constraintsInstalled = false
    private var deleteButtonRepeatTimer: Timer?
    
    open var nextButtonBlock: (() -> Void)?
    open weak var activeTextField: UITextField?
    
    // MARK: - Public functions
    
    public func addButtons(row buttonRow: [VIBaseInputViewButton]) {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        for button in buttonRow {
            button.setContentHuggingPriority(UILayoutPriority(500), for: .horizontal)
            
            switch button.keyType {
            case .delete:
                button.addTarget(self, action: #selector(deleteButtonTouchDownAction(_:)), for: .touchDown)
                button.addTarget(self, action: #selector(deleteButtonTouchUpAction(_:)), for: .touchUpInside)
            case .next:
                button.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
            case .dismiss:
                button.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
            case .normal(_):
                button.addTarget(self, action: #selector(normalButtonTapped), for: .touchUpInside)
            default:
                break
            }
            stackView.addArrangedSubview(button)
        }
        
        self.mainStackView.addArrangedSubview(stackView)
    }
    
    // MARK: - Layout
    
    override open func updateConstraints() {
        if !self.constraintsInstalled {
            self.constraintsInstalled = true
            self.setupConstraints()
        }
        super.updateConstraints()
    }
    
    // MARK: - Private functions
    
    private func setupConstraints() {
        if #available(iOS 11, *) {
            let guide = self.safeAreaLayoutGuide
            
            let minWidthConstraint = self.mainStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 500)
            minWidthConstraint.priority = UILayoutPriority(550)
            let leadingConstraint = self.mainStackView.leadingAnchor.constraintGreaterThanOrEqualToSystemSpacingAfter(guide.leadingAnchor, multiplier: 1)
            leadingConstraint.priority = UILayoutPriority(600)
            let trailingConstraint = guide.trailingAnchor.constraintGreaterThanOrEqualToSystemSpacingAfter(self.mainStackView.trailingAnchor, multiplier: 1)
            trailingConstraint.priority = UILayoutPriority(600)
            
            let constraints = [
                leadingConstraint,
                trailingConstraint,
                minWidthConstraint,
                self.mainStackView.topAnchor.constraintEqualToSystemSpacingBelow(guide.topAnchor, multiplier: 1),
                guide.bottomAnchor.constraintEqualToSystemSpacingBelow(self.mainStackView.bottomAnchor, multiplier: 1),
                self.mainStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ]
            self.addConstraints(constraints)
        } else {
            let guide = self.layoutMarginsGuide
            
            let minWidthConstraint = self.mainStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 500)
            minWidthConstraint.priority = UILayoutPriority(550)
            let leadingConstraint = self.mainStackView.leadingAnchor.constraint(greaterThanOrEqualTo: guide.leadingAnchor)
            leadingConstraint.priority = UILayoutPriority(600)
            let trailingConstraint = self.mainStackView.trailingAnchor.constraint(lessThanOrEqualTo: guide.trailingAnchor)
            trailingConstraint.priority = UILayoutPriority(600)
            
            let constraints = [
                leadingConstraint,
                trailingConstraint,
                minWidthConstraint,
                self.mainStackView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 8),
                self.mainStackView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -8),
                self.mainStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ]
            self.addConstraints(constraints)
        }
    }
    
    private func deleteInActiveTextfield() {
        guard let textField = self.activeTextField,
            let range = textField.selectedTextRange else {
                return
        }
        
        if range.isEmpty {
            guard let start = textField.position(from: range.start, offset: -1),
                let end = textField.position(from: range.end, offset: 0) else {
                    return
            }
            
            if let removeRange = textField.textRange(from: start, to: end) {
                textField.replace(removeRange, withText: "")
            }
        } else {
            textField.replace(range, withText: "")
        }
    }
    
    // MARK: - Actions
    
    @objc func dismissButtonTapped(_ control: UIButton) {
        self.activeTextField?.resignFirstResponder()
    }
    
    @objc func normalButtonTapped(_ control: UIButton) {
        guard let textField = self.activeTextField, let oldText = textField.text else {
            dlog("No active textfield")
            return
        }
        
        guard let newText = control.titleLabel?.text else {
            dlog("No new text to append")
            return
        }
        
        textField.text = oldText + newText
    }
    
    @objc func nextButtonTapped(_ control: UIButton) {
        if let block = self.nextButtonBlock {
            block()
        }
    }
    
    @objc func deleteButtonTouchDownAction(_ control: UIButton) {
        self.deleteInActiveTextfield()
        let timer = Timer(fire: Date().addingTimeInterval(0.5), interval: 0.15, repeats: true) { _ in
            self.deleteInActiveTextfield()
        }
        RunLoop.current.add(timer, forMode: .commonModes)
        self.deleteButtonRepeatTimer = timer
    }
    
    @objc func deleteButtonTouchUpAction(_ control: UIButton) {
        dlog()
        self.deleteButtonRepeatTimer?.invalidate()
    }
    
    // MARK: - Life cycle
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = self.viewBackground
        self.mainStackView.translatesAutoresizingMaskIntoConstraints = false
        self.mainStackView.axis = .vertical
        self.mainStackView.distribution = .fillEqually
        self.mainStackView.spacing = 5
        self.addSubview(self.mainStackView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
}

