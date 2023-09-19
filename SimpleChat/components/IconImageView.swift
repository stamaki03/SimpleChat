//
//  IconImageView.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

final class IconImageView: UIImageView {
    
    let userImage: UIImage? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = userImage ?? UIImage(systemName: "camera")
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 75
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
