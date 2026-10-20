import Foundation
import Moya
import Alamofire

enum HabitAPI {
    case dayCreateHabit(periodType: String, name: String, categorys: String, totalRepeat: Int)
    case weekCreateHabit(periodType: String, name: String, categorys: String, dayOfWeek: [Int])
    case getHabits
    case deleteHabit(habitId: Int)
    case verifyHabit(habitId: Int, completedCount: Int)
    case patchHabit(habitId: Int, periodType: String, name: String, categorys: String, totalRepeat: Int?, dayOfWeek: [Int]?)
}

extension HabitAPI: TargetType {
    var baseURL: URL { Secrets.baseURL }

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
            return "/habits/update/\(habitId)"
        case .verifyHabit(let habitId, _):
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
        case .dayCreateHabit(let periodType, let name, let categorys, let totalRepeat):
            return .requestParameters(parameters: ["periodType": periodType, "name": name, "categories": [categorys], "totalRepeat": totalRepeat], encoding: JSONEncoding.default)
        case .weekCreateHabit(let periodType, let name, let categorys, let dayOfWeek):
            return .requestParameters(parameters: ["periodType": periodType, "name": name, "categories": [categorys], "dayOfWeek": dayOfWeek], encoding: JSONEncoding.default)
        case .getHabits, .deleteHabit:
            return .requestPlain
        case .patchHabit(_, let periodType, let name, let categorys, let totalRepeat, let dayOfWeek):
            var parameters: [String: Any] = [
                "periodType": periodType,
                "name": name,
                "categories": [categorys]
            ]

            if let totalRepeat {
                parameters["totalRepeat"] = totalRepeat
            }
            if let dayOfWeek {
                parameters["dayOfWeek"] = dayOfWeek
            }
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .verifyHabit(_, let completedCount):
            return .requestParameters(parameters: ["completedCount": completedCount], encoding: JSONEncoding.default)
        }
    }

    var headers: [String: String]? {
        ["Authorization": "Bearer \(TokenManager.shared.token)"]
    }
}

struct habitInfo: Codable, Equatable {
    let habit_id: Int
    let periodType: String
    let name: String
    let categories: [String]
    let totalRepeat: Int?
    let dayOfWeek: [Int]?
    let completedCount: Int
    let completed: Bool
    let streak: Int
}

struct response: Codable {
    let statusCode: Int?
    let message: String
}
