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
    let titleLabel = UILabel().then {
        $0.text = "비밀번호 변경"
        $0.font = .systemFont(ofSize: 30, weight: .semibold)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
    }
    private func setup() {
        view.addSubview(navBar)
        view.addSubview(titleLabel)
        
        navBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(101)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(59)
            $0.centerX.equalToSuperview()
        }
    }
}
