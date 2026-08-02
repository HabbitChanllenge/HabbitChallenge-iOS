//
//  UIWindow+.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/2/26.
//

import UIKit
extension UIWindow {
    static func changeRootViewController(to VC: UIViewController, animated: Bool) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
                print("rootVC 바꾸는거 실패")
                return
              }
        //
        let navVC = UINavigationController(rootViewController: VC)
        window.rootViewController = navVC
        //rootViewController 바꿈
    }
}
