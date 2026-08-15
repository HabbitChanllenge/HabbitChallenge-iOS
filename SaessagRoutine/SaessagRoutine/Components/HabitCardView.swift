//
//  HabitCardView.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/3/26.
//

import UIKit
import SnapKit
import Then
enum weekdays : String {
    case sunday = "일요일"
    case monday = "월요일"
    case tuesday = "화요일"
    case wednesday = "수요일"
    case thursday = "목요일"
    case friday = "금요일"
    case saturday = "토요일"
}
final class HabitCardView: UIView {
    var cardHeight = 116
    var times = 0
    var didTimes = 0
    
    let habitCard = UIView().then {
        $0.backgroundColor = UIColor(named: "main300")
        $0.layer.cornerRadius = 10
    }//카드
    let textStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 2
    }//텍스트 세로 스택
    let buttonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 29
    }//버튼 가로 스택
    let mainCheckBoxStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.isHidden = true
        $0.alignment = .leading
    }//체크박스 세로 스택
    
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
    }//펼쳤을 때 중간에 가로 선
    
    init(titleText: String, days: Int, times: Int, didTimes: Int, category: String, cycle: String, day : [String]?) {
        super.init(frame: .zero)
        self.didTimes = didTimes
        setAttributes(titleText, days, times, didTimes, category, cycle, day)
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes(_ titleText: String, _ days: Int, _ times: Int, _ didTimes: Int, _ category: String, _ cycle: String, _ day: [String]?) {
        self.times = times
        let cycle = (cycle == "day") ? "매일" : (weekdays(rawValue: day?.first ?? "")?.rawValue ?? "매주")
        titleLabel.text = titleText
        categoryLabel.text = category
        timesLabel.text = "\(cycle) \(didTimes)/\(times)"
        if cycle == "매일" {
            daysButton.setTitle("\(days)일 성공", for: .normal)
        } else {
            daysButton.setTitle("\(days)주 성공", for: .normal)
        }
        patchButton.addTarget(self, action: #selector(patchButtonTapped), for: .touchUpInside)
        
        let isCompleted = (didTimes >= times)
        if isCompleted {
            verificationButton.isEnabled = false
            verificationButton.backgroundColor = UIColor(named: "main500")
            habitCard.backgroundColor = UIColor(named: "main300")
        } else {
            verificationButton.backgroundColor = UIColor(named: "main600")
            habitCard.backgroundColor = UIColor(named: "gray300")
        }
    }//텍스트 설정
    private func setupLayout() {
        self.addSubview(habitCard)
        
        habitCard.addSubview(textStack)
        habitCard.addSubview(buttonStack)
        habitCard.addSubview(lineView)
        habitCard.addSubview(mainCheckBoxStack)
        
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(categoryLabel)
        textStack.addArrangedSubview(timesLabel)
        
        buttonStack.addArrangedSubview(verificationButton)
        buttonStack.addArrangedSubview(patchButton)
        buttonStack.addArrangedSubview(daysButton)
        
        
        habitCard.snp.makeConstraints {
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
            $0.trailing.leading.bottom.equalToSuperview().inset(16)
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(buttonStack.snp.bottom).offset(24)
        }
        mainCheckBoxStack.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalTo(lineView.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().offset(-21)
        }
    }//레이아웃 잡기
    
    @objc func patchButtonTapped() {
        onPatchButtonTapped?()//클로저 사용
    }//수정 버튼 클릭 시
    @objc func verificationButtonTapped() {
        let isExpanded = lineView.isHidden
        var checkBox : CheckBoxView
        
        lineView.isHidden = !isExpanded
        mainCheckBoxStack.isHidden = !isExpanded
        
        let isCompleted = (didTimes >= times)//인증 성공 여부 판단
        if isCompleted {
            verificationButton.isEnabled = false
            verificationButton.backgroundColor = UIColor(named: "main500")
            habitCard.backgroundColor = UIColor(named: "main300")
        }//성공 했으면 인증버튼 비활성화, 배경색 변경
        
        if isExpanded {
            mainCheckBoxStack.snp.remakeConstraints {
                $0.leading.equalToSuperview().inset(16)
                $0.top.equalTo(lineView.snp.bottom).offset(20)
                $0.bottom.equalToSuperview().offset(-21)
            }//카드 밑에를 체크박스에서 21만큼 떨어지게
            buttonStack.snp.remakeConstraints {
                $0.height.equalTo(24)
                $0.top.equalTo(textStack.snp.bottom).offset(14)
                $0.trailing.leading.equalToSuperview().inset(16)
            }//카드 바텀이 버튼에서 16 떨어졌던거 없앰
            mainCheckBoxStack.arrangedSubviews.forEach{//원래 있던 박스들 삭제
                $0.removeFromSuperview()
            }

            var checkBoxHStack: UIStackView?//가로 스택 생성
            for i in 0 ..< self.times {
                if i % 7 == 0 {//
                    checkBoxHStack = UIStackView().then {
                        $0.axis = .horizontal
                        $0.spacing = 24
                        $0.alignment = .center
                        $0.distribution = .fill
                        mainCheckBoxStack.addArrangedSubview($0)
                    }//가로 줄 추가
                }//7개 단위로 가로 줄 하나씩 추가 하는.
                if i < self.didTimes {
                    checkBox = CheckBoxView(isChecked: true)//체크 돼 있는걸로 생성
                } else {
                    checkBox = CheckBoxView(isChecked: false)// 안 돼있는걸로 생성
                }//체크박스 생성
                checkBox.onChecked = { [weak self] isNowChecked in
                    guard let self = self else { return }

                    if isNowChecked {//체크 됐을 때
                        self.didTimes += 1
                    } else {//체크 돼있던 애가 취소 됐을 때
                        self.didTimes -= 1
                    }
                    let cycleText = self.timesLabel.text?.components(separatedBy: " ").first ?? ""//매일, 월요일 같은 텍스트 추출
                    self.timesLabel.text = "\(cycleText) \(self.didTimes)/\(self.times)"//"매일 6/8" 텍스트 변경
                }//체크 됐을 때 텍스트 변경 하는 클로저
                checkBoxHStack?.addArrangedSubview(checkBox)//가로 체크박스 스택에 박스 하나하나 추가
            }//체크박스 생성
        }//확장 됐을 때 할 액션
        else {
            mainCheckBoxStack.snp.removeConstraints()//체크박스 스택뷰 레이아웃 없애기
            buttonStack.snp.remakeConstraints {
                $0.height.equalTo(24)
                $0.top.equalTo(textStack.snp.bottom).offset(14)
                $0.trailing.leading.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview().inset(16)
            }//카드 바텀을 다시 버튼에서 16 떨어지게 설정
        }//확장 돼 있던거 접기
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.window?.layoutIfNeeded()//바뀌면 바로바로 레이아웃 다시 잡아서 바꾸라는 코드
        }
    }//인증 버튼 클릭 시
}
