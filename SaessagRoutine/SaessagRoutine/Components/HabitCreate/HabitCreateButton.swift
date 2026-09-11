import UIKit
import SnapKit
import Then

final class HabitCreateButton: UIView {

    let createButton = UIButton().then {
        $0.setTitle("생성하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(named: "main600")
        $0.layer.cornerRadius = 15
        $0.titleLabel?.font = .systemFont(ofSize: 26, weight: .bold)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(createButton)

        createButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(80)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
