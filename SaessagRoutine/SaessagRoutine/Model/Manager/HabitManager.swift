//
//  HabitManager.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/20/26.
//

import UIKit

class HabitManager {
    static let shared = HabitManager()//전역에 공유하겠다는 뜻
    private init() {}//다른 파일에서 인스턴스를 생성 할 수 없게 만드는 거
    
    var totalHabits: Int = 0
    var didHabits: Int = 0
    
    var id: Int = 0
    var name: String? //습관 이름
    var periodType: String? //하루인지 일주일인지. day와 week로 들어옴
    var category: String? //카테고리
    var repeatCount: Int? //하루에 몇번 하는지. 하루 습관 할 때만 사용
    var repeatDay: [Int]? //무슨 요일에 하는지. 일주일 습관 할 때만 사용
    
    var didDays = 44 //몇 일, 몇 주 표시. 카드 제작 때 사용
    var didCount: Int = 0
    var isCompleted: Bool = false
    
    func reset() {
        isCompleted = false
        totalHabits = 0
        didHabits = 0
        name = nil
        periodType = nil
        category = nil
        repeatDay = []
        repeatCount = nil
    }
}
enum weekNumber : String {
    case monday = "월요일"
    case tuesday = "화요일"
    case wednesday = "수요일"
    case thursday = "목요일"
    case friday = "금요일"
    case saturday = "토요일"
    case sunday = "일요일"
    
    var number: Int {
        switch self {
        case .monday: return 1
        case .tuesday: return 2
        case .wednesday: return 3
        case .thursday: return 4
        case .friday: return 5
        case .saturday: return 6
        case .sunday: return 7
        }
    }
}
