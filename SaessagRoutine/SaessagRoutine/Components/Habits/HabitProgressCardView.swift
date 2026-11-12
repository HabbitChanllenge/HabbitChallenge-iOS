//
//  HabitProgressCardView.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/18/26.
//

import UIKit
import SnapKit
import Then
import Moya

class HabitProgressCardView : UIView {
    let progressCard = UIView().then {
        $0.backgroundColor = UIColor(named: "main300")
        $0.layer.cornerRadius = 10
    }
    let baseProgressBar = UIView().then {
        $0.backgroundColor = UIColor(named: "gray500")
        $0.layer.cornerRadius = 10
    }
    let progressBar = UIView().then {
        $0.backgroundColor = UIColor(named: "main600")
        $0.layer.cornerRadius = 10
    }
    
    let titleLabel = UILabel().then {
        $0.text = "오늘의 습관 달성"
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.textColor = .black
    }
    let grayProgressLabel = UILabel().then {
        $0.textColor = UIColor(named: "gray600")
        $0.font = .systemFont(ofSize: 10, weight: .medium)
    }
    let whiteProgressLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 12, weight: .medium)
    }
    
    init() {
        super.init(frame: .zero)
        // 수정함: init 시점에 HomeViewController()를 직접 생성하여 데이터를 가져오던 setAtrribute() 호출 제거 (크래시 원인 제거)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(total: Int, complete: Int, animated: Bool = false) {
        let safeTotal = max(total, 0)
        let safeComplete = min(max(complete, 0), safeTotal)
        let progress = safeTotal > 0 ? CGFloat(safeComplete) / CGFloat(safeTotal) : 0
        let progressText = "\(safeComplete)/\(safeTotal)"

        grayProgressLabel.text = progressText
        whiteProgressLabel.text = progressText
        progressBar.snp.remakeConstraints {
            $0.leading.bottom.height.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(progress)
        }

        let layout: () -> Void = { self.superview?.layoutIfNeeded() }
        if animated {
            UIView.animate(withDuration: 0.3, animations: layout)
        } else {
            layout()
        }
    }
    
    private func setupView() {
        self.addSubview(progressCard)
        
        progressCard.addSubview(baseProgressBar)
        progressCard.addSubview(titleLabel)
        progressCard.addSubview(grayProgressLabel)
        
        baseProgressBar.addSubview(progressBar)
        baseProgressBar.addSubview(whiteProgressLabel)
        
        progressCard.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(116)
        }
        baseProgressBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(26)
            $0.height.equalTo(24)
        }
        progressBar.snp.makeConstraints {
            $0.leading.bottom.height.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0)
        }
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        grayProgressLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.leading.equalToSuperview().inset(16)
        }
        whiteProgressLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func updateBar() {
        configure(
            total: HabitManager.shared.totalHabits,
            complete: HabitManager.shared.didHabits,
            animated: true
        )
    }
}

