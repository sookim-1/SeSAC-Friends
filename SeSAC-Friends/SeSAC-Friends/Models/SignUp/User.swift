//
//  User.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/23.
//

import Foundation

struct User: Codable {
    let phoneNumber: String
    let FCMtoken: String
    let nick: String
    let birth: String
    let email: String
    let gender: Int
}

struct FCMTokenModel: Codable {
    let FCMtoken: String
}
