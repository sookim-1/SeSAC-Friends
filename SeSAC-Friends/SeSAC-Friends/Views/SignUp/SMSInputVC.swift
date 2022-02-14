//
//  SMSInputVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/23.
//

import Toast_Swift
import RxCocoa
import RxSwift

final class SMSInputVC: BaseVC {
    private let mainView = SMSInputView()
    private var limitTime: Int = 60
    var varification: String?
    private var viewModel = SMSInputViewModel()
    var authViewModel: SMSAuthViewModel?
    var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.smsAuthTextField.becomeFirstResponder()
        getSetTime()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.centerMessageToast(message: "인증번호를 보냈습니다.")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        UserDefaults.varification = self.varification!
    }
    
    @objc func getSetTime() {
        secToTime(sec: limitTime)
        limitTime -= 1
    }
    
    private func secToTime(sec: Int) {
        let minute = (sec % 3600) / 60
        let second = (sec % 3600) % 60
        
        if second < 10 {
            mainView.timerLabel.text = String(minute) + ":" + "0" + String(second)
        } else {
            mainView.timerLabel.text = String(minute) + ":" + String(second)
        }
        
        if limitTime != 0 {
            perform(#selector(getSetTime), with: nil, afterDelay: 1.0)
        }
        else if limitTime == 0 {
            mainView.timerLabel.text = "0:00"
            mainView.doneButton.isEnabled = false
        }
    }
    
    private func bind() {
        mainView.smsAuthTextField.rx.text
            .orEmpty
            .bind(to: viewModel.smsAuthText)
            .disposed(by: disposeBag)
        
        viewModel.smsAuthText
            .map{ $0.count > 5 }
            .bind(to: viewModel.smsAuthValid)
            .disposed(by: disposeBag)
        
        viewModel.smsAuthValid.subscribe(onNext: { valid in
            if valid {
                self.mainView.smsAuthTextField.textFieldStatus = .success
                self.mainView.doneButton.buttonStatus = .fill
            } else {
                self.mainView.smsAuthTextField.textFieldStatus = .error
            }
        }).disposed(by: disposeBag)
        
        mainView.doneButton.rx.tap
            .bind {
                self.viewModel.smsAuthInput(verifyID: self.varification!)
             }
             .disposed(by: disposeBag)
        
        viewModel.verifyID
            .observe(on: MainScheduler.instance)
            .subscribe { event in
            switch event {
            case .next(let idToken):
                guard idToken != nil else {
                    return
                }
                if idToken == "에러" {
                    self.centerMessageToast(message: "에러가 발생했습니다. 다시 시도해주세요.")
                }
                else {
                    UserDefaults.idToken = idToken!
                    SignUpService.shared.getSesacUser { response in
                        switch response.response?.statusCode {
                        case 200:
                            print("성공")
                            UserDefaults.isUser = true
                            switch response.result {
                            case .success(let response):
                                print("\(response)")
                                self.windowChangeVC(viewController: TabBarVC())
                            case .failure(let error):
                                print("get user error: \(error)")
                            }
                        case 401:
                            print("파이어베이스토큰만료")
                        case 406:
                            self.windowChangeVC(viewController: NicknameInputVC())
                        case 500:
                            print("서버에러")
                        case 501:
                            print("클라이언트에러")
                        default:
                            print("에러")
                        }
                    }
                }
            case .completed:
                print("완료")
            case .error(let err):
                print(err)
            }
        }.disposed(by: disposeBag)
        
        mainView.sendButton.rx.tap
            .bind {
                self.limitTime = 60
                self.mainView.doneButton.isEnabled = true
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
    
}
