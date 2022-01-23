//
//  EmailInputVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/23.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class EmailInputVC: UIViewController {
    var viewModel = EmailViewModel()
    var disposeBag = DisposeBag()

    lazy var authDescriptionLabel: CustomLabel = CustomLabel(lineHeight: 1.5, text: "이메일을 입력해주세요\n휴대폰 번호 변경시 인증을 위해 사용해요", labelList: .emailLabel)
    
    lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "SeSAC@email.com"
        textField.textFieldStatus = .inactive
        textField.keyboardType = .emailAddress
        
        return textField
    }()
    
    let doneButton: CustomButton = CustomButton(text: "다음")
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authDescriptionLabel, emailTextField, doneButton])
        stackView.axis = .vertical
        stackView.spacing = view.frame.height * 0.08
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        emailTextField.becomeFirstResponder()
        configure()
        setUpConstraints()
        setUpNavigationBar()
        
        emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.emailText)
            .disposed(by: disposeBag)
        viewModel.emailText
            .map{ self.viewModel.isValidEmail(text: $0) }
            .bind(to: viewModel.emailValid)
            .disposed(by: disposeBag)
        viewModel.emailValid.subscribe(onNext: { valid in
            if valid {
                self.emailTextField.textFieldStatus = .success
                self.doneButton.buttonStatus = .fill
            } else {
                self.emailTextField.textFieldStatus = .error
            }
        }).disposed(by: disposeBag)
        
        doneButton.rx.tap
            .bind {
                UserDefaults.standard.set(self.viewModel.emailText.value, forKey: "email")
                self.navigationController?.pushViewController(GenderVC(), animated: true)
             }
             .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        emailTextField.textFieldStatus = .inactive
    }
    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")

        navigationItem.backBarButtonItem = UIBarButtonItem()
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(stackView)
        doneButton.buttonStatus = .disable
    }
    
    private func setUpConstraints() {
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.6)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }

    }

    
}
