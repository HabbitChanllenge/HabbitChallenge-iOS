//
//  RootTapBarController.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/2/26.
//

import UIKit
enum tabIndex : Int {
    case home
    case habit
    case ranking
    case profile
}
final class RootTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        setTabBar()
        setTabBarItem()
    }
    private func setTabBar() {//탭 바 전체의 속성을 설정
        let navAppearance = UITabBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = .white
        navAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(named: "gray500")
        navAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(named: "gray500")]
        navAppearance.shadowColor = UIColor(named: "gray400")
        
        tabBar.standardAppearance = navAppearance
        tabBar.tintColor = UIColor(named: "main800")
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = navAppearance
        }
    }
    private func setTabBarItem() {//탭바에서 각 버튼마다의 속성 설정
        let home = makeNavController(
            to: HomeViewController(),
            title: "홈",
            img: "house"
        )
        let habit = makeNavController(
            to: HabitViewController(),
            title: "습관",
            img: "leaf"
        )
        let rank = makeNavController(
            to: RankingViewController(),
            title: "랭킹",
            img: "trophy"
        )
        let myPage = makeNavController(
            to: MyPageViewContoller(),
            title: "마이페이지",
            img: "person"
        )
        viewControllers = [home, habit, rank, myPage]
    }
    private func makeNavController(to: UIViewController, title: String, img: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: to)
        navController.tabBarItem.image = UIImage(systemName: img)
        navController.tabBarItem.title = title
        return navController
    }
}
