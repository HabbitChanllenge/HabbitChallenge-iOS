//
//  HabbitMainViewController.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/2/26.
//

import UIKit
import SnapKit
import Then
import Moya

class HabitViewController: UIViewController {
    let topBar = NavigationBarView(streak: "20")
    let titleText = UILabel().then {
        $0.text = "Habit"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleText)
        view.addSubview(topBar)
        titleText.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        topBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(101)
        }
    }
}

