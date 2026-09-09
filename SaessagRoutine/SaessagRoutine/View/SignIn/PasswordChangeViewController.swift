//
//  PasswordChangeViewController.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 9/9/26.
//

import SnapKit
import Then
import Moya
import UIKit

final class PasswordChangeViewController: UIViewController {
    let titleText = UILabel().then {
        $0.text = "비밀번호 변경"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 30, weight: .semibold)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
    }
    private func setup() {
        view.addSubview(titleText)
        
        titleText.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(116)
        }
    }
}
