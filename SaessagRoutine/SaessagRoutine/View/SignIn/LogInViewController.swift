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
    let titleText = UILabel().then {
        $0.text = "로그인"
        $0.font = .systemFont(ofSize: 37, weight: .semibold)
        $0.textColor = .black
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleText)
        titleText.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(181)
        }
    }
}
