//
//  HomeViewController.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 7/31/26.
//

import UIKit
import SnapKit
import Then
import Moya

class HomeViewController: UIViewController {
    let topHabitCard : HabitCardView = HabitCardView(titleText: "물마시기", days: 54, times: 3, didTimes: 2, category: "#일상", cycle: "매일")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(topHabitCard)
        topHabitCard.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

