//
//  CustomChatLabel.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/21.
//

import UIKit

final class CustomChatLabel: UILabel {
    
    let padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    init(frame: CGRect, fontSize: CGFloat, text: String) {
        super.init(frame: frame)
        self.adjustsFontSizeToFitWidth = true
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.text = text
        self.textColor = .black
        self.numberOfLines = 0
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func drawText(in rect: CGRect) {
        let newRect = rect.inset(by: padding)
        super.drawText(in: newRect)
    }

    override var intrinsicContentSize: CGSize {
        var intrinsicContentSize = super.intrinsicContentSize
        intrinsicContentSize.height += padding.top + padding.bottom
        intrinsicContentSize.width += padding.left + padding.right
        return intrinsicContentSize
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
