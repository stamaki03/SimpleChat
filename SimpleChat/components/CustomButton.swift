//
//  CustomButton.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/18.
//

import UIKit

final class CustomButton: UIButton {
    
    init(frame: CGRect, cornerRadius: CGFloat, systemName: String) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.borderColor = CGColor.init(gray: 0.5, alpha: 1.0)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.setImage(UIImage(systemName: systemName), for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
