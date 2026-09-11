import UIKit
import SnapKit
import Then
import Moya

final class HabitCreateViewController: UIViewController {
    
    private let topBar = NavigationBarView(streak: "31")
    
    private let scrollView = UIScrollView()
    
    private let contentView = UIView()
    
    private let habitNameView = HabitNameView()
    private let repeatCycleView = RepeatCycleView()
    private let categoryView = CategoryView()
    private let verificationCountView = VerificationCountView()
    private let notificationView = NotificationView()
    private let habitCreateButton = HabitCreateButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        view.addSubview(topBar)
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(habitNameView)
        contentView.addSubview(repeatCycleView)
        contentView.addSubview(categoryView)
        contentView.addSubview(verificationCountView)
        contentView.addSubview(notificationView)
        contentView.addSubview(habitCreateButton)
    }
    
    private func setupLayout() {
        
        topBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(101)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        habitNameView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(125)
        }
        
        repeatCycleView.snp.makeConstraints {
            $0.top.equalTo(habitNameView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(100)
        }
        
        categoryView.snp.makeConstraints {
            $0.top.equalTo(repeatCycleView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(175)
        }

        verificationCountView.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(235)
        }
        
        notificationView.snp.makeConstraints {
            $0.top.equalTo(verificationCountView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(120)
        }
        
        habitCreateButton.snp.makeConstraints {
            $0.top.equalTo(notificationView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(80)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
