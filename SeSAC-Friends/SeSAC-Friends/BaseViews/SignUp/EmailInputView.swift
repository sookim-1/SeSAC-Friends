//
//  EmailInputView.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/01.
//

import UIKit
import SnapKit

class EmailInputView: UIView, ViewRepresentable {
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
        stackView.spacing = self.frame.height * 0.08
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        addSubview(stackView)
        doneButton.buttonStatus = .disable
    }
    
    

    func setUpConstraints() {
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.6)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
    

}
