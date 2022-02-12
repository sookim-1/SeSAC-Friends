//
//  MyInfoVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/02.
//

import UIKit
import SnapKit

final class MyInfoVC: BaseVC {

    // MARK: 프로퍼티
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        saveButton()
        setUpLayout()
    }

    // MARK: 초기설정
    override func configure() {
        view.backgroundColor = .systemBackground
        title = "정보 관리"
        tableView.allowsSelection = true
        
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
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    private func saveButton() {
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func save() {
        print("저장")
    }
    
    // MARK: 오토레이아웃
    private func setUpLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
    }
    
    private func withDraw() {
        SignUpService.shared.postWithDraw { response in
            switch response.response?.statusCode {
            case 200:
                UserDefaults.isUser = false
                
                ["idToken", "phoneNumber", "FCMToken", "nickname", "birthday", "email"].forEach { str in
                    UserDefaults.standard.removeObject(forKey: str)
                }
                switch response.result {
                case .success(let response):
                    print("\(response)")
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    windowScene.windows.first?.rootViewController = OnboardingVC()
                    windowScene.windows.first?.makeKeyAndVisible()
                case .failure(let error):
                    print("withdraw user error: \(error)")
                }
                
                break
            case 401:
                print("파이어베이스 토큰만료")
                self.refreshIdToken { result in
                    switch result {
                    case .success(let idToken):
                        UserDefaults.idToken = idToken
                        self.withDraw()
                    case .failure(let error):
                        print(error)
                    }
                }
                break
            case 406:
                UserDefaults.isUser = false
                
                ["idToken", "phoneNumber", "FCMToken", "nickname", "birthday", "email"].forEach { str in
                    UserDefaults.standard.removeObject(forKey: str)
                }
                
                self.view.makeToast("이미 탈퇴 처리된 회원입니다.", point: self.view.center, title: nil, image: nil) { didTap in
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    windowScene.windows.first?.rootViewController = OnboardingVC()
                    windowScene.windows.first?.makeKeyAndVisible()
                }
                
                break
            case 500:
                print("서버에러")
                
                break
            case 501:
                print("클라이언트에러")
                
                break
            default:
                print("에러")
                
                break
            }
        }
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
            
            cell.customImageView.image = R.image.sesac_background_1()
            
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
//        case 5:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
//            cell.textLabel?.text = "회원탈퇴"
//            cell.textLabel?.font = UIFont.CustomFont.title2R16
//            return cell
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
            //tableView.deselectRow(at: indexPath, animated: true)
            //withDraw()
            print("few")
//            let alertVC = AlertVC()
//            alertVC.okBtn.addTarget(self, action: #selector(withDraw), for: .touchUpInside)
//            alertVC.modalPresentationStyle = .overFullScreen
//            alertVC.modalTransitionStyle = .crossDissolve
//            self.present(alertVC, animated: true)
        } else {
            print("기능 구현 예정")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 500
        }
        return 200
    }
}
