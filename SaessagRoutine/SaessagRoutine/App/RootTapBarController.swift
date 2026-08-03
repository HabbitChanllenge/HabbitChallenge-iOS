//
//  RootTapBarController.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/2/26.
//

import UIKit
final class RootTabBarController: UITabBarController {
    override func viewDidLoad() {
        setTabBar()
        setTabBarItem()
    }
    private func setTabBar() {//탭 바 전체의 속성을 설정
        let navAppearance = UITabBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = .clear
        navAppearance.shadowColor = .clear
        navAppearance.selectionIndicatorImage = UIImage()
        navAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(named: "gray500")
        navAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(named: "gray500")]
        
        tabBar.tintColor = UIColor(named: "main800")
    }
    private func setTabBarItem() {//탭바에서 각 버튼마다의 속성 설정
        viewControllers = [
            makeNavController(
                rootViewController: HomeViewController(),
                title: "홈",
                img: "house"
            ),
            makeNavController(
                rootViewController: HabitViewController(),
                title: "습관",
                img: "leaf"
            ),
            makeNavController(
                rootViewController: RankingViewController(),
                title: "랭킹",
                img: "trophy"
            ), makeNavController(
                rootViewController: MyPageViewContoller(),
                title: "마이페이지",
                img: "person"
            )
        ]
    }
    private func makeNavController(rootViewController: UIViewController, title: String, img: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = UIImage(systemName: img)
        navController.tabBarItem.title = title
        return navController
    }
}
