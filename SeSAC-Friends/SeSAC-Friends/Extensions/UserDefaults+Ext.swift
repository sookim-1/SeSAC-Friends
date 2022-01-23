//
//  UserDefaults+Ext.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/23.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    var container: UserDefaults = .standard

    var wrappedValue: T {
        get {
            return container.object(forKey: key) as? T ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}

extension UserDefaults {
    @UserDefault(key: "phoneNumber", defaultValue: "")
    static var phoneNumber: String
    
    @UserDefault(key: "FCMToken", defaultValue: "")
    static var FCMToken: String
    
    @UserDefault(key: "nickname", defaultValue: "")
    static var nickname: String
    
    @UserDefault(key: "birthday", defaultValue: "")
    static var birthday: String
    
    @UserDefault(key: "email", defaultValue: "")
    static var email: String
    
    @UserDefault(key: "idToken", defaultValue: "")
    static var idToken: String
}
