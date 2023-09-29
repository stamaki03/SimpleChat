//
//  IconImageView.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

final class IconImageView: UIImageView {
    init(frame: CGRect, cornerRadius: CGFloat) {
        super.init(frame: frame)
        self.image = UIImage(systemName: "person.circle")
        self.clipsToBounds = true
        self.contentMode = .scaleToFill
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
