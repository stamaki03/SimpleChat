//
//  ProfileViewController.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/29.
//

import UIKit

final class ProfileViewController: UIViewController {
    let signUpTitleLabel = TitleLabel(frame: .zero, text: "プロフィール")
    let iconImageView = IconImageView(frame: .zero, cornerRadius: 75)
    let idLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "ID：", paddingSize: 0)
    let idText = CustomLabel(frame: .zero, fontSize: 20.0, text: "", paddingSize: 0)
    let nameLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "名前：", paddingSize: 0)
    let nameText = CustomLabel(frame: .zero, fontSize: 20.0, text: "", paddingSize: 0)
    let backButton = SelectButton(frame: .zero, title: "戻る", backgroundcolor: UIColor(named: "bg") ?? .white, borderColor: UIColor.clear.cgColor, borderWidth: 0, foregroundcolor: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setView()
        setButtonAction()
        setBarItem()
        Task{
            try await displayProfile()
        }
    }
    
    private func setView() {
        view.backgroundColor = .white
        view.addSubview(signUpTitleLabel)
        view.addSubview(iconImageView)
        view.addSubview(idLabel)
        view.addSubview(idText)
        view.addSubview(nameLabel)
        view.addSubview(nameText)
        view.addSubview(backButton)
        // 制約設定
        ProfileViewConstraints.makeConstraints(view: view, iconImageView: iconImageView, signUpTitleLabel: signUpTitleLabel, idLabel: idLabel, idText: idText, nameLabel: nameLabel, nameText: nameText, backButton: backButton)
    }
    
    private func displayProfile() async throws {
        guard let currentUser = AuthenticationManager.shared.getcurrentUser() else { return }
        let currentUserInfo = try await UserManager.shared.fetchUser(userId: currentUser.uid)
        self.idText.text = currentUserInfo.email
        self.nameText.text = currentUserInfo.name
        guard let url = currentUserInfo.photoUrl else { return }
        if !url.isEmpty {
            let imageUrl = URL(string: url)!
            let (imageData, urlResponse) = try await URLSession.shared.data(from: imageUrl)
            guard let urlResponse = urlResponse as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            guard 200 ..< 300 ~= urlResponse.statusCode else {
                throw URLError(.badServerResponse)
            }
            self.iconImageView.image = UIImage(data: imageData)!
        }
    }
    
    private func setButtonAction() {
        backButton.addTarget(self, action: #selector(userBack(sender:)), for:.touchUpInside)
    }
    
    private func setBarItem() {
        navigationItem.hidesBackButton = true
    }
    
    @objc internal func userBack(sender: UIButton){
        self.navigationController?.popViewController(animated: false)
    }
    
}
