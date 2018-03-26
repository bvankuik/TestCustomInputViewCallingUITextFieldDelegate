//
//  VIBaseInputViewButton.swift
//  sayboltbase
//
//  Created by Bart van Kuik on 06/03/2018.
//  Copyright © 2018 Saybolt. All rights reserved.
//

import UIKit


public class VIBaseInputViewButton: UIButton {
    public enum KeyType {
        case normal(caption: String)
        case custom(caption: String)
        case delete
        case next
        case dismiss
        case none
    }
    
    private let buttonBackground = UIColor(red: 137/255.0, green: 139/255.0, blue: 137/255.0, alpha: 1.0)
    private let viewBackground = UIColor(red: 86/255.0, green: 88/255.0, blue: 86/255.0, alpha: 1.0)
    private var oldBackgroundColor: UIColor?
    private var animator: UIViewPropertyAnimator?
    public var keyType: KeyType
    
    public var highlightedColor: UIColor?
    override open var backgroundColor: UIColor? {
        didSet {
            if self.oldBackgroundColor == nil {
                self.oldBackgroundColor = self.backgroundColor
            }
        }
    }
    
    override open var isHighlighted: Bool {
        didSet {
            guard let oldBackgroundColor = self.oldBackgroundColor else {
                return
            }
            
            self.animator?.stopAnimation(true)
            if self.isHighlighted {
                self.backgroundColor = highlightedColor ?? .white
            } else {
                self.animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear) {
                    self.backgroundColor = oldBackgroundColor
                }
                self.animator?.startAnimation()
            }
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: super.intrinsicContentSize.width, height: min(super.intrinsicContentSize.height, 33.0))
        }
        set {
        }
    }

    // MARK: - Life cycle
    
    public init(_ keyType: KeyType) {
        self.keyType = keyType
        super.init(frame: CGRect())
        self.highlightedColor = .lightGray
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = self.buttonBackground
        
        switch self.keyType {
        case .normal(let caption):
            self.setTitle(caption, for: UIControlState())
        case .custom(let caption):
            self.setTitle(caption, for: UIControlState())
        case .delete:
            self.setTitle("\u{232b}", for: UIControlState())
        case .next:
            self.setTitle("\u{25b6}", for: UIControlState())
        case .dismiss:
            let bundle = Bundle(for: type(of: self))
            if let searchIcon = UIImage(named: "dismiss_keyboard", in: bundle, compatibleWith: nil) {
                self.setImage(searchIcon.withRenderingMode(.alwaysTemplate), for: .normal)
            }
            self.imageView?.tintColor = UIColor.white
            self.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
          case .none:
            self.backgroundColor = .clear
        }
        self.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.textAlignment = .center
        self.setTitleColor(UIColor.white, for: UIControlState())
        self.layer.cornerRadius = 3.0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
