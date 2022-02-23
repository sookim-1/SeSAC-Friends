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
    private var fromQueueDB: [FromQueueDB] = []
    private var fromQueueDBRequested: [FromQueueDB] = []
    private var isRequested: Bool = false
    private var uid: String?
    private var indexPathRow: Int = 0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        configure()
        setUpLayout()
        configureEmptyView()
        defaultSetting()
        
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { timer in
            self.onQueueNetworking { result in
                print("onQueue 5초마다 네트워킹 시작")
                switch result {
                case .success(let value):
                    self.post = value
                case .failure(_):
                    print("error")
                }
            }
        })
        
        emptyView.refreshButton.addTarget(self, action: #selector(refreshTouchUp), for: .touchUpInside)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
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
    
    func defaultSetting() {
        onQueueNetworking { result in
            print("onQueue 네트워킹 시작")
            switch result {
            case .success(let value):
                self.post = value
            case .failure(_):
                print("error")
            }
        }
        
        guard let post = post else {
            return
        }
        
        if !post.fromQueueDBRequested.isEmpty {
            configureTableView()
        } else {
            configureEmptyView()
        }
    }
    
    @objc func refreshTouchUp() {
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
    
    func configureTableView() {
        emptyView.removeFromSuperview()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(FindTableViewCell.self, forCellReuseIdentifier: "FindTableViewCell")
        
        
        // MARK: - didselectRowAt Not Called
        tableView.allowsMultipleSelection = false
        
        
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
            isRequested = true
            if !post.fromQueueDBRequested.isEmpty {
                fromQueueDBRequested = post.fromQueueDBRequested
                configureTableView()
            } else {
                configureEmptyView()
            }
            
        }
        else {
            isRequested = false
            if !post.fromQueueDB.isEmpty {
                fromQueueDB = post.fromQueueDB
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
        return isRequested ? fromQueueDBRequested.count : fromQueueDB.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FindTableViewCell", for: indexPath) as? FindTableViewCell
        else { return UITableViewCell() }
        
        if isRequested {
            cell.cardView.backgroundImageView.image = UIImage(named: "sesac_background_\(fromQueueDBRequested[indexPath.row].background + 1)")
            cell.cardView.sesacImageView.image = UIImage(named: "sesac_face_\(fromQueueDBRequested[indexPath.row].sesac + 1)")
            cell.cardView.bottomView.titleLable.text = fromQueueDBRequested[indexPath.row].nick
            cell.cardView.bottomView.reviewView.text = fromQueueDBRequested[indexPath.row].reviews[0]
            addTextViewGesture(textView: cell.cardView.bottomView.reviewView)
            
            cell.cardView.decisionButton.setTitle("수락하기", for: .normal)
            cell.cardView.decisionButton.backgroundColor = .CustomColor.success
            cell.cardView.decisionButton.addTarget(self, action: #selector(touchDecisionButton), for: .touchUpInside)
            
            
        } else {
            cell.cardView.backgroundImageView.image = UIImage(named: "sesac_background_\(fromQueueDB[indexPath.row].background + 1)")
            cell.cardView.sesacImageView.image = UIImage(named: "sesac_face_\(fromQueueDB[indexPath.row].sesac + 1)")
            cell.cardView.bottomView.titleLable.text = fromQueueDB[indexPath.row].nick
            if fromQueueDB[indexPath.row].reviews.isEmpty {
                cell.cardView.bottomView.reviewView.text = "첫 리뷰를 기다리는 중이에요!"
                cell.cardView.bottomView.reviewView.textColor = .CustomColor.gray4
            } else {
                cell.cardView.bottomView.reviewView.text = fromQueueDB[indexPath.row].reviews[0]
                cell.cardView.bottomView.reviewView.textColor = .CustomColor.black
            }
            addTextViewGesture(textView: cell.cardView.bottomView.reviewView)
            cell.cardView.decisionButton.setTitle("요청하기", for: .normal)
            cell.cardView.decisionButton.backgroundColor = .CustomColor.error
            
            cell.cardView.decisionButton.addTarget(self, action: #selector(touchDecisionButton), for: .touchUpInside)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
    func addTextViewGesture(textView: UITextView) {
        textView.isUserInteractionEnabled = true
        let event = UITapGestureRecognizer(target: self,
                    action: #selector(commuteMethod))
        textView.addGestureRecognizer(event)
    }
    
    @objc func commuteMethod() {
        print(indexPathRow)
        let reviewVC = ReviewVC()
        
        if isRequested {
            reviewVC.reviews = fromQueueDBRequested[indexPathRow].reviews
            self.navigationController?.pushViewController(reviewVC, animated: true)
        } else {
            reviewVC.reviews = fromQueueDB[indexPathRow].reviews
            self.navigationController?.pushViewController(reviewVC, animated: true)
        }
    }
    
    @objc func touchDecisionButton() {
        let alertVC = AlertVC()
        if isRequested {
            alertVC.titleLabel.text = "취미 같이 하기를 수락할까요?"
            alertVC.subtitleLabel.text = "요청을 수락하면 채팅창에서 대화를 나눌 수 있어요"
            
            alertVC.okBtn.addTarget(self, action: #selector(okButtonTouch), for: .touchUpInside)
            alertVC.cancelBtn.addTarget(self, action: #selector(cancelButtonTouch), for: .touchUpInside)
            self.present(alertVC, animated: true, completion: nil)
        
        } else {
            alertVC.titleLabel.text = "취미 같이 하기를 요청할게요!"
            alertVC.subtitleLabel.text = "요청이 수락되면 30분 후에 리뷰를 남길 수 있어요"
            
            alertVC.okBtn.addTarget(self, action: #selector(okButtonTouch), for: .touchUpInside)
            alertVC.cancelBtn.addTarget(self, action: #selector(cancelButtonTouch), for: .touchUpInside)
            self.present(alertVC, animated: true, completion: nil)
        }
        
    }
    
    @objc func okButtonTouch() {
        print("ok")
        if !isRequested {
            HomeService.shared.hobbyrequestQueue(uid: Request(otheruid: fromQueueDB[indexPathRow].uid)) { response in
                switch response.response?.statusCode {
                case 200:
                    print("성공")
                    switch response.result {
                    case .success(let response):
                        print("네트워크 리스폰스\(response)")
                        //self.addCustomPin()
                        self.dismiss(animated: true, completion: nil)
                        self.navigationController?.pushViewController(ChatVC(), animated: true)
                    case .failure(let error):
                        print("get user error: \(error)")
                    }
                    break
                case 201:
                    print("hobbyaccept호출")
                case 202:
                    self.centerMessageToast(message: "상대방이 취미 함께하기를 그만두었습ㅂ니다.")
                case 401:
                    print("파이어베이스 토큰만료")
                    self.refreshIdToken { result in
                        switch result {
                        case .success(let idToken):
                            UserDefaults.idToken = idToken
                            self.onQueueNetworking { _ in
                                print("토큰갱신")
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
    
    @objc func cancelButtonTouch() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("선택된 행은 \(indexPath.row)번쨰 행")
        indexPathRow = indexPath.row
    }
}
