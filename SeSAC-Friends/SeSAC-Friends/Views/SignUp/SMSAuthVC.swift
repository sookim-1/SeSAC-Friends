//
//  ViewController.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/17.
//

import AnyFormatKit
import FirebaseAuth
import Toast_Swift
import RxSwift
import RxCocoa

final class SMSAuthVC: BaseVC {
    private let mainView = SMSAuthView()
    private var viewModel = SMSAuthViewModel()
    var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.phoneNumberTextField.delegate = self
        authTapButton()
    }
    
    private func bindTextField() {
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
    }

    private func authTapButton() {
        mainView.doneButton.rx.tap
            .bind {
                if !self.viewModel.phoneNumberValid.value {
                    self.centerMessageToast(message: "잘못된 전화번호 형식입니다")
                } else {
                    self.viewModel.smsAuth()
                }
             }
             .disposed(by: disposeBag)
        
        viewModel.verifyID
            .observe(on: MainScheduler.instance)
            .subscribe {
                if $0.element == "에러" {
                    self.centerMessageToast(message: "에러가 발생했습니다. 다시 시도해주세요")
                } else {
                    let smsInputVC = SMSInputVC()
                    smsInputVC.varification = $0.element
                    smsInputVC.authViewModel = self.viewModel
                    UserDefaults.phoneNumber = "+82\(self.removeHyphenPhoneNumber(phoneNumber: self.viewModel.phoneNumberText.value))"
                    self.navigationController?.pushViewController(smsInputVC, animated: true)
                }
            }.disposed(by: disposeBag)
    }
    
    private func removeHyphenPhoneNumber(phoneNumber: String?) -> String {
        var phoneNumber = phoneNumber!
        phoneNumber = phoneNumber.replacingOccurrences(of: "_", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        return phoneNumber
    }
}

extension SMSAuthVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.formatPhoneNumber(range: range, string: string)
        bindTextField()
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

