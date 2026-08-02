//
//  ViewController.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 7/30/26.
//

import UIKit
import SnapKit
import Then
import Moya

class SignUpViewController: UIViewController {
    let titleLabel = UILabel().then {
        $0.text = "계정 만들기"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 30, weight: .semibold)
    }
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 19
    }
    let idTextField = LabeledTextFieldView(title: "아이디", placeholder: "앱에서 불릴 이름", isPassword: false)
    let emailTextField = LabeledTextFieldView(title: "이메일", placeholder: "이메일을 입력해 주세요", isPassword: false)
    let passwordTextField = LabeledTextFieldView(title: "비밀번호", placeholder: "비밀번호를 입력해 주세요", isPassword: true)
    let passwordCheckTextField = LabeledTextFieldView(title: "비밀번호 확인", placeholder: "비밀번호를 확인해주세요", isPassword: true)
    let errorMessagePassword = UILabel().then {
        $0.text = "비밀번호가 일치하지 않습니다."
        $0.textColor = UIColor(named: "error")
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.isHidden = true
    }
    let errorMessageNoInput = UILabel().then {
        $0.text = "모두 입력되지 않았습니다"
        $0.textColor = UIColor(named: "error")
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(idTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(passwordCheckTextField)
        stackView.addArrangedSubview(errorMessagePassword)
        //스택뷰에 추가
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(98)
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(79)
            $0.centerX.width.equalToSuperview().inset(24)
        }
    }
}

