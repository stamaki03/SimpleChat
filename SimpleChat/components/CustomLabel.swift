//
//  CustomLabel.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/18.
//

import UIKit

final class CustomLabel: UILabel {
    private let padding: UIEdgeInsets
    
    init(frame: CGRect, fontSize: CGFloat, text: String, paddingSize: CGFloat) {
        padding = UIEdgeInsets(top: paddingSize, left: paddingSize, bottom: paddingSize, right: paddingSize)
        super.init(frame: frame)
        self.adjustsFontSizeToFitWidth = true
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.numberOfLines = 0
        self.text = text
        self.textColor = .black
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
