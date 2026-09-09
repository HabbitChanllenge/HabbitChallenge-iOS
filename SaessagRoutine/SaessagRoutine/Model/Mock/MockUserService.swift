//
//  User.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/21/26.
//

import Foundation
struct Mypage: Codable {
    let user : [user]
}
struct user : Codable {
    var email : String
    var Id : String
}
final class UserData {
    static let shared = UserData()
    
    private init() {}
    
    var userInformation : user = user(email: "test@gmail.com", Id: "testID")
    
    func updateUserInfo(email: String, id: String) {
        userInformation.email = email
        userInformation.Id = id
    }
}
