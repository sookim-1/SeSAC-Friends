//
//  SMSInputService.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/01.
//

import Foundation
import Alamofire

struct SignUpService {
    static let shared = SignUpService()
    
    private let headers: HTTPHeaders = [
        "idtoken": "\(UserDefaults.idToken)"
    ]
    
    func getSesacUser(completion: @escaping (DataResponse<UserInfoModel, AFError>) -> Void) {
        AF.request(Endpoint.user.url, method: .get, parameters: [:], headers: headers)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: UserInfoModel.self, completionHandler: completion)
    }
    
    func postSignUp(gender: Int, completion: @escaping (AFDataResponse<String>) -> Void) {
        let postData = User(phoneNumber: UserDefaults.phoneNumber, FCMtoken: UserDefaults.FCMToken ?? "", nick: UserDefaults.nickname, birth: UserDefaults.birthday, email: UserDefaults.email, gender: gender)
    
        AF.request(Endpoint.user.url, method: .post, parameters: postData, encoder: JSONParameterEncoder.default, headers: headers)
            .responseString(completionHandler: completion)
    }
    
    func postWithDraw(completion: @escaping (AFDataResponse<String>) -> Void) {
        AF.request(Endpoint.withdraw.url, method: .post, parameters: [:], headers: headers)
            .responseString(completionHandler: completion)
    }
}
