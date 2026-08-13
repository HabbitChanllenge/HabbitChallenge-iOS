//
//  HabitCardStackView.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/13/26.
//

import UIKit
import SnapKit
import Then
import Moya

class HabitCardStackView: UIView {
    let stackView = UIStackView().then {
        $0.spacing = 16
        $0.axis = .vertical
    }
    
    init(isHome: Bool) {
        super.init(frame: .zero)
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
        }
    }
    
}

