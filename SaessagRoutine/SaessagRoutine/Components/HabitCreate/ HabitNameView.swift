import UIKit
import SnapKit
import Then

final class HabitNameView: UIView {

    private let titleLabel = UILabel().then {
        $0.text = "습관명"
        $0.font = .systemFont(ofSize: 25, weight: .semibold)
        $0.textColor = UIColor(named: "gray900")
    }

    let textField = UITextField().then {
        $0.placeholder = "습관의 이름을 입력해 주세요."
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = UIColor(named: "gray900")
        $0.backgroundColor = UIColor(named: "gray200")
        $0.layer.cornerRadius = 10

        $0.leftView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: 20,
            height: 0
        ))

        $0.leftViewMode = .always
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)
        addSubview(textField)

        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.equalTo(40)
        }

        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
            $0.width.equalTo(355)
            $0.height.equalTo(50)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
