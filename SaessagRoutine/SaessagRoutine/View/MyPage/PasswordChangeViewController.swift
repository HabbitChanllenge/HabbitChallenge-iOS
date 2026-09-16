//
//  PasswordChangeViewController.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 9/16/26.
//

import UIKit
import SnapKit
import Then
import Moya

class PasswordChangeViewController: UIViewController {
    let navBar = NavigationBarView(streak: "44")
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
        $0.alignment = .center
    }
    
    let titleLabel = UILabel().then {
        $0.text = "비밀번호 변경"
        $0.font = .systemFont(ofSize: 30, weight: .semibold)
    }
    
    let beforePasswordTextField = LabeledTextFieldView(title: "비밀번호", placeholder: "비밀번호를 입력해 주세요", isPassword: true)
    let newPasswordTextField = LabeledTextFieldView(title: "새 비밀번호", placeholder: "비밀번호를 입력해 주세요", isPassword: true)
    let newPasswordCheckTextField = LabeledTextFieldView(title: "새 비밀번호 확인", placeholder: "비밀번호를 입력해 주세요", isPassword: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
    }
    private func setup() {
        view.addSubview(navBar)
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(beforePasswordTextField)
        stackView.addArrangedSubview(newPasswordTextField)
        stackView.addArrangedSubview(newPasswordCheckTextField)
        
        navBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(101)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(116)
            $0.centerX.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(59)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
