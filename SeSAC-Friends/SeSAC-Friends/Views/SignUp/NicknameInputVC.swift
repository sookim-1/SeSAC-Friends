//
//  NicknameVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/21.
//

import RxCocoa
import RxSwift
import Toast_Swift

final class NicknameInputVC: BaseVC {
    private var viewModel = NicknameViewModel()
    var disposeBag = DisposeBag()
    private let mainView = NicknameInputView()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.nicknameTextField.becomeFirstResponder()
        
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        mainView.nicknameTextField.textFieldStatus = .inactive
    }
    
    private func bind() {
        mainView.nicknameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.nicknameText)
            .disposed(by: disposeBag)
        viewModel.nicknameText
            .map{ $0.count > 0 && $0.count < 10 }
            .bind(to: viewModel.nicknameValid)
            .disposed(by: disposeBag)
        viewModel.nicknameValid.subscribe(onNext: { valid in
            if valid {
                self.mainView.nicknameTextField.textFieldStatus = .success
                self.mainView.doneButton.buttonStatus = .fill
            } else {
                self.mainView.nicknameTextField.textFieldStatus = .error
            }
        }).disposed(by: disposeBag)
        
        mainView.doneButton.rx.tap
            .bind {
                if self.viewModel.nicknameValid.value {
                    self.centerMessageToast(message: "닉네임은 1자 이상 10자 이내로 부탁드려요")
                }
                else {
                    UserDefaults.nickname = self.viewModel.nicknameText.value
                    self.navigationController?.pushViewController(BirthdayInputVC(), animated: true)
                }
             }
             .disposed(by: disposeBag)
    }
    
}

