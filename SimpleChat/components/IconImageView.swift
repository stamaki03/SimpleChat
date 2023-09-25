//
//  IconImageView.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

final class IconImageView: UIImageView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = UIImage(systemName: "camera")
        self.clipsToBounds = true
        self.layer.cornerRadius = 25
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
