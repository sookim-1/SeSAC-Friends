//
//  FindVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/15.
//

import UIKit

import SnapKit

final class FindVC: BaseVC, TapViewDelegate {


    private var tapView: CustomTapView!
    private var emptyView = EmptyView(text: "아쉽게도 주변에 새싹이 없어요ㅠ\n취미를 변경하거나 조금만 더 기다려 주세요!")
    private var tableView = UITableView()
    private var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        configure()
        setUpLayout()
        configureEmptyView()
        onQueueNetworking { result in
            print("onQueue 네트워킹 시작")
            switch result {
            case .success(let value):
                self.post = value
            case .failure(_):
                print("error")
            }
        }
    }
    
    override func configure() {
        title = "새싹 찾기"
        
        tapView = CustomTapView(frame: .zero, buttonTitle: ["주변 새싹", "받은 요청"])
        tapView.delegate = self
        tapView.backgroundColor = .clear

        view.addSubview(tapView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(stopFindRequest))
        self.emptyView.changeHobbyButton.addTarget(self, action: #selector(changeHobby), for: .touchUpInside)
    }
    
    func configureTableView() {
        emptyView.removeFromSuperview()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FindTableViewCell.self, forCellReuseIdentifier: "FindTableViewCell")
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(tapView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureEmptyView() {
        tableView.removeFromSuperview()
        view.addSubview(emptyView)
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(tapView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setUpLayout() {
        tapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    func change(to index: Int) {
        print(index)
        guard let post = post else {
            return
        }

        
        if index == 1 {
            if !post.fromQueueDBRequested.isEmpty {
                configureTableView()
            } else {
                configureEmptyView()
            }
        }
        else {
            if !post.fromQueueDB.isEmpty {
                configureTableView()
            } else {
                configureEmptyView()
            }
        }
    }
    
    @objc func stopFindRequest() {
        HomeService.shared.deleteQueue { response in
            switch response.response?.statusCode {
            case 200:
                self.navigationController?.popToRootViewController(animated: true)
            case 201:
                self.centerMessageToast(message: "누군가와 취미를 함께하기로 약속하셨어요!")
            case 401:
                self.centerMessageToast(message: "파이어베이스 토큰만료")
            case 406:
                self.centerMessageToast(message: "미가입 회원")
            case 500:
                self.centerMessageToast(message: "서버에러")
            default:
                print("에러")
            }
        }
    }
    
    @objc func changeHobby() {
        HomeService.shared.deleteQueue { response in
            switch response.response?.statusCode {
            case 200:
                self.navigationController?.popViewController(animated: true)
            default:
                self.centerMessageToast(message: "에러발생")
            }
        }
    }
    
    private func onQueueNetworking(completion: @escaping (Result<Post?, Error>) -> Void) {
        let tempModel: OnQueue = OnQueue(region: 1275130688, lat: 37.517819364682694, long: 126.88647317074734)
        HomeService.shared.postOnQueue(model: tempModel) { response in
            switch response.response?.statusCode {
            case 200:
                print("성공")
                switch response.result {
                case .success(let response):
                    print("네트워크 리스폰스\(response)")
                    completion(.success(response))
                    //self.addCustomPin()
                case .failure(let error):
                    print("get user error: \(error)")
                }
                break
            case 401:
                print("파이어베이스 토큰만료")
                self.refreshIdToken { result in
                    switch result {
                    case .success(let idToken):
                        UserDefaults.idToken = idToken
                        self.onQueueNetworking { _ in
                            print("토큰갱신")
                            completion(.success(nil))
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
                break
            case 406:
                print("미가입 회원입니다.")
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

extension FindVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FindTableViewCell", for: indexPath) as? FindTableViewCell
        else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
}
