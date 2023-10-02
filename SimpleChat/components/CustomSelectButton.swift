//
//  CustomSelectButton.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/18.
//

import UIKit

final class CustomSelectButton: UIButton {
    init(frame: CGRect, title: String, backgroundcolor: UIColor, borderColor: CGColor, borderWidth: CGFloat, foregroundcolor: UIColor) {
        super.init(frame: frame)
        self.backgroundColor = backgroundcolor
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = 10.0
        self.setTitle(title, for: .normal)
        self.setTitleColor(foregroundcolor, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buttonValidate() {
        self.isEnabled = true
        self.backgroundColor = UIColor(named: "bg")
    }
    
    func buttonInvalidate() {
        self.isEnabled = false
        self.backgroundColor = .lightGray
    }
}
