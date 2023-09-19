//
//  CustomTextField.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/18.
//

import UIKit
import Combine

final class CustomTextField: UITextField {
    
    init(frame: CGRect, placeholder: String) {
        super.init(frame: frame)
        self.font = UIFont.systemFont(ofSize: 20.0)
        self.layer.borderColor = CGColor.init(gray: 0.5, alpha: 1.0)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.placeholder = placeholder
        self.textColor = .black
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
