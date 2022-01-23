//
//  GenderVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/23.
//

import UIKit

class GenderVC: UIViewController {

    var genderIndex: Int = 2
    lazy var authDescriptionLabel: CustomLabel = CustomLabel(lineHeight: 1.5, text: "성별을 선택해 주세요\n새싹 찾기 기능을 이용하기 위해서 필요해요!", labelList: .genderLabel)
    
    lazy var manView: UIView = {
        let view = UIView()

        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.CustomColor.gray3.cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    lazy var womanView: UIView = {
        let view = UIView()

        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.CustomColor.gray3.cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    let manImageView = UIImageView(image: UIImage(named: "man"))
    let manLabel = UILabel()
    let womanImageView = UIImageView(image: UIImage(named: "woman"))
    let womanLabel = UILabel()

    
    let doneButton: CustomButton = CustomButton(text: "다음")
    
    lazy var manStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [manView, womanView])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authDescriptionLabel, manStackView, doneButton])
        stackView.axis = .vertical
        stackView.spacing = view.frame.height * 0.08
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configure()
        setUpConstraints()
        setUpNavigationBar()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        manView.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(handleTap2(sender:)))
        womanView.addGestureRecognizer(tapGesture2)
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        manView.backgroundColor = UIColor.CustomColor.green.withAlphaComponent(0.5)
        if womanView.backgroundColor == UIColor.CustomColor.green.withAlphaComponent(0.5) {
            womanView.backgroundColor = .clear
        }
        genderIndex = 1
        doneButton.buttonStatus = .fill
        print("man")
        
    }
    @objc func handleTap2(sender: UITapGestureRecognizer) {
        womanView.backgroundColor = UIColor.CustomColor.green.withAlphaComponent(0.5)
        if manView.backgroundColor == UIColor.CustomColor.green.withAlphaComponent(0.5) {
            manView.backgroundColor = .clear
        }
        genderIndex = 0
        doneButton.buttonStatus = .fill
        print("woman")
    }

    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")

        navigationItem.backBarButtonItem = UIBarButtonItem()
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(stackView)
        doneButton.buttonStatus = .disable
        doneButton.addTarget(self, action: #selector(authComplete), for: .touchUpInside)
        
        
        manLabel.text = "남자"
        womanLabel.text = "여자"
        manView.addSubview(manImageView)
        manView.addSubview(manLabel)
        womanView.addSubview(womanImageView)
        womanView.addSubview(womanLabel)
    }
    
    private func setUpConstraints() {
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.6)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        manStackView.snp.makeConstraints { make in
            make.size.equalTo(120)
        }
        
        manImageView.snp.makeConstraints { make in
            make.centerX.equalTo(manView.snp.centerX)
            make.top.equalTo(manView.snp.top)
            make.width.equalTo(manImageView.snp.height).multipliedBy(1.0 / 1.0)
            make.bottom.equalTo(manLabel.snp.top)
        }
    
        manLabel.snp.makeConstraints { make in
            make.centerX.equalTo(manView.snp.centerX)
            make.bottom.equalTo(manView.snp.bottom)
        }
        
        womanImageView.snp.makeConstraints { make in
            make.centerX.equalTo(womanView.snp.centerX)
            make.top.equalTo(womanView.snp.top)
            make.width.equalTo(womanImageView.snp.height).multipliedBy(1.0 / 1.0)
            make.bottom.equalTo(womanLabel.snp.top)
        }
    
        womanLabel.snp.makeConstraints { make in
            make.centerX.equalTo(womanView.snp.centerX)
            make.bottom.equalTo(womanView.snp.bottom)
        }
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }

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
        var request = URLRequest(url: SeSacAPI.postUser.url)
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
