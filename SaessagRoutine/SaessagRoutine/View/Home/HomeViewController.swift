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
    let topHabitCard : HabitCardView = HabitCardView(titleText: "물마시기", days: 54, times: 3, category: "#일상", cycle: "매일")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(topHabitCard)
        topHabitCard.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        topHabitCard.onPatchButtonTapped = { [weak self] in//수정 버튼 눌렸을 때 uiView에선 화면 전환이 불가하기 때문에 작성해주는 친구
            guard let self = self,
            let tabBarController = self.tabBarController else { return }
            tabBarController.swichTo(tab: .habit)// 탭을 어디로 이동할지

            DispatchQueue.main.async {
                if let nav = tabBarController.selectedViewController as? UINavigationController {
                    nav.pushViewController(HabitEditViewController(),animated: true)
                }
            }
        }
    }
}
