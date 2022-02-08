//
//  GenderVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/23.
//

import RxCocoa
import RxSwift

class GenderVC: BaseVC {

    var genderIndex: Int = 2
    let mainView = GenderView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        mainView.doneButton.addTarget(self, action: #selector(authComplete), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        mainView.manView.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(handleTap2(sender:)))
        mainView.womanView.addGestureRecognizer(tapGesture2)
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        mainView.manView.backgroundColor = UIColor.CustomColor.green.withAlphaComponent(0.5)
        if mainView.womanView.backgroundColor == UIColor.CustomColor.green.withAlphaComponent(0.5) {
            mainView.womanView.backgroundColor = .clear
        }
        genderIndex = 1
        mainView.doneButton.buttonStatus = .fill
        print("man")
        
    }
    @objc func handleTap2(sender: UITapGestureRecognizer) {
        mainView.womanView.backgroundColor = UIColor.CustomColor.green.withAlphaComponent(0.5)
        if mainView.manView.backgroundColor == UIColor.CustomColor.green.withAlphaComponent(0.5) {
            mainView.manView.backgroundColor = .clear
        }
        genderIndex = 0
        mainView.doneButton.buttonStatus = .fill
        print("woman")
    }
    
    
    @objc func authComplete() {
        
        let idToken = UserDefaults.idToken
        postUser(idToken: idToken) { result in
            switch result {
            case .success(let str):
                print(str)
                DispatchQueue.main.async {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: HomeVC())
                    windowScene.windows.first?.makeKeyAndVisible()
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func postUser(idToken: String, completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: Endpoint.user.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(idToken, forHTTPHeaderField: "idtoken")
        let phoneNumber = UserDefaults.phoneNumber
        let FCMToken = UserDefaults.FCMToken
        let nick = UserDefaults.nickname
        let birth = UserDefaults.birthday
        let email = UserDefaults.email
        
        [phoneNumber, FCMToken, nick, birth, email].forEach { str in
            print(str)
        }
        
        request.httpBody = try? JSONEncoder().encode(User(phoneNumber: phoneNumber, FCMtoken: "aefewfawefajlgrhawljfawflawejflajw313123123efkljawlkfj222aw", nick: nick, birth: birth, email: email, gender: genderIndex))
        
        
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
            case 201:
                print("닉네임")
                completion(.success("닉네임"))
            case 202:
                print("사용할수없는닉네임")
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
