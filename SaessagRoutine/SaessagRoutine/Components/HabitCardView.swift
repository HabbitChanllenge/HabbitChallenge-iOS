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
    var cardHeight = 116
    let habitCard = UIView().then { //카드
        $0.backgroundColor = UIColor(named: "main300")
        $0.layer.cornerRadius = 10
    }
    let textStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 2
    }
    let buttonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 29
    }
    
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.textColor = .black
    }
    let categoryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 10, weight: .semibold)
        $0.textColor = UIColor(named: "gray600")
    }
    let timesLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 10, weight: .semibold)
        $0.textColor = UIColor(named: "gray600")
    }
    
    let patchButton = UIButton(type: .system).then {
        $0.setTitle("수정", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        $0.backgroundColor = UIColor(named: "main600")
        $0.tintColor = .white
        $0.layer.cornerRadius = 10
    }//수정버튼
    let daysButton = UIButton().then {
        $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        $0.backgroundColor = UIColor(named: "main600")
        $0.tintColor = .white
        $0.layer.cornerRadius = 10
    }//n일 성공, n주 성공
    let verificationButton = UIButton(type: .system).then {
        $0.setTitle("인증", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        $0.tintColor = .white
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(changeHeight), for: .touchUpInside)
    }//인증버튼
    var onPatchButtonTapped: (() -> Void)?
    
    init(titleText: String, days: Int, times: Int, didTimes: Int, category: String, cycle: String) {
        super.init(frame: .zero)
        setAttributes(titleText, days, times, didTimes, category, cycle)
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes(_ titleText: String, _ days: Int, _ times: Int, _ didTimes: Int, _ category: String, _ cycle: String) {
        titleLabel.text = titleText
        categoryLabel.text = category
        timesLabel.text = "\(cycle) \(didTimes)/\(times)"
        if cycle == "매일" {
            daysButton.setTitle("\(days)일 성공", for: .normal)
        } else {
            daysButton.setTitle("\(days)주 성공", for: .normal)
        }
        patchButton.addTarget(self, action: #selector(patchButtonTapped), for: .touchUpInside)
        
        var isCompleted = (didTimes >= times)
        if isCompleted {
            verificationButton.isEnabled = false
            verificationButton.backgroundColor = UIColor(named: "main500")
            habitCard.backgroundColor = UIColor(named: "main300")
        } else {
            verificationButton.backgroundColor = UIColor(named: "main600")
            habitCard.backgroundColor = UIColor(named: "gray300")
        }
    }
    private func setupLayout() {
        self.addSubview(habitCard)
        
        habitCard.addSubview(textStack)
        habitCard.addSubview(buttonStack)
        
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(categoryLabel)
        textStack.addArrangedSubview(timesLabel)
        
        buttonStack.addArrangedSubview(verificationButton)
        buttonStack.addArrangedSubview(patchButton)
        buttonStack.addArrangedSubview(daysButton)
        
        habitCard.snp.makeConstraints {
            $0.height.equalTo(cardHeight)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.bottom.equalToSuperview()
        }
        
        verificationButton.snp.makeConstraints {
            $0.width.equalTo(88)
            $0.height.equalTo(24)
        }
        patchButton.snp.makeConstraints {
            $0.width.equalTo(88)
            $0.height.equalTo(24)
        }
        daysButton.snp.makeConstraints {
            $0.width.equalTo(88)
            $0.height.equalTo(24)
        }
        
        textStack.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(46)
        }
        buttonStack.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.top.equalTo(textStack.snp.bottom).offset(14)
            $0.trailing.leading.equalToSuperview().inset(16)
        }
    }
    @objc func patchButtonTapped() {
        print("수정버튼 클릭")
        onPatchButtonTapped?()//클로저 사용
    }
    @objc func changeHeight() {
        cardHeight = (cardHeight == 116) ? 190 : 116
        
        habitCard.snp.updateConstraints {
            $0.height.equalTo(cardHeight)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.superview?.layoutIfNeeded()
        }
    }
}
