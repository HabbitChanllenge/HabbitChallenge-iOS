//
//  MyPageTextField.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/21/26.
//

import UIKit
import SnapKit
import Then
final class MyPageTextField: UIView {
    let userInfo = UserData.shared.userInformation
    
    let stack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 19
    }
    
    let email : LabeledTextFieldView = LabeledTextFieldView(title: "이메일", placeholder: "이메일을 입력해 주세요", isPassword: false)
    let password : LabeledTextFieldView = LabeledTextFieldView(title: "비밀번호", placeholder: "비밀번호를 입력해 주세요", isPassword: true)
    let id : LabeledTextFieldView = LabeledTextFieldView(title: "아이디", placeholder: "아이디를 입력해 주세요", isPassword: false)
    
    init(canEdit: Bool) {
        super.init(frame: .zero)
        if !canEdit {
            email.textField.isEnabled = false
            password.textField.isEnabled = false
            id.textField.isEnabled = false
        }
        setupLayout()
        updateInfo()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.addSubview(stack)
        
        stack.addArrangedSubview(email)
        stack.addArrangedSubview(password)
        stack.addArrangedSubview(id)
        
        stack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    func updateInfo() {
        let userInfo : user = UserData.shared.userInformation
        
        email.textField.text = userInfo.email
        password.textField.text = userInfo.password
        id.textField.text = userInfo.Id
    }
}
