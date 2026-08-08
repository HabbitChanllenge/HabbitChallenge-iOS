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
    var times = 0
    var didTimes = 0
    
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
    let checkBoxStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 24
        $0.isHidden = true
        $0.distribution = .fillEqually
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
        $0.addTarget(self, action: #selector(verificationButtonTapped), for: .touchUpInside)
    }//인증버튼
    var onPatchButtonTapped: (() -> Void)?
    
    let lineView = UIView().then {
        $0.backgroundColor = UIColor(named: "gray600")
        $0.isHidden = true
    }
    
    init(titleText: String, days: Int, times: Int, didTimes: Int, category: String, cycle: String) {
        super.init(frame: .zero)
        self.didTimes = didTimes
        setAttributes(titleText, days, times, didTimes, category, cycle)
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes(_ titleText: String, _ days: Int, _ times: Int, _ didTimes: Int, _ category: String, _ cycle: String) {
        self.times = times
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
        habitCard.addSubview(lineView)
        habitCard.addSubview(checkBoxStack)
        
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
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(buttonStack.snp.bottom).offset(24)
        }
        checkBoxStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(lineView.snp.bottom).offset(20)
            $0.height.equalTo(25)
        }
    }
    @objc func patchButtonTapped() {
        print("수정버튼 클릭")
        onPatchButtonTapped?()//클로저 사용
    }
    @objc func verificationButtonTapped() {
        let isExpanded = (cardHeight == 116)
        var checkBox : CheckBoxView
        
        cardHeight = isExpanded ? 190 : 116
        lineView.isHidden = !isExpanded
        checkBoxStack.isHidden = !isExpanded
        
        if isExpanded {
            checkBoxStack.arrangedSubviews.forEach{
                $0.removeFromSuperview()
            }
            for i in 0 ..< self.times {
                if i < self.didTimes {
                    checkBox = CheckBoxView(isChecked: true)
                } else {
                    checkBox = CheckBoxView(isChecked: false)
                }
                checkBoxStack.addArrangedSubview(checkBox)
                checkBox.onChecked = { [weak self] isNowChecked in
                    guard let self = self else { return }
                    if isNowChecked {
                        self.didTimes += 1
                    } else {
                        self.didTimes -= 1
                    }
                    let cycleText = self.timesLabel.text?.components(separatedBy: " ").first ?? ""
                    self.timesLabel.text = "\(cycleText) \(self.didTimes)/\(self.times)"
                }
            }
        }
        
        habitCard.snp.updateConstraints {
            $0.height.equalTo(cardHeight)
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.superview?.layoutIfNeeded()
        }
    }
}
