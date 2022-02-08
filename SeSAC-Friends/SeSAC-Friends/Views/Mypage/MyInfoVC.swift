//
//  MyInfoVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/02.
//

import UIKit
import SnapKit

class MyInfoVC: BaseVC {

    // MARK: 프로퍼티
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setUpLayout()
    }

    // MARK: 초기설정
    override func configure() {
        view.backgroundColor = .systemBackground
        title = "정보 관리"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none // 테이블뷰 간의 구분선없애기
        view.addSubview(tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.register(ExpandableTableViewCell.self, forCellReuseIdentifier: "ExpandableTableViewCell")
        tableView.register(GenderTableViewCell.self, forCellReuseIdentifier: "GenderTableViewCell")
        tableView.register(HobbyTableViewCell.self, forCellReuseIdentifier: "HobbyTableViewCell")
        tableView.register(PhoneValidTableViewCell.self, forCellReuseIdentifier: "PhoneValidTableViewCell")
        tableView.register(AgeTableViewCell.self, forCellReuseIdentifier: "AgeTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    // MARK: 오토레이아웃
    func setUpLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
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
        var request = URLRequest(url: Endpoint.withdraw.url)
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

extension MyInfoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableTableViewCell", for: indexPath) as? ExpandableTableViewCell
            else { return UITableViewCell() }
            
            cell.customImageView.image = UIImage(named: "sesac_background_1")
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GenderTableViewCell", for: indexPath) as? GenderTableViewCell
            else { return UITableViewCell() }
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HobbyTableViewCell", for: indexPath) as? HobbyTableViewCell
            else { return UITableViewCell() }
            
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneValidTableViewCell", for: indexPath) as? PhoneValidTableViewCell
            else { return UITableViewCell() }
            
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AgeTableViewCell", for: indexPath) as? AgeTableViewCell
            else { return UITableViewCell() }
            
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            cell.textLabel?.text = "회원탈퇴"
            cell.textLabel?.font = UIFont.CustomFont.title2R16
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            guard let cell = tableView.cellForRow(at: indexPath) as? ExpandableTableViewCell
            else { return }

            tableView.performBatchUpdates {
                UIView.animate(withDuration: 0.3) {
                      cell.bottomView.isHidden = !cell.bottomView.isHidden
                        if !cell.bottomView.isHidden {
                            cell.bottomTitleView.arrowBtn.setImage(UIImage(named: "arrow_down"), for: .normal)
                    } else {
                        cell.bottomTitleView.arrowBtn.setImage(UIImage(named: "arrow_up"), for: .normal)
                    }
                }
            }
        }
        else if indexPath.row == 5 {
            tableView.deselectRow(at: indexPath, animated: true)
            let alertVC = AlertVC()
            //alertVC.okBtn.addTarget(self, action: #selector(withDraw), for: .touchUpInside)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        } else {
            print("ttt")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 500
        }
        return 100
    }
}
