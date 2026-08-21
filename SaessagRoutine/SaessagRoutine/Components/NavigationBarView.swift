//
//  NavigationBarView.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/6/26.
//

import UIKit
import Then
import SnapKit

final class NavigationBarView: UIView {//쓸 화면 내에서 자체적으로 네비바 높이를 101로 설정해 주세요
    let logoImg = UIImageView().then {
        $0.image = UIImage(named: "topBarLogo")
    }//로고 이미지 설정
    let streakLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 25, weight: .semibold)
        $0.textColor = UIColor(named: "main700")
    }//전체 스트릭 텍스트
    init(streak : String) {
        super.init(frame: .zero)
        streakLabel.text = "\(streak)일"
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setup() {
        addSubview(logoImg)
        addSubview(streakLabel)
        logoImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(66)
        }
        streakLabel.snp.makeConstraints {
            $0.centerY.equalTo(logoImg)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
}
