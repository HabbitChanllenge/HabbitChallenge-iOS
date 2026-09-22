import UIKit
import SnapKit
import Then

final class HabitCreateButton: UIView {

    let createButton = UIButton(type: .system).then {
        $0.setTitle("생성하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(named: "main400")
        $0.layer.cornerRadius = 10
        $0.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        $0.isEnabled = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(createButton)

        createButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setEnabled(_ enabled: Bool) {
        createButton.isEnabled = enabled

        createButton.backgroundColor = UIColor(
            named: enabled ? "main600" : "main400"
        )
    }
}
