//
//  TitleLabel.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/18.
//

import UIKit

final class TitleLabel: UILabel {
    init(frame: CGRect, text: String) {
        super.init(frame: frame)
        self.adjustsFontSizeToFitWidth = true
        self.font = UIFont.systemFont(ofSize: 40.0)
        self.textAlignment = NSTextAlignment.center
        self.text = text
        self.textColor = .black
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
