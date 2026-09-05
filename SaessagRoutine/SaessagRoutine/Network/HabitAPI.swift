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
    case dayCreateHabit(periodType : String, name : String, categorys : [String], totalRepeat : Int, alarm : Bool)
    case weekCreateHabit(periodType : String, name : String, categorys : [String], dayOfWeek: [Int], alarm : Bool)
    case getHabits
    case deleteHabit(habitId : Int)
    case verifyHabit(habitId : Int, completedCount : Int, complated : Bool)
    case patchHabit(habitId : Int, name : String, categorys : [String], totalRepeat : Int, dayOfWeek: [Int], alarm : Bool)
}
extension HabitAPI : TargetType {
    
    var baseURL: URL { return Secrets.baseURL }
    var path: String {
        switch self {
        case .dayCreateHabit:
            return "/habits/day"
        case .weekCreateHabit:
            return "/habits/week"
        case .getHabits:
            return "/habits"
        case .deleteHabit(let habitId):
            return "/habits/\(habitId)"
        case .patchHabit(let habitId, _, _, _, _, _):
            return "/habits/\(habitId)"
        case .verifyHabit(let habitId, _, _):
            return "/habit/\(habitId)"
        }
    }
    var method: Moya.Method {
        switch self {
        case .dayCreateHabit, .weekCreateHabit, .verifyHabit:
            return .post
        case .getHabits:
            return .get
        case .patchHabit:
            return .patch
        case .deleteHabit:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .dayCreateHabit(let periodType, let name, let categorys, let totalRepeat, let alarm):
            let param : [String : Any] = ["periodType" : periodType, "name" : name, "categorys" : [categorys], "totalRepeat" : totalRepeat, "alarm" : alarm]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
            
        case .getHabits, .deleteHabit:
            return .requestPlain
            
        case .weekCreateHabit(let periodType, let name, let categorys, let dayOfWeek, let alarm):
            let param : [String : Any] = ["periodType" : periodType, "name" : name, "categorys" : [categorys], "dayOfWeek" : dayOfWeek, "alarm" : alarm]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
            
        case .patchHabit(_, let name, let categorys, let totalRepeat, let dayOfWeek, let alarm):
            let param : [String : Any] = ["name" : name, "categorys" : [categorys], "totalRepeat" : totalRepeat, "dayOfWeek" : dayOfWeek, "alarm" : alarm]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
            
        case .verifyHabit(_, let completedCount, let complated):
            let param : [String : Any] = ["completedCount" : completedCount, "complated" : complated]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
struct habitInfoResponse: Codable {//습관 보기 때 사용
    let status : String
    let habits: [habitInfo]
}
struct habitInfo : Codable {//습관 보기 시 사용.
    let habitId: Int
    let periodType : String
    let name: String
    let categorys: [String]
    let totalRepeat: Int?
    let dayOfWeek: [Int]?
    let completedCount: Int
    let completed : Bool
}
struct response : Codable {//습관 삭제, 수정, 인증, 생성시 사용
    let status : Int?
    let message: String
}
