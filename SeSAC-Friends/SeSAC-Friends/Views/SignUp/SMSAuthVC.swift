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
    let disposeBag = DisposeBag()
    private var verifyID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setUpConstraints()
        setUpNavigationBar()
        doneButton.buttonStatus = .disable
        doneButton.addTarget(self, action: #selector(handleDoneBtn(_:)), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        phoneNumberTextField.textFieldStatus = .inactive
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
        navigationController?.pushViewController(SMSInputVC(), animated: true)
    }
    
}

