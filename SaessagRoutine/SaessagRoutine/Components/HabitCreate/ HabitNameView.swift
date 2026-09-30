import UIKit
import SnapKit
import Then

final class HabitNameView: UIView {
    var nameEditing: ((Bool) -> Void)?
    
    private let titleLabel = UILabel().then {
        $0.text = "습관명"
        $0.font = .systemFont(ofSize: 25, weight: .semibold)
        $0.textColor = .black
    }
    let textField = UITextField().then {
        $0.placeholder = "습관의 이름을 입력해 주세요."
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .black
        $0.backgroundColor = UIColor(named: "gray200")
        $0.layer.cornerRadius = 10

        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))

        $0.leftViewMode = .always
        $0.addTarget(self, action: #selector(textChanger), for: .editingChanged)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
        guard let text = HabitManager.shared.name else { return }
        textField.text = text
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(textField)

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }
        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(19)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview()
        }
    }
    @objc private func textChanger() {
        HabitManager.shared.name = textField.text
        let isNil : Bool
        if textField.text?.isEmpty ?? true {
            isNil = true
        } else {
            isNil = false
        }
        nameEditing?(isNil)
    }
}
