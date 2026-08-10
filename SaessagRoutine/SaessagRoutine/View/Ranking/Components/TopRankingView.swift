import UIKit
import SnapKit
import Then

final class TopRankingView: UIView {
    
    private let firstNameLabel = UILabel().then {
        $0.text = "seoyun_1444"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textAlignment = .center
    }
    
    private let firstDayLabel = UILabel().then {
        $0.text = "365일"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "main900")
    }

    private let firstStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }
    
    private let firstRankView = UIView().then {
        $0.backgroundColor = UIColor(named: "main400")
        $0.layer.cornerRadius = 20
    }
    
    private let trophyImageView = UIImageView().then {
        $0.image = UIImage(named: "trophyImage")
        $0.contentMode = .scaleAspectFit
    }
    
    private let secondNameLabel = UILabel().then {
        $0.text = "seoyun_2444"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textAlignment = .center
    }
    private let secondDayLabel = UILabel().then {
        $0.text = "277일"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "main900")
    }
    private let secondStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }
    private let secondRankView = UIView().then {
        $0.backgroundColor = UIColor(named: "main600")
        $0.layer.cornerRadius = 20
    }
    private let thirdNameLabel = UILabel().then {
        $0.text = "seoyun_3444"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textAlignment = .center
    }
    private let thirdDayLabel = UILabel().then {
        $0.text = "244일"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "main900")
    }
    private let thirdStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }
    private let thirdRankView = UIView().then {
        $0.backgroundColor = UIColor(named: "main700")
        $0.layer.cornerRadius = 20
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(firstStackView)
        addSubview(firstRankView)
        addSubview(secondStackView)
        addSubview(secondRankView)
        addSubview(thirdStackView)
        addSubview(thirdRankView)
        
        firstStackView.addArrangedSubview(firstNameLabel)
        firstStackView.addArrangedSubview(firstDayLabel)
        
        secondStackView.addArrangedSubview(secondNameLabel)
        secondStackView.addArrangedSubview(secondDayLabel)
        
        thirdStackView.addArrangedSubview(thirdNameLabel)
        thirdStackView.addArrangedSubview(thirdDayLabel)
        
        firstRankView.addSubview(trophyImageView)
    }
    
    private func setupLayout() {
        
        firstStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(82)
            $0.leading.equalToSuperview().offset(153)
        }
        
        firstRankView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(125)
            $0.leading.equalToSuperview().offset(154.5)
            $0.width.equalTo(97)
            $0.height.equalTo(136)
        }
        secondStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(127)
            $0.leading.equalToSuperview().offset(52)
        }
        secondRankView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(169)
            $0.leading.equalToSuperview().offset(52)
            $0.width.equalTo(97)
            $0.height.equalTo(92)
        }
        trophyImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        thirdStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(147)
            $0.trailing.equalToSuperview().offset(-48.5)
        }
        thirdRankView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(189)
            $0.trailing.equalToSuperview().offset(-49.5)
            $0.width.equalTo(97)
            $0.height.equalTo(72)
        }
    }
    
}

