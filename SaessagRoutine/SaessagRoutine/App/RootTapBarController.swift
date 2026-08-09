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
    enum Tab: Int {
        case home
        case habit
        case rank
        case myPage
    }
    override func viewDidLoad() {
        setTabBar()
        setTabBarItem()
    }
    private func setTabBar() {//탭 바 전체의 속성을 설정
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = .white
        tabAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(named: "gray500")
        tabAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(named: "gray500")]
        tabAppearance.shadowColor = UIColor(named: "gray400")
        
        tabBar.standardAppearance = tabAppearance
        tabBar.tintColor = UIColor(named: "main800")
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
        navController.tabBarItem.image?.withRenderingMode(.alwaysOriginal)
        
        return navController
    }
}
