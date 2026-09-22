import UIKit
import SnapKit
import Then

final class HabitCreateHeaderView: UIView {

    private let logoLabel = UILabel().then {
        $0.text = "새싹루틴"
        $0.font = .systemFont(ofSize: 38, weight: .bold)
        $0.textColor = UIColor(named: "main700")
    }

    private let dayLabel = UILabel().then {
        $0.text = "31일"
        $0.font = .systemFont(ofSize: 30, weight: .bold)
        $0.textColor = UIColor(named: "main700")
        $0.textAlignment = .right
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(logoLabel)
        addSubview(dayLabel)

        logoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(195)
        }

        dayLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
