//
//  BadgeImageView.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

final class BadgeImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = UIImage(systemName: "n.circle")
        // self.image = UIImage()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
