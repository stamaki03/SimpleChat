//
//  CustomLabel.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/18.
//

import UIKit

final class CustomLabel: UILabel {
    
    init(frame: CGRect, fontSize: CGFloat, text: String) {
        super.init(frame: frame)
        self.adjustsFontSizeToFitWidth = true
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.text = text
        self.textColor = .black
        self.numberOfLines = 0
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
