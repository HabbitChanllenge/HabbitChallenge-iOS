import UIKit
import SnapKit
import Then
import Moya

class RankingViewController: UIViewController {
    let provider = MoyaProvider<StreakAPI>(plugins: [MoyaLoggingPlugin()])
    
    let navBar = NavigationBarView()
    private let topRankingView : TopRankingView = TopRankingView()
    
    private let scrollView = UIScrollView()
    
    private let rankingStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBar.streakLabel.text = "\(StreakManager.shared.allStreak)일"
        setRanking()
        setLayout()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    private func setLayout() {
        view.addSubview(topRankingView)
        view.addSubview(scrollView)
        view.addSubview(navBar)

        scrollView.addSubview(rankingStackView)

        navBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(108)
        }

        topRankingView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(-30)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(260)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(topRankingView.snp.bottom).offset(7)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        rankingStackView.snp.makeConstraints {
            $0.top.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.leading.trailing.equalTo(scrollView.frameLayoutGuide).inset(24)
        }
        
        view.bringSubviewToFront(navBar)
    }
    
    private func setRanking() {
        provider.request(.getRank) { [self] in
            switch $0 {
            case .success(let res):
                guard let data = try? res.map([RankData].self) else { return }
                let count = data.count
                self.rankingStackView.subviews.forEach { $0.removeFromSuperview() }
                if count >= 3 {//유저가 3명보다 많거나 3명일 시
                    self.topRankingView.configure(firstName: data[0].userName, firstDays: data[0].allStreak, secondName: data[1].userName, secondDays: data[1].allStreak, thirdName: data[2].userName, thirdDays: data[2].allStreak)
                } else {//3명보다 적을 시
                    self.topRankingView.firstNameLabel.text = data[0].userName
                    self.topRankingView.firstDayLabel.text = "\(data[0].allStreak)일"
                    //1등은 무조건 있으니까 일단 설정
                    
                    return//이 밑은 3명 이상일 때에만 실행 할거다.
                }
                
                for i in 4..<count+1 {
                    let row : RowRankingView = RowRankingView()
                    row.configure(rank: i, name: data[i].userName, days: data[i].allStreak)
                    self.rankingStackView.addArrangedSubview(row)
                }//4등부터 포문 돌아가면서 추가.
            case .failure(let error):
                print(error)
            }
        }
    }
}
