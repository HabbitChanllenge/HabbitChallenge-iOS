//
//  habitCreateManager.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 9/27/26.
//

import Foundation
class HabitCreateManager {
    static let shared = HabitCreateManager()//전역에 공유하겠다는 뜻
    private init() {}//다른 파일에서 인스턴스를 생성 할 수 없게 만드는 거
    
    var name: String?
    var isWeekly: Bool = false
    var category: String?
    var repeatCount: Int?
    var repeatDay: [Int]?
    var isAlarm: Bool = true
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
