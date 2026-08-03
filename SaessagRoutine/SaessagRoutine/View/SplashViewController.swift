//
//  SplashViewController.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 7/31/26.
//

import UIKit
import SnapKit
import Then

class SplashViewController: UIViewController {
    let logoImg = UIImageView().then {
        $0.image = UIImage(named: "splashLogo")
        $0.contentMode = .scaleAspectFit
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(logoImg)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            self?.splashToHome()
        }
        logoImg.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    func splashToHome() {
        let loginVC = LogInViewController()
<<<<<<< HEAD
        present(loginVC, animated: false)
=======
        //rootViewController를 로그인 뷰 컨트롤러로 바꿈.
        navigationController?.pushViewController(loginVC, animated: false)
        UIWindow.changeRootViewController(to: loginVC, animated: false)
>>>>>>> chore/splash-root-vc
    }
}
