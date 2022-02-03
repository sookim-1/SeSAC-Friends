//
//  ViewController.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/17.
//

import FirebaseAuth
import RxSwift
import RxCocoa
import Toast_Swift

class SMSAuthVC: BaseVC {
    let mainView = SMSAuthView()
    var viewModel = SMSAuthViewModel()
    var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

  //      bind()

        test()
    }
    
    func bind() {
//        let input = SMSAuthViewModel.Input(text: mainView.phoneNumberTextField.rx.text, tap: mainView.doneButton.rx.tap)
//        let output = viewModel.transform(input: input)
//
//        output.validStatus.subscribe(onNext: { valid in
//            if valid {
//                self.mainView.phoneNumberTextField.textFieldStatus = .success
//                self.mainView.doneButton.buttonStatus = .fill
//            } else {
//                self.mainView.phoneNumberTextField.textFieldStatus = .error
//            }
//        }).disposed(by: disposeBag)
//
//        output.buttonTap.bind {
//            if !output.validStatus {
//                self.view.makeToast("잘못된 전화번호 형식입니다")
//            }
//            self.viewModel.smsAuth()
//         }
//         .disposed(by: disposeBag)
//
//        viewModel.verifyID
//            .observe(on: MainScheduler.instance)
//            .subscribe { event in
//            print(event)
//            switch event {
//            case .next(let varification):
//                print(varification)
//                guard varification != nil else { return }
//                if varification == "에러" {
//                    self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요")
//                } else {
//                    let smsInputVC = SMSInputVC()
//                    smsInputVC.varification = varification
//                    smsInputVC.authViewModel = self.viewModel
//                    UserDefaults.phoneNumber = "+82\(self.viewModel.phoneNumberText.value)"
//                    self.navigationController?.pushViewController(smsInputVC, animated: true)
//                }
//            case .completed:
//                print("완료")
//            case .error(let err):
//                print(err)
//            }
//        }.disposed(by: disposeBag)
    }
    

    func test() {
        mainView.phoneNumberTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.phoneNumberText)
            .disposed(by: disposeBag)
        
        viewModel.phoneNumberText
            .map { self.viewModel.isValidPhoneNumber(text: $0) }
            .bind(to: viewModel.phoneNumberValid)
            .disposed(by: disposeBag)
        
        viewModel.phoneNumberValid.subscribe(onNext: { valid in
            if valid {
                self.mainView.phoneNumberTextField.textFieldStatus = .success
                self.mainView.doneButton.buttonStatus = .fill
            } else {
                self.mainView.phoneNumberTextField.textFieldStatus = .error
            }
        }).disposed(by: disposeBag)
        
        mainView.doneButton.rx.tap
            .bind {
                if !self.viewModel.phoneNumberValid.value {
                    self.view.makeToast("잘못된 전화번호 형식입니다")
                } else {
                    self.viewModel.smsAuth()
                }
             }
             .disposed(by: disposeBag)
        
        viewModel.verifyID
            .observe(on: MainScheduler.instance)
            .subscribe {
                if $0.element == "에러" {
                    self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요")
                } else {
                    let smsInputVC = SMSInputVC()
                    smsInputVC.varification = $0.element
                    smsInputVC.authViewModel = self.viewModel
                    UserDefaults.phoneNumber = "+82\(self.viewModel.phoneNumberText.value)"
                    self.navigationController?.pushViewController(smsInputVC, animated: true)
                }
            }.disposed(by: disposeBag)
    }

}

