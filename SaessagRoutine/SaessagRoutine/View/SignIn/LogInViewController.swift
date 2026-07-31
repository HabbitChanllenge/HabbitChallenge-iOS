//
//  LogInViewController.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 7/31/26.
//

import UIKit
import SnapKit
import Then
import Moya

class LogInViewController: UIViewController {
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 19
    }
    let titleText = UILabel().then {
        $0.text = "로그인"
        $0.font = .systemFont(ofSize: 37, weight: .semibold)
        $0.textColor = .black
    }
    let emailTextField : UIView = LabeledTextFieldView(title: "이메일 주소", placeholder: "이메일을 입력해 주세요.")
    let passwordTextField : UIView = LabeledTextFieldView(title: "비밀번호", placeholder: "비밀번호를 입력해 주세요.")
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(titleText)
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        
        titleText.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(181)
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleText.snp.bottom).offset(110)
            $0.centerX.width.equalToSuperview().inset(24)
        }
    }
}
