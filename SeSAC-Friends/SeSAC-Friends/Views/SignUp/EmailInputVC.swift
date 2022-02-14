//
//  EmailInputVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/23.
//

import Toast_Swift
import RxCocoa
import RxSwift

final class EmailInputVC: BaseVC {
    private var viewModel = EmailViewModel()
    var disposeBag = DisposeBag()
    private let mainView = EmailInputView()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.emailTextField.becomeFirstResponder()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        mainView.emailTextField.textFieldStatus = .inactive
    }
    
    private func bind() {
        mainView.emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.emailText)
            .disposed(by: disposeBag)
        viewModel.emailText
            .map{ self.viewModel.isValidEmail(text: $0) }
            .bind(to: viewModel.emailValid)
            .disposed(by: disposeBag)
        viewModel.emailValid.subscribe(onNext: { valid in
            if valid {
                self.mainView.emailTextField.textFieldStatus = .success
                self.mainView.doneButton.buttonStatus = .fill
            } else {
                self.mainView.emailTextField.textFieldStatus = .error
            }
        }).disposed(by: disposeBag)
        
        mainView.doneButton.rx.tap
            .bind {
                if self.viewModel.emailValid.value {
                    UserDefaults.email = self.viewModel.emailText.value
                    self.navigationController?.pushViewController(GenderVC(), animated: true)
                } else {
                    self.centerMessageToast(message: "이메일 형식이 올바르지 않습니다.")
                }
             }
             .disposed(by: disposeBag)
    }

}
