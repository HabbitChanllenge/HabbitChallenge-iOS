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
    var progressBarWidth: CGFloat = 0
    
    init(totalHabits : Int, complete : Int) {
        super.init(frame: .zero)
        setAtrribute(total: totalHabits, complete: complete)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setAtrribute(total : Int, complete : Int) {
        let total = CGFloat(total)
        let complete = CGFloat(complete)
        progressBarWidth = (complete/total)*322.0
        
        var progressText = "\(Int(complete))/\(Int(total))"
        grayProgressLabel.text = progressText
        whiteProgressLabel.text = progressText
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
            $0.width.equalTo(self.progressBarWidth)
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
        
    }
}

