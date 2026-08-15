//
//  MoceHabitService.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/14/26.
//

import Foundation

struct HabitListResponse: Codable {
    let status: String
    let habits: [Habit]
}
struct Habit: Codable {
    let habitId: Int
    let periodType: String
    let name: String
    let category: String
    let totalRepeat : Int
    let dayOfWeek: [String]?
    let streak: Int
}

struct MockHabitCard {
    static let habit: [Habit] = [
        Habit(habitId: 1, periodType: "week", name: "금욜마다 수영가기", category: "운동", totalRepeat: 10, dayOfWeek: ["friday"], streak: 10),
        Habit(habitId: 2, periodType: "day", name: "하루 수학 30분씩 5번", category: "공부", totalRepeat: 5, dayOfWeek: nil, streak: 10),
        Habit(habitId: 3, periodType: "day", name: "물 마시기", category: "생활", totalRepeat: 7, dayOfWeek: nil, streak: 55)
    ]
}//데이터
