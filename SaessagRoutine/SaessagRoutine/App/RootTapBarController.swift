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
        navAppearance.backgroundColor = .white
        navAppearance.shadowColor = .clear
        
        tabBar.standardAppearance = navAppearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = navAppearance
        }
        tabBar.tintColor = UIColor(named: "main800")
        tabBar.unselectedItemTintColor = UIColor(named: "gray500")
        
        traitOverrides.horizontalSizeClass = .compact
    }
    private func setTabBarItem() {//탭바에서 각 버튼마다의 속성 설정
        viewControllers = [
            makeNavController(
                rootViewController: HomeViewController(),
                title: "홈",
                img: "house"
            ),
            makeNavController(
                rootViewController: HabbitViewController(),
                title: "습관",
                img: "leaf"
            ),
            makeNavController(
                rootViewController: RankingViewController(),
                title: "랭킹",
                img: "trophy"
            ),
            makeNavController(
                rootViewController: MyPageViewContoller(),
                title: "마이페이지",
                img: "person"
            )
        ]
    }
    private func makeNavController(rootViewController: UIViewController, title: String, img: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = UIImage(systemName: img)
        navController.tabBarItem.selectedImage = UIImage(systemName: img)
        navController.tabBarItem.title = title
        
        return navController
    }
}
