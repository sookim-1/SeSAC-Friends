//
//  ViewController.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/17.
//

import UIKit
import FirebaseAuth
import SnapKit
import RxSwift

class SMSAuthVC: UIViewController {
    lazy var authDescriptionLabel: CustomLabel = CustomLabel(lineHeight: 1.08, text: "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요", labelList: .smsAuthLabel)
    
    var phoneNumberTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    let doneButton: CustomButton = CustomButton(text: "인증문자받기")

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authDescriptionLabel, phoneNumberTextField, doneButton])
        stackView.axis = .vertical
        stackView.spacing = view.frame.height * 0.08
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    var viewModel = SMSAuthViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setUpConstraints()
        setUpNavigationBar()
        doneButton.buttonStatus = .disable
        
        phoneNumberTextField.rx.text
            .orEmpty
            .bind(to: viewModel.phoneNumberText)
            .disposed(by: disposeBag)
        
        viewModel.phoneNumberText
            .map{ self.viewModel.isValidPhoneNumber(text: $0) }
            .bind(to: viewModel.phoneNumberValid)
            .disposed(by: disposeBag)
        
        viewModel.phoneNumberValid.subscribe(onNext: { valid in
            if valid {
                self.phoneNumberTextField.textFieldStatus = .success
                self.doneButton.buttonStatus = .fill
            } else {
                self.phoneNumberTextField.textFieldStatus = .error
            }
        }).disposed(by: disposeBag)
        
        doneButton.rx.tap
            .bind {
                 self.viewModel.smsAuth()
             }
             .disposed(by: disposeBag)
        
        viewModel.verifyID
            .observe(on: MainScheduler.instance)
            .subscribe { event in
            print(event)
            switch event {
            case .next(let varification):
                print(varification)
                guard varification != nil else { return }
                if varification == "에러" {
                    print("에러발생")
                } else {
                    let smsInputVC = SMSInputVC()
                    smsInputVC.varification = varification
                    UserDefaults.standard.set("+82\(self.viewModel.phoneNumberText.value)", forKey: "phoneNumber")
                    self.navigationController?.pushViewController(smsInputVC, animated: true)
                }
            case .completed:
                print("완료")
            case .error(let err):
                print(err)
            }
        }.disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        //phoneNumberTextField.textFieldStatus = .inactive
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
    }
    
    private func setUpConstraints() {
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.6)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }

    @objc func handleDoneBtn(_ sender: Any) {
        //navigationController?.pushViewController(SMSInputVC(), animated: true)
    
        print(viewModel.phoneNumberText.value)
    }
    
}

