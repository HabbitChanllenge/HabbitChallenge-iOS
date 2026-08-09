//
//  UITabBar++.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/6/26.
//

import UIKit
extension UITabBarController {
    func swichTo(tab : tabIndex) {
        self.selectedIndex = tab.rawValue//탭 전환
    }
}
