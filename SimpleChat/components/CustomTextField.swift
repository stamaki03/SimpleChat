//
//  CustomTextField.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/18.
//

import UIKit

final class CustomTextField: UITextField {
    let padding: CGFloat
    
    init(frame: CGRect, placeholder: String, paddingSize: CGFloat) {
        self.padding = paddingSize
        super.init(frame: frame)
        self.backgroundColor = .white
        self.font = UIFont.systemFont(ofSize: 20.0)
        self.layer.borderColor = CGColor.init(gray: 0.5, alpha: 1.0)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.placeholder = placeholder
        self.textColor = .black
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
