//
//  File.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 9/4/26.
//

import Foundation
import Moya
import Alamofire

enum HabitAPI {
    case createHabit(periodType : String, name : String, categorys : [String], totalRepeat : Int, dayOfWeek: [Int], alarm : Bool)
    case getHabits
    case verifyHabit(completedCount : Int, complated : Bool)
    case deleteHabit
    case patchHabit(name : String, categorys : [String], totalRepeat : Int, dayOfWeek: [Int], alarm : Bool)
    case checkHabit(completedCount : Int, complated : Bool)
}
