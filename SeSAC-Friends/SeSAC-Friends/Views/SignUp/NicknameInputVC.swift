//
//  NicknameVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/21.
//

import UIKit

class NicknameInputVC: UIViewController {
    
    lazy var authDescriptionLabel: CustomLabel = CustomLabel(text: "닉네임을 입력해 주세요", labelList: .nicknameLabel)
    
    lazy var nicknameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "10자 이내로 입력"
        textField.textFieldStatus = .inactive
        textField.keyboardType = .namePhonePad
        
        return textField
    }()
    
    let doneButton: CustomButton = CustomButton(text: "다음")
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authDescriptionLabel, nicknameTextField, doneButton])
        stackView.axis = .vertical
        stackView.spacing = view.frame.height * 0.08
        stackView.distribution = .equalSpacing
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configure()
        setUpConstraints()
        setUpNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        nicknameTextField.textFieldStatus = .inactive
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
        doneButton.addTarget(self, action: #selector(authComplete), for: .touchUpInside)
    }
    
    private func setUpConstraints() {
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.6)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
    
    @objc func authComplete() {
        navigationController?.pushViewController(BirthdayInputVC(), animated: true)
    }
}

