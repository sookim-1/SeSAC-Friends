//
//  HomeService.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/10.
//

import Foundation
import Alamofire

struct HomeService {
    static let shared = HomeService()
    
    private let headers: HTTPHeaders = [
        "idtoken": "\(UserDefaults.idToken)"
    ]

    private init() {}
    
    func postOnQueue(model: OnQueue, completion: @escaping (DataResponse<Post, AFError>) -> Void) {
        
        AF.request(Endpoint.onqueue.url, method: .post, parameters: model, encoder: JSONParameterEncoder.default, headers: headers)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: Post.self, completionHandler: completion)
    }
    
}
