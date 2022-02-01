//
//  SMSInputService.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/01.
//

import Foundation

struct SMSInputService {
    func getUser(idToken: String, completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: SeSacAPI.getUser.url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(idToken, forHTTPHeaderField: "idtoken")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error)
                completion(.failure(error!))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(error!))
                return
            }
            
            guard let data = data else {
                completion(.failure(error!))
                return
            }

            
            switch response.statusCode {
            case 200:
                print("성공")
//                let token = try! JSONDecoder().decode(FCMTokenModel.self, from: data)
//                UserDefaults.standard.set(token, forKey: "FCMToken")
                completion(.success("성공"))
            case 201:
                print("닉네임")
                completion(.success("닉네임"))
            case 401:
                print("파이어베이스토큰만료")
                completion(.failure(error!))
            case 500:
                print("서버에러")
                completion(.failure(error!))
            case 501:
                print("클라이언트에러")
                completion(.failure(error!))
            default:
                print("에러")
                completion(.failure(error!))
            }
            
        }.resume()
    }
}
