//
//  HabitCardView.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/3/26.
//

import UIKit
import SnapKit
import Then
final class HabitCardView: UIView {
    init(titleText: String, days: Int, times: Int, didTimes: Int, category: String, cycle: String) {
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
