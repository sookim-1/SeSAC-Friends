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
    
    func postQueue(model: Queue, completion: @escaping (AFDataResponse<String>) -> Void) {
        
        AF.request(Endpoint.queue.url, method: .post, parameters: model, encoder: JSONParameterEncoder.default, headers: headers)
            .responseString(completionHandler: completion)
    }
    
    func deleteQueue(completion: @escaping (AFDataResponse<String>) -> Void) {
        
        AF.request(Endpoint.queue.url, method: .delete, parameters: [:], headers: headers)
            .responseString(completionHandler: completion)
    }
    
    func hobbyrequestQueue(uid: Request, completion: @escaping (AFDataResponse<String>) -> Void) {
        
        AF.request(Endpoint.hobbyrequest.url, method: .post, parameters: uid, encoder: JSONParameterEncoder.default, headers: headers)
            .responseString(completionHandler: completion)
    }

}
