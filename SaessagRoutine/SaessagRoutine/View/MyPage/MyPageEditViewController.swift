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
    let label = UILabel().then {
        $0.text = "마이페이지 수정"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    private func setUp() {
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
