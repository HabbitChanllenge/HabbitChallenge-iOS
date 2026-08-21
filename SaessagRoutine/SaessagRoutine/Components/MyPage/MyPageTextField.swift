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
    let userInfo: [user] = UserData.userInformation
    
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
        email.textField.text = userInfo[0].email
        password.textField.text = userInfo[0].password
        id.textField.text = userInfo[0].Id
        
        setUp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        self.addSubview(stack)
        
        stack.addArrangedSubview(email)
        stack.addArrangedSubview(password)
        stack.addArrangedSubview(id)
        
        stack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
