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
    
    var name: String?
    var isWeekly: Bool = false
    var category: String?
    var repeatCount: Int?
    var repeatDay: [Int]?
    
    func reset() {
        name = nil
        isWeekly = false
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
