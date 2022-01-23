//
//  SMSInputVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/23.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import Toast_Swift

class SMSInputVC: UIViewController {
    var limitTime: Int = 60
    var varification: String?
    var viewModel = SMSInputViewModel()
    var authViewModel: SMSAuthViewModel?
    var disposeBag = DisposeBag()
    
    lazy var authDescriptionLabel: CustomLabel = CustomLabel(lineHeight: 1.5, text: "인증번호가 문자로 전송되었어요\n(최대 소모 20초)", labelList: .smsInputLabel)
    lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [smsAuthTextField, sendButton])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy var smsAuthTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "인증번호 입력"
        textField.textFieldStatus = .inactive
        textField.keyboardType = .numberPad
        textField.textContentType = .oneTimeCode
        
        return textField
    }()
    
    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.CustomColor.green
        return label
    }()
    
    let sendButton: CustomButton = CustomButton(text: "재전송")
    let doneButton: CustomButton = CustomButton(text: "인증하고 시작하기")
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authDescriptionLabel, textFieldStackView, doneButton])
        stackView.axis = .vertical
        stackView.spacing = view.frame.height * 0.08
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.makeToast("인증번호를 보냈습니다")
        view.backgroundColor = .systemBackground
        smsAuthTextField.becomeFirstResponder()
        smsAuthTextField.rightView = timerLabel
        smsAuthTextField.rightViewMode = .always
        getSetTime()
        configure()
        setUpConstraints()
        setUpNavigationBar()
        
        smsAuthTextField.rx.text
            .orEmpty
            .bind(to: viewModel.smsAuthText)
            .disposed(by: disposeBag)
        
        viewModel.smsAuthText
            .map{ $0.count > 5 }
            .bind(to: viewModel.smsAuthValid)
            .disposed(by: disposeBag)
        
        viewModel.smsAuthValid.subscribe(onNext: { valid in
            if valid {
                self.smsAuthTextField.textFieldStatus = .success
                self.doneButton.buttonStatus = .fill
            } else {
                self.smsAuthTextField.textFieldStatus = .error
            }
        }).disposed(by: disposeBag)
        
        doneButton.rx.tap
            .bind {
                self.viewModel.smsAuthInput(verifyID: self.varification!)
             }
             .disposed(by: disposeBag)
        
        viewModel.verifyID
            .observe(on: MainScheduler.instance)
            .subscribe { event in
            print(event)
            switch event {
            case .next(let idToken):
                print(idToken)
                guard idToken != nil else {
                    return
                }
                if idToken == "에러" {
                    self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요")
                }
                else {
                    UserDefaults.idToken = idToken!
                    self.getUser(idToken: idToken!) { [weak self] result in
                        switch result {
                        case .success(let str):
                            DispatchQueue.main.async {
                                if str == "닉네임" {
                                    self?.navigationController?.pushViewController(NicknameInputVC(), animated: true)
                                }
                                else{
                                    self?.navigationController?.pushViewController(HomeVC(), animated: true)
                                }
                            }
                        case .failure(let err):
                            self?.view.makeToast("에러가 발생했습니다. 다시 시도해주세요")
                        }
                        
                    }
                }
            case .completed:
                print("완료")
            case .error(let err):
                print(err)
            }
        }.disposed(by: disposeBag)
        
        sendButton.rx.tap
            .bind {
                self.limitTime = 60
                self.authViewModel?.smsAuth()
            }
            .disposed(by: disposeBag)
                
        authViewModel?.verifyID
            .observe(on: MainScheduler.instance)
            .subscribe { value in
                switch value {
                case .next(let value):
                    self.varification = value
                    self.getSetTime()
                case .error(_):
                    break
                case .completed:
                    break
                }
        }
        .disposed(by: disposeBag)
            
    }
    
    override func viewDidLayoutSubviews() {
        //smsAuthTextField.textFieldStatus = .inactive
    }
    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")

        navigationItem.backBarButtonItem = UIBarButtonItem()
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        
        sendButton.buttonStatus = .fill
        doneButton.buttonStatus = .disable
        view.addSubview(stackView)
    }
    
    private func setUpConstraints() {
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.6)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        smsAuthTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        sendButton.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
    }
    
    
    @objc func getSetTime() {
        secToTime(sec: limitTime)
        limitTime -= 1
    }
    
    func secToTime(sec: Int) {
        let minute = (sec % 3600) / 60
        let second = (sec % 3600) % 60
        
        if second < 10 {
            timerLabel.text = String(minute) + ":" + "0" + String(second)
        } else {
            timerLabel.text = String(minute) + ":" + String(second)
        }
        
        if limitTime != 0 {
            perform(#selector(getSetTime), with: nil, afterDelay: 1.0)
        }
        else if limitTime == 0 {
            timerLabel.text = "00:00"
        }
    }
    
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
