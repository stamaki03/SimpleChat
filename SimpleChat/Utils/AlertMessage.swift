//
//  AlertMessage.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/25.
//

import UIKit

final class AlertMessage {
    
    static let shared = AlertMessage()
    private init() {}
    
    func notificationAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "エラー", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
}
