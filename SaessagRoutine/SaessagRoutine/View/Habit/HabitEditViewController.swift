//
//  HabitEditViewController.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/4/26.
//

import UIKit
import SnapKit
import Then
import Moya

class HabitEditViewController: UIViewController {
    let titleText = UILabel().then {
        $0.text = "습관 수정"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleText)
        titleText.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

