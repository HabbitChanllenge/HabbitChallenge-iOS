//
//  checkBoxView.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/8/26.
//

import UIKit
import SnapKit
import Then
final class CheckBoxView: UIView {
    let square = UIButton().then {
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "main900")?.cgColor
        $0.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
    }
    let checkmark = UIImageView().then {
        $0.image = UIImage(systemName: "checkmark")
        $0.tintColor = UIColor(named: "main800")
    }
    var onChecked: ((Bool) -> Void)?//클로저 선언
    var isChecked = false
    
    init(isChecked : Bool) {
        super.init(frame: .zero)
        self.isChecked = isChecked
        checkmark.isHidden = !isChecked
        
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setLayout() {
        self.addSubview(square)
        self.addSubview(checkmark)
        square.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.edges.equalToSuperview()
            $0.height.width.equalTo(25)
        }
        checkmark.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.width.equalTo(25)
        }
    }//레이아웃 잡기
    @objc private func checkBoxTapped() {
        isChecked.toggle()//체크 여부 바꾸기
        checkmark.isHidden = !isChecked//체크 여부에 따른 체크마크 표시 여부
        onChecked?(isChecked)//클로저 부르기, HabitCardView 파일에 가서 실행
    }//체크박스 클릭 시
}
