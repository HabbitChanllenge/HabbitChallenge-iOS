//
//  MyPageViewContoller.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/2/26.
//

import UIKit
import SnapKit
import Then
import Moya

class MyPageViewContoller: UIViewController {
    let userInfo = UserData.shared
    let editVC = MyPageEditViewController()
    
    let navBar = NavigationBarView(streak: "31")
    let profileImg = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "profileImg")
    }
    let userID = UILabel().then {
        $0.font = .systemFont(ofSize: 30, weight: .regular)
        $0.textColor = .black
    }
    let logoutButton = UIButton(type: .system).then {
        $0.setTitle("로그아웃 하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = UIColor(named: "main200")
        $0.layer.cornerRadius = 16
        $0.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    let textFiledStack : MyPageTextField = MyPageTextField(canEdit: false)
    let editButton = UIButton(type: .system).then {
        $0.setTitle("내 정보 수정하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(named: "main400")
        $0.layer.cornerRadius = 10
        $0.titleLabel?.font = .systemFont(ofSize: 25, weight: .semibold)
        $0.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    let editSucsessMessage = UILabel().then {
        $0.text = "수정이 완료되었습니다!"
        $0.textColor = UIColor(named: "main800")
        $0.font = .systemFont(ofSize: 20, weight: .regular)
        $0.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        if let user = userInfo.userInformation.first {
            userID.text = user.Id
        }
        textFiledStack.updateInfo()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userIDText = userInfo.userInformation.first?.Id { userID.text = userIDText; }
        setupView()
    }
    
    private func setupView() {
        view.addSubview(navBar)
        view.addSubview(profileImg)
        view.addSubview(userID)
        view.addSubview(logoutButton)
        view.addSubview(textFiledStack)
        view.addSubview(editSucsessMessage)
        view.addSubview(editButton)
        
        navBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(101)
        }
        profileImg.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(27)
            $0.height.width.equalTo(173)
            $0.leading.equalToSuperview().inset(10)
        }
        userID.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(62)
            $0.leading.equalTo(profileImg.snp.trailing).offset(32)
        }
        logoutButton.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.width.equalTo(111)
            $0.top.equalTo(userID.snp.bottom).offset(17)
            $0.leading.equalTo(profileImg.snp.trailing).offset(28)
        }
        textFiledStack.snp.makeConstraints {
            $0.top.equalTo(profileImg.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        editSucsessMessage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(textFiledStack.snp.bottom).offset(3)
        }
        editButton.snp.makeConstraints {
            $0.top.equalTo(textFiledStack.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(63)
        }
    }
    @objc private func editButtonTapped() {
        navigationController?.pushViewController(MyPageEditViewController(), animated: false)
    }
    @objc private func logoutButtonTapped() {
        UIWindow.changeRootViewController(to: LogInViewController(), animated: false)
    }
    private func updateUserInfo() {
        if let user = userInfo.userInformation.first {
            userID.text = user.Id
            
        }
    }
}
