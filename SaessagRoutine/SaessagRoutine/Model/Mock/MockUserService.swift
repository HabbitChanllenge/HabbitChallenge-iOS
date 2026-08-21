//
//  User.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/21/26.
//

import Foundation
struct Mypage: Codable {
    let user: [user]
}
struct user : Codable {
    let email : String
    let Id : String
    let password : String
}
struct UserData: Codable {
    static let userInformation : [user] = [
        user(email: "test@gmail.com", Id: "testID", password: "1234")
    ]
}
