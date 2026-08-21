//
//  MyPageEditViewController.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/21/26.
//

import UIKit
import SnapKit
import Then
import Moya

class MyPageEditViewController: UIViewController {
    let userInfo : [user] = UserData.userInformation
    
    let navBar = NavigationBarView(streak: "31")
    
    let profileImg = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "profileImg")
    }
    let textFiledStack = MyPageTextField(canEdit: true)
    let editButton = UIButton(type: .system).then {
        $0.setTitle("수정 완료하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(named: "main600")
        $0.layer.cornerRadius = 10
        $0.titleLabel?.font = .systemFont(ofSize: 25, weight: .semibold)
        $0.addTarget(self, action: #selector(editFinishButtonTapped), for: .touchUpInside)
    }
    let notAllFilled = UILabel().then {
        $0.text = "형식에 맞게 입력해 주세요"
        $0.textColor = UIColor(named: "error")
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(navBar)
        view.addSubview(profileImg)
        view.addSubview(textFiledStack)
        view.addSubview(notAllFilled)
        view.addSubview(editButton)
        
        navBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(101)
        }
        profileImg.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(27)
            $0.height.width.equalTo(173)
            $0.centerX.equalToSuperview()
        }
        
        textFiledStack.snp.makeConstraints {
            $0.top.equalTo(profileImg.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        notAllFilled.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(textFiledStack.snp.bottom).offset(3)
        }
        editButton.snp.makeConstraints {
            $0.height.equalTo(63)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(38)
        }
    }
    @objc private func editFinishButtonTapped() {
        let emailT = textFiledStack.email.textField.text
        let passwordT = textFiledStack.password.textField.text
        let idT = textFiledStack.id.textField.text
        
        if emailT == "" || passwordT == "" || idT == "" {//하나라도 비어있을 시
            notAllFilled.isHidden = false
        } else {
            self.navigationController?.popViewController(animated: false)//
        }
    }
}
