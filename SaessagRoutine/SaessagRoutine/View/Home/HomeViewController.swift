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
    let topHabitCard : HabitCardView = HabitCardView(titleText: "물마시기", days: 54, times: 10, didTimes: 4, category: "#일상", cycle: "매일")
    let navBar = NavigationBarView(streak: "31")

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        topHabitCard.onPatchButtonTapped = { [weak self] in
            guard let self = self,
            let tabBarController = self.tabBarController else { return }
            tabBarController.swichTo(tab: .habit)// 탭을 어디로 이동할지

            DispatchQueue.main.async {
                if let nav = tabBarController.selectedViewController as? UINavigationController {
                    nav.pushViewController(HabitEditViewController(),animated: true)
                }
            }//탭이동 이후 화면 이동으로 순서 보장 위함
        }//수정 버튼 눌렸을 때 uiView에선 화면 전환이 불가하기 때문에 작성해주는 친구
    }
    private func setLayout() {
        view.addSubview(navBar)
        view.addSubview(topHabitCard)
        navBar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(108)
        }
        topHabitCard.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
