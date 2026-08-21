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
    let userInfo : [user] = UserData.userInformation
    
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
    }
    let textFiledStack = MyPageTextField(canEdit: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userID.text = userInfo[0].Id
        setupView()
    }
    private func setupView() {
        view.addSubview(navBar)
        view.addSubview(profileImg)
        view.addSubview(userID)
        view.addSubview(logoutButton)
        view.addSubview(textFiledStack)
        
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
    }
}

