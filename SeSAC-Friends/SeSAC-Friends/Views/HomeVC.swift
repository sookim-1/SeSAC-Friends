//
//  HomeVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/23.
//

import UIKit
import SnapKit

class HomeVC: UIViewController {

    var btn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        btn.backgroundColor = .systemRed
        btn.setTitle("회원탈퇴", for: .normal)
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        btn.addTarget(self, action: #selector(withDraw), for: .touchUpInside)
    }
    
    
    @objc func withDraw() {
        let idToken = UserDefaults.standard.string(forKey: "idToken")
        withDrawUser(idToken: idToken!) { result in
            switch result {
            case .success(let str):
                print(str)
                ["idToken", "phoneNumber", "FCMToken", "nickname", "birthday", "email"].forEach { str in
                    UserDefaults.standard.removeObject(forKey: str)
                }
                DispatchQueue.main.async {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: SMSAuthVC())
                    windowScene.windows.first?.makeKeyAndVisible()
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func withDrawUser(idToken: String, completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: SeSacAPI.withdrawUser.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(idToken, forHTTPHeaderField: "idToken")
        
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
                completion(.success("성공"))
            case 401:
                print("파이어베이스토큰만료")
                completion(.failure(error!))
            case 406:
                print("이미 탈퇴처리된 회원")
                completion(.failure(error!))
            case 500:
                print("서버에러")
                completion(.failure(error!))
            default:
                print("에러")
                completion(.failure(error!))
            }
                           
        }.resume()
    }
                        
}
